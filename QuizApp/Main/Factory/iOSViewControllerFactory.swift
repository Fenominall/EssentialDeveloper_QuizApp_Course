//
//  iOSViewControllerFactory.swift
//  QuizApp
//
//  Created by Fenominall on 8/13/22.
//

import QuizEngine
import UIKit

final class iOSViewControllerFactory: ViewControllerFactory {
    // MARK: - Properties
    typealias Answers = [(question: Question<String>, answer: [String])]
    
    private let options: [Question<String>: [String]]
    private let correctAnswers: Answers
    
    private var questions: [Question<String>] {
        return correctAnswers.map { $0.question }
    }
    
    // MARK: - Initializers
    init(options: [Question<String>: [String]], correctAnswers: Answers) {
        self.options = options
        self.correctAnswers = correctAnswers
    }

    // MARK: - Methods
    func questionViewController(for question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController {
        guard let options = self.options[question] else {
            fatalError("Couldnot find options for question")
        }
        return questionViewController(for: question, options: options, answerCallback: answerCallback)
    }

    // MARK: - Helpers
    private func questionViewController(
        for question: Question<String>,
        options: [String],
        answerCallback: @escaping ([String]) -> Void) -> UIViewController {
            switch question {
            case .singleAnswer(let value):
                return questionViewController(for: question, value: value, options: options, allowsMultipleSelection: false, answerCallback: answerCallback)
            case .multipleAnswer(let value):
                let controller = questionViewController(for: question, value: value, options: options, allowsMultipleSelection: true, answerCallback: answerCallback)
                return controller
            }
        }
    
    private func questionViewController(
        for question: Question<String>,
        value: String,
        options: [String],
        allowsMultipleSelection: Bool,
        answerCallback: @escaping ([String]) -> Void) -> QuestionViewController {
            let presenter = QuestionPresenter(questions: questions, currentQuestion: question)
            let controller = QuestionViewController(
                question: value,
                options: options,
                allowsMultipleSelection: allowsMultipleSelection,
                selection: answerCallback)
            controller.title = presenter.title
            return controller
        }
    
    func resultsViewController(for userAnswers: Answers) -> UIViewController {
        let presenter = ResultsPresenter(
            userAnswers: userAnswers,
            correctAnswers: correctAnswers,
            scorer: BasicScore.score)
        
        let controller = ResultsViewController(summary: presenter.summary, answers: presenter.presentableAnswer)
        controller.title = presenter.title
        return controller
    }
    
    func resultsViewController(for result: Results<Question<String>, [String]>) -> UIViewController {
        let presenter = ResultsPresenter(
            userAnswers: questions.map { question in
                (question, result.answers[question]! )
            },
            correctAnswers: correctAnswers,
            scorer: { _, _ in result.score })

        let controller = ResultsViewController(summary: presenter.summary, answers: presenter.presentableAnswer)
        controller.title = presenter.title
        return controller
    }
}
