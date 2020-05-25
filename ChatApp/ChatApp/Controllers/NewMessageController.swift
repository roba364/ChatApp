//
//  NewMessageController.swift
//  ChatApp
//
//  Created by SofiaBuslavskaya on 21/05/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit

private let reuseIdentifier = "UserCell"

protocol NewMessageControllerDelegate: class {
    func controller(_ controller: NewMessageController, wantsToStartChatWith user: User)
}

class NewMessageController: UITableViewController {
    
    //MARK: Properties
    
    private var users = [User]()
    private var filteredUsers = [User]()
    
    weak var delegate: NewMessageControllerDelegate?
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var isSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureSearchController()
        fetchUsers()
    }
    
    //MARK: - Selectors
    
    @objc func handleDismiss() {
        dismiss(animated: true)
    }
    
    //MARK: - API
    
    private func fetchUsers() {
        Service.fetchUsers { [weak self] (users) in
            self?.users = users
            self?.tableView.reloadData()
        }
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        
        configureNavigationBar(withTitle: "New message", prefersLargeTitles: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleDismiss))
        
        tableView.tableFooterView = UIView()
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 80
    }
    
    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.showsCancelButton = false
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search user..."
        definesPresentationContext = false
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.textColor = .systemPurple
            textField.backgroundColor = .white
        }
    }
}

    //MARK: - UITableViewDataSource

extension NewMessageController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return isSearchMode ? filteredUsers.count : users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        
        cell.user = isSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        
        return cell
    }
}

    //MARK: - UITableViewDelegate

extension NewMessageController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let user = isSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        
        delegate?.controller(self, wantsToStartChatWith: user)
    }
}

extension NewMessageController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        
        filteredUsers = users.filter({ (user) -> Bool in
            return user.username.contains(searchText) || user.fullname.contains(searchText)
        })
        
        self.tableView.reloadData()
    }
}
