//
//  LoginViewModel.swift
//  ChatApp
//
//  Created by SofiaBuslavskaya on 20/05/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import Foundation

protocol AuthenticationProtocol {
    var formIsValid: Bool { get }
}

struct LoginViewModel: AuthenticationProtocol {
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false
            && password?.isEmpty == false
    }
}
