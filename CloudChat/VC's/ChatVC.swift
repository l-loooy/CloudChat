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

final class ChatVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextFiled: UITextField!
    @IBOutlet weak var sendMessageButton: UIButton!
    
    //ref to dataBase
    private let db = Firestore.firestore()
    
    private var messagesArray = [Messages]()
    
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
    
    private func loadMessage() {
        db.collection(Constants.FireStore.collectionName)
            //sorted messages by date
            .order(by: Constants.FireStore.dateField)
            .addSnapshotListener() { [weak self] (querySnapshot, error) in
                self?.messagesArray = []
                if let realError = error {
                    print("Error getting documents: \(realError)")
                } else {
                    self?.snapshotMethod(querySnapshot)
                }
        }
    }
    
    /*
     class QuerySnapshot : NSObject
     A QuerySnapshot contains zero or more DocumentSnapshot objects.
     It can be enumerated using the documents property and its size can be inspected with isEmpty and count.
     */
    private func snapshotMethod(_ querySnapshot: QuerySnapshot?) {
        if let snapshotDocuments = querySnapshot?.documents {
            for doc in snapshotDocuments {
                let data = doc.data()
                if let messageSender = data[Constants.FireStore.senderField] as? String,
                    let messageBody = data[Constants.FireStore.bodyField] as? String {
                    let newMessage = Messages(sender: messageSender, body: messageBody)
                    self.messagesArray.append(newMessage)
                    
                    //updateUI inside of closure we should switch on mainThread and do it async
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.scrollToBottom()
                    }
                }
            }
        }
    }
    
    private func scrollToBottom() {
        //autoscroll to bottom of the messagesArray, when new message is created
        let indexPath = IndexPath(row: self.messagesArray.count - 1, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    //When sending, the "sender: message body" pair will be added to the db
    @IBAction func sendMessageButtonPressed(_ sender: UIButton) {
        //if textFiled is empty, there is nothing to send and button is unavaliable
        guard let messageBody = messageTextFiled.text , let messageSender = Auth.auth().currentUser?.email else {
            return
        }
        if !messageTextFiled.text!.isEmpty {
            db.collection(Constants.FireStore.collectionName).addDocument(data: [
                Constants.FireStore.senderField : messageSender,
                Constants.FireStore.bodyField : messageBody,
                Constants.FireStore.dateField : Date().timeIntervalSince1970
            ]) { [weak self] error in
                self?.handlerSendMessageCallback(error)
            }
        }
    }
    
    private func handlerSendMessageCallback(_ error: Error?) {
        guard let error = error else {
            DispatchQueue.main.async {
                print("Data is successfully saved")
                self.clearMessageTextField()
            }
            return
        }
        alertSendMessage(error)
    }
    
    private func clearMessageTextField() {
        messageTextFiled.text = ""
    }
    
    private func alertSendMessage(_ error: Error?) {
        let alert = UIAlertController(title: "Something goes wrong...",
                                      message: error?.localizedDescription,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
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
