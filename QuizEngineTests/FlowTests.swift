//
//  FlowTests.swift
//  QuizEngineTests
//
//  Created by Fenominall on 7/16/22.
//

import Foundation
import XCTest
@testable import QuizEngine

class FlowTests: XCTestCase {
    private var delegate: DelegateSpy!
    private weak var weakSut: Flow<DelegateSpy>?
    
    override func setUp() {
        super.setUp()
        delegate = DelegateSpy()
    }
    
    override func tearDown() {
        super.tearDown()
        delegate = nil
        XCTAssertNil(weakSut, "Memory leak detected. Weak reference to the SUT instance not nil.")
    }
    
    func test_start_withNoQuestions_doesNotDelegateQuestionHandling() {
        makeSUT(questions: []).start()
        XCTAssertTrue(delegate.questionsAsked.isEmpty)
    }
    
    func test_start_withOneQuestion_delegatesCorrectQuestionHandling() {
        let question1 = makeQuestion()
        makeSUT(questions: [question1]).start()
        XCTAssertEqual(delegate.questionsAsked, [question1])
    }
    
    func test_start_withOneQuestion_delegatesAnotherCorrectQuestionHandling() {
        let question2 = makeQuestion("Q2")
        makeSUT(questions: [question2]).start()
        XCTAssertEqual(delegate.questionsAsked, [question2])
    }
    
    func test_start_withTwoQuestions_delegatesQuestionHandling() {
        let questions = makeQuestions()
        makeSUT(questions: questions).start()
        XCTAssertEqual(delegate.questionsAsked, [questions[0]])
    }
    
    func test_startTwice_withTwoQuestion_delegatesQuestionHandlingTwice() {
        let questions = makeQuestions()
        let sut = makeSUT(questions: questions)
        sut.start()
        sut.start()
        XCTAssertEqual(delegate.questionsAsked, [questions[0], questions[0]])
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withThreeQuestions_delegatsdSecondAndThridQuestionHandling() {
        let questions = ["Q1", "Q2", "Q3"]
        let sut = makeSUT(questions: questions)
        sut.start()
        
        delegate.answerCompletions[0]("A1")
        delegate.answerCompletions[1]("A2")
        
        XCTAssertEqual(delegate.questionsAsked, questions)
    }
    
    func test_startAndAnswerFirstQuestion_withOneQuestion_doesNotDelegatsdSecondAndThridQuestionHandling() {
        let question = makeQuestion()
        let sut = makeSUT(questions: [question])
        sut.start()
        
        delegate.answerCompletions[0]("A1")
        
        XCTAssertEqual(delegate.questionsAsked, [question])
    }
    
    func test_start_withNoQuestions_completesWithEmptyQuiz() {
        makeSUT(questions: []).start()
        XCTAssertEqual(delegate.completedQuizzes.count, 1)
        XCTAssertTrue(delegate.completedQuizzes[0].isEmpty)
    }
    
    func test_startWithOneQuestion_doesNotCompleteQuiz() {
        makeSUT(questions: [makeQuestion()]).start()
        XCTAssertTrue(delegate.completedQuizzes.isEmpty)
    }

    func test_startAndAnswerFirstQuestion_withTwoQuestions_doesNotCompleteQuiz() {
        let questions = makeQuestions()
        let sut = makeSUT(questions: questions)
        sut.start()
        
        delegate.answerCompletions[0]("A1")
        XCTAssertTrue(delegate.completedQuizzes.isEmpty)
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestions_completesQuiz() {
        let questions = makeQuestions()
        let sut = makeSUT(questions: questions)
        sut.start()
        
        delegate.answerCompletions[0]("A1")
        delegate.answerCompletions[1]("A2")
        XCTAssertEqual(delegate.completedQuizzes.count, 1)
        assertEqual(delegate.completedQuizzes[0], [(questions[0], "A1"), (questions[1], "A2")])
    }
    
    func test_startAndAnswerFirstAndSecondQuestionTwice_withTwoQuestions_completesQuizTwice() {
        let questions = makeQuestions()
        let sut = makeSUT(questions: questions)
        sut.start()

        delegate.answerCompletions[0]("A1")
        delegate.answerCompletions[1]("A2")

        delegate.answerCompletions[0]("A1-1")
        delegate.answerCompletions[1]("A2-2")

        XCTAssertEqual(delegate.completedQuizzes.count, 2)
        assertEqual(delegate.completedQuizzes[0], [(questions[0], "A1"), (questions[1], "A2")])
        assertEqual(delegate.completedQuizzes[1], [(questions[0], "A1-1"), (questions[1], "A2-2")])
    }

    // MARK: - Helpers
    private func makeSUT(questions: [String]) -> Flow<DelegateSpy> {
        let sut = Flow(questions: questions, delegate: delegate)
        weakSut = sut
        return sut
    }

    
    private func makeQuestion(
        _ question: String = "Q1") -> String {
            question
        }
    
    private func makeQuestions() -> [String] {
        [makeQuestion(), makeQuestion("Q2")]
    }
}
