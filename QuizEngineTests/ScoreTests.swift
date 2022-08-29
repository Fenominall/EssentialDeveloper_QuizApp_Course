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
    
    
    private class BasicScore {
        static func score(for: [Any], comparingTo: [Any]) -> Int {
            return 0
        }
    }
}
