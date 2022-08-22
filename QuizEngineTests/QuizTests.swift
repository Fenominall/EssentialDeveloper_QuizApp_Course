//
//  QuizTests.swift
//  QuizEngineTests
//
//  Created by Fenominall on 8/22/22.
//

import XCTest
import QuizEngine

class QuizTests: XCTestCase {
    private var router: DeprecatedRouterSpy!
    private var game: Game<String, String, DeprecatedRouterSpy>!

    override func setUp() {
        super.setUp()
        router = DeprecatedRouterSpy()
        game = startGame(
            questions: ["Q1", "Q2"],
            router: router,
            correctAnswers: ["Q1": "A1", "Q2": "A2"])
    }
    
    override func tearDown() {
        router = nil
        game = nil
        super.tearDown()
    }
    
    func test_startGame_answerZeroOutOfTwoCorrectly_scoresZero() {
        router.anserCallback("wrong")
        router.anserCallback("wrong")
        
        XCTAssertEqual(router.routedResult?.score, 0)
    }
    
    func test_startGame_answerOneOutOfTwoCorrectly_scoresOne() {
        router.anserCallback("A1")
        router.anserCallback("wrong")
        
        XCTAssertEqual(router.routedResult?.score, 1)
    }
    
    func test_startGame_answerTwoOutOfTwoCorrectly_scoresTwo() {
        router.anserCallback("A1")
        router.anserCallback("A2")
        
        XCTAssertEqual(router.routedResult?.score, 2)
    }
    
    private class DeprecatedRouterSpy: Router {
        var routedResult: Results<String, String>? = nil
        var anserCallback: (String) -> Void = { _ in }
        
        func routeTo(question: String, answerCallback: @escaping (String) -> Void) {
            self.anserCallback = answerCallback
        }
        func routeTo(result: Results<String, String>) {
            routedResult = result
        }
    }

}
