//
//  RegistrationVC.swift
//  FlashChat
//
//  Created by admin on 16.07.2022.
//  Copyright © 2022 Sergey Lolaev. All rights reserved.
//

import UIKit
import FirebaseAuth


final class RegistrationVC: UIViewController {
    
    @IBOutlet weak var emailRegistration: UITextField!
    @IBOutlet weak var passwordRegistration: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func registrationButtonPressed(_ sender: UIButton) {
        if let email = emailRegistration.text, let password = passwordRegistration.text {
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
                if let realError = error {
                    self?.showAlert(title: "Error", message: realError.localizedDescription, style: .alert)
                } else {
                    self?.performSegue(withIdentifier: Constants.registerSegue, sender: self)
                }
            }
        }
    }
    
    // if something goes wrong with registration, show the error to user.
    private func showAlert(title: String, message: String, style: UIAlertController.Style) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "ok", style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}
