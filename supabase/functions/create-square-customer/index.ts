import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  // Handle CORS preflight requests from the app
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const { email, userId } = await req.json()
    
    // 1. Create the customer in Square
    const squareResponse = await fetch('https://connect.squareup.com/v2/customers', {
      method: 'POST',
      headers: {
        'Square-Version': '2023-12-13',
        'Authorization': `Bearer ${Deno.env.get('SQUARE_ACCESS_TOKEN')}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        email_address: email,
        reference_id: userId // Save the Supabase ID in Square for cross-referencing
      })
    })

    const squareData = await squareResponse.json()
    
    if (!squareResponse.ok) {
      throw new Error(`Square API Error: ${JSON.stringify(squareData)}`)
    }

    const squareCustomerId = squareData.customer.id

    // 2. Update the Supabase 'profiles' table using the Service Role Key
    const supabaseClient = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    )

    const { error: dbError } = await supabaseClient
      .from('profiles')
      .update({ square_customer_id: squareCustomerId })
      .eq('id', userId)

    if (dbError) throw dbError

    return new Response(JSON.stringify({ success: true, squareCustomerId }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 200,
    })
    } catch (error) {
        // This prints the exact error into your Supabase Dashboard Logs
        console.error("CRITICAL FUNCTION ERROR:", error.message, error.stack)
        
        return new Response(JSON.stringify({ error: error.message }), {
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
          status: 400, 
        })
      }
})