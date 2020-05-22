//
//  ProfileController.swift
//  ChatApp
//
//  Created by SofiaBuslavskaya on 22/05/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "ProfileCell"

class ProfileController: UITableViewController {
    
    //MARK: - Properties
    
    private var user: User? {
        didSet { headerView.user = user }
    }
    
    private lazy var headerView = ProfileHeaderView(frame: .init(x: 0, y: 0,
                                                                 width: view.frame.width,
                                                                 height: 380))
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
    
    //MARK: - API
    
    private func fetchUser() {
        guard let currentUID = Auth.auth().currentUser?.uid else { return }
        Service.fetchUser(withUID: currentUID) { (user) in
            self.user = user
        }
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        tableView.backgroundColor = .white
        
        headerView.delegate = self
        tableView.tableHeaderView = headerView
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.contentInsetAdjustmentBehavior = .never
    }
}

    //MARK: - TableViewDataSource

extension ProfileController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        return cell
    }
}

    //MARK: - ProfileHeaderViewDelegate

extension ProfileController: ProfileHeaderViewDelegate {
    
    func dismissController() {
        dismiss(animated: true)
    }
}
