//
//  ShakeGame.swift
//  ShakeApp
//
//  Created by Roman Shestopal on 25.09.2021.
//

import Foundation
import Alamofire
import SwiftyJSON
import SystemConfiguration

protocol gameProtocol {
    var message: [String] {get}
    var isConnected: Bool {get}
    var messageFromAPI: String {get}
    func Parser()
    func checkNetwork() -> String
    func addMessage(text: String?) -> ([String])
}

public class Game: gameProtocol {
    
    func addMessage (text: String?) -> ([String]){
        if text != "" {
            message.append(text!)
        }
        return message
    }
    
    var isConnected: Bool = false
    var count: Int = 0
    var message: [String] = []
    var messageFromAPI: String = "Shake me (from API)"
    let url: String = "https://8ball.delegator.com/magic/JSON/%3Cquestion_string%3E"
    let question: String = ""
    let answer: String = ""
    let type: String = ""
    let magic: String = ""
  
    // проверка на подключение к сети интернет
    @objc public func checkNetwork() -> String {
        if Reachability.isConnected(){
            print("is connected")
            isConnected = true
            return "is connected"
        } else {
            print("not connected")
            isConnected = false
            return "No connection"
        }
    }
    
    //      опрос API и обработка ответа
    func Parser() {
        let url = url
        let param = ["question": self.question,
                     "answer" : self.answer,
                     "type": self.type ]

        AF.request(url, method: .get, parameters: param).responseJSON { [self]responds in
            switch responds.result{
            case .success(let value):
                let json = JSON(value)
                //print("1 - \(json)")
                let result: Dictionary<String, JSON> = json["magic"].dictionaryValue
                let result2: String = result["answer"]!.stringValue
                print("2 - \(result2)")
                messageFromAPI = result2
                print("message - \(messageFromAPI)")
            case .failure(let error):
                print(error)
            }
        }
    }
}




public class Reachability {
    
    class func isConnected() -> Bool {
        
        var noAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        noAddress.sin_len = UInt8(MemoryLayout.size(ofValue: noAddress))
        noAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &noAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {noSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, noSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
    }
}
