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
    func questionViewController(for question: String, answerCallback: @escaping (String) -> Void) -> UIViewController
    
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
    func routeTo(question: String, answerCallback: @escaping (String) -> Void) {
        let viewController = factory.questionViewController(for: question, answerCallback: answerCallback)
        navigationController.pushViewController(viewController, animated: true)
    }
    func routeTo(result: Result<String, String>) {
        
    }
}
