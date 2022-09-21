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
            VStack(alignment: .leading, spacing: 16.0) {
                Text(title)
                    .foregroundColor(Color.blue)
                    .font(.headline)
                    .fontWeight(.medium)
                    .padding(.top)
                Text(question)
                    .font(.largeTitle)
                    .fontWeight(.medium)
            }.padding()
            ForEach(options, id: \.self) { option in
                Button(action: {}) {
                    HStack {
                        Circle()
                            .stroke(Color.secondary, lineWidth: 2.5)
                        .frame(width: 40, height: 40)
                        Text(option)
                            .font(.title)
                            .foregroundColor(Color.secondary)
                        Spacer()
                    }.padding()
                }
            }
            Spacer()
        }
    }
}

struct SingleAnswerQuestion_Previews: PreviewProvider {
    static var previews: some View {
        SingleAnswerQuestion(
            title: "1 of 2",
            question: "What is the date today?",
            options: [
                "Monday",
                "Thuesday",
                "Wendsday",
            ],
            selection: { _ in })
        
        SingleAnswerQuestion(
            title: "1 of 2",
            question: "What is the date today?",
            options: [
                "Monday",
                "Thuesday",
                "Wendsday",
            ],
            selection: { _ in })
        .preferredColorScheme(.dark)
        .environment(\.dynamicTypeSize, .xxxLarge)
    }
}
