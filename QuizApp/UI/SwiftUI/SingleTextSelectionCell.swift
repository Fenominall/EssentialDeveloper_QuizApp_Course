//
//  SingleTextSelectionCell.swift
//  QuizApp
//
//  Created by Fenominall on 9/21/22.
//

import SwiftUI

struct SingleTextSelectionCell: View {
    let text: String
    let selection: () -> Void

    var body: some View {
        Button(action: selection) {
            HStack {
                Circle()
                    .stroke(Color.secondary, lineWidth: 2.5)
                    .frame(width: 40, height: 40)
                Text(text)
                    .font(.title)
                    .foregroundColor(Color.secondary)
                Spacer()
            }.padding()
        }
    }
}

struct SingleTextSelectionCell_Previews: PreviewProvider {
    static var previews: some View {
        SingleTextSelectionCell(text: "Test Option!", selection: {})
            .previewLayout(.sizeThatFits)
    }
}
