//
//  ScoreTests.swift
//  QuizEngineTests
//
//  Created by Fenominall on 8/29/22.
//

import XCTest
import QuizApp

class ScoreTests: XCTestCase {

    func test_noAnswers_scoresZero() {
//        XCTAssertEqual(BasicScore.score(for: [], comparingTo: []), 0)
    }
    
    func test_oneNonMantchingAswers_scoresZero() {
        XCTAssertEqual(BasicScore.score(for: ["not a match"], comparingTo: ["an answer"]), 0)
    }
    
    func test_oneMantchingAnswers_scoresOne() {
        XCTAssertEqual(BasicScore.score(for: ["an answer"], comparingTo: ["an answer"]), 1)
    }
    
    func test_oneMantchingAnswerOneWrongAnswer_scoresOne() {
        let score = BasicScore.score(
            for: ["an answer", "not a match"],
            comparingTo: ["an answer", "another answer"])
        XCTAssertEqual(score, 1)
    }
    
    func test_twoMantchingAnswers_scoresTwo() {
        let score = BasicScore.score(
            for: ["an answer", "another answer"],
            comparingTo: ["an answer", "another answer"])
        XCTAssertEqual(score, 2)
    }
    
    func test_withTwoManyAnswers_twoMantchingAnswers_scoresTwo() {
        let score = BasicScore.score(
            for: ["an answer", "another answer", "an extra answer"],
            comparingTo: ["an answer", "another answer"])
        XCTAssertEqual(score, 2)
    }
    
    func test_withTwoManyMatchingAnswers_oneMantchingAnswers_scoresOne() {
        let score = BasicScore.score(
            for: ["not mantching", "another answer"],
            comparingTo: ["an answer", "another answer", "an extra answer"])
        XCTAssertEqual(score, 1)
    }
}
