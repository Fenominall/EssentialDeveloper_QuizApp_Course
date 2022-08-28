//
//  Flow.swift
//  QuizEngine
//
//  Created by Fenominall on 7/16/22.
//

import Foundation

class Flow<Delegate: QuizDelegate> {
    // MARK: - Properties
    typealias Question = Delegate.Question
    typealias Answer = Delegate.Answer
    
    private let delegate: Delegate
    private let questions: [Question]
    private var answers: [Question: Answer] = [:]
    private var newaAswers: [(Question, Answer)] = []
    // Calculating the score it`s a separate responisiblity that should not depend on the Flow module
    private var scoring: ([Question: Answer]) -> Int
    
    // MARK: - Lifecycle
    init(questions: [Question],
         delegate: Delegate,
         scoring: @escaping ([Question: Answer]) -> Int = { _ in 0}) {
        self.questions = questions
        self.delegate = delegate
        self.scoring = scoring
    }
    // MARK: - Helpers
    func start() {
        delegateQuestionHandling(at: questions.startIndex)
    }
    
    private func delegateQuestionHandling(at index: Int) {
        guard index < questions.endIndex else {
            delegate.didCompleteQuiz(withAnswers: newaAswers)
            delegate.handle(result: result())
            return }
        let question = questions[index]
        delegate.answer(for: question,
                        completion: answer(for: question, at: index))
    }
    
    private func delegateQuestionHandling(after index: Int) {
        delegateQuestionHandling(at: questions.index(after: index))
    }
    
    private func answer(for question: Question, at index: Int) -> (Answer) -> Void {
        return { [weak self] answer in
            self?.newaAswers.append((question, answer))
            self?.answers[question] = answer
            self?.delegateQuestionHandling(after: index)
        }
    }
    
    private func result() -> Results<Question, Answer> {
        return Results(answers: answers, score: scoring(answers))
    }
}
