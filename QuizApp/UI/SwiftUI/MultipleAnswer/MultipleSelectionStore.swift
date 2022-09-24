//
//  MultipleSelectionStore.swift
//  QuizApp
//
//  Created by Fenominall on 9/23/22.
//

struct MultipleSelectionStore {
    var options: [MultipleSelectionOption]
    var canSubmit: Bool {
        // Cheking if an option was selected to toggle the state of canSubmit
        // The array of options shouldnot be empty
        // The same as options.contains(where: { $0.isSelected })
        !options.filter(\.isSelected).isEmpty
    }
    private let handler: ([String]) -> Void
    
    init(options: [String], handler: @escaping ([String]) -> Void = { _ in }) {
        self.options = options.map({ MultipleSelectionOption(text: $0) })
        self.handler = handler
    }
    
    func submit() {
        guard canSubmit else { return }
        // the same as handler(options.filter { $0.isSelected}.map(\.text))
        handler(options.filter(\.isSelected).map(\.text))
    }
}

struct MultipleSelectionOption {
    let text: String
    var isSelected = false
    
    mutating func select() {
        isSelected.toggle()
    }
}
