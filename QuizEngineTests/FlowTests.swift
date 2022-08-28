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
        XCTAssertTrue(delegate.handledQuestions.isEmpty)
    }
    
    func test_start_withOneQuestion_delegatesCorrectQuestionHandling() {
        let question1 = makeQuestion()
        makeSUT(questions: [question1]).start()
        XCTAssertEqual(delegate.handledQuestions, [question1])
    }
    
    func test_start_withOneQuestion_delegatesAnotherCorrectQuestionHandling() {
        let question2 = makeQuestion("Q2")
        makeSUT(questions: [question2]).start()
        XCTAssertEqual(delegate.handledQuestions, [question2])
    }
    
    func test_start_withTwoQuestions_delegatesQuestionHandling() {
        let questions = makeQuestions()
        makeSUT(questions: questions).start()
        XCTAssertEqual(delegate.handledQuestions, [questions[0]])
    }
    
    func test_startTwice_withTwoQuestion_delegatesQuestionHandlingTwice() {
        let questions = makeQuestions()
        let sut = makeSUT(questions: questions)
        sut.start()
        sut.start()
        XCTAssertEqual(delegate.handledQuestions, [questions[0], questions[0]])
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withThreeQuestions_delegatsdSecondAndThridQuestionHandling() {
        let questions = ["Q1", "Q2", "Q3"]
        let sut = makeSUT(questions: questions)
        sut.start()
        
        delegate.answerCompletion("A1")
        delegate.answerCompletion("A2")
        
        XCTAssertEqual(delegate.handledQuestions, questions)
    }
    
    func test_startAndAnswerFirstQuestion_withOneQuestion_doesNotDelegatsdSecondAndThridQuestionHandling() {
        let question = makeQuestion()
        let sut = makeSUT(questions: [question])
        sut.start()
        
        delegate.answerCompletion("A1")
        
        XCTAssertEqual(delegate.handledQuestions, [question])
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
        
        delegate.answerCompletion("A1")
        XCTAssertTrue(delegate.completedQuizzes.isEmpty)
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestions_completesQuiz() {
        let questions = makeQuestions()
        let sut = makeSUT(questions: questions)
        sut.start()
        
        delegate.answerCompletion("A1")
        delegate.answerCompletion("A2")
        XCTAssertEqual(delegate.completedQuizzes.count, 1)
        XCTAssertTrue(delegate.completedQuizzes[0].elementsEqual([(questions[0], "A1"), (questions[1], "A2")], by: ==))
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestions_scores() {
        let questions = makeQuestions()
        let sut = makeSUT(questions: questions, scoring: { _ in 20 })
        sut.start()
        
        delegate.answerCompletion("A1")
        delegate.answerCompletion("A2")
        
        XCTAssertEqual(delegate.handledResult?.score, 20)
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestions_scoresWithTheRightAnswer() {
        var receivedAnswers = [String: String]()
         let questions = makeQuestions()
        let sut = makeSUT(questions: questions, scoring: { answers in
            receivedAnswers = answers
            return 20 })
        sut.start()
        
        delegate.answerCompletion("A1")
        delegate.answerCompletion("A2")
        
        XCTAssertEqual(receivedAnswers, [questions[0]: "A1", questions[1]: "A2"])
    }
    // MARK: - Helpers
    private func makeSUT(questions: [String],
                         scoring: @escaping ([String: String]) -> Int = { _ in 0 }) -> Flow<DelegateSpy> {
        let sut = Flow(questions: questions, delegate: delegate, scoring: scoring)
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
    
    private class DelegateSpy: QuizDelegate {
        var handledQuestions: [String] = []
        var handledResult: Results<String, String>? = nil
        var completedQuizzes: [[(String, String)]] = []
        var answerCompletion: (String) -> Void = { _ in }
        
        func answer(for question: String, completion: @escaping (String) -> Void) {
            handledQuestions.append(question)
            self.answerCompletion = completion
        }
        
        func didCompleteQuiz(withAnswers answers: [(question: String, answer: String)]) {
            completedQuizzes.append(answers
            )
        }
        
        func handle(result: Results<String, String>) {
            handledResult = result
        }
    }
}
