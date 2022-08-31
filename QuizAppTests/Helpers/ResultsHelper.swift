//
//  ResultsHelper.swift
//  QuizAppTests
//
//  Created by Vladyslav Todorov on 8/13/22.
//

@testable import QuizEngine

extension Results {
    static func make(answers: [Question: Answer] = [:], score: Int = 0) -> Results<Question, Answer> {
        return Results(answers: answers, score: score)
    }
}

extension Results: Equatable where Answer: Equatable {
    public static func == (lhs: Results<Question, Answer>, rhs: Results<Question, Answer>) -> Bool {
        lhs.score == rhs.score && lhs.answers == rhs.answers
    }
}

extension Results: Hashable where Answer: Equatable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(score)
    }
}
