//
//  File.swift
//  QuizApp
//
//  Created by Fenominall on 7/23/22.
//

import Foundation
import QuizEngine
import UIKit

protocol ViewControllerFactory {
    func questionViewController(for question: Question<String>, answerCallback: @escaping (String) -> Void) -> UIViewController
    func resultsViewController(for result: Results<Question<String>, String>) -> UIViewController
}


class NavigationControllerRouter: Router {
    // MARK: - Properties
    private let navigationController: UINavigationController
    private let factory: ViewControllerFactory
    
    // MARK: - Lifecycle
    init(_ navigationController: UINavigationController, factory: ViewControllerFactory) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    // MARK: - Methods
    func routeTo(question: Question<String>, answerCallback: @escaping (String) -> Void) {
        show(factory.questionViewController(for: question, answerCallback: answerCallback))
    }
    
    func routeTo(result: Results<Question<String>, String>) {
        show(factory.resultsViewController(for: result))
    }
    
    private func show(_ viewController: UIViewController) {
        navigationController.pushViewController(viewController, animated: true)
    }
}
