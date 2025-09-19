//
//  CardStyle.swift
//  9044406_Assignment_1
//
//  Created by Dhruv Rasikbhai Jivani on 9/18/25.
//

import SwiftUI

struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(UIColor.secondarySystemBackground))
            )
            .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
}
