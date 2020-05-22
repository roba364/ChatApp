//
//  Message.swift
//  ChatApp
//
//  Created by SofiaBuslavskaya on 21/05/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import Firebase

struct Message {
    let text: String
    let toId: String
    let fromId: String
    var timeStamp: Timestamp!
    var user: User?
    
    let isFromCurrentUser: Bool
    
    init(dictionary: [String: Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.toId = dictionary["toId"] as? String ?? ""
        self.fromId = dictionary["fromId"] as? String ?? ""
        self.timeStamp = dictionary["timeStamp"] as? Timestamp ?? Timestamp(date: Date())
        
        self.isFromCurrentUser = fromId == Auth.auth().currentUser?.uid
    }
}
