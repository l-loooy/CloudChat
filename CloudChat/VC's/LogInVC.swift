//
//  LogInVC.swift
//  FlashChat
//
//  Created by admin on 16.07.2022.
//  Copyright © 2022 Sergey Lolaev. All rights reserved.
//

import UIKit
import FirebaseAuth

class LogInVC: UIViewController {
    
    
    @IBOutlet weak var emailLogIn: UITextField!
    @IBOutlet weak var passwordLogIn: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logInButtonPressed(_ sender: UIButton) {
        if let email = emailLogIn.text, let password = passwordLogIn.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    self.showAlert(title: "Error", message: e.localizedDescription, style: .alert)
                } else {
                    self.performSegue(withIdentifier: Constants.logInSegue, sender: self)
                }
            }
        }
    }
}



//MARK: - LogInVC
extension LogInVC {
    func showAlert(title: String, message: String, style: UIAlertController.Style) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "ok", style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}
