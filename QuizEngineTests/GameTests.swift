//
//  GameTests.swift
//  QuizEngineTests
//
//  Created by Fenominall on 7/22/22.
//

import Foundation
import XCTest
@testable import QuizEngine

@available(*, deprecated)
class DeprecatedGameTests: XCTestCase {
    var router: RouterSpy!
    var game: Game<String, String, RouterSpy>!

    override func setUp() {
        super.setUp()
        router = RouterSpy()
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
        var routedQuestions: [String] = []
        var routedResult: Results<String, String>? = nil
        var anserCallback: (String) -> Void = { _ in }
        
        func routeTo(question: String, answerCallback: @escaping (String) -> Void) {
            routedQuestions.append(question)
            self.anserCallback = answerCallback
        }
        func routeTo(result: Results<String, String>) {
            routedResult = result
        }
    }

}
