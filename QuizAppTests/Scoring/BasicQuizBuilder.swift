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
}

// Builder
struct BasicQuizBuilder {
    // MARK: - Protperties
    private let questions: [Question<String>]
    
    // MARK: - Initializers
    init(singleAnswerQuestion: String) {
        self.questions = [.singleAnswer(singleAnswerQuestion)]
    }
    func build() -> BasicQuiz {
        BasicQuiz(questions: questions)
    }
}

final class BasicQuizBuilderTest: XCTestCase {
    func test_init_withSingleAnswerQuestion() {
        let sut = BasicQuizBuilder(singleAnswerQuestion: "q1")
        XCTAssertEqual(sut.build().questions, [.singleAnswer("q1")])
    }
}
