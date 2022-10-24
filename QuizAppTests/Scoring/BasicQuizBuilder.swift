//
//  BasicQuizBuilder.swift
//  QuizAppTests
//
//  Created by Vladislav Todorov on 10/22/22.
//

import XCTest
import QuizEngine
@testable import QuizApp

final class BasicQuizBuilderTest: XCTestCase {
    
    //MARK: - SingleAnswerQuestion
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
        assert(
            try BasicQuizBuilder(
                singleAnswerQuestion: "q1",
                options: NonEmptyOptions(head: "o1", tail: ["o1", "o3"]),
                answer: "o1"),
            throws: .duplicateOptions(["o1", "o1", "o3"]))
    }
    
    func test_init_withSingleAnswerQuestion_missingAnswerInOptions_throw() throws {
        assert(
            try BasicQuizBuilder(
                singleAnswerQuestion: "q1",
                options: NonEmptyOptions(head: "o1", tail: ["o1", "o3"]),
                answer: "o4"
            ),
            throws: .missingAnswerInOptions(answer: ["o4"],
                                            options: ["o1", "o1", "o3"]))
    }
    
    func test_addSingleAnswerQuestion() throws {
        var sut = try BasicQuizBuilder(
            singleAnswerQuestion: "q1",
            options: NonEmptyOptions(head: "o1", tail: ["o2", "o3"]), answer: "o1")
        
        try sut.add(singleAnswerQuestion: "q2",
                    options: NonEmptyOptions(head: "o3", tail: ["o4", "o5"]),
                    answer: "o3")
        
        let result = sut.build()
        XCTAssertEqual(result.questions, [.singleAnswer("q1"), .singleAnswer("q2")])
        XCTAssertEqual(result.options, [
            .singleAnswer("q1"): ["o1", "o2", "o3"],
            .singleAnswer("q2"): ["o3", "o4", "o5"],
        ])
        assertEqual(result.correctAnswers, [
            (.singleAnswer("q1"), ["o1"]),
            (.singleAnswer("q2"), ["o3"])
        ])
    }
    
    func test_init_addSingleAnswerQuestion_duplicateOptions_throw() throws {
        var sut = try BasicQuizBuilder(
            singleAnswerQuestion: "q1",
            options: NonEmptyOptions(head: "o1", tail: ["o2", "o3"]), answer: "o1")
        
        assert(
            try sut.add(singleAnswerQuestion: "q2",
                        options: NonEmptyOptions(head: "o3", tail: ["o3", "o5"]),
                        answer: "o3"),
            throws: .duplicateOptions(["o3", "o3", "o5"]))
    }
    
    func test_init_addSingleAnswerQuestion_missingAnswerInOptions_throw() throws {
        var sut = try BasicQuizBuilder(
            singleAnswerQuestion: "q1",
            options: NonEmptyOptions(head: "o1", tail: ["o2", "o3"]), answer: "o1")
        
        assert(
            try sut.add(singleAnswerQuestion: "q2",
                        options: NonEmptyOptions(head: "o3", tail: ["o4", "o5"]),
                        answer: "o6"),
            throws: .missingAnswerInOptions(
                answer: ["o6"],
                options: ["o3", "o4", "o5"])
        )
    }
    
    func test_init_addSingleAnswerQuestion_duplicateQuestion_throw() throws {
        var sut = try BasicQuizBuilder(
            singleAnswerQuestion: "q1",
            options: NonEmptyOptions(head: "o1", tail: ["o2", "o3"]),
            answer: "o1")
        
        assert(
            try sut.add(
                singleAnswerQuestion: "q1",
                options: NonEmptyOptions(head: "o3", tail: ["o4", "o5"]),
                answer: "o6"),
            throws: .duplicateQuestion(.singleAnswer("q1"))
        )
    }
    
    func test_addingSingleAnswerQuestion() throws {
        let sut = try BasicQuizBuilder(
            singleAnswerQuestion: "q1",
            options: NonEmptyOptions(head: "o1", tail: ["o2", "o3"]),
            answer: "o1"
        ).adding(
            singleAnswerQuestion: "q2",
            options: NonEmptyOptions(head: "o3", tail: ["o4", "o5"]),
            answer: "o3")
        
        let result = sut.build()
        XCTAssertEqual(result.questions, [.singleAnswer("q1"), .singleAnswer("q2")])
        XCTAssertEqual(result.options, [
            .singleAnswer("q1"): ["o1", "o2", "o3"],
            .singleAnswer("q2"): ["o3", "o4", "o5"],
        ])
        assertEqual(result.correctAnswers, [
            (.singleAnswer("q1"), ["o1"]),
            (.singleAnswer("q2"), ["o3"])
        ])
    }
    
    func test_init_addingSingleAnswerQuestion_duplicateOptions_throw() throws {
        let sut = try BasicQuizBuilder(
            singleAnswerQuestion: "q1",
            options: NonEmptyOptions(head: "o1", tail: ["o2", "o3"]), answer: "o1")
        
        assert(
            try sut.adding(singleAnswerQuestion: "q2",
                        options: NonEmptyOptions(head: "o3", tail: ["o3", "o5"]),
                        answer: "o3"),
            throws: .duplicateOptions(["o3", "o3", "o5"]))
    }
    
    func test_init_addingSingleAnswerQuestion_missingAnswerInOptions_throw() throws {
        let sut = try BasicQuizBuilder(
            singleAnswerQuestion: "q1",
            options: NonEmptyOptions(head: "o1", tail: ["o2", "o3"]), answer: "o1")
        
        assert(
            try sut.adding(singleAnswerQuestion: "q2",
                        options: NonEmptyOptions(head: "o3", tail: ["o4", "o5"]),
                        answer: "o6"),
            throws: .missingAnswerInOptions(
                answer: ["o6"],
                options: ["o3", "o4", "o5"])
        )
    }
    
    func test_init_addingSingleAnswerQuestion_duplicateQuestion_throw() throws {
        let sut = try BasicQuizBuilder(
            singleAnswerQuestion: "q1",
            options: NonEmptyOptions(head: "o1", tail: ["o2", "o3"]),
            answer: "o1")
        
        assert(
            try sut.adding(
                singleAnswerQuestion: "q1",
                options: NonEmptyOptions(head: "o3", tail: ["o4", "o5"]),
                answer: "o6"),
            throws: .duplicateQuestion(.singleAnswer("q1"))
        )
    }
    
    //MARK: - MultipleAnswerQuestion
    func test_init_withMultipleAnswerQuestion() throws {
        let sut = try BasicQuizBuilder(
            multipleAnswerQuestion: "q1",
            options: NonEmptyOptions(head: "o1", tail: ["o2", "o3"]),
            answer: NonEmptyOptions(head: "o1", tail: ["o3"]))
        
        let result = sut.build()
        XCTAssertEqual(result.questions, [.multipleAnswer("q1")])
        XCTAssertEqual(result.options, [.multipleAnswer("q1"): ["o1", "o2", "o3"]])
        assertEqual(result.correctAnswers, [(.multipleAnswer("q1"), ["o1", "o3"])])
    }
    
    func test_init_addMultipleAnswerQuestion_duplicateAnswers_throw() throws {
        var sut = try BasicQuizBuilder(
            multipleAnswerQuestion: "q1",
            options: NonEmptyOptions(head: "o1", tail: ["o2", "o3"]),
            answer: NonEmptyOptions(head: "o1", tail: []))
        assert(
            try sut.add(multipleAnswerQuestion: "q2",
                        options: NonEmptyOptions(head: "o3", tail: ["o4", "o5"]),
                        answer: NonEmptyOptions(head: "o3", tail: ["o3"])),
            throws: .duplicateAnswers(["o3", "o3"]))
    }
    
    
    // MARK: - Helpers
    private func assertEqual(_ a1: [(Question<String>, [String])],
                             _ a2: [(Question<String>, [String])],
                             file: StaticString = #filePath,
                             line: UInt = #line) {
        XCTAssertTrue(a1.elementsEqual(a2, by: ==), "\(a1) is not equal to \(a2)",
                      file: file, line: line)
    }
    
    func assert<T>(_ expression: @autoclosure () throws -> T,
                   throws expectedError: BasicQuizBuilder.AddingError,
                   file: StaticString = #filePath,
                   line: UInt = #line) {
        XCTAssertThrowsError(try expression()) { error in
            XCTAssertEqual(
                error as? BasicQuizBuilder.AddingError,
                expectedError,
                file: file,
                line: line
            )
        }
    }
}


