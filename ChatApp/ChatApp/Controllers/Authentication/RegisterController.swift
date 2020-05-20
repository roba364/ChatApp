//
//  RegisterController.swift
//  ChatApp
//
//  Created by SofiaBuslavskaya on 20/05/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit

class RegisterController: UIViewController {
    
    //MARK: - Properties
    
    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "plus_photo")
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        return button
    }()
    
    private lazy var emailContainerView: UIView = {
        return InputContainerView(image: UIImage(systemName: "envelope"),
        textField: emailTextField)
    }()
    
    private lazy var fullNameContainerView: UIView = {
        return InputContainerView(image: UIImage(named: "user"),
        textField: fullNameTextField)
    }()
    
    private lazy var userNameContainerView: UIView = {
        return InputContainerView(image: UIImage(named: "user"),
        textField: userNameTextField)
    }()
    
    private lazy var passwordContainerView: InputContainerView = {
        return InputContainerView(image: UIImage(systemName: "lock"),
                                               textField: passwordTextField)
    }()
    
    private let emailTextField: CustomTextField = {
        return CustomTextField(placeholder: "Email", secure: false)
    }()
    
    private let fullNameTextField: CustomTextField = {
        return CustomTextField(placeholder: "Full Name", secure: false)
    }()
    
    private let userNameTextField: CustomTextField = {
        return CustomTextField(placeholder: "User Name", secure: false)
    }()
    
    
    private let passwordTextField: CustomTextField = {
        return CustomTextField(placeholder: "Password", secure: true)
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setHeight(height: 50)
        return button
    }()
    
    private let alreadyHaveAnAccount: UIButton = {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Already have an account? ",
                                                        attributes: [.font : UIFont.systemFont(ofSize: 16),
                                                                     .foregroundColor: UIColor.white])
        
        attributedTitle.append(NSAttributedString(string: "Sign In",
                                                  attributes: [.font : UIFont.boldSystemFont(ofSize: 16),
                                                               .foregroundColor: UIColor.white]))
        
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        return button
    }()
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        
    }
    
    //MARK: - Selectors
    
    @objc func handleSelectPhoto() {
        
    }
    
    @objc func handleDismiss() {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        configureGradientLayer()
        
        view.addSubview(plusPhotoButton)
        // activate programmatic autolayout
        
        plusPhotoButton.centerX(inView: view)
        plusPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         paddingTop: 32,
                         width: 200,
                         height: 200)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView, fullNameContainerView, userNameContainerView, passwordContainerView, signUpButton])
        stack.axis = .vertical
        stack.spacing = 16
        
        view.addSubview(stack)
        stack.anchor(top: plusPhotoButton.bottomAnchor,
                     left: view.leftAnchor,
                     right: view.rightAnchor,
                     paddingTop: 32,
                     paddingLeft: 32,
                     paddingRight: 32)
        
        view.addSubview(alreadyHaveAnAccount)
        alreadyHaveAnAccount.anchor(left: view.leftAnchor,
                                       bottom: view.bottomAnchor,
                                       right: view.rightAnchor,
                                       paddingLeft: 32,
                                       paddingBottom: 35,
                                       paddingRight: 32)
    }
}
