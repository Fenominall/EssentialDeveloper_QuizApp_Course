//
//  DummyQuizData.swift
//  QuizApp
//
//  Created by Fenominall on 10/2/22.
//

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
        case duplicateQuestion(Question<String>)
        case duplicateAnswers([String])
        case missingAnswerInOptions(answer: [String], options: [String])
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
    
    init(multipleAnswerQuestion: String, options: NonEmptyOptions, answer: NonEmptyOptions) throws {
        try add(multipleAnswerQuestion: multipleAnswerQuestion, options: options, answer: answer)
    }
    
    // MARK: API
    mutating func add(singleAnswerQuestion: String, options: NonEmptyOptions, answer: String) throws {
       self = try adding(singleAnswerQuestion: singleAnswerQuestion, options: options, answer: answer)
    }
    
    mutating func add(multipleAnswerQuestion: String, options: NonEmptyOptions, answer: NonEmptyOptions) throws {
       self = try adding(multipleAnswerQuestion: multipleAnswerQuestion, options: options, answer: answer)
    }
    
    
    func adding(singleAnswerQuestion: String, options: NonEmptyOptions, answer: String) throws -> BasicQuizBuilder {
        try adding(
            question: Question.singleAnswer(singleAnswerQuestion),
            options: options.all,
            answer: [answer])
    }
    
    func adding(multipleAnswerQuestion: String, options: NonEmptyOptions, answer: NonEmptyOptions) throws -> BasicQuizBuilder {
        try adding(
            question: Question.multipleAnswer(multipleAnswerQuestion),
            options: options.all,
            answer: answer.all)
    }
    
    func build() -> BasicQuiz {
        BasicQuiz(questions: questions, options: options, correctAnswers: correctAnswers)
    }
    
    func adding(question: Question<String>, options: [String], answer: [String]) throws -> BasicQuizBuilder {
        
        // Question should not be duplicated
        guard !questions.contains(question) else {
            throw AddingError.duplicateQuestion(question)
        }
        
        // Checking that options contain an answer
        guard Set(answer).isSubset(of: Set(options)) else {
            throw AddingError.missingAnswerInOptions(answer: answer, options: options)
        }
        // Converting passed (options and answers) into a set to check if we have duplicates
        // If duplicates were found init will throw a duplicate error with passed duplicates
        guard Set(options).count == options.count else {
            throw AddingError.duplicateOptions(options)
        }
        guard Set(answer).count == answer.count else {
            throw AddingError.duplicateAnswers(answer)
        }
        
        // mutating the dictionary to add new options
        var newOptions = self.options
        newOptions[question] = options

        return BasicQuizBuilder(
            questions: questions + [question],
            options: newOptions,
            correctAnswers: correctAnswers + [(question, answer)])
    }
}

let demoQuiz = try! BasicQuizBuilder(
    singleAnswerQuestion: "Can Vlad become a professional iOS delevoper?",
    options: .init(
        head: "He is already on it`s way!",
        tail: [ "May be!", "Try it!"]),
    answer: "He is already on it`s way!")
    .adding(
        multipleAnswerQuestion: "I am a Boss?",
        options: .init(head: "OF Course!", tail: ["NOOO!", "Sure You are the Best!"]),
        answer: .init(head: "OF Course!", tail: ["Sure You are the Best!"]))
    .build()


