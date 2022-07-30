//
//  Results.swift
//  QuizEngine
//
//  Created by Fenominall on 7/22/22.
//

import Foundation

public struct Result<Question: Hashable, Answer: Equatable> {
    public let answers: [Question: Answer]
    public let score: Int
}

