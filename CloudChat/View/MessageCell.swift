//
//  MessageCell.swift
//  CloudChat
//
//  Created by admin on 17.07.2022.
//  Copyright © 2022 Sergey Lolaev. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    @IBOutlet weak var messageText: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var messageView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        messageView.layer.cornerRadius = messageView.frame.size.height / 3
        messageText.textColor = UIColor(named: Constants.BrandColors.brandPalette)
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
