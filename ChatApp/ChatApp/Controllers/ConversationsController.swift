//
//  ConversationsController.swift
//  ChatApp
//
//  Created by SofiaBuslavskaya on 20/05/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "ConversationCell"

class ConversationsController: UIViewController {
    
    //MARK: - Properties
    
    private let tableView = UITableView()
    private var conversations = [Conversation]()
    private var conversationsDictionary = [String: Conversation]()
    
    private let newMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.backgroundColor = .systemPurple
        button.tintColor = .white
        button.addTarget(self, action: #selector(showNewMessage), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        authenticateUser()
        fetchConversations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar(withTitle: "Messages", prefersLargeTitles: true)
    }
    
    //MARK: - Selectors
    
    @objc func showProfile() {
        
        let profileController = ProfileController(style: .insetGrouped)
        // use delegate chaining
        profileController.delegate = self
        let nav = UINavigationController(rootViewController: profileController)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    @objc func showNewMessage() {
        let newMessageController = NewMessageController()
        newMessageController.delegate = self
        let navController = UINavigationController(rootViewController: newMessageController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
    
    //MARK: - API
    
    private func fetchConversations() {
        Service.fetchConversations { (conversations) in
            
            conversations.forEach({ conversation in
                // set the key
                let message = conversation.message
                self.conversationsDictionary[message.chatPartnerId] = conversation
            })
            
            self.conversations = Array(self.conversationsDictionary.values)
            self.tableView.reloadData()
        }
    }
    
    private func authenticateUser() {
        if Auth.auth().currentUser?.uid == nil {
            presentLoginScreen()
            print("DEBUG: User is not logged in")
        }
    }
    
    private func logout() {
        do {
            try Auth.auth().signOut()
            presentLoginScreen()
        } catch let error {
            print("DEBUG: Error signing out...", error.localizedDescription)
        }
    }
    
    //MARK: - Helpers
    
    private func presentLoginScreen() {
        DispatchQueue.main.async {
            let controller = LoginController()
            controller.delegate = self
            let navVC = UINavigationController(rootViewController: controller)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .white
    
        configureTableView()
        
        
        let image = UIImage(systemName: "person.circle.fill")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image,
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(showProfile))
        
        view.addSubview(newMessageButton)
        newMessageButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                right: view.rightAnchor,
                                paddingBottom: 16,
                                paddingRight: 24,
                                width: 50,
                                height: 50)
        newMessageButton.layer.cornerRadius = 25
        
    }
    
    private func configureTableView() {
        tableView.backgroundColor = .white
        tableView.rowHeight = 80
        tableView.register(ConversationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
        tableView.frame = view.frame
    }
    
    private func showChatController(forUser user: User) {
        let chatController = ChatController(user: user)
        navigationController?.pushViewController(chatController, animated: true)
    }
}

    //MARK: - UITableViewDelegate

extension ConversationsController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = conversations[indexPath.row].user
        showChatController(forUser: user)
        
    }
}

    //MARK: - UITableViewDataSource

extension ConversationsController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ConversationCell else { fatalError("Failed to register reusable ConversationCell")}
        
        let conversation = conversations[indexPath.row]
    
        cell.conversation = conversation
        
        return cell
    }
    
}

    //MARK: - NewMessageControllerDelegate

extension ConversationsController: NewMessageControllerDelegate {
    
    func controller(_ controller: NewMessageController, wantsToStartChatWith user: User) {
        dismiss(animated: true)
        showChatController(forUser: user)
    }
}

    //MARK: - ProfileControllerDelegate

extension ConversationsController: ProfileControllerDelegate {
    // use delegate chaining
    // end of chaining
    func handleLogout() {
        logout()
    }
}

    //MARK: - AuthenticationDelegate
    
extension ConversationsController: AuthenticationDelegate {
    func authenticationComplete() {
        dismiss(animated: true)
        configureUI()
        fetchConversations()
    }
}
