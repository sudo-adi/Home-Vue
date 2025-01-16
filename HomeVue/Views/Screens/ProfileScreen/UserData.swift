//
//  UserData.swift
//  Home Vue
//
//  Created by student-2 on 19/12/24.
//

import Foundation
import UIKit
struct UserModel {
    var UserName : String
    var UserEmail : String
    var UserPassword : String
    var UserProfilePhoto : UIImage?
    var DOB : Date
    var mobile : String
}

var User1 : UserModel = UserModel(UserName: "Nishtha", UserEmail: "nishtha@gmail.com", UserPassword: "54321", UserProfilePhoto: UIImage(named: "strawberry"), DOB: Date(),mobile: "9999955555")
