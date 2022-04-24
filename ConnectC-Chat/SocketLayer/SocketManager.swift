//
//  SocketManager.swift
//  ConnectC-Chat
//
//  Created by Karthikeyan Anbu on 23/04/22.
//

import Foundation
import SocketIO

class SocketIOManager: NSObject {
    
    static let sharedInstance = SocketIOManager()
    
    var socket = SocketManager(socketURL: URL(string: "http://connect-ec-v3.dci.in:8006")!, config: [.log(false), .forcePolling(true)]).defaultSocket
    
    
    override init() {
        super.init()
        
        socket.on("test") { dataArray, ack in
            print(dataArray)
        }
        
    }
    
    func establishConnection() {
        print("Socket connected")
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    // send message
    func sendMessage(message: String, withNickname nickname: String) {
        socket.emit("chatMessage", nickname, message)
    }
    
    func sendStartTypingMessage(nickname: String) {
        socket.emit("startType", nickname)
    }
    
    
    func sendStopTypingMessage(nickname: String) {
        socket.emit("stopType", nickname)
    }
    
    // receiveMessage
    func getChatMessage(completion: @escaping (_ messageInfo: [String: Any]) -> Void) {
        socket.on("newChatMessage") { dataArray, ack  in
            var messageDictionary = [String: Any]()
            //            messageDictionary["nickname"] = dataArray[0] as! String
            //            messageDictionary["message"] = dataArray[1] as! String
            //            messageDictionary["date"] = dataArray[2] as! String
            completion(messageDictionary)
        }
    }
    
    private func listenForOtherMessages() {
        socket.on("private-channel:private_eventss") { dataArray, socketAck in
            NotificationCenter.default.post(name: .private_eventss, object: nil, userInfo: dataArray[0] as? [String: Any])
        }
        
    }
}


extension Notification.Name {
    static let private_eventss = Notification.Name("private_eventss")
    static let userWasDisconnectedNotification = Notification.Name("userWasDisconnectedNotification")
    static let userTypingNotification = Notification.Name("userTypingNotification")
}
