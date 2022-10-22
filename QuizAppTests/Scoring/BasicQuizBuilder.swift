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
    
    enum AddingError: Equatable, Error {
        case duplicateOptions([String])
    }
    
    // MARK: - Initializers
    init(singleAnswerQuestion: String, options: NonEmptyOptions) throws {
        let allOptions = options.all
        
        // Converting all passed options into a set to check of we have duplicates
        // If duplicates found init will throw a duplicate error with duplicated options
        guard Set(allOptions).count == allOptions.count else {
            throw AddingError.duplicateOptions(allOptions)
        }
                
        let question = Question.singleAnswer(singleAnswerQuestion)
        self.questions = [question]
        self.options = [question: allOptions]
        
    }
    
    // MARK: API
    func build() -> BasicQuiz {
        BasicQuiz(questions: questions, options: options)
    }
}

final class BasicQuizBuilderTest: XCTestCase {
    func test_init_withSingleAnswerQuestion() throws {
        let sut = try BasicQuizBuilder(
            singleAnswerQuestion: "q1",
            options: NonEmptyOptions(head: "o1", tail: ["o2", "o3"]))
        
        let result = sut.build()
        XCTAssertEqual(result.questions, [.singleAnswer("q1")])
        XCTAssertEqual(result.options, [.singleAnswer("q1"): ["o1", "o2", "o3"]])
    }
    
    func test_init_withSingleAnswerQuestion_duplicateOptions_throw() throws {
        XCTAssertThrowsError(
            try BasicQuizBuilder(
                singleAnswerQuestion: "q1",
                options: NonEmptyOptions(head: "o1", tail: ["o1", "o3"]))
        ) { error in
            XCTAssertEqual(error as? BasicQuizBuilder.AddingError, BasicQuizBuilder.AddingError.duplicateOptions(["o1", "o1", "o3"]))
        }
    }
}
