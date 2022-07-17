//
//  Flow.swift
//  QuizEngine
//
//  Created by Fenominall on 7/16/22.
//

import Foundation

protocol Router {
    typealias AnswerCallback = (String) -> Void
    func routeTo(question: String, answerCallback: @escaping AnswerCallback)
    func routeTo(result: [String: String])
}

class Flow {
    // MARK: - Properties
    private let router: Router
    private let questions: [String]
    private var result: [String: String] = [:]
    
    // MARK: - Lifecycle
    init(questions: [String], router: Router) {
        self.questions = questions
        self.router = router
    }
    // MARK: - Helpers
    func start() {
        guard let firstQuestion = questions.first
        else {
            router.routeTo(result: result)
            return }
        router.routeTo(question: firstQuestion,
                       answerCallback: nextCallback(from: firstQuestion))
    }
    
    // Implements the recurstion of questions flow
    private func nextCallback(from question: String) -> Router.AnswerCallback {
        return { [weak self] in self?.routeNext(question, $0) }
    }
    
    private func routeNext(_ question: String, _ answer: String) {
        guard let currentQuestionIndex =
                questions.firstIndex(of: question)
        else { return }
        result[question] = answer
        
        let nextQuestionIndex = currentQuestionIndex + 1
        guard nextQuestionIndex <
                questions.count
        else { self.router.routeTo(result: result)
            return }
        let nextQuestion = questions[nextQuestionIndex]
        router.routeTo(
            question: nextQuestion,
            answerCallback: nextCallback(from: nextQuestion))
    }
}
