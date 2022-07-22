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
    func test_startGame_answerOneOutOfTwoCorrectly_scores1() {
        let router = RouterSpy()
        startGame(questions: ["Q1", "Q2"], router: router, correctAnswers: ["Q1": "A1", "Q2": "A2"])
        
        router.anserCallback("A1")
        router.anserCallback("wrong")
        
        XCTAssertEqual(router.routedResult?.score, 1)
    }
}
 
