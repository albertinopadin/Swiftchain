//
//  SwiftchainServer.swift
//  Swiftchain
//
//  Created by Albertino Padin on 3/16/17.
//  Copyright © 2017 Albertino Padin. All rights reserved.
//

import Foundation
import Swifter

public class SwiftchainServer {
    // Combines Http and WebSocket servers to operate the blockchain:
    // HTTP interface to control the node
    // WebSockets to communicate with other nodes (P2P)
    
    static let default_http_port: UInt16 = 3002
    static let default_p2p_port: UInt16 = 6002
    
    let httpServer = HttpServer()
    let p2pServer = HttpServer()
    var initialPeers = [String]()  // Guessing the peers are just a list of IP Addresses???
    
    init(httpPort: UInt16 = default_http_port, p2pPort: UInt16 = default_p2p_port) {
        self.connectToPeers(newPeers: initialPeers)
        self.initHttpServer(port: httpPort)
        self.initP2PServer(port: p2pPort)
    }
    
    func initHttpServer(port: UInt16) {
        do {
            try self.httpServer.start(port)
            print("Listening HTTP on port: \(port)")
        } catch is Error {
            print("There was an error starting the http server.")
        }
    }
    
    func initP2PServer(port: UInt16) {
        do {
            try self.p2pServer.start(port)
            print("Listening WebSocket P2P on port: \(port)")
        } catch is Error {
            print("There was an error starting the websocket server.")
        }
    }
    
//    func initConnection(ws: WebSocket) {
//        
//    }
//    
//    func initMessageHandler(ws: WebSocket) {
//        
//    }
//    
//    func initErrorHandler(ws: WebSocket) {
//        
//    }
    
    func connectToPeers(newPeers: [String]) {
        // TODO
    }
    
    func handleBlockchainResponse(message: HTTPURLResponse) {
        
    }
    
//    func write(ws: WebSocket, message: String) {
//        
//    }
    
    func broadcast(message: String) {
        
    }
    
}
