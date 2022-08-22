//
//  QuizTests.swift
//  QuizEngineTests
//
//  Created by Fenominall on 8/22/22.
//

import XCTest
@testable import QuizEngine

final class Quiz {

    private let flow: Any
    
    private init(flow: Any) {
        self.flow = flow
    }
    
    static func start<Question, Answer: Equatable, Delegate: QuizDelegate>
    (questions: [Question],
     delegate: Delegate,
     correctAnswers: [Question: Answer]) -> Quiz where
    Delegate.Question == Question, Delegate.Answer == Answer {
        let flow = Flow(
            questions: questions,
            delegate: delegate,
            scoring: { scoring($0, correctAnswers: correctAnswers) })
        flow.start()
        return Quiz(flow: flow)
    }
}

class QuizTests: XCTestCase {
    private var delegate: DelegateSpy!
    private var quiz: Quiz!

    override func setUp() {
        super.setUp()
        delegate = DelegateSpy()
        quiz = Quiz.start(
            questions: ["Q1", "Q2"],
            delegate: delegate,
            correctAnswers: ["Q1": "A1", "Q2": "A2"])
    }
    
    override func tearDown() {
        delegate = nil
        quiz = nil
        super.tearDown()
    }
    
    func test_startQuiz_answerZeroOutOfTwoCorrectly_scoresZero() {
        delegate.anserCallback("wrong")
        delegate.anserCallback("wrong")
        
        XCTAssertEqual(delegate.handledResult?.score, 0)
    }
    
    func test_startQuiz_answerOneOutOfTwoCorrectly_scoresOne() {
        delegate.anserCallback("A1")
        delegate.anserCallback("wrong")
        
        XCTAssertEqual(delegate.handledResult?.score, 1)
    }
    
    func test_startQuiz_answerTwoOutOfTwoCorrectly_scoresTwo() {
        delegate.anserCallback("A1")
        delegate.anserCallback("A2")
        
        XCTAssertEqual(delegate.handledResult?.score, 2)
    }
    
    private class DelegateSpy: Router, QuizDelegate {
        var handledResult: Results<String, String>? = nil
        var anserCallback: (String) -> Void = { _ in }
        
        func handle(question: String, answerCallback: @escaping (String) -> Void) {
            self.anserCallback = answerCallback
        }
        
        func handle(result: Results<String, String>) {
            handledResult = result
        }
    
        func routeTo(question: String, answerCallback: @escaping (String) -> Void) {
            handle(question: question, answerCallback: answerCallback)
        }
        func routeTo(result: Results<String, String>) {
            handle(result: result)
        }
    }

}
