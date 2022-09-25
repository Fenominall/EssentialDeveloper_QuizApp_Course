//
//  SingleAnswerQuestion.swift
//  QuizApp
//
//  Created by Fenominall on 9/21/22.
//

import SwiftUI

struct SingleAnswerQuestion: View {
    let title: String
    let question: String
    let options: [String]
    let selection: (String)-> Void?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0.0) {
            HeaderView(title: title, subtitle: question)
            ForEach(options, id: \.self) { option in
                SingleTextSelectionCell(
                    text: option,
                    selection: {
                        selection(option)
                    })
            }
            Spacer()
        }
    }
}

// MARK: - Previews
struct SingleAnswerQuestion_Previews: PreviewProvider {
    static var previews: some View {
        SingleAnswerQuestionTestView()
        
        SingleAnswerQuestionTestView()
            .preferredColorScheme(.dark)
            .environment(\.dynamicTypeSize, .xxxLarge)
    }
    
    struct SingleAnswerQuestionTestView: View {
        @State var selection: String = "none"
        
        var body: some View {
            VStack {
                SingleAnswerQuestion(
                    title: "1 of 2",
                    question: "What is the date today?",
                    options: [
                        "Monday",
                        "Thuesday",
                        "Wendsday",
                    ],
                    selection: { selection = $0 })
                Spacer()
                Text("Last selection: " + selection)
            }
        }
    }
}
