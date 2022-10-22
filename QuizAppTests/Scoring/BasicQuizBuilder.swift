//
//  BasicQuizBuilder.swift
//  QuizAppTests
//
//  Created by Vladislav Todorov on 10/22/22.
//

import XCTest
import QuizEngine

// Product
struct BasicQuiz {
    let questions: [Question<String>]
    let options: [Question<String> : [String]]
    let correctAnswers: [(Question<String>, [String])]
}

struct NonEmptyOptions {
    let head: String
    let tail: [String]
    
    var all: [String] {
        [head] + tail
    }
}

// Builder

struct BasicQuizBuilder {
    // MARK: - Protperties
    private let questions: [Question<String>]
    private let options: [Question<String> : [String]]
    private let correctAnswers: [(Question<String>, [String])]
    
    enum AddingError: Equatable, Error {
        case duplicateOptions([String])
        case missingAnswerInOptions(answer: [String], options: [String])
    }
    
    // MARK: - Initializers
    init(singleAnswerQuestion: String, options: NonEmptyOptions, answer: String) throws {
        let allOptions = options.all
        
        // Checking that allOptions contain an answer
        guard allOptions.contains(answer) else {
            throw AddingError.missingAnswerInOptions(answer: [answer], options: allOptions)
        }
        // Converting all passed options into a set to check of we have duplicates
        // If duplicates found init will throw a duplicate error with duplicated options
        guard Set(allOptions).count == allOptions.count else {
            throw AddingError.duplicateOptions(allOptions)
        }
                
        let question = Question.singleAnswer(singleAnswerQuestion)
        self.questions = [question]
        self.options = [question: allOptions]
        self.correctAnswers = [(question, [answer])]
    }
    
    // MARK: API
    func build() -> BasicQuiz {
        BasicQuiz(questions: questions, options: options, correctAnswers: correctAnswers)
    }
}

final class BasicQuizBuilderTest: XCTestCase {
    
    func test_init_withSingleAnswerQuestion() throws {
        let sut = try BasicQuizBuilder(
            singleAnswerQuestion: "q1",
            options: NonEmptyOptions(head: "o1", tail: ["o2", "o3"]), answer: "o1")
        
        let result = sut.build()
        XCTAssertEqual(result.questions, [.singleAnswer("q1")])
        XCTAssertEqual(result.options, [.singleAnswer("q1"): ["o1", "o2", "o3"]])
        assertEqual(result.correctAnswers, [(.singleAnswer("q1"), ["o1"])])
    }
    
    func test_init_withSingleAnswerQuestion_duplicateOptions_throw() throws {
        XCTAssertThrowsError(
            try BasicQuizBuilder(
                singleAnswerQuestion: "q1",
                options: NonEmptyOptions(head: "o1", tail: ["o1", "o3"]),
                answer: "o1"
            )
        ) { error in
            XCTAssertEqual(error as? BasicQuizBuilder.AddingError,
                           BasicQuizBuilder.AddingError.duplicateOptions(["o1", "o1", "o3"]))
        }
    }
    
    func test_init_withSingleAnswerQuestion_missingAnswerInOptions_throw() throws {
        XCTAssertThrowsError(
            try BasicQuizBuilder(
                singleAnswerQuestion: "q1",
                options: NonEmptyOptions(head: "o1", tail: ["o1", "o3"]),
                answer: "o4"
            )
        ) { error in
            XCTAssertEqual(
                error as? BasicQuizBuilder.AddingError,
                BasicQuizBuilder.AddingError
                    .missingAnswerInOptions(answer: ["o4"], options: ["o1", "o1", "o3"]))
        }
    }
    
    // MARK: - Helpers
    private func assertEqual(_ a1: [(Question<String>, [String])],
                             _ a2: [(Question<String>, [String])],
                             file: StaticString = #filePath,
                             line: UInt = #line) {
        XCTAssertTrue(a1.elementsEqual(a2, by: ==), "\(a1) is not equal to \(a2)",
                      file: file, line: line)
    }
}


