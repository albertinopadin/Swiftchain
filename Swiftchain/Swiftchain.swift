//
//  Swiftchain.swift
//  Swiftchain
//
//  Created by Albertino Padin on 3/11/17.
//  Copyright © 2017 Albertino Padin. All rights reserved.
//

import Foundation

// Maybe we could conform this class to certain protocols later on
class Swiftchain<T> where T: Equatable {
    var blockchain: [Block<T>]
    
    init() {
        self.blockchain = []
        let genesisBlock = getGenesisBlock()
        self.blockchain.append(genesisBlock)
    }
    
    func getGenesisBlock() -> Block<T> {
        let genesisData: T? = nil
        let currentTimestamp = Swiftchain.getCurrentTimeStamp()
        let genesisHash: String = Swiftchain.calculateHash(index: 0, previousHash: "0", timestamp: currentTimestamp, data: genesisData)
        return Block(index: 0,
                     previousHash: "0",
                     timestamp: currentTimestamp,
                     data: genesisData,
                     hash: genesisHash)
    }
    
    func generateNextBlock(data: T) -> Block<T>? {
        guard let previousBlock = self.getLatestBlock() else {
            return nil
        }
        
        let nextIndex = previousBlock.index + 1
        let nextTimestamp = Swiftchain.getCurrentTimeStamp()
        let nextHash = Swiftchain.calculateHash(index: nextIndex,
                                                previousHash: previousBlock.hash,
                                                timestamp: nextTimestamp,
                                                data: data)
        return Block(index: nextIndex,
                     previousHash: previousBlock.hash,
                     timestamp: nextTimestamp,
                     data: data,
                     hash: nextHash)
    }
    
    func calculateHashForBlock(block: Block<T>) -> String {
        return Swiftchain.calculateHash(index: block.index,
                                        previousHash: block.previousHash,
                                        timestamp: block.timestamp,
                                        data: block.data)
    }
    
    func addBlock(newBlock: Block<T>) {
        if self.isValidNewBlock(newBlock: newBlock, previousBlock: self.getLatestBlock()) {
            self.blockchain.append(newBlock)
        }
    }
    
    func isValidNewBlock(newBlock: Block<T>, previousBlock: Block<T>?) -> Bool {
        // TODO: Should include proper log function in the future:
        if let prev = previousBlock {
            if prev.index + 1 != newBlock.index {
                print("Invalid index for block: \(newBlock)")
                return false
            }
            else if prev.hash != newBlock.previousHash {
                print("Invalid previous hash for block: \(newBlock)")
                return false
            }
            else if self.calculateHashForBlock(block: newBlock) != newBlock.hash {
                print("Invalid hash for block: \(newBlock)")
                print("Calculated: \(self.calculateHashForBlock(block: newBlock)), passed in block: \(newBlock.hash)")
                return false
            }
            
            // All checks passed:
            return true
        } else {
            // We should always have at least the genesis block in the blockchain
            // If we do not something is very wrong:
            return false
        }
        
    }
    
    func getLatestBlock() -> Block<T>? {
        return self.blockchain.last
    }
    
    func replaceChain(newBlocks: [Block<T>]) {
        if isValidChain(blockchainToValidate: newBlocks) && newBlocks.count > self.blockchain.count {
            print("Recieved blockchain is valid; replacing current with new.")
            self.blockchain = newBlocks
            // broadcast(responseLatestMsg())  <- Will implement the server as a separate class later on
        }
    }
    
    func isValidChain(blockchainToValidate: [Block<T>]) -> Bool {
        if let genesisBlockToValidate = blockchainToValidate.first {
            if genesisBlockToValidate != self.getGenesisBlock() {
                return false
            }
        }
        
        for i in 1 ..< blockchainToValidate.count {
            if !isValidNewBlock(newBlock: blockchainToValidate[i], previousBlock: blockchainToValidate[i - 1]) {
                return false
            }
        }
        
        return true
    }
    
    /* STATIC FUNCTIONS */
    
    // Returns the Unix time in milliseconds:
    static func getCurrentTimeStamp() -> UInt64 {
        return UInt64(NSDate().timeIntervalSince1970 * 1000.0)
    }
    
    static func calculateHash(index: UInt64, previousHash: String, timestamp: UInt64, data: T?) -> String {
        let dataString = "\(index)\(previousHash)\(timestamp)\(data)"
        return Swiftchain.sha256(dataString: dataString) ?? ""
    }
    
    static func sha256(dataString: String) -> String? {
        guard let stringData = dataString.data(using: String.Encoding.utf8) else { return nil }
        var digestData = Data(count: Int(CC_SHA256_DIGEST_LENGTH))
        
        _ = digestData.withUnsafeMutableBytes({ digestBytes in
            stringData.withUnsafeBytes( { stringBytes in
                CC_SHA256(stringBytes, CC_LONG(stringData.count), digestBytes)
            })
        })
        let digestString = digestData.map { String(format: "%02hhx", $0) }.joined()
        return digestString
    }
}
