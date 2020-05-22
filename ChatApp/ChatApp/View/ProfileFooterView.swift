//
//  ProfileFooterView.swift
//  ChatApp
//
//  Created by SofiaBuslavskaya on 22/05/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit

protocol ProfileFooterViewDelegate: class {
    func handleLogout()
}

class ProfileFooterView: UIView {
    
    //MARK: - Properties
    
    weak var delegate: ProfileFooterViewDelegate?
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log out", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.backgroundColor = .systemPink
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(logoutButton)
        logoutButton.anchor(left: leftAnchor, right: rightAnchor, paddingLeft: 32, paddingRight: 32, height: 50)
        logoutButton.centerX(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    @objc func handleLogout() {
        delegate?.handleLogout()
    }
    
    //MARK: - Helpers
}
