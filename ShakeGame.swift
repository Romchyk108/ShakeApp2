//
//  ShakeGame.swift
//  ShakeApp
//
//  Created by Roman Shestopal on 25.09.2021.
//

import Foundation

class Game{
    var count :Int = 0
    var message : [String] = ["Just do it!", "Change your mind"]
    
    func addMessage (text : String?) -> ([String]){
        if text != "" {
            message.append(text!)
        }
        return message
    }
    
    init(newMessage: String) {
        self.message = [newMessage]
    }
}
