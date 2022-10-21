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
}

public enum Answer<T: Hashable>: Hashable {
    case ordered([T])
    case unordered(Set<T>)
    case single(T)
}
