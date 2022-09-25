//
//  ResultView.swift
//  QuizApp
//
//  Created by Fenominall on 9/24/22.
//

import SwiftUI

struct ResultView: View {
    // MARK: - Properties
    let title: String
    let summary: String
    let answers: [PresentableAnswer]
    let playAgain: () -> Void
    
    // MARK: - View Body
    var body: some View {
        VStack(alignment: .leading, spacing: 0.0) {
            HeaderView(title: title, subtitle: summary)
            
            List(answers, id: \.question) { model in
                ResultAnswerCell(model: model)
            }.listStyle(.plain)
            Spacer()
            
            RoundedButton(title: "Play again", action: playAgain)
                .padding()
        }
    }
}

// MARK: - Preview
struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultTestView()
        ResultTestView()
            .preferredColorScheme(.dark)
            .environment(\.dynamicTypeSize, .xxxLarge)
    }
    
    struct ResultTestView: View {
        @State var playAgainCount = 0
        
        var body: some View {
            VStack {
                ResultView(
                    title: "Results",
                    summary: "You got 3/5 correct!",
                    answers: [
                        .init(question: "What is an answers to question #001?", answer: "True answer", wrongAnswer: "Wrong answer"),
                        .init(question: "What is an answers to question #002", answer: "True answer", wrongAnswer: nil),
                        .init(question: "What is an answers to question #003", answer: "True answer", wrongAnswer: nil),
                        .init(question: "What is an answers to question #004?", answer: "True answer", wrongAnswer: "Wrong answer"),
                        .init(question: "What is an answers to question #005?", answer: "True answer", wrongAnswer: nil),
                    ],
                    playAgain: { playAgainCount += 1 })
                Text("Play again count: \(playAgainCount)")
            }
        }
    }
}
