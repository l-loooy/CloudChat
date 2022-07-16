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
        
        DispatchQueue.main.async {
            self.animatedTitle()
        }
    }
}


//MARK: - WelcomeVC
extension WelcomeVC {
    
    func animatedTitle() {
        titleLabel.text = ""
        let titleText = "☁️ CloudChat ☁️"
        var delay = 0
        
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.1 * Double(delay), repeats: false) { (timer) in
                self.titleLabel.text?.append(letter)
            }
            delay += 1
        }
    }
}

