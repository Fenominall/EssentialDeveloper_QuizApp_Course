//
//  iOSSwiftUIViewControllerFactory.swift
//  QuizApp
//
//  Created by Fenominall on 9/22/22.
//

import SwiftUI
import QuizEngine
import UIKit

final class iOSSwiftUINavigationAdapter: QuizSources {
    
    // MARK: - Properties
    typealias Question = QuizEngine.Question<String>
    typealias Answer = [String]
    typealias Answers = [(question: Question, answer: Answer)]
    
//    private let navigation: UINavigationController
    private let show: (UIViewController) -> Void
    private let options: [Question: Answer]
    private let correctAnswers: Answers
    private let playAgain: () -> Void
    private var questions: [Question] {
        return correctAnswers.map { $0.question }
    }
    
    // MARK: - Initializers
    init(show: @escaping (UIViewController) -> Void, options: [Question: Answer], correctAnswers: Answers, playAgain: @escaping () -> Void) {
        self.show = show
        self.options = options
        self.correctAnswers = correctAnswers
        self.playAgain = playAgain
    }
    
    // MARK: - Methods
    func answer(for question: Question, completion: @escaping (Answer) -> Void) {
        show(questionViewController(for: question, answerCallback: completion))
    }
    
    func didCompleteQuiz(withAnswers answers: Answers) {
        show(resultsViewController(for: answers))
    }
    
    //    private func show(_ controller: UIViewController) {
    //        navigation.setViewControllers([controller], animated: true)
    //    }
    
    private func questionViewController(for question: Question, answerCallback: @escaping (Answer) -> Void) -> UIViewController {
        guard let options = self.options[question] else {
            fatalError("Couldnot find options for question")
        }
        return questionViewController(for: question, options: options, answerCallback: answerCallback)
    }
    
    // MARK: - Helpers
    private func questionViewController(
        for question: Question,
        options: Answer,
        answerCallback: @escaping (Answer) -> Void) -> UIViewController {
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
        for question: Question,
        value: String,
        options: Answer,
        allowsMultipleSelection: Bool,
        answerCallback: @escaping (Answer) -> Void) -> QuestionViewController {
            let presenter = QuestionPresenter(questions: questions, currentQuestion: question)
            let controller = QuestionViewController(
                question: value,
                options: options,
                allowsMultipleSelection: allowsMultipleSelection,
                selection: answerCallback)
            controller.title = presenter.title
            return controller
        }
    
    private func resultsViewController(for userAnswers: Answers) -> UIViewController {
        let presenter = ResultsPresenter(
            userAnswers: userAnswers,
            correctAnswers: correctAnswers,
            scorer: BasicScore.score)
        
        return UIHostingController(
            rootView: ResultView(
                title: presenter.title,
                summary: presenter.summary,
                answers: presenter.presentableAnswer,
                playAgain: playAgain)
        )
    }
}

