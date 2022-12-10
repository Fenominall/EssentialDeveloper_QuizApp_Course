//
//  File.swift
//  QuizApp
//
//  Created by Fenominall on 7/23/22.
//

import UIKit
import QuizEngine
import BasicQuizDomain

final class NavigationControllerRouter: QuizSources {
    
    // MARK: - Properties
    private let navigationController: UINavigationController
    private let factory: ViewControllerFactory
    
    // MARK: - Lifecycle
    init(_ navigationController: UINavigationController, factory: ViewControllerFactory) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    // MARK: - Methods
    func answer(for question: Question<String>, completion: @escaping ([String]) -> Void) {
        switch question {
            
        case .singleAnswer:
            show(factory.questionViewController(for: question, answerCallback: completion))
        case .multipleAnswer:
            let button = UIBarButtonItem(title: "Submit", style: .done, target: nil, action: nil)
            let buttonController = SubmitButtonController(button, completion)
            let controller = factory.questionViewController(
                for: question,
                answerCallback: { selection in
                    buttonController.update(selection)
                })
            controller.navigationItem.rightBarButtonItem = button
            show(controller)
        }
    }
    
    func didCompleteQuiz(withAnswers answers: [(question: Question<String>, answer: [String])]) {
        show(factory.resultsViewController(for: answers.map { $0 }))
    }
    
    private func show(_ viewController: UIViewController) {
        navigationController.pushViewController(viewController, animated: true)
    }
}

// Implemeting the MVC pattern for the Submit Button
// The NavigationControllerRouter class is a controller and the created button is a view, factory provides a model
private class SubmitButtonController: NSObject {
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
