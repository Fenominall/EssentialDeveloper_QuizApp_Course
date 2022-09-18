//
//  ViewControllerFactory.swift
//  QuizApp
//
//  Created by Fenominall on 8/13/22.
//

import QuizEngine
import UIKit

protocol ViewControllerFactory {
    typealias Answers = [(question: Question<String>, answers: [String])]
    
    func questionViewController(for question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController
    func resultsViewController(for userAnswers: Answers) -> UIViewController
    
    func resultsViewController(for result: Results<Question<String>, [String]>) -> UIViewController
}

extension ViewControllerFactory {
    func resultsViewController(for userAnswers: Answers) -> UIViewController {
        UIViewController()
    }
}

