//
//  ProfileHeaderView.swift
//  ChatApp
//
//  Created by SofiaBuslavskaya on 22/05/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit

protocol ProfileHeaderViewDelegate: class {
    func dismissController()
}

class ProfileHeaderView: UIView {
    
    //MARK: - Properties
    
    var user: User? {
        didSet { configureUserWithData() }
    }
    
    weak var delegate: ProfileHeaderViewDelegate?
    
    private let dismissButton: UIButton = {
         let button = UIButton(type: .system)
         button.setImage(UIImage(systemName: "xmark"), for: .normal)
         button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
         button.tintColor = .white
         button.imageView?.setDimensions(height: 22, width: 22)
         return button
     }()
     
     private let profileImageView: UIImageView = {
         let iv = UIImageView()
         iv.clipsToBounds = true
         iv.contentMode = .scaleAspectFill
         iv.layer.borderColor = UIColor.white.cgColor
         iv.layer.borderWidth = 4.0
         return iv
     }()
     
     private let fullnameLabel: UILabel = {
         let label = UILabel()
         label.font = .boldSystemFont(ofSize: 20)
         label.textColor = .white
         label.textAlignment = .center
        label.text = "Sergey Borovkov"
         return label
     }()
     
    private let usernameLabel: UILabel = {
         let label = UILabel()
         label.font = .systemFont(ofSize: 16)
         label.textColor = .white
         label.textAlignment = .center
        label.text = "@roba"
         return label
     }()
    
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    @objc func handleDismiss() {
        delegate?.dismissController()
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        configureGradientLayer()
        
        profileImageView.setDimensions(height: 200, width: 200)
        profileImageView.layer.cornerRadius = 200 / 2
        
        addSubview(profileImageView)
        profileImageView.centerX(inView: self)
        profileImageView.anchor(top: topAnchor, paddingTop: 96)
        
        let stack = UIStackView(arrangedSubviews: [fullnameLabel, usernameLabel])
        stack.axis = .vertical
        stack.spacing = 4
        
        addSubview(stack)
        stack.centerX(inView: self)
        stack.anchor(top: profileImageView.bottomAnchor, paddingTop: 16)
        
        addSubview(dismissButton)
        dismissButton.anchor(top: topAnchor, left: leftAnchor, paddingTop: 44, paddingLeft: 12)
        dismissButton.setDimensions(height: 48, width: 48)
    }
    
    private func configureGradientLayer() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemPurple.cgColor, UIColor.systemPink.cgColor]
        gradient.locations = [0, 1]
        layer.addSublayer(gradient)
        gradient.frame = bounds
    }
    
    private func configureUserWithData() {
        guard
            let user = user,
            let url = URL(string: user.profileImageUrl)
            else { return }
        
        fullnameLabel.text = user.fullname
        usernameLabel.text = "@" + user.username
        profileImageView.sd_setImage(with: url)
    }
    
}
