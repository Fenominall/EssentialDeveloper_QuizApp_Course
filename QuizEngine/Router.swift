//
//  Router.swift
//  QuizEngine
//
//  Created by Fenominall on 7/22/22.
//

import Foundation

public protocol QuizDelegate {
    // Adding associatedtype for more geneirc flow, the questions and answers can be not only Strings, but images, videos etc. other types.
    associatedtype Question: Hashable
    associatedtype Answer
    
    func handle(question: Question, answerCallback: @escaping (Answer) -> Void)
    func handle(result: Results<Question, Answer>)
}

// Depricating for changes to let the client migrate with no issues
@available(*, deprecated)
public protocol Router {
    // Adding associatedtype for more geneirc flow, the questions and answers can be not only Strings, but images, videos etc. other types.
    associatedtype Question: Hashable
    associatedtype Answer: Equatable
    
    func routeTo(question: Question, answerCallback: @escaping (Answer) -> Void)
    func routeTo(result: Results<Question, Answer>)
}