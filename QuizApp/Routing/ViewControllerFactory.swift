//
//  ViewControllerFactory.swift
//  QuizApp
//
//  Created by Fenominall on 8/13/22.
//

import QuizEngine
import UIKit

protocol ViewControllerFactory {
    
    func questionViewController(for question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController
    func resultsViewController(for result: Results<Question<String>, [String]>) -> UIViewController
}


