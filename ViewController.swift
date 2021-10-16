//
//  ViewController.swift
//  ShakeApp
//
//  Created by Roman Shestopal on 24.09.2021.
//

import UIKit
import Alamofire
import SwiftyJSON
import SystemConfiguration
//import ReachabilitySwift

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

protocol ViewControllerDelegate {
    func update(arrMessage: [String])
}

class ViewController: UIViewController, ViewControllerDelegate {
    func update(arrMessage: [String]) {
        message = arrMessage
    }
    
    @objc public func checkNetwork() {
        if Reachability.isConnected(){
            print("is connected")
            statusNetwork.text = "Is connected"
            Message.isHidden = true
        } else {
            print("not connected")
            statusNetwork.text = "No connection"
            Message.isHidden = false
        }
    }
    
    func Parser(url: String, parameters: [String: String]){

        AF.request(url, method: .get, parameters: parameters).responseJSON {responds in
            //print("result - \(responds.result)")
            switch responds.result{
            case .success(let value):
                let json = JSON(value)
                //print("1 - \(json)")
                let result: Dictionary<String, JSON> = json["magic"].dictionaryValue
                let result2: String = result["answer"]!.stringValue
                print("2 - \(result2)")
                self.messageFromAPI.text = result2
            case .failure(let error):
                print(error)
            }
            
        }
    }

    @IBOutlet weak var Message: UILabel!
    @IBOutlet weak var messageFromAPI: UILabel!
    @IBOutlet weak var statusNetwork: UILabel!
    
    var timer : Timer?
    
    func updateTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkNetwork), userInfo: nil, repeats: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //updateTimer()
        checkNetwork()
        print("viewDidLoad")
//        Parser(url: url, parameters: param)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("viewWillAppear")
        updateTimer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //updateTimer()
        print("ViewDidAppear")
    }

    override var canBecomeFirstResponder: Bool{
        get {
            return true
        }
    }
    
    var count: Int = 0
    var message: [String] = []
    //var answer: String = ""
    let url: String = "https://8ball.delegator.com/magic/JSON/%3Cquestion_string%3E"
    let question: String = ""
    let answer: String = ""
    let type: String = ""
    let magic: String = ""
    var defaults = UserDefaults.standard
    
//    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
//        if motion == .motionShake{
//            print("Finish shake")
//            count += 1
//            Message.text = "You finish shake me \(count) times"
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let SettincgVC = segue.destination as? SettingViewController{
            SettincgVC.ArrMessage = message
            SettincgVC.delegate = self
        }
    }
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        //print("Start shake")
//        var text :String = Message.text!
        //checkNetwork()
        update(arrMessage: message)
        count += 1
        if !message.isEmpty{
            //Message.text = "\(message[count-1]) "
            Message.text = "\(defaults.string(forKey: MessagesUserDefaults.KeyNoConnectionMessage)!)"
        } else {
            Message.text = "go to Setting and add your first message";
        }
        //Message.text = "\(message[count-1]) "
        print(defaults.string(forKey: MessagesUserDefaults.KeyNoConnectionMessage)!)
        if count == message.count {
            count = 0
        }
        let param = ["question": question,
                    "answer" : answer,
                    "type": type ]
        //let param2 = ["magic": param]
        Parser(url: url, parameters: param)
    }

}

