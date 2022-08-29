//
//  Assertion.swift
//  QuizEngineTests
//
//  Created by Fenominall on 8/29/22.
//

import XCTest


func assertEqual(_ a1: [(String, String)],
                         _ a2: [(String, String)],
                         file: StaticString = #filePath,
                         line: UInt = #line) {
    XCTAssertTrue(a1.elementsEqual(a2, by: ==), "\(a1) is not equal to \(a2)",
                  file: file, line: line)
}

