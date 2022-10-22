//
//  BasicQuizBuilder.swift
//  QuizAppTests
//
//  Created by Vladislav Todorov on 10/22/22.
//

import XCTest
@testable import QuizApp

struct BasicQuiz {
    
}

struct BasicQuizBuilder {
    func build() -> BasicQuiz? {
        return nil
    }
}

final class BasicQuizBuilderTest: XCTestCase {
    func test_empty() {
        let sut = BasicQuizBuilder()
        XCTAssertNil(sut.build())
    }
}
