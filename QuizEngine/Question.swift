//
//  File.swift
//  QuizEngine
//
//  Created by Fenominall on 8/17/22.
//

import Foundation

public enum Question<T: Hashable>: Hashable {
    case singleAnswer(T)
    case multipleAnswer(T)

    public func hash(into hasher: inout Hasher) {
        switch self {
        case .singleAnswer(let single):
            hasher.combine(single)
        case .multipleAnswer(let multiple):
            hasher.combine(multiple)
        }
    }
}

