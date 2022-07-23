//
//  Flow.swift
//  QuizEngine
//
//  Created by Fenominall on 7/16/22.
//

import Foundation

class Flow <Question, Answer, R: Router> where R.Question == Question, R.Answer == Answer {
    // MARK: - Properties
    private let router: R
    private let questions: [Question]
    private var answers: [Question: Answer] = [:]
    // Calculating the score it`s a separate responisiblity that should not depend on the Flow module
    private var scoring: ([Question: Answer]) -> Int
    
    // MARK: - Lifecycle
    init(questions: [Question],
         router: R,
         scoring: @escaping ([Question: Answer]) -> Int) {
        self.questions = questions
        self.router = router
        self.scoring = scoring
    }
    // MARK: - Helpers
    func start() {
        guard let firstQuestion = questions.first
        else {
            router.routeTo(result: result())
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
        answers[question] = answer
        
        let nextQuestionIndex = currentQuestionIndex + 1
        
        guard nextQuestionIndex < questions.count
        else { self.router.routeTo(result: result())
            return }
        let nextQuestion = questions[nextQuestionIndex]
        router.routeTo(
            question: nextQuestion,
            answerCallback: nextCallback(from: nextQuestion))
    }
    
    
    private func result() -> Result<Question, Answer> {
        return Result(answers: answers, score: scoring(answers))
    }
}
