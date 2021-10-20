//
//  ViewController.swift
//  ShakeApp
//
//  Created by Roman Shestopal on 24.09.2021.
//

import UIKit
import SystemConfiguration


protocol ViewControllerDelegate {
    func update(arrMessage: [String])
}

class ViewController: UIViewController, ViewControllerDelegate{

    var isConnected: Bool = false
    var game: Game!
    var gameProtocol: gameProtocol?
    
    func update(arrMessage: [String]) {
        message = arrMessage
    }
    
    @objc public func checkNetwork2() {
        if game.isConnected {
            statusNetwork.text = game.checkNetwork()
            Message.isHidden = true
        } else {
            statusNetwork.text = game.checkNetwork()
            Message.isHidden = false
        }
    }

    @IBOutlet weak var Message: UILabel!
    @IBOutlet weak var messageFromAPI: UILabel!
    @IBOutlet weak var statusNetwork: UILabel!
    
    // создание таймера для проверки подключения к сети
    var timer : Timer?
    
    func updateTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkNetwork2), userInfo: nil, repeats: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        game = Game() //defaults.string(forKey: MessagesUserDefaults.KeyNoConnectionMessage)!)
        print("viewDidLoad")
        updateTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("viewWillAppear")
        statusNetwork.text = game.checkNetwork()
        game.message = message
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("ViewDidAppear")
        game.Parser()
    }

    override var canBecomeFirstResponder: Bool{
        get {
            return true
        }
    }
    
    var count: Int = 0
    var message: [String] = []
    var defaults = UserDefaults.standard
    
    // Связь с SettingViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let SettincgVC = segue.destination as? SettingViewController{
            SettincgVC.ArrMessage = message
            SettincgVC.delegate = self
        }
    }
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        update(arrMessage: message)
        game.message = message
        count += 1
        if game.isConnected{
            game.Parser()
            messageFromAPI.text = game.messageFromAPI
        }
        if !game.message.isEmpty{
            Message.text = "\(game.message[count - 1])"
            print("count - \(game.message.count)")
            //Message.text = "\(defaults.string(forKey: MessagesUserDefaults.KeyNoConnectionMessage)!)"
        } else {
            Message.text = "go to Setting and add your first message";
            count = 0
        }
        //Message.text = "\(message[count-1]) "
        print("game.message - \(game.message)")
        print(game.message.isEmpty)
        if count == game.message.count {
            count = 0
        }
    }

}

