//
//  SwiftchainServer.swift
//  Swiftchain
//
//  Created by Albertino Padin on 3/16/17.
//  Copyright © 2017 Albertino Padin. All rights reserved.
//

import Foundation
import Swifter

private let default_http_port: UInt16 = 3002
private let default_p2p_port: UInt16 = 6002

private enum MessageType: Int {
    case QUERY_LATEST           = 0
    case QUERY_ALL              = 1
    case RESPONSE_BLOCKCHAIN    = 2
}


public class SwiftchainServer<T> where T: Equatable {
    // Combines Http and WebSocket servers to operate the blockchain:
    // HTTP interface to control the node
    // WebSockets to communicate with other nodes (P2P)
    
    var swiftchain = Swiftchain<T>()
    
    // Dictionaries that will later be converted to JSON using JSONSerialization.dataWithJSONObject()
    let queryChainLengthMsg: [String: Any] = ["type": MessageType.QUERY_LATEST]
    let queryAllMsg: [String: Any] = ["type": MessageType.QUERY_ALL]
    
    // Dynamically generated JSON:
    // TODO: Remove Pretty Printing after finished debugging
    func responseChainMsg() throws -> [String: Any] {
        let jsonBlockchain = try JSONSerialization.data(withJSONObject: self.swiftchain.blockchain,
                                                        options: JSONSerialization.WritingOptions.prettyPrinted)
        return ["type": MessageType.RESPONSE_BLOCKCHAIN, "data": jsonBlockchain]
    }
    
    func responseLatestMsg() throws -> [String: Any] {
        let jsonLatestBlock = try toJSON(obj: self.swiftchain.getLatestBlock()!)
        return ["type": MessageType.RESPONSE_BLOCKCHAIN, "data": jsonLatestBlock]
    }
    
    let httpServer = HttpServer()
    let p2pServer = HttpServer()
    var initialPeers = [String]()  // Guessing the peers are just a list of IP Addresses???
    var sockets = [Socket]()
    
    init(httpPort: UInt16 = default_http_port, p2pPort: UInt16 = default_p2p_port) {
        self.connectToPeers(newPeers: initialPeers)
        self.initHttpServer(port: httpPort)
        self.initP2PServer(port: p2pPort)
    }
    
    func initHttpServer(port: UInt16) {
        do {
            try self.httpServer.start(port)
            print("Listening HTTP on port: \(port)")
        } catch {
            print("There was an error starting the http server.")
        }
    }
    
    func initP2PServer(port: UInt16) {
        do {
            try self.p2pServer.start(port)
            print("Listening WebSocket P2P on port: \(port)")
        } catch {
            print("There was an error starting the websocket server.")
        }
    }
    
    func initConnection(ws: Socket) {
        do {
            self.sockets.append(ws)
            self.initMessageHandler(ws: ws)
            self.initErrorHandler(ws: ws)
            let msg = try self.toJSON(obj: self.queryChainLengthMsg)
            self.write(ws: ws, message: msg)
        } catch {
            print("Could not initialize connection, ws: \(ws)")
        }
    }
    
    func initMessageHandler(ws: Socket) {
        
    }
    
    func initErrorHandler(ws: Socket) {
        
    }
    
    func connectToPeers(newPeers: [String]) {
        // TODO
    }
    
    func handleBlockchainResponse(message: HTTPURLResponse) {
        
    }
    
    func write(ws: Socket, message: Data) {
        do {
            try ws.writeData(message)
        } catch {
            print("There was an error writing to the socket, ws: \(ws), message: \(message)")
        }
    }
    
    func broadcast(message: Data) {
        for socket in self.sockets {
            self.write(ws: socket, message: message)
        }
    }
    
    func toJSON(obj: Any) throws -> Data {
        return try JSONSerialization.data(withJSONObject: obj,
                                          options: JSONSerialization.WritingOptions.prettyPrinted)
    }
}
