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
        COLLECTION_USERS.getDocuments { (snapshot, error) in
            snapshot?.documents.forEach({ document in
                
                let dictionary = document.data()
                
                let user = User(dictionary: dictionary)
                
                users.append(user)
                completion(users)
            })
        }
    }
    
    static func fetchUser(withUID uid: String, completion: @escaping(User) -> Void) {
        COLLECTION_USERS.document(uid).getDocument { (snapshot, error) in
            guard let dictionary = snapshot?.data() else { return }
            let user = User(dictionary: dictionary)
            completion(user)
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
        
    static func fetchConversations(completion: @escaping (([Conversation]) -> Void)) {
        var conversations = [Conversation]()
        guard let currentUID = Auth.auth().currentUser?.uid else { return }
        
        let query = COLLECTION_MESSAGES.document(currentUID).collection("recent-messages").order(by: "timeStamp")
        
        query.addSnapshotListener { (snapshot, error) in
            snapshot?.documentChanges.forEach({ change in
                let dictionary = change.document.data()
                let message = Message(dictionary: dictionary)
                
                self.fetchUser(withUID: message.toId) { (user) in
                     let conversation = Conversation(user: user, message: message)
                    conversations.append(conversation)
                    completion(conversations)
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
        
        // upload message data to user who send message, and who get message
        COLLECTION_MESSAGES.document(currentUID).collection(user.uid).addDocument(data: data) { (_) in
            COLLECTION_MESSAGES.document(user.uid)
                               .collection(currentUID)
                               .addDocument(data: data,
                                            completion: completion)
            
            // create new collection of recent-messages
            // upload recent message data to user who send message, and who get message
            COLLECTION_MESSAGES.document(currentUID)
                               .collection("recent-messages")
                               .document(user.uid)
                               .setData(data)
            
            COLLECTION_MESSAGES.document(user.uid)
                               .collection("recent-messages")
                               .document(currentUID)
                               .setData(data)
        }
    }
    
}
