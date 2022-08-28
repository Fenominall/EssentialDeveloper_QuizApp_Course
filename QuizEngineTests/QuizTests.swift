//
//  QuizTests.swift
//  QuizEngineTests
//
//  Created by Fenominall on 8/22/22.
//

import XCTest
import QuizEngine

class QuizTests: XCTestCase {
    private var quiz: Quiz!
    
    func test_startQuiz_answerZeroOutOfTwoCorrectly_scoresZero() {
        let delegate = DelegateSpy()
        quiz = Quiz.start(
            questions: ["Q1", "Q2"],
            delegate: delegate,
            correctAnswers: ["Q1": "A1", "Q2": "A2"])
        
        delegate.answerCompletion("A1")
        delegate.answerCompletion("A2")
        
        XCTAssertEqual(delegate.completedQuizzes.count, 1)
        assertEqual(delegate.completedQuizzes[0], [("Q1", "A1"), ("Q2", "A2")])
    }

    // MARK: - Helpers
    private func assertEqual(_ a1: [(String, String)],
                             _ a2: [(String, String)],
                             file: StaticString = #filePath,
                             line: UInt = #line) {
        XCTAssertTrue(a1.elementsEqual(a2, by: ==), "\(a1) is not equal to \(a2)",
                      file: file, line: line)
    }
    
    private class DelegateSpy: QuizDelegate {
        var completedQuizzes: [[(String, String)]] = []
        var answerCompletion: (String) -> Void = { _ in }
        
        func answer(for question: String, completion: @escaping (String) -> Void) {
            self.answerCompletion = completion
        }
        
        func didCompleteQuiz(withAnswers answers: [(question: String, answer: String)]) {
            completedQuizzes.append(answers
            )
        }
        
        func handle(result: Results<String, String>) {}
    }
}
