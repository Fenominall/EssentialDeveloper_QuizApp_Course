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
}

// Builder
struct BasicQuizBuilder {
    // MARK: - Protperties
    private let questions: [Question<String>]
    private let options: [Question<String> : [String]]
    
    // MARK: - Initializers
    init(singleAnswerQuestion: String, options: NonEmptyOptions) {
        let question = Question.singleAnswer(singleAnswerQuestion)
        self.questions = [question]
        self.options = [question: [options.head] + options.tail]
        
    }
    func build() -> BasicQuiz {
        BasicQuiz(questions: questions, options: options)
    }
}

final class BasicQuizBuilderTest: XCTestCase {
    func test_init_withSingleAnswerQuestion() {
        let sut = BasicQuizBuilder(
            singleAnswerQuestion: "q1",
            options: NonEmptyOptions(head: "o1", tail: ["o2", "o3"]))
        
        let result = sut.build()
        XCTAssertEqual(result.questions, [.singleAnswer("q1")])
        XCTAssertEqual(result.options, [.singleAnswer("q1"): ["o1", "o2", "o3"]])
    }
}
