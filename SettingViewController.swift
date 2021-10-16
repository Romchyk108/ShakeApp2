//
//  SettingViewController.swift
//  ShakeApp
//
//  Created by Roman Shestopal on 25.09.2021.
//

import UIKit

enum MessagesUserDefaults{
    static let KeyNoConnectionMessage = "NoConnectionMessage"
}

class SettingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView?.dataSource = self
        }
    }
    @IBOutlet weak var textField: UITextField!
    @IBAction func addNewText(_ sender: UIButton) {
        let alertController = UIAlertController(title: "New message", message: "Enter your message", preferredStyle: .alert)
        let addMessage = UIAlertAction(title: "Add", style: .default, handler: { [self] add in
            let textF = alertController.textFields?.first
            if let newMessage = textF?.text{
                if newMessage != ""{
                    self.ArrMessage.append(newMessage)
                    self.delegate?.update(arrMessage: self.ArrMessage)
                    print(self.ArrMessage)
                    self.tableView.reloadData()
                    defaults.setValue(newMessage, forKey: MessagesUserDefaults.KeyNoConnectionMessage)
                }
            }
        })
        alertController.addTextField(configurationHandler: { _ in})
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertController.addAction(addMessage)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    

    var delegate: ViewControllerDelegate?
    var ArrMessage : [String] = []
    var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //tableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SettingViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ArrMessage.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath) as UITableViewCell
        
        //let arr = ArrMessage[indexPath.row]
        cell.textLabel?.text = String(ArrMessage[indexPath.row])
        //cell.textLabel?.text = String(UserDefaults.string(<#T##self: UserDefaults##UserDefaults#>))
        print("TableView")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            ArrMessage.remove(at: indexPath.row)
            self.delegate?.update(arrMessage: self.ArrMessage)
            
            tableView.endUpdates()
        }
    }
    
}
