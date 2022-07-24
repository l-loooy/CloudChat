//
//  ViewController.swift
//  FlashChat
//
//  Created by admin on 15.07.2022.
//  Copyright © 2022 Sergey Lolaev. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animatedTitle()        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.isNavigationBarHidden = false
    }
}


//MARK: - WelcomeVC
extension WelcomeVC {
    
    func animatedTitle() {
        titleLabel.text = ""
        let titleText = Constants.chatName
        var delay = 0
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.1 * Double(delay), repeats: false) { (timer) in
                self.titleLabel.text?.append(letter)
            }
            delay += 1
        }
    }
}

