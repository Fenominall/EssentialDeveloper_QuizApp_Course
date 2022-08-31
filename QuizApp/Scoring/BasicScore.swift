//
//  BasicScore.swift
//  QuizApp
//
//  Created by Fenominall on 8/31/22.
//

import Foundation

public class BasicScore {
    public static func score(for answers: [String], comparingTo correctAnswers: [String]) -> Int {
        return zip(answers, correctAnswers).reduce(0) { score, tuple in
            return score + (tuple.0 == tuple.1 ? 1 : 0)
        }
        // The same behavior
        //            var score = 0
        //            for (index, answer) in answers.enumerated() {
        //                if index >= correctAnswers.count { return score }
        //                score += (answer == correctAnswers[index]) ? 1 : 0
        //            }
        //            return score
    }
}
