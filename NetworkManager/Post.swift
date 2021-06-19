//
//  Post.swift
//  NetworkManager
//
//  Created by SERGEY VOROBEV on 14.06.2021.
//

import Foundation

struct Post: Codable {
    let userId: Int
    let postId: Int
    let postTitle: String
    let postBody: String
    
    enum CodingKeys: String, CodingKey {
        case userId
        case postId = "id"
        case postTitle = "title"
        case postBody = "body"
    }
}
