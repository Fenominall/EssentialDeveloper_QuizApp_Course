//
//  NavigationControllerRouterTests.swift
//  QuizAppTests
//
//  Created by Fenominall on 7/23/22.
//

import XCTest
@testable import QuizApp
@testable import QuizEngine

class NavigationControllerRouterTests: XCTestCase {

    func test_answerForQuestion_showsQuestionController() {
        let viewController = UIViewController()
        let secondViewController = UIViewController()
        factory.stub(question: singleAnswerQuestion, with: viewController)
        factory.stub(question: multipleAnswerQuestion, with: secondViewController)
        
        sut.answer(for: singleAnswerQuestion, completion: { _ in })
        sut.answer(for: multipleAnswerQuestion, completion: { _ in })
        
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertEqual(navigationController.viewControllers.first, viewController)
        XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
    }
    
    func test_answerForQuestion_singleAnswer_answerCallback_progressesToNextQuestion() {

        var callbackWasFired = false
        sut.answer(for: singleAnswerQuestion, completion: { _ in callbackWasFired = true })
        factory.answerCallback[singleAnswerQuestion]!(["anything"])
        
        XCTAssertTrue(callbackWasFired)
    }
    
    func test_answerForQuestion_multipleAnswer_answerCallback_doesNotProgressesToNextQuestion() {
        var callbackWasFired = false
        
        sut.answer(for: multipleAnswerQuestion, completion: { _ in callbackWasFired = true })
        factory.answerCallback[multipleAnswerQuestion]!(["anything"])
        
        XCTAssertFalse(callbackWasFired)
    }
    
    // MARK: - Testing Submit Button
    func test_answerForQuestion_singleAnswer_doesNotconfigureViewControllerWithSubmitButton() {
        let viewController = UIViewController()
        
        factory.stub(question: singleAnswerQuestion, with: viewController)
        
        sut.answer(for: singleAnswerQuestion, completion: { _ in  })
        
        XCTAssertNil(viewController.navigationItem.rightBarButtonItem)
    }
    
    func test_answerForQuestion_multipleAnswer_configuresViewControllerWithSubmitButton() {
        let viewController = UIViewController()

        factory.stub(question: multipleAnswerQuestion, with: viewController)
        
        sut.answer(for: multipleAnswerQuestion, completion: { _ in })

        XCTAssertNotNil(viewController.navigationItem.rightBarButtonItem)
    }
    
    func test_answerForQuestion_multipleAnswerSubmitButton_isDissabledWhenZeroAnswersSelected() {
        let viewController = UIViewController()
        factory.stub(question: multipleAnswerQuestion, with: viewController)
        
        sut.answer(for: multipleAnswerQuestion, completion: { _ in })
        XCTAssertFalse(viewController.navigationItem.rightBarButtonItem!.isEnabled)
        
        factory.answerCallback[multipleAnswerQuestion]!(["anything"])
        XCTAssertTrue(viewController.navigationItem.rightBarButtonItem!.isEnabled)
        
        factory.answerCallback[multipleAnswerQuestion]!([])
        XCTAssertFalse(viewController.navigationItem.rightBarButtonItem!.isEnabled)
    }
    
    func test_answerForToQuestion_multipleAnswerSubmitButton_progressesToNextQuestion() {
        let viewController = UIViewController()
        factory.stub(question: multipleAnswerQuestion, with: viewController)
        
        var callbackWasFired = false
        sut.answer(for: multipleAnswerQuestion, completion: { _ in callbackWasFired = true })
        
        factory.answerCallback[multipleAnswerQuestion]!(["anything"])
        let button = viewController.navigationItem.rightBarButtonItem
        button?.simulateTap()
        XCTAssertTrue(callbackWasFired)
    }

    
    func test_didCompleteQuiz_showsResultController() {
        let viewController = UIViewController()
        let userAnswers = [(singleAnswerQuestion, ["A1"])]
        
        let secondViewController = UIViewController()
        let secondUserAnswers = [(multipleAnswerQuestion, ["A2"])]
        
        factory.stub(resultForQuestions: [singleAnswerQuestion], with: viewController)
        factory.stub(resultForQuestions: [multipleAnswerQuestion], with: secondViewController)
        
        sut.didCompleteQuiz(withAnswers: userAnswers)
        sut.didCompleteQuiz(withAnswers: secondUserAnswers)
        
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertEqual(navigationController.viewControllers.first, viewController)
        XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
    }
    
    // MARK: - Helpers
    private let singleAnswerQuestion = Question.singleAnswer("Q1")
    private let multipleAnswerQuestion = Question.multipleAnswer("Q1")
    
    private let navigationController = NonAnimatedNavigationController()
    private let factory = ViewControllerFactoryStub()
    
    private lazy var sut: NavigationControllerRouter = {
        return NavigationControllerRouter(
            self.navigationController,
            factory: self.factory)
    }()
    
    private class NonAnimatedNavigationController: UINavigationController {
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            super.pushViewController(viewController, animated: false)
        }
    }
    
    private class ViewControllerFactoryStub: ViewControllerFactory {
        private var stubbedQuestions = [Question<String>: UIViewController]()
        private var stubbedResults = [[Question<String>]: UIViewController]()
        var answerCallback = [Question<String>: ([String]) -> Void]()
        
        func stub(question: Question<String>, with viewController: UIViewController) {
            stubbedQuestions[question] = viewController
        }
        
        func stub(resultForQuestions questions: [Question<String>], with viewController: UIViewController) {
            stubbedResults[questions] = viewController
        }
        
        func questionViewController(for question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController {
            self.answerCallback[question] = answerCallback
            return stubbedQuestions[question] ?? UIViewController()
        }
        
        func resultsViewController(for userAnswers: Answers) -> UIViewController {
            return stubbedResults[userAnswers.map { $0.question }] ?? UIViewController()
        }

        func resultsViewController(for result: Results<Question<String>, [String]>) -> UIViewController {
            return UIViewController()
        }
    }
}

private extension  UIBarButtonItem {
    func simulateTap() {
        target!.performSelector(onMainThread: action!, with: nil, waitUntilDone: true)
    }
}
