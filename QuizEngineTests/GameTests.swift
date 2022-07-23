//
//  GameTests.swift
//  QuizEngineTests
//
//  Created by Fenominall on 7/22/22.
//

import Foundation
import XCTest
import QuizEngine

class GameTests: XCTestCase {
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
}
