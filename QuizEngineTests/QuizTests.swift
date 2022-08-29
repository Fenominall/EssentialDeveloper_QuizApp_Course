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
    
    func test_startQuiz_answersAllQuiestion_completesWithAnswers() {
        let delegate = DelegateSpy()
        quiz = Quiz.start(
            questions: ["Q1", "Q2"],
            delegate: delegate)
        
        delegate.answerCompletions[0]("A1")
        delegate.answerCompletions[1]("A2")
        
        XCTAssertEqual(delegate.completedQuizzes.count, 1)
        assertEqual(delegate.completedQuizzes[0], [("Q1", "A1"), ("Q2", "A2")])
    }
    
    func test_startQuiz_answersAllQuiestionTwice_completesWithNewAnswers() {
        let delegate = DelegateSpy()
        quiz = Quiz.start(
            questions: ["Q1", "Q2"],
            delegate: delegate)

        delegate.answerCompletions[0]("A1")
        delegate.answerCompletions[1]("A2")

        delegate.answerCompletions[0]("A1-1")
        delegate.answerCompletions[1]("A2-2")

        XCTAssertEqual(delegate.completedQuizzes.count, 2)
        assertEqual(delegate.completedQuizzes[0], [("Q1", "A1"), ("Q2", "A2")])
        assertEqual(delegate.completedQuizzes[1], [("Q1", "A1-1"), ("Q2", "A2-2")])
    }

    // MARK: - Helpers

    private class DelegateSpy: QuizDelegate {
        var completedQuizzes: [[(String, String)]] = []
        var answerCompletions: [(String) -> Void] = []
        
        func answer(for question: String, completion: @escaping (String) -> Void) {
            answerCompletions.append(completion)
        }
        
        func didCompleteQuiz(withAnswers answers: [(question: String, answer: String)]) {
            completedQuizzes.append(answers
            )
        }
    }
}
