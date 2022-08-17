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
    
    public static func ==(lhs: Question<T>, rhs: Question<T>) -> Bool {
        switch (lhs, rhs) {
        case (.singleAnswer(let l), .singleAnswer(let r)):
            return l == r
        case (.multipleAnswer(let l), .multipleAnswer(let r)):
            return l == r
        default:
            return false
        }
    }
}

