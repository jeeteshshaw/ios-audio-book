//
//  Safe.swift
//  Sample
//
//  Created by Jeetesh Shaw on 10/05/25.
//

import Foundation

extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
