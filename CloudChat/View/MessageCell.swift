//
//  MessageCell.swift
//  CloudChat
//
//  Created by admin on 17.07.2022.
//  Copyright © 2022 Sergey Lolaev. All rights reserved.
//

import UIKit

final class MessageCell: UITableViewCell {
    
    @IBOutlet weak var messageText: UILabel!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var meAvatarImage: UIImageView!
    @IBOutlet weak var youAvatarImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageView.layer.cornerRadius = messageView.frame.size.height / 3
        messageText.textColor = .black
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
