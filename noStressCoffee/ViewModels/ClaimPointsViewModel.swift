//
//  ClaimPointsViewModel.swift
//  noStressCoffee
//
//  Created by James Choi on 2/25/26.
//
// FOR CLAIMING POINTS FROM A RECEIPT

import Foundation
import Supabase
import Combine

@MainActor
class ClaimPointsViewModel: ObservableObject {
    @Published var receiptId = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    
    func claimPoints() async {
        guard !receiptId.isEmpty else { return }
        
        isLoading = true
        errorMessage = nil
        successMessage = nil
        
        do {
            guard let user = try? await SupabaseManager.client.auth.session.user else { return }
            
            struct ClaimRequest: Encodable {
                let userId: UUID
                let receiptId: String
            }
            
            // Invoke the new Edge Function
            try await SupabaseManager.client.functions.invoke(
                "claim-receipt-points",
                options: FunctionInvokeOptions(
                    body: try? JSONEncoder().encode(ClaimRequest(userId: user.id, receiptId: receiptId))
                )
            )
            
            self.successMessage = "Points successfully added to your account!"
            self.receiptId = ""
        } catch {
            self.errorMessage = "Invalid receipt or points already claimed."
        }
        
        isLoading = false
    }
}
