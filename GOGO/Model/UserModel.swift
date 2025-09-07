//
//  UserModel.swift
//  MoneyMagnet
//
//  Created by GitHesh11 on 2023-09-25.
//

import Foundation

struct UserModel: Codable {
    let status: Bool
    let data: UserData?
    let message: String?
}

struct UserData: Codable {
    let user: User
    let accessToken: String
    
    enum CodingKeys: String, CodingKey {
        case user
        case accessToken = "access_token"
    }
}

struct User: Codable {
    let userID, username, userPassword: String
    let v: Int

    enum CodingKeys: String, CodingKey {
        case userID = "_id"
        case username, userPassword
        case v = "__v"
    }
}

struct UserRegisterModel: Codable {
    let status: Bool
    let data: User?
    let message: String?
}
