//
//  MultipleTextSelectionCell.swift
//  QuizApp
//
//  Created by Fenominall on 9/23/22.
//

import SwiftUI

struct MultipleTextSelectionCell: View {
    @Binding var option: MultipleSelectionOption
    
    var body: some View {
        Button(action: { option.select() }) {
            HStack {
                Rectangle()
                    .strokeBorder(option.isSelected ? Color.blue : .secondary, lineWidth: 2.5)
                    .overlay(content: {
                        Rectangle()
                            .fill(option.isSelected ? Color.blue : .clear)
                            .frame(width: 26, height: 26)
                    })
                    .frame(width: 40, height: 40)
                Text(option.text)
                    .font(.title)
                    .foregroundColor(option.isSelected ? Color.blue : .secondary)
                Spacer()
            }.padding()
        }
    }
}


struct MultipleTextSelectionCell_Previews: PreviewProvider {
    static var previews: some View {
        MultipleTextSelectionCell(option: .constant(.init(text: "A text", isSelected: false)))
            .previewLayout(.sizeThatFits)
        MultipleTextSelectionCell(option: .constant(.init(text: "A text", isSelected: true)))
            .previewLayout(.sizeThatFits)
    }
}
