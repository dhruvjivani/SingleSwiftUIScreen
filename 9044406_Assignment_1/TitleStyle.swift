//
//  TitleStyle.swift
//  9044406_Assignment_1
//
//  Created by Dhruv Rasikbhai Jivani on 9/18/25.
//

import SwiftUI

struct TitleStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.bold())
            .foregroundColor(.accentColor)
            .padding(.bottom, 5)
    }
}
