//
//  AnnouncementsView.swift
//  noStressCoffee
//
//  Created by James Choi on 2/12/26.
//

import SwiftUI
    
import SwiftUI

struct AnnouncementsView: View {
    var body: some View {
        NavigationStack {
            List {
                ForEach(1...3, id: \.self) { i in
                    VStack(alignment: .leading) {
                        Text("New Seasonal Blend")
                            .fontWeight(.bold)
                        Text("Try our new organic roast arriving this Friday.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("News")
        }
    }
}

#Preview {
    AnnouncementsView()
}
