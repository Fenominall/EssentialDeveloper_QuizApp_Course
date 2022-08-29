//
//  Game.swift
//  QuizEngine
//
//  Created by Fenominall on 7/22/22.
//

// Depricating for changes to let the client migrate with no issues
@available(*, deprecated, message: "Use QuizDelegate insted")
public protocol Router {
    // Adding associatedtype for more geneirc flow, the questions and answers can be not only Strings, but images, videos etc. other types.
    associatedtype Question: Hashable
    associatedtype Answer: Equatable
    
    func routeTo(question: Question, answerCallback: @escaping (Answer) -> Void)
    func routeTo(result: Results<Question, Answer>)
}

@available(*, deprecated)
public struct Results<Question: Hashable, Answer> {
    public var answers: [Question: Answer]
    public var score: Int
}

@available(*, deprecated, message: "Use Quiz insted")
public class Game <Question, Answer, R: Router> {
    let flow: Any
    
    init(flow: Any) {
        self.flow = flow
    }
}

@available(*, deprecated, message: "Use Quiz.start() insted")
public func startGame<Question, Answer, R: Router>
(questions: [Question],
 router: R,
 correctAnswers: [Question: Answer]) ->Game<Question, Answer, R> where R.Question == Question, R.Answer == Answer{
    let flow = Flow(
        questions: questions,
        delegate: QuizDelegateToRouterAdapter(router: router, correctAnswers))
    flow.start()
    return Game(flow: flow)
}

// Private adapter for forwarding messages to and oldAPI with new API
@available(*, deprecated, message: "remove along with the deprecated Game types")
private class QuizDelegateToRouterAdapter<R: Router>: QuizDelegate {
    private let router: R
    private let correctAnswers: [R.Question: R.Answer]
    
    init(router: R, _ correctAnswers: [R.Question: R.Answer]) {
        self.router = router
        self.correctAnswers = correctAnswers
    }
    
    func answer(for question: R.Question, completion: @escaping (R.Answer) -> Void) {
        router.routeTo(question: question, answerCallback: completion)
    }
    
    func didCompleteQuiz(withAnswers answers: [(question: R.Question, answer: R.Answer)]) {
        let answerDictonary = answers.reduce([R.Question: R.Answer]()) { acc, tuple in
            var accumulation = acc
            accumulation[tuple.question] = tuple.answer
            return accumulation
        }
        let score = scoring(answerDictonary, correctAnswers: correctAnswers)
        let result = Results(answers: answerDictonary, score: score)
        router.routeTo(result: result)
    }
        
    private func scoring(_ answers: [R.Question: R.Answer], correctAnswers: [R.Question: R.Answer]) -> Int {
        return answers.reduce(0) { (score, tuple) in
            return score + (correctAnswers[tuple.key] == tuple.value ? 1 : 0)
        }
    }
}
