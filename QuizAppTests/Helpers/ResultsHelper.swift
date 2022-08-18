//
//  ResultsHelper.swift
//  QuizAppTests
//
//  Created by Vladyslav Todorov on 8/13/22.
//

@testable import QuizEngine

extension Results: Hashable {
    
    static func make(answers: [Question: Answer] = [:], score: Int = 0) -> Results<Question, Answer> {
        return Results(answers: answers, score: score)
    }
     
    public static func == (lhs: Results<Question, Answer>, rhs: Results<Question, Answer>) -> Bool {
        lhs.score == rhs.score
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(1)
    }
}
