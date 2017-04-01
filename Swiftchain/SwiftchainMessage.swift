//
//  SwiftchainMessage.swift
//  Swiftchain
//
//  Created by Albertino Padin on 4/1/17.
//  Copyright © 2017 Albertino Padin. All rights reserved.
//

import Foundation

public class SwiftchainMessage {
    
    var type: MessageType
    var data: Data?
    
    init(type: MessageType) {
        self.type = type
        self.data = nil
    }
    
    init(type: MessageType, data: Data) {
        self.type = type
        self.data = data
    }
    
}
