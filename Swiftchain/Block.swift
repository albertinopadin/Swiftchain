//
//  Block.swift
//  Swiftchain
//
//  Created by Albertino Padin on 3/11/17.
//  Copyright © 2017 Albertino Padin. All rights reserved.
//

import Foundation

class Block<T> {
    let index: Int64
    let previousHash: String
    let timestamp: String
    let data: T
    let hash: String
    
    init(index: Int64, previousHash: String, timestamp: String, data: T, hash: String) {
        self.index = index
        self.previousHash = previousHash
        self.timestamp = timestamp
        self.data = data
        self.hash = hash
    }
}
