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
    private var questions: [Question<String>] = []
    private var options: [Question<String> : [String]] = [:]
    private var correctAnswers: [(Question<String>, [String])] = []
    
    enum AddingError: Equatable, Error {
        case duplicateOptions([String])
        case missingAnswerInOptions(answer: [String], options: [String])
        case duplicateQuestion(Question<String>)
    }
    
    // MARK: - Initializers
    private init(questions: [Question<String>],
                 options: [Question<String> : [String]],
                 correctAnswers: [(Question<String>, [String])]) {
        self.questions = questions
        self.options = options
        self.correctAnswers = correctAnswers
    }

    init(singleAnswerQuestion: String, options: NonEmptyOptions, answer: String) throws {
        try add(singleAnswerQuestion: singleAnswerQuestion, options: options, answer: answer)
    }
    
    // MARK: API
    mutating func add(singleAnswerQuestion: String, options: NonEmptyOptions, answer: String) throws {
       self = try adding(singleAnswerQuestion: singleAnswerQuestion, options: options, answer: answer)
    }
    
    func adding(singleAnswerQuestion: String, options: NonEmptyOptions, answer: String) throws -> BasicQuizBuilder {
        let question = Question.singleAnswer(singleAnswerQuestion)
        
        // Question should be duplicated
        guard !questions.contains(question) else {
            throw AddingError.duplicateQuestion(question)
        }
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
        
        // mutating the dictionary to add new options
        var newOptions = self.options
        newOptions[question] = allOptions

        return BasicQuizBuilder(
            questions: questions + [question],
            options: newOptions,
            correctAnswers: correctAnswers + [(question, [answer])])
    }
    
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


