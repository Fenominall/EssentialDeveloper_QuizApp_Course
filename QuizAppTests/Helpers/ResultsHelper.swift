//
//  ResultsHelper.swift
//  QuizAppTests
//
//  Created by Vladyslav Todorov on 8/13/22.
//

import QuizEngine

extension Results: Hashable {
    public static func == (lhs: Results<Question, Answer>, rhs: Results<Question, Answer>) -> Bool {
        lhs.score == rhs.score
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(1)
    }
}
