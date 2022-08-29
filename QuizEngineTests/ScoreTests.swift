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
    
    
    private class BasicScore {
        static func score(for answers: [String], comparingTo correctAnswers: [String]) -> Int {
            if answers.isEmpty {
                return 0
            }
            return answers == correctAnswers ? 1 : 0
        }
    }
}
