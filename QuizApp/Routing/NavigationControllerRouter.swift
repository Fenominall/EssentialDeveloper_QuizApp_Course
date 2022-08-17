//
//  File.swift
//  QuizApp
//
//  Created by Fenominall on 7/23/22.
//

import QuizEngine
import UIKit

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
    func routeTo(question: Question<String>, answerCallback: @escaping ([String]) -> Void) {
        switch question {
            
        case .singleAnswer(_):
            show(factory.questionViewController(for: question, answerCallback: answerCallback))
        case .multipleAnswer(_):
            let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
            let buttonController = SubmitButtinController(button, answerCallback)
            button.isEnabled = false
            let controller = factory.questionViewController(for: question, answerCallback: { selection in
                buttonController.update(selection)
            })
            controller.navigationItem.rightBarButtonItem = button
            show(controller)
        }
    }
    
    func routeTo(result: Results<Question<String>, [String]>) {
        show(factory.resultsViewController(for: result))
    }
    
    private func show(_ viewController: UIViewController) {
        navigationController.pushViewController(viewController, animated: true)
    }
}

// Implemeting the MVC patter for the submtiButton
// The class is being a controller and the created but is a view, factory provides a model
private class SubmitButtinController: NSObject {
    let button: UIBarButtonItem
    let callBack: ([String]) -> Void
    private var model = [String]()
    
    internal init(_ button: UIBarButtonItem, _ callBack: @escaping ([String]) -> Void) {
        self.button = button
        self.callBack = callBack
        super.init()
        self.setup()
    }

    func update(_ model: [String]) {
        self.model = model
        updateButtonState()
    }
    
    private func updateButtonState() {
        button.isEnabled = model.count > 0
    }
    
    private func setup() {
        button.target = self
        button.action = #selector(fireCallBack)
        updateButtonState()
    }
    
    @objc private func fireCallBack() {
        callBack(model)
    }
}
