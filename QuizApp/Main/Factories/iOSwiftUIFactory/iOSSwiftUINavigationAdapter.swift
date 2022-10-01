//
//  iOSSwiftUIViewControllerFactory.swift
//  QuizApp
//
//  Created by Fenominall on 9/22/22.
//

import SwiftUI
import QuizEngine
import UIKit

class QuizNavigationStore: ObservableObject {
    enum CurrentView {
        case single(SingleAnswerQuestion)
        case multiple(MultipleAnswerQuestion)
        case result(ResultView)
    }
    
    
    @Published var currentView: CurrentView?
}

final class iOSSwiftUINavigationAdapter: QuizSources {
    
    // MARK: - Properties
    typealias Question = QuizEngine.Question<String>
    typealias Answer = [String]
    typealias Answers = [(question: Question, answer: Answer)]
    
    private let navigation: QuizNavigationStore
    private let options: [Question: Answer]
    private let correctAnswers: Answers
    private let playAgain: () -> Void
    private var questions: [Question] {
        return correctAnswers.map { $0.question }
    }
    
    // MARK: - Initializers
    init(navigation: QuizNavigationStore, options: [Question: Answer], correctAnswers: Answers, playAgain: @escaping () -> Void) {
        self.navigation = navigation
        self.options = options
        self.correctAnswers = correctAnswers
        self.playAgain = playAgain
    }
    
    // MARK: - Methods
    func answer(for question: Question, completion: @escaping (Answer) -> Void) {
        guard let options = self.options[question] else {
            fatalError("Couldnot find options for question")
        }
        let presenter = QuestionPresenter(questions: questions, currentQuestion: question)
        switch question {
            // value = question
        case .singleAnswer(let value):
            navigation.currentView = .single(
                SingleAnswerQuestion(
                    title: presenter.title,
                    question: value,
                    options: options,
                    selection: { completion([$0]) }))
        case .multipleAnswer(let value):
            navigation.currentView = .multiple(
                MultipleAnswerQuestion(
                    title: presenter.title,
                    question: value,
                    store: .init(
                        options: options,
                        handler: completion)))
        }
    }
    
    func didCompleteQuiz(withAnswers answers: Answers) {
        let presenter = ResultsPresenter(
            userAnswers: answers,
            correctAnswers: correctAnswers,
            scorer: BasicScore.score)
        
        navigation.currentView = .result(
            ResultView(
                title: presenter.title,
                summary: presenter.summary,
                answers: presenter.presentableAnswer,
                playAgain: playAgain)
        )
    }
}

