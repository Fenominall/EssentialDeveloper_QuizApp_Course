//
//  ResultAnswerCell.swift
//  QuizApp
//
//  Created by Fenominall on 9/24/22.
//

import SwiftUI

struct ResultAnswerCell: View {
    let model: PresentableAnswer
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0.0) {
            Text(model.question)
                .font(.title)
            Text(model.answer)
                .font(.title2)
                .foregroundColor(.green)
            
            if let wrongAnswer = model.wrongAnswer {
                Text(wrongAnswer)
                    .font(.title2)
                    .foregroundColor(.red)
            }
        }.padding(.vertical)
    }
}
