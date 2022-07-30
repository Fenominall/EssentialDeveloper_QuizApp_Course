//
//  Results.swift
//  QuizEngine
//
//  Created by Fenominall on 7/22/22.
//

import Foundation

public struct Results<Question: Hashable, Answer: Equatable> {
    public var answers: [Question: Answer]
    public var score: Int
    
    init(answers: [Question: Answer],score: Int) {
        self.answers = answers
        self.score = score
    }
}

