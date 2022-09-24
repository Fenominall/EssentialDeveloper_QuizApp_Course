//
//  iOSViewControllerFactoryTests.swift
//  QuizAppTests
//
//  Created by Fenominall on 8/13/22.
//

import SwiftUI
import UIKit
import XCTest
@testable import QuizApp
import QuizEngine

class iOSSwiftUIViewControllerFactoryTests: XCTestCase {

    // MARK: - Single Answer
    func test_questionViewController_singleAnswer_createsControllerWithTitle() throws {
        let presenter = QuestionPresenter(questions: questions, currentQuestion: singleAnswerQuestion)
        let view = try XCTUnwrap(makeSingleAnswerQuestion())
        
        XCTAssertEqual(view.title, presenter.title)
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithQuestion() throws {
        let view = try XCTUnwrap(makeSingleAnswerQuestion())

        XCTAssertEqual(view.question, "Q1")
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithOptions() throws {
        let view = try XCTUnwrap(makeSingleAnswerQuestion())

        XCTAssertEqual(view.options, options[singleAnswerQuestion])
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithAnswerCallback() throws {
        var answers = [[String]]()
        let view = try XCTUnwrap(makeSingleAnswerQuestion(answerCallBack: { answers.append($0) }))

        XCTAssertEqual(answers, [])
        
        view.selection(view.options[0])
        XCTAssertEqual(answers, [[view.options[0]]])
        
        view.selection(view.options[1])
        XCTAssertEqual(answers, [[view.options[0]], [view.options[1]]])
    }
    // MARK: - Multiple Answer
    
    func test_questionViewController_MultipleAnswer_CreatesControllerWithTitle() throws {
        let presenter = QuestionPresenter(questions: questions, currentQuestion: multipleAnswerQuestion)
        let view = try XCTUnwrap(makeMultipleAnswerQuestion())
        
        XCTAssertEqual(view.title, presenter.title)
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithQuestion() throws {
        let view = try XCTUnwrap(makeMultipleAnswerQuestion())
        XCTAssertEqual(view.question, "Q2")
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithOptions() throws {
        let view = try XCTUnwrap(makeMultipleAnswerQuestion())

        XCTAssertEqual(view.store.options.map(\.text), options[multipleAnswerQuestion])
    }
    
    // MARK: - Results
    func test_resultsViewController_createsControllerWithSummary() throws {
        let (view, presenter) = try XCTUnwrap( makeResults())
        
        XCTAssertEqual(view.summary, presenter.summary)
    }
    
    func test_resultsViewController_createsControllerWithTitle() throws {
        let (view, presenter) = try XCTUnwrap( makeResults())
        
        XCTAssertEqual(view.title, presenter.title)
    }
    
    func test_resultsViewController_createsControllerWithPresentableAnswer() throws {
        let (view, presenter) = try XCTUnwrap( makeResults())
        
        XCTAssertEqual(view.answers, presenter.presentableAnswer)
    }
    
    
    // MARK: - Helpers
    private var singleAnswerQuestion: Question<String> { .singleAnswer("Q1") }
    private var multipleAnswerQuestion: Question<String> { .multipleAnswer("Q2") }
    private var questions: [Question<String>] {
        [singleAnswerQuestion, multipleAnswerQuestion]
    }
    
    private var options: [Question<String>: [String]] {
        [singleAnswerQuestion: ["A1", "A2", "A3"], multipleAnswerQuestion: ["A4", "A5", "A6"]]
    }
    
    private var correctAnswers: [(Question<String>, [String])] {
        [(singleAnswerQuestion, ["A1"]), (multipleAnswerQuestion, ["A4", "A5"])]
    }
    
    private func makeSUT() -> iOSSwiftUIViewControllerFactory {
        return iOSSwiftUIViewControllerFactory(options: options, correctAnswers: correctAnswers)
    }
    
    private func makeSingleAnswerQuestion(answerCallBack: @escaping ([String]) -> Void = { _ in }) -> SingleAnswerQuestion? {
        let sut = makeSUT()
        let controller = sut.questionViewController(
            for: singleAnswerQuestion,
            answerCallback: answerCallBack) as? UIHostingController<SingleAnswerQuestion>
        return controller?.rootView
    }
    
    private func makeMultipleAnswerQuestion(answerCallBack: @escaping ([String]) -> Void = { _ in }) -> MultipleAnswerQuestion? {
        let sut = makeSUT()
        let controller = sut.questionViewController(
            for: multipleAnswerQuestion,
            answerCallback: answerCallBack) as? UIHostingController<MultipleAnswerQuestion>
        return controller?.rootView
    }
    
    private func makeQuestionController(question: Question<String>, answerCallBack: @escaping ([String]) -> Void = { _ in }) -> QuestionViewController {
        let sut = makeSUT()
        let controller = sut.questionViewController(for: question, answerCallback: answerCallBack) as! QuestionViewController
        return controller
    }
    
    private func makeResults() -> (view: ResultView, presenter: ResultsPresenter)? {
        let sut = makeSUT()
        let controller = sut.resultsViewController(for: correctAnswers) as? UIHostingController<ResultView>
        
        let presenter = ResultsPresenter(
            userAnswers: correctAnswers,
            correctAnswers: correctAnswers,
            scorer: BasicScore.score)
        
        return controller.map { ($0.rootView, presenter) }
    }
}
