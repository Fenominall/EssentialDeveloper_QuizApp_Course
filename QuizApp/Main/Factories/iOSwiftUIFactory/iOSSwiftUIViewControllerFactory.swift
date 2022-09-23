//
//  iOSSwiftUIViewControllerFactory.swift
//  QuizApp
//
//  Created by Fenominall on 9/22/22.
//

import SwiftUI
import QuizEngine
import UIKit

final class iOSSwiftUIViewControllerFactory: ViewControllerFactory {
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
            let presenter = QuestionPresenter(questions: questions, currentQuestion: question)
            switch question {
                // value = question
            case .singleAnswer(let value):
                return UIHostingController(
                    rootView: SingleAnswerQuestion(
                        title: presenter.title,
                        question: value,
                        options: options,
                        selection: { answerCallback([$0]) }))
                
            case .multipleAnswer(let value):
                return UIHostingController(
                    rootView: MultipleAnswerQuestion(
                        title: presenter.title,
                        question: value,
                        store: .init(
                            options: options,
                            handler: answerCallback)))
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
}

