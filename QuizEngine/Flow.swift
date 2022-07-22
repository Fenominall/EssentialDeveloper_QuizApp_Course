//
//  Flow.swift
//  QuizEngine
//
//  Created by Fenominall on 7/16/22.
//

import Foundation

protocol Router {
    // Adding associatedtype for more geneirc flow, the questions can be not only String, but images, videos etc. other types.
    associatedtype Question: Hashable
    associatedtype Answer
    
    func routeTo(question: Question, answerCallback: @escaping (Answer) -> Void)
    func routeTo(result: [Question: Answer])
}

class Flow <Question, Answer, R: Router> where R.Question == Question, R.Answer == Answer {
    // MARK: - Properties
    private let router: R
    private let questions: [Question]
    private var result: [Question: Answer] = [:]
    
    // MARK: - Lifecycle
    init(questions: [Question], router: R) {
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
    
    private func nextCallback(from question: Question) -> (Answer) -> Void {
        return { [weak self] in self?.routeNext(question, $0) }
    }
    
    // Implements the recurstion of questions flow
    private func routeNext(_ question: Question, _ answer: Answer) {
        guard let currentQuestionIndex =
                questions.firstIndex(of: question)
        else { return }
        result[question] = answer
        
        let nextQuestionIndex = currentQuestionIndex + 1
        
        guard nextQuestionIndex < questions.count
        else { self.router.routeTo(result: result)
            return }
        let nextQuestion = questions[nextQuestionIndex]
        router.routeTo(
            question: nextQuestion,
            answerCallback: nextCallback(from: nextQuestion))
    }
}
