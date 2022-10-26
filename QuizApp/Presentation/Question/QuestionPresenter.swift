//
//  QuestionPresenter.swift
//  QuizApp
//
//  Created by Vladyslav Todorov on 8/14/22.
//

import Foundation
import BasicQuizDomain

struct QuestionPresenter {
    let questions: [Question<String>]
    let currentQuestion: Question<String>
    
    var title: String {
        guard let questionIndex = questions.firstIndex(of: currentQuestion) else { return "" }
        return "\(questionIndex + 1) of \(questions.count)"
    }
}
