//
//  ClaimPointsView.swift
//  noStressCoffee
//
//  Created by James Choi on 2/25/26.
//
// FOR CLAIMING POINTS FROM RECEIPT

import SwiftUI

struct ClaimPointsView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = ClaimPointsViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Enter the Order ID found at the bottom of your noStressCoffee receipt.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                
                TextField("Receipt Order ID", text: $viewModel.receiptId)
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 6).stroke(Color(.systemGray4), lineWidth: 1))
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                
                if let error = viewModel.errorMessage {
                    Text(error).foregroundColor(.red).font(.caption)
                }
                if let success = viewModel.successMessage {
                    Text(success).foregroundColor(.green).font(.caption)
                }
                
                Button(action: {
                    Task { await viewModel.claimPoints() }
                }) {
                    if viewModel.isLoading {
                        ProgressView().tint(.white)
                    } else {
                        Text("Claim Points")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(viewModel.receiptId.isEmpty ? Color.gray : Color.brown)
                .foregroundColor(.white)
                .cornerRadius(10)
                .disabled(viewModel.receiptId.isEmpty || viewModel.isLoading)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Claim Receipt")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                        .foregroundColor(.brown)
                }
            }
        }
    }
}

#Preview {
    ClaimPointsView()
}
