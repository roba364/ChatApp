//
//  RegisterController.swift
//  ChatApp
//
//  Created by SofiaBuslavskaya on 20/05/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit
import Firebase

class RegisterController: UIViewController {
    
    //MARK: - Properties
    
    private var viewModel = RegisterViewModel()
    private var profileImage: UIImage?
    
    weak var delegate: AuthenticationDelegate?
    
    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "plus_photo")
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFill
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
        let button = UIButton(type: .system)
        button.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setHeight(height: 50)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
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
        configureNotificationObservers()
    }
    
    //MARK: - Selectors
    
    @objc func handleRegistration() {
        guard
            let email = emailTextField.text,
            let fullname = fullNameTextField.text,
            let username = userNameTextField.text?.lowercased(),
            let password = passwordTextField.text,
            let profileImage = profileImage
            else { return }
        
        let credentials = RegistrationCredentials(email: email,
                                                 password: password,
                                                 fullname: fullname,
                                                 username: username,
                                                 profileImage: profileImage)
        
        showLoader(true, withText: "Registering...")
            
        AuthService.shared.createUser(credentials: credentials) { (error) in
            if let error = error {
                print("DEBUG: Failed to create user with error", error.localizedDescription)
                self.showLoader(false)
            }
            
            self.showLoader(false)
            self.delegate?.authenticationComplete()
        }
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else if sender == fullNameTextField {
            viewModel.fullName = sender.text
        } else if sender == userNameTextField {
            viewModel.userName = sender.text
        } else {
            viewModel.password = sender.text
        }
        
        checkFormStatus()
    }
    
    @objc func handleSelectPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    @objc func handleDismiss() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func keyboardWillShow() {
        if view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 88
        }
    }
    
    @objc func keyboardWillHide() {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
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
    
    private func configureNotificationObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange(sender:)), for: .editingChanged)
        fullNameTextField.addTarget(self, action: #selector(textDidChange(sender:)), for: .editingChanged)
        userNameTextField.addTarget(self, action: #selector(textDidChange(sender:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange(sender:)), for: .editingChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

//MARK: - UIImagePickerControllerDelegate

extension RegisterController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[.originalImage] as? UIImage
        profileImage = image
        plusPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 3.0
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.contentMode = .scaleAspectFill
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width / 2
        
        dismiss(animated: true)
    }
}

    //MARK: - AuthenticationControllerProtocol

extension RegisterController: AuthenticationControllerProtocol {

        func checkFormStatus() {
            if viewModel.formIsValid {
                signUpButton.isEnabled = true
                signUpButton.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
            } else {
                signUpButton.isEnabled = false
                signUpButton.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
            }
        }
}

//MARK: - AuthenticationControllerProtocol

