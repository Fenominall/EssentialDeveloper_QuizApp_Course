//
//  FlowTests.swift
//  QuizEngineTests
//
//  Created by Fenominall on 7/16/22.
//

import Foundation
import XCTest
@testable import QuizEngine

class FlowTests: XCTestCase {
    var router: RouterSpy!
    
    override func setUp() {
        super.setUp()
        router = RouterSpy()
    }
    
    override func tearDown() {
        super.tearDown()
        router = nil
    }
    
    func test_start_withNoQuestions_doesNotRouteToQuestion() {
        makeSUT(questions: []).start()
        XCTAssertTrue(router.routedQuestions.isEmpty)
    }
    
    func test_start_withOneQuestion_routesToCorrectQuestion() {
        let question1 = makeQuestion()
        makeSUT(questions: [question1]).start()
        XCTAssertEqual(router.routedQuestions, [question1])
    }
    
    func test_start_withOneQuestion_routesToQuestion_2() {
        let question2 = makeQuestion("Q2")
        makeSUT(questions: [question2]).start()
        XCTAssertEqual(router.routedQuestions, [question2])
    }
    
    func test_start_withTwoQuestion_routesToFirstQuestion() {
        let questions = makeQuestions()
        makeSUT(questions: questions).start()
        XCTAssertEqual(router.routedQuestions, [questions[0]])
    }
    
    func test_startTwice_withTwoQuestion_routesToFirstQuestionTwice() {
        let question1 = makeQuestion()
        let sut = makeSUT(questions: [question1, makeQuestion("Q2")])
        sut.start()
        sut.start()
        XCTAssertEqual(router.routedQuestions, [question1, question1])
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withThreeQuestions_routesToSecondAndThridQuestion() {
        let questions = ["Q1", "Q2", "Q3"]
        let sut = makeSUT(questions: questions)
        sut.start()
        
        router.anserCallback("A1")
        router.anserCallback("A2")
        
        XCTAssertEqual(router.routedQuestions, questions)
    }
    
    func test_startAndAnswerFirstQuestion_withOneQuestions_doesNotRouteToAnotherQuestion() {
        let question = makeQuestion()
        let sut = makeSUT(questions: [question])
        sut.start()
        
        router.anserCallback("A1")
        
        XCTAssertEqual(router.routedQuestions, [question])
    }
    
    func test_start_withNoQuestions_routesToResult() {
        makeSUT(questions: []).start()
        XCTAssertEqual(router.routedResult, [:])
    }
    
    func test_startWithOneQuestion_doesNotRouteToResult() {
        makeSUT(questions: [makeQuestion()]).start()
        XCTAssertNil(router.routedResult)
    }
    
    func test_startAndAnswerFirstQuestion_withTwoQuestions_doesNotRouteToResult() {
        let questions = makeQuestions()
        let sut = makeSUT(questions: questions)
        sut.start()
        
        router.anserCallback("A1")
        
        XCTAssertNil(router.routedResult)
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestions_routesToResult() {
        let questions = makeQuestions()
        let sut = makeSUT(questions: questions)
        sut.start()
        
        router.anserCallback("A1")
        router.anserCallback("A2")
        
        XCTAssertEqual(router.routedResult, [questions[0]: "A1", questions[1]: "A2"])
    }
    
    // MARK: - Helpers
    private func makeSUT(questions: [String]) -> Flow {
        return Flow(questions: questions, router: router)
    }
    
    private func makeQuestion(
        _ question: String = "Q1") -> String {
            question
        }
    
    private func makeQuestions() -> [String] {
        [makeQuestion(), makeQuestion("Q2")]
    }
    
    class RouterSpy: Router {
        var routedQuestions: [String] = []
        var routedResult: [String: String]?
        var anserCallback: Router.AnswerCallback = { _ in }
        
        func routeTo(question: String, answerCallback: @escaping Router.AnswerCallback) {
            routedQuestions.append(question)
            self.anserCallback = answerCallback
        }
        func routeTo(result: [String : String]) {
            routedResult = result
        }
    }
}
