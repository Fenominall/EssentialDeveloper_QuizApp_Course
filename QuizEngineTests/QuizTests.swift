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
    private var quiz: Game<String, String, DelegateSpy>!

    override func setUp() {
        super.setUp()
        delegate = DelegateSpy()
        quiz = startGame(
            questions: ["Q1", "Q2"],
            router: delegate,
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
    
    private class DelegateSpy: Router {
        var handledResult: Results<String, String>? = nil
        var anserCallback: (String) -> Void = { _ in }
        
        func routeTo(question: String, answerCallback: @escaping (String) -> Void) {
            self.anserCallback = answerCallback
        }
        func routeTo(result: Results<String, String>) {
            handledResult = result
        }
    }

}
