//
//  Flow.swift
//  QuizEngine
//
//  Created by Fenominall on 7/16/22.
//

import Foundation

protocol Router {
    func routeTo(question: String, anserCallback: @escaping (String) -> Void)
}

class Flow {
    // MARK: - Properties
    let router: Router
    let questions: [String]
    
    // MARK: - Lifecycle
    init(questions: [String], router: Router) {
        self.questions = questions
        self.router = router
    }
    // MARK: - Helpers
    func start() {
        guard let firstQuestion = questions.first
        else { return }
        router.routeTo(question: firstQuestion) { [weak self] _ in
            guard let self = self else { return }
            let firstQuestionIndex = self.questions.firstIndex(of: firstQuestion)!
            let nextQuestion = self.questions[firstQuestionIndex + 1]
            self.router.routeTo(question: nextQuestion) { _ in
                
            }
        }
    }
}
