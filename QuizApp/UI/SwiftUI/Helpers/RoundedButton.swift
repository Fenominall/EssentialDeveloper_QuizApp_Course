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
    
    init(title: String, isEnabled: Bool = true, action: @escaping () -> Void) {
        self.title = title
        self.isEnabled = isEnabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action, label: {
            HStack {
                Spacer()
                Text(title)
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
        RoundedButtonTestView(isEnabled: true)
        RoundedButtonTestView(isEnabled: false)
    }
    
    struct RoundedButtonTestView: View {
        @State var buttonTappedCount = 0
        var isEnabled: Bool
        
        var body: some View {
            VStack {
                RoundedButton(
                    title: "Submit",
                    isEnabled: isEnabled,
                    action: { buttonTappedCount += 1 })
                Text("Button tapped, action fired: \(buttonTappedCount) times")
            }
        }
    }
}
