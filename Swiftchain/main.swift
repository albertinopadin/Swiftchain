//
//  main.swift
//  Swiftchain
//
//  Created by Albertino Padin on 3/11/17.
//  Copyright © 2017 Albertino Padin. All rights reserved.
//

import Foundation

//print("Hello, World!")
// Testing
let swiftchain = Swiftchain<Int>()
let genesisBlock = swiftchain.blockchain[0]
print("Genesis Block:")
print("\(genesisBlock)")
print("Index: \(genesisBlock.index)")
print("Timestamp: \(genesisBlock.timestamp)")
print("Prev Hash: \(genesisBlock.previousHash)")
print("Hash: \(genesisBlock.hash)")
