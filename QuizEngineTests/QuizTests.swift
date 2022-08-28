//
//  QuizTests.swift
//  QuizEngineTests
//
//  Created by Fenominall on 8/22/22.
//

import XCTest
import QuizEngine

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
        delegate.answerCompletion("wrong")
        delegate.answerCompletion("wrong")
        
        XCTAssertEqual(delegate.handledResult?.score, 0)
    }
    
    func test_startQuiz_answerOneOutOfTwoCorrectly_scoresOne() {
        delegate.answerCompletion("A1")
        delegate.answerCompletion("wrong")
        
        XCTAssertEqual(delegate.handledResult?.score, 1)
    }
    
    func test_startQuiz_answerTwoOutOfTwoCorrectly_scoresTwo() {
        delegate.answerCompletion("A1")
        delegate.answerCompletion("A2")
        
        XCTAssertEqual(delegate.handledResult?.score, 2)
    }
    
    private class DelegateSpy: QuizDelegate {
        var handledResult: Results<String, String>? = nil
        var answerCompletion: (String) -> Void = { _ in }
        
        func answer(for: String, completion: @escaping (String) -> Void) {
            self.answerCompletion = completion
        }
        
        func handle(result: Results<String, String>) {
            handledResult = result
        }
    }
}
