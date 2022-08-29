//
//  ScoreTests.swift
//  QuizEngineTests
//
//  Created by Fenominall on 8/29/22.
//

import XCTest

class ScoreTests: XCTestCase {

    func test_noAnswers_scoresZero() {
        XCTAssertEqual(BasicScore.score(for: [], comparingTo: []), 0)
    }
    
    func test_oneWrongAnswers_scoresZero() {
        XCTAssertEqual(BasicScore.score(for: ["wrong"], comparingTo: ["correct"]), 0)
    }
    
    func test_oneCorrectAnswers_scoresOne() {
        XCTAssertEqual(BasicScore.score(for: ["correct"], comparingTo: ["correct"]), 1)
    }
    
    func test_oneCorrectAnswerOneWrongAnswer_scoresOne() {
        let score = BasicScore.score(
            for: ["correct 1", "wrong"],
            comparingTo: ["correct 1", "correct 2"])
        XCTAssertEqual(score, 1)
    }
    
    func test_twoCorrectAnswers_scoresTwo() {
        let score = BasicScore.score(
            for: ["correct 1", "correct 2"],
            comparingTo: ["correct 1", "correct 2"])
        XCTAssertEqual(score, 2)
    }
    
    func test_withUnequalSizedData_twoCorrectAnswers_scoresTwo() {
        let score = BasicScore.score(
            for: ["correct 1", "correct 2", "an extra answer"],
            comparingTo: ["correct 1", "correct 2"])
        XCTAssertEqual(score, 2)
    }
    
    private class BasicScore {
        static func score(for answers: [String], comparingTo correctAnswers: [String]) -> Int {
            var score = 0
            for (index, answer) in answers.enumerated() {
                if index >= correctAnswers.count { return score }
                score += (answer == correctAnswers[index]) ? 1 : 0
            }
            return score
        }
    }
}
