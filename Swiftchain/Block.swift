//
//  Block.swift
//  Swiftchain
//
//  Created by Albertino Padin on 3/11/17.
//  Copyright © 2017 Albertino Padin. All rights reserved.
//

import Foundation

class Block<T> {
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
}
