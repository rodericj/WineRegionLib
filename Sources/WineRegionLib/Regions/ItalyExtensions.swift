//
//  File.swift
//  
//
//  Created by Roderic Campbell on 12/20/20.
//

import Foundation

extension String {
    var capitalizeFirst: String {
        prefix(1).capitalized + dropFirst()
    }
}

extension Character {
    var isUppercase: Bool { return String(self).uppercased() == String(self) }
}


extension String {

    func capitalizeAndSplit() -> String {
        let indexes = Set(self
                            .enumerated()
                            .filter { $0.element.isUppercase }
                            .map { $0.offset })

        let chunks = self
            .map { String($0) }
            .enumerated()
            .reduce([String]()) { chunks, elm -> [String] in
                guard !chunks.isEmpty else { return [elm.element] }
                guard !indexes.contains(elm.offset) else { return chunks + [String(elm.element)] }

                var chunks = chunks
                chunks[chunks.count-1] += String(elm.element)
                return chunks
            }
        return chunks.joined(separator: " ")
    }
}
