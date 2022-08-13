//
//  iOSViewControllerFactoryTests.swift
//  QuizAppTests
//
//  Created by Fenominall on 8/13/22.
//

import UIKit
import XCTest
@testable import QuizApp

class iOSViewControllerFactoryTests: XCTestCase {
    let options = ["A1", "A2"]
    
    // MARK: - Single Answer
    func test_questionViewController_singleAnswer_createsControllerWithQuestion() {
        XCTAssertEqual(makeQuestionController(question: Question.singleAnswer("Q1")).question, "Q1")
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithOptions() {
        XCTAssertEqual(makeQuestionController(question: Question.singleAnswer("Q1")).options, options)
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithSingleSelection() {
        let controller = makeQuestionController(question: Question.singleAnswer("Q1"))
        controller.loadViewIfNeeded()
        XCTAssertFalse(controller.tableView.allowsMultipleSelection)
    }
    
    // MARK: - Multiple Answer
    func test_questionViewController_multipleAnswer_createsControllerWithQuestion() {
        XCTAssertEqual(makeQuestionController(question: Question.multipleAnswer("Q1")).question, "Q1")
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithOptions() {
        XCTAssertEqual(makeQuestionController(question: Question.multipleAnswer("Q1")).options, options)
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithSingleSelection() {
        let controller = makeQuestionController(question: Question.multipleAnswer("Q1"))
        controller.loadViewIfNeeded()
        XCTAssertTrue(controller.tableView.allowsMultipleSelection)
    }
    
    
    // MARK: - Helpers
    func makeSUT(options: [Question<String>: [String]]) -> iOSViewControllerFactory {
        return iOSViewControllerFactory(options: options)
    }
    
    func makeQuestionController(question: Question<String> = Question.singleAnswer("")) -> QuestionViewController {
        return makeSUT(options: [question: options]).questionViewController(for: question) { _ in } as! QuestionViewController
    }
}
