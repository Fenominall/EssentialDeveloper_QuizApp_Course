//
//  File.swift
//  QuizApp
//
//  Created by Fenominall on 7/23/22.
//

import Foundation
import QuizEngine
import UIKit

class NavigationControllerRouter: Router {
    // MARK: - Properties
    private let navigationController: UINavigationController

    // MARK: - Lifecycle
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Methods
    func routeTo(question: String, answerCallback: @escaping (String) -> Void) {
        navigationController.pushViewController(UIViewController(), animated: false)
    }
    func routeTo(result: Result<String, String>) {
        
    }
}
