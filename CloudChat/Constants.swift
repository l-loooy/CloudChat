//
//  Constants.swift
//  CloudChat
//
//  Created by admin on 17.07.2022.
//  Copyright © 2022 Sergey Lolaev. All rights reserved.
//



struct Constants {
    static let registerSegue = "fromRegisterToChat"
    static let logInSegue = "fromLogInToChat"
    
    static let chatName = "☁️ CloudChat ☁️"
    
    static let cellID = "ReusableCell"
    static let cellNibName = "MessageCell"
    
    struct BrandColors {
        static let brandPalette = "BrandPalette"
        static let brandPink = "BrandPink"
        static let brandPurple = "BrandPurple"
        static let messageTextColor = "messageTextColor"
    }
    
    struct FireStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
}
