//
//  ChatVC.swift
//  FlashChat
//
//  Created by admin on 16.07.2022.
//  Copyright © 2022 Sergey Lolaev. All rights reserved.
//

import UIKit
import FirebaseAuth

class ChatVC: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chatTextField: UITextField!
    var messages = [
        Messages(sender: "lol@gmail.com", body: "алло"),
        Messages(sender: "chuvak@gmail.com", body: "да..."),
        Messages(sender: "lol@gmail.com", body: "че там с деньгами?"),
        Messages(sender: "chuvak@gmail.com", body: "какими деньгами"),
        Messages(sender: "lol@gmail.com", body: "которые я влОжил"),
        Messages(sender: "chuvak@gmail.com", body: "куда ты влОжил?"),
        Messages(sender: "lol@gmail.com", body: "в капитал прожиточного минимума")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.allowsSelection = false
        
        tableView.register(UINib(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.cellID)
        
        //title for NavBar
        title = Constants.chatName
        navigationItem.hidesBackButton = true
    }
    
    
    @IBAction func sendMessageButtonPressed(_ sender: UIButton) {
    }
    
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            self.navigationController?.popViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

//MARK: - UITableViewDataSource
extension ChatVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellID, for: indexPath) as! MessageCell
        cell.messageText.text = messages[indexPath.row].body
        return cell
    }
}
