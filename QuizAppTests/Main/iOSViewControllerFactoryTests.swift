//
//  iOSViewControllerFactoryTests.swift
//  QuizAppTests
//
//  Created by Fenominall on 8/13/22.
//

import UIKit
import XCTest
@testable import QuizApp
import QuizEngine

class iOSViewControllerFactoryTests: XCTestCase {
    let singleAnswerQuestion = Question.singleAnswer("Q1")
    let multipleAnswerQuestion = Question.multipleAnswer("Q1")
    let options = ["A1", "A2"]
    
    // MARK: - Single Answer
    func test_questionViewController_singleAnswer_createsControllerWithTitle() {
        let presenter = QuestionPresenter(questions: [singleAnswerQuestion], currentQuestion: singleAnswerQuestion)
        XCTAssertEqual(makeQuestionController(question: singleAnswerQuestion).title, presenter.title)
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithQuestion() {
        XCTAssertEqual(makeQuestionController(question: singleAnswerQuestion).question, "Q1")
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithOptions() {
        XCTAssertEqual(makeQuestionController(question: singleAnswerQuestion).options, options)
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithSingleSelection() {
        XCTAssertFalse(makeQuestionController(question: singleAnswerQuestion).allowsMultipleSelection)
    }
    
    // MARK: - Multiple Answer
    
    func test_questionViewController_MultipleAnswer_CreatesControllerWithTitle() {
        let presenter = QuestionPresenter(questions: [singleAnswerQuestion, multipleAnswerQuestion], currentQuestion: multipleAnswerQuestion)
        XCTAssertEqual(makeQuestionController(question: multipleAnswerQuestion).title, presenter.title)
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithQuestion() {
        XCTAssertEqual(makeQuestionController(question: multipleAnswerQuestion).question, "Q1")
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithOptions() {
        XCTAssertEqual(makeQuestionController(question: multipleAnswerQuestion).options, options)
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithSingleSelection() {
        let controller = makeQuestionController(question: multipleAnswerQuestion)
        controller.loadViewIfNeeded()
        XCTAssertTrue(controller.tableView.allowsMultipleSelection)
    }
    
    func test_resultsViewController_createsControllerWithSummary() {
        let results = makeResults()
        
        XCTAssertEqual(results.0.summary, results.1.summary)
    }
    
    func test_resultsViewController_createsControllerWithTitle() {
        let results = makeResults()
        
        XCTAssertEqual(results.controller.title, results.presenter.title)
    }
    
    func test_resultsViewController_createsControllerWithPresentableAnswer() {
        let results = makeResults()
        
        XCTAssertEqual(results.controller.answers.count, results.presenter.presentableAnswer.count)
    }
    
    
    // MARK: - Helpers
    func makeSUT(options: [Question<String>: [String]] = [:], correctAnswers: [Question<String>: [String]] = [:]) -> iOSViewControllerFactory {
        return iOSViewControllerFactory(questions: [singleAnswerQuestion, multipleAnswerQuestion], options: options, correctAnswers: correctAnswers)
    }
    
    func makeQuestionController(question: Question<String> = Question.singleAnswer("")) -> QuestionViewController {
        return makeSUT(options: [question: options]).questionViewController(for: question) { _ in } as! QuestionViewController
    }
    
    func makeResults() -> (controller: ResultsViewController, presenter: ResultsPresenter) {
        let questions = [singleAnswerQuestion, multipleAnswerQuestion]
        let userAnswers = [singleAnswerQuestion: ["A1"], multipleAnswerQuestion: ["A1", "A2"]]
        let correctAnswers = [singleAnswerQuestion: ["A1"], multipleAnswerQuestion: ["A1", "A2"]]
        let result = Results.make(answers: userAnswers, score: 2)
        
        let presenter = ResultsPresenter(result: result, questions: questions, correctAnswers: correctAnswers)
        let sut = makeSUT(correctAnswers: correctAnswers)
        
        let controller = sut.resultsViewController(for: result) as! ResultsViewController
        return (controller, presenter)
    }
}

private extension ResultsPresenter {
    // creating a new initializer to change the clients code without breaking the behavoir
    convenience init(result: Results<Question<String>, [String]>, questions: [Question<String>], correctAnswers: [Question<String>: [String]])  {
        self.init(
            userAnswers: questions.map { question in
            (question, result.answers[question]! )},
            correctAnswers: questions.map { question in
                (question, correctAnswers[question]! )},
            scorer: { _, _ in result.score })
    }
    
}
