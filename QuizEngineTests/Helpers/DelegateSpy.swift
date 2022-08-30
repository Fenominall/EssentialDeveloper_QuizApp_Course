//
//  DelegateSpy.swift
//  QuizEngineTests
//
//  Created by Fenominall on 8/29/22.
//

import Foundation
import QuizEngine

class DelegateSpy: QuizSources {
    var questionsAsked: [String] = []
    var answerCompletions: [(String) -> Void] = []
    var completedQuizzes: [[(String, String)]] = []
    
    func answer(for question: String, completion: @escaping (String) -> Void) {
        questionsAsked.append(question)
        self.answerCompletions.append(completion)
    }
    
    func didCompleteQuiz(withAnswers answers: [(question: String, answer: String)]) {
        completedQuizzes.append(answers
        )
    }
}
