//
//  Flow.swift
//  QuizEngine
//
//  Created by Fenominall on 7/16/22.
//

import Foundation

// The engine of the game
final class Flow<Delegate: QuizSources> {
    // MARK: - Properties
    typealias Question = Delegate.Question
    typealias Answer = Delegate.Answer
    
    private let delegate: Delegate
    private let questions: [Question]
    private var answers: [(Question, Answer)] = []
    
    // MARK: - Lifecycle
    init(questions: [Question],
         delegate: Delegate) {
        self.questions = questions
        self.delegate = delegate
    }
    // MARK: - Helpers
    func start() {
        delegateQuestionHandling(at: questions.startIndex)
    }
    
    private func delegateQuestionHandling(at index: Int) {
        guard index < questions.endIndex else {
            delegate.didCompleteQuiz(withAnswers: answers)
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
            self?.answers.replaceOrInsert((question, answer), at: index)
            self?.delegateQuestionHandling(after: index)
        }
    }    
}

private extension Array {
    mutating func replaceOrInsert(_ element: Element, at index: Index) {
        if index < count {
            remove(at: index)
        }
        insert(element, at: index)
    }
}
