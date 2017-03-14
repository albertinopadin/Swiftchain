//
//  Block.swift
//  Swiftchain
//
//  Created by Albertino Padin on 3/11/17.
//  Copyright © 2017 Albertino Padin. All rights reserved.
//

import Foundation

class Block<T>: Equatable where T: Equatable {
    let index: UInt64
    let previousHash: String
    let timestamp: UInt64
    let data: T?
    let hash: String
    
    init(index: UInt64, previousHash: String, timestamp: UInt64, data: T?, hash: String) {
        self.index = index
        self.previousHash = previousHash
        self.timestamp = timestamp
        self.data = data
        self.hash = hash
    }
    
    static func ==(lhs: Block<T>, rhs: Block<T>) -> Bool {
        return lhs.index == rhs.index &&
               lhs.previousHash == rhs.previousHash &&
               lhs.timestamp == rhs.timestamp &&
               lhs.data == rhs.data &&
               lhs.hash == rhs.hash
    }
}
