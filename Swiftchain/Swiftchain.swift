//
//  Swiftchain.swift
//  Swiftchain
//
//  Created by Albertino Padin on 3/11/17.
//  Copyright © 2017 Albertino Padin. All rights reserved.
//

import Foundation

// Maybe we could conform this class to certain protocols later on
class Swiftchain<T> {
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
