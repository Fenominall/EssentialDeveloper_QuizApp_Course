//
//  RoundedButton.swift
//  QuizApp
//
//  Created by Fenominall on 9/24/22.
//

import SwiftUI

struct RoundedButton: View {
    let title: String
    let isEnabled: Bool
    let action: () -> Void
    
    init(title: String, isEnabled: Bool, action: @escaping () -> Void) {
        self.title = title
        self.isEnabled = isEnabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action, label: {
            HStack {
                Spacer()
                Text("Submit")
                    .padding()
                    .foregroundColor(.white)
                Spacer()
            }
            .background(.blue)
            .cornerRadius(25)
        })
        .buttonStyle(PlainButtonStyle())
        .padding()
        .disabled(!isEnabled)
    }
}

struct RoundedButton_Previews: PreviewProvider {
    static var previews: some View {
        RoundedButton(title: "Enabled", isEnabled: true, action: { print("Class") })
            .previewLayout(.sizeThatFits)
        RoundedButton(title: "Disabled", isEnabled: false, action: { print("Class") })
            .previewLayout(.sizeThatFits)

    }
}
