import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const { receiptId, userId } = await req.json()

    const supabaseClient = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    )

    // 1. Idempotency Check: Has this receipt been used?
    const { data: existingEvent } = await supabaseClient
      .from('square_webhook_events')
      .select('event_id')
      .eq('event_id', receiptId)
      .single()

    if (existingEvent) {
      throw new Error("This receipt has already been claimed.")
    }

    // 2. Fetch the Order from Square
    const squareResponse = await fetch(`https://connect.squareup.com/v2/orders/${receiptId}`, {
      method: 'GET',
      headers: {
        'Square-Version': '2023-12-13',
        'Authorization': `Bearer ${Deno.env.get('SQUARE_ACCESS_TOKEN')}`
      }
    })

    const squareData = await squareResponse.json()
    
    if (!squareResponse.ok || !squareData.order) {
      throw new Error("Invalid receipt ID. Please check your receipt and try again.")
    }

    const order = squareData.order

    // 3. Check if the order already had a customer attached at the register
    if (order.customer_id) {
        throw new Error("Points for this order were already assigned at the register.")
    }

    // 4. CUSTOM POINTS LOGIC: Iterate through line items
    let pointsToAward = 0;

    if (order.line_items) {
      for (const item of order.line_items) {
        const itemName = item.name.toLowerCase();
        
        // RULE A: Exclude Gift Cards entirely
        if (itemName.includes("gift card")) {
            continue; // Skip to the next item
        }

        // Base math: 1 point per dollar. Square amounts are in cents.
        const itemCents = parseInt(item.total_money.amount, 10);
        let itemPoints = Math.floor(itemCents / 100);

        // RULE B: Multipliers (e.g., Double points for purchasing bags of coffee beans)
        if (itemName.includes("whole bean") || itemName.includes("roast")) {
            itemPoints *= 2; 
        }

        pointsToAward += itemPoints;
      }
    }

    if (pointsToAward === 0) {
        throw new Error("This receipt does not contain any point-eligible items.")
    }

    // 5. Update Supabase Data
    // Fetch current balance
    const { data: profile } = await supabaseClient
        .from('profiles')
        .select('points_balance')
        .eq('id', userId)
        .single()

    const newBalance = (profile?.points_balance || 0) + pointsToAward

    // Update the user's points
    await supabaseClient
      .from('profiles')
      .update({ points_balance: newBalance })
      .eq('id', userId)

    // Log the receipt ID so it can never be used again
    await supabaseClient
      .from('square_webhook_events')
      .insert({ event_id: receiptId })

    return new Response(JSON.stringify({ success: true, pointsAwarded: pointsToAward, newBalance }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 200,
    })

  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 400,
    })
  }
})