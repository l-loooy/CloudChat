//
//  ChatVC.swift
//  FlashChat
//
//  Created by admin on 16.07.2022.
//  Copyright © 2022 Sergey Lolaev. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextFiled: UITextField!
    @IBOutlet weak var sendMessageButton: UIButton!
    
    //ref to dataBase
    let db = Firestore.firestore()
    
    var messagesArray = [Messages]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.allowsSelection = false
        //register nibCell
        tableView.register(UINib(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.cellID)
        
        //title for NavBar
        title = Constants.chatName
        
        navigationItem.hidesBackButton = true
        
        loadMessage()
        
    }
    
    
    // class QuerySnapshot : NSObject
    // A QuerySnapshot contains zero or more DocumentSnapshot objects. It can be enumerated using the documents property and its size can be inspected with isEmpty and count.
    
    func loadMessage() {
        db.collection(Constants.FireStore.collectionName)
            //sorted messages by date
            .order(by: Constants.FireStore.dateField)
            .addSnapshotListener() { (querySnapshot, err) in
                
                self.messagesArray = []
                
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let messageSender = data[Constants.FireStore.senderField] as? String, let messageBody = data[Constants.FireStore.bodyField] as? String {
                                let newMessage = Messages(sender: messageSender, body: messageBody)
                                self.messagesArray.append(newMessage)
                                
                                //updateUI inside of closure we should switch on mainThread and do it async
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                    
                                    //autoscroll to bottom of the messagesArray, when new message is created
                                    let indexPath = IndexPath(row: self.messagesArray.count - 1, section: 0)
                                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                                }
                            }
                        }
                    }
                }
        }
    }
    //При отправке сообщения в db будет добавляться пара "отправитель: тело сообщения"
    
    @IBAction func sendMessageButtonPressed(_ sender: UIButton) {
        //if textFiled is empty there is nothing to send and button is unavaliable
        if messageTextFiled.text != "" {
            if let messageBody = messageTextFiled.text , let messageSender = Auth.auth().currentUser?.email {
                
                db.collection(Constants.FireStore.collectionName).addDocument(data: [
                    Constants.FireStore.senderField : messageSender,
                    Constants.FireStore.bodyField : messageBody,
                    Constants.FireStore.dateField : Date().timeIntervalSince1970
                    ])
                { (error) in
                    if let err = error {
                        print("Error adding document: \(err)")
                    } else {
                        print("Data is successfully saved")
                        DispatchQueue.main.async {
                            self.messageTextFiled.text = ""
                        }
                    }
                }
            }
        }
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
        return messagesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messagesArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellID, for: indexPath) as! MessageCell
        cell.messageText.text = message.body
        
        //message from the current user
        if message.sender == Auth.auth().currentUser?.email {
            
            cell.meAvatarImage.isHidden = false
            cell.youAvatarImage.isHidden = true
            //выбрать окончательный цвет для фона вокруг сообщения
            cell.messageView.backgroundColor = UIColor(named: Constants.BrandColors.brandPink)
            cell.messageText.textColor = UIColor(named: Constants.BrandColors.messageTextColor)
        } else {
            cell.meAvatarImage.isHidden = true
            cell.youAvatarImage.isHidden = false
            cell.messageView.backgroundColor = UIColor(named: Constants.BrandColors.brandPurple)
            cell.messageText.textColor = .white
        }
        return cell
    }
}
