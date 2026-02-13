//
//  SupabaseManager.swift
//  noStressCoffee
//
//  Created by James Choi on 2/13/26.
//

import Foundation
import Supabase

enum SupabaseManager {
    static let client = SupabaseClient(
        supabaseURL: URL(string: "https://oeywovscnlhnetwmctyz.supabase.co")!,
        supabaseKey: "sb_publishable_FiObl-OR5qnUsweDZp60-g_8NoRkmQ8"
    )
}
