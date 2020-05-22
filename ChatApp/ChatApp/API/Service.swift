//
//  Service.swift
//  ChatApp
//
//  Created by SofiaBuslavskaya on 21/05/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import Foundation
import Firebase

struct Service {
    
    static func fetchUsers(completion: @escaping ([User]) -> Void) {
        var users = [User]()
        Firestore.firestore().collection("users").getDocuments { (snapshot, error) in
            snapshot?.documents.forEach({ document in
                
                let dictionary = document.data()
                
                let user = User(dictionary: dictionary)
                
                users.append(user)
                completion(users)
            })
        }
    }
    
    static func fetchMessages(forUser user: User, completion: @escaping ([Message]) -> Void) {
        var messages = [Message]()
        
        guard let currentUID = Auth.auth().currentUser?.uid else { return }
        
        // fetch all recent messages
        let query = COLLECTION_MESSAGES.document(currentUID).collection(user.uid).order(by: "timeStamp")
        
        // snapshot listener reports about new changes in database
        query.addSnapshotListener { (snapshot, error) in
            snapshot?.documentChanges.forEach({ change in
                // when we add something in database
                if change.type == .added {
                    let dictionary = change.document.data()
                    messages.append(Message(dictionary: dictionary))
                    completion(messages)
                }
            })
        }
    }
    
    static func uploadMessage(_ message: String, to user: User, completion: ((Error?) -> Void)?) {
        guard let currentUID = Auth.auth().currentUser?.uid else { return }
        
        let data = ["text": message,
                    "fromId": currentUID,
                    "toId": user.uid,
                    "timeStamp": Timestamp(date: Date())] as [String: Any]
        
        COLLECTION_MESSAGES.document(currentUID).collection(user.uid).addDocument(data: data) { (_) in
            COLLECTION_MESSAGES.document(user.uid).collection(currentUID).addDocument(data: data, completion: completion)
        }
    }
    
}
