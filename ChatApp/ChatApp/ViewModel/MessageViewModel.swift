//
//  MessageViewModel.swift
//  ChatApp
//
//  Created by SofiaBuslavskaya on 21/05/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit

struct MessageViewModel {
    
    private let message: Message
    
    var messageBackgroundColor: UIColor {
        return message.isFromCurrentUser ? .systemPurple : #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    
    var messageTextColor: UIColor {
        return message.isFromCurrentUser ? .white : .black
    }
    
    var rightAnchorActive: Bool {
        return message.isFromCurrentUser
    }
    
    var leftAnchorActive: Bool {
        return !message.isFromCurrentUser
    }
    
    var shouldHideProfileImage: Bool {
        return message.isFromCurrentUser
    }
    
    // prepare profileImage from database to show at ChatViewController
    var profileImageUrl: URL? {
        guard let user = message.user else { return nil }
        return URL(string: user.profileImageUrl)
    }
    
    init(message: Message) {
        self.message = message
    }
}
