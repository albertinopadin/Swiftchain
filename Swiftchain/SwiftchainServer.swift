//
//  SwiftchainServer.swift
//  Swiftchain
//
//  Created by Albertino Padin on 3/16/17.
//  Copyright © 2017 Albertino Padin. All rights reserved.
//

import Foundation
import Swifter
import Starscream

private let default_http_port: UInt16 = 3002
private let default_p2p_port: UInt16 = 6002
private let localWebSocketAddressPrefix = "ws://localhost:"

public class SwiftchainServer<T>: WebSocketDelegate where T: Equatable {
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
    var p2pServer: WebSocket!
    var initialPeers = [String]()  // Guessing the peers are just a list of IP Addresses???
    var sockets = [WebSocket]()
    
    init(httpPort: UInt16 = default_http_port, p2pPort: UInt16 = default_p2p_port) {
        self.connectToPeers(newPeers: initialPeers)
        self.initHttpServer(port: httpPort)
        self.initP2PServer(port: p2pPort)
    }
    
    func initHttpServer(port: UInt16) {
        do {
            try self.httpServer.start(port)
            print("Listening HTTP on port: \(port)")
        } catch let error {
            print("There was an error starting the http server, , error: \(error).")
        }
    }
    
    func initP2PServer(port: UInt16) {
        do {
            self.p2pServer = WebSocket(url: URL(string: localWebSocketAddressPrefix + String(port))!)
            self.p2pServer.delegate = self
            self.p2pServer.connect()
            print("Listening WebSocket P2P on port: \(port)")
        } //catch let error {
//            print("There was an error starting the websocket server, , error: \(error).")
//        }
    }
    
    /** Starscream delegate methods **/
    public func websocketDidConnect(socket: WebSocket) {
        print("WebSocket is connected, \(socket)")
    }
    
    public func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        print("WebSocket has disconnected, \(socket)")
    }
    
    public func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        print("Got text: \(text) in socket: \(socket)")
    }
    
    public func websocketDidReceiveData(socket: WebSocket, data: Data) {
        do {
            print("Got data: \(data) in socket: \(socket)")
            let message = try self.fromJSON(data: data) as! SwiftchainMessage
            print("Message parsed from data: \(message)")
            
            switch message.type {
            case MessageType.QUERY_LATEST:
                try self.write(ws: socket, message: self.toJSON(obj: self.responseLatestMsg()))
            case MessageType.QUERY_ALL:
                try self.write(ws: socket, message: self.toJSON(obj: self.responseChainMsg()))
            case MessageType.RESPONSE_BLOCKCHAIN:
                try self.handleBlockchainResponse(message: message)
            default:
                print("Recieved unknown type of data: \(data) on socket: \(socket).")
            }
        } catch let error {
            print("There was an error recieving data on socket: \(socket), data: \(data), error: \(error)")
        }
    }
    
    /*********************************/
    
    func initConnection(ws: WebSocket) {
        do {
            self.sockets.append(ws)
//            self.initMessageHandler(ws: ws)
//            self.initErrorHandler(ws: ws)
            let msg = try self.toJSON(obj: self.queryChainLengthMsg)
//            self.write(ws: ws, message: msg)
        } catch let error {
            print("Could not initialize connection, ws: \(ws), error: \(error).")
        }
    }

//    Replaced by Starscream delegate function
//    func initMessageHandler(ws: Socket) {
//        
//    }
    
    func initErrorHandler(ws: Socket) {
        
    }
    
    func connectToPeers(newPeers: [String]) {
        // TODO
    }
    
    func handleBlockchainResponse(message: SwiftchainMessage) {
        
    }
    
    func write(ws: WebSocket, message: Data) {
//        do {
//            try ws.writeData(message)
//        } catch let error {
//            print("There was an error writing to the socket, ws: \(ws), message: \(message), error: \(error).")
//        }
    }
    
    func broadcast(message: Data) {
        for socket in self.sockets {
            self.write(ws: socket, message: message)
        }
    }
    
    func fromJSON(data: Data) throws -> Any {
        return try JSONSerialization.jsonObject(with: data)
    }
    
    func toJSON(obj: Any) throws -> Data {
        return try JSONSerialization.data(withJSONObject: obj,
                                          options: JSONSerialization.WritingOptions.prettyPrinted)
    }
}
