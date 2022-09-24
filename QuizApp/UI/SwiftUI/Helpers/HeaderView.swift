//
//  QuestionHeader.swift
//  QuizApp
//
//  Created by Fenominall on 9/21/22.
//

import SwiftUI

struct HeaderView: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16.0) {
            Text(title)
                .foregroundColor(Color.blue)
                .font(.headline)
                .fontWeight(.medium)
                .padding(.top)
            Text(subtitle)
                .font(.largeTitle)
                .fontWeight(.medium)
        }.padding()
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(title: "1 of 2", subtitle: "What is up Bro, it`s sunnt today!")
            .previewLayout(.sizeThatFits)
    }
}
