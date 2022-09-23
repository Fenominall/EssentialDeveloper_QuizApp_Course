//
//  MultipleAnswerQuestion.swift
//  QuizApp
//
//  Created by Fenominall on 9/23/22.
//

import SwiftUI

struct MultipleAnswerQuestion: View {
    let title: String
    let question: String
    @State var store: MultipleSelectionStore
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0.0) {
            QuestionHeader(title: title, question: question)
            
            ForEach(store.options.indices) { index in
                MultipleTextSelectionCell(option: $store.options[index])
            }
            Spacer()
            Button(action: store.submit) {
                HStack {
                    Spacer()
                    Text("Submit")
                        .padding()
                        .foregroundColor(.white)
                    Spacer()
                }
                .background(.blue)
                .cornerRadius(25)
            }
            .buttonStyle(PlainButtonStyle())
            .padding()
            .disabled(!store.canSubmit)
        }
    }
}

// MARK: - Previews
struct MultipleAnswerStore_Previews: PreviewProvider {
    static var previews: some View {
        MultipleAnswerStoreTestView()
        
        MultipleAnswerStoreTestView()
            .preferredColorScheme(.dark)
            .environment(\.dynamicTypeSize, .xxxLarge)
    }
    
    struct MultipleAnswerStoreTestView: View {
        @State var selection = ["none"]
        
        var body: some View {
            VStack {
                MultipleAnswerQuestion(
                    title: "1 of 2",
                    question: "What is the date today?",
                    store: .init(
                        options: [
                            "Monday",
                            "Thuesday",
                            "Wendsday",
                        ],
                        handler: { selection = $0 }
                    ))
                Spacer()
                Text("Last submission: " + selection.joined(separator: ", "))
            }
        }
    }
}
