//
//  QuestionHeader.swift
//  QuizApp
//
//  Created by Fenominall on 9/21/22.
//

import SwiftUI

struct QuestionHeader: View {
    let title: String
    let question: String
    
    var body: some View {
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
    }
}

struct QuestionHeader_Previews: PreviewProvider {
    static var previews: some View {
        QuestionHeader(title: "1 of 2", question: "What is up Bro, it`s sunnt today!")
            .previewLayout(.sizeThatFits)
    }
}
