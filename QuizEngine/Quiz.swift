//
//  Quiz.swift
//  QuizEngine
//
//  Created by Fenominall on 8/22/22.
//

import Foundation

public final class Quiz {
    private let flow: Any
    
    private init(flow: Any) {
        self.flow = flow
    }
    
    public static func start<Delegate: QuizDelegate>(
        questions: [Delegate.Question],
        delegate: Delegate) -> Quiz where Delegate.Answer: Equatable {
        let flow = Flow(
            questions: questions,
            delegate: delegate)
        flow.start()
        return Quiz(flow: flow)
    }
}
