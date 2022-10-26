//
//  ViewControllerFactory.swift
//  QuizApp
//
//  Created by Fenominall on 8/13/22.
//

import BasicQuizDomain
import UIKit

protocol ViewControllerFactory {
    typealias Answers = [(question: Question<String>, answer: [String])]
    
    func questionViewController(for question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController
    func resultsViewController(for userAnswers: Answers) -> UIViewController
}
