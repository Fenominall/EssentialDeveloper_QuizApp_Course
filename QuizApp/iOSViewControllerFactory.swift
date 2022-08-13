//
//  iOSViewControllerFactory.swift
//  QuizApp
//
//  Created by Fenominall on 8/13/22.
//

import QuizEngine
import UIKit

class iOSViewControllerFactory: ViewControllerFactory {
    private var options = [Question<String>: [String]]()
    
    init(options: [Question<String>: [String]]) {
        self.options = options
    }
    
    func questionViewController(for question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController {
        guard let options = self.options[question] else {
            fatalError("Couldnot find options for question")
        }
        return questionViewController(for: question, options: options, answerCallback: answerCallback)
    }
    
    private func questionViewController(
        for question: Question<String>,
        options: [String],
        answerCallback: @escaping ([String]) -> Void) -> UIViewController {
            switch question {
            case .singleAnswer(let value):
                return QuestionViewController(
                    question: value,
                    options: options,
                    selection: answerCallback)
            case .multipleAnswer(let value):
                let controller = QuestionViewController(
                    question: value,
                    options: options,
                    selection: answerCallback)
                controller.loadViewIfNeeded()
                controller.tableView.allowsMultipleSelection = true
                return controller
            }
        }
    
    func resultsViewController(for result: Results<Question<String>, [String]>) -> UIViewController {
        UIViewController()
    }
}
