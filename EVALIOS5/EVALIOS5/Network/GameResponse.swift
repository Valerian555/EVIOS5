//
//  GameResponse.swift
//  EVALIOS5
//
//  Created by Student08 on 25/10/2023.
//

import Foundation

struct GameResponse: Codable {
    let featured_win: [WindowsGame]
}

struct WindowsGame: Codable {
    let id: Int?
    let name: String?
    let discounted: Bool?
    let discount_percent: Int?
    let original_price: Int?
    let final_price: Int?
    let currency: String?
    let small_capsule_image: String?
    let large_capsule_image: String?
    let windows_available: Bool?
    let mac_available: Bool?
    let linux_available: Bool?
    let controller_support: String?
}

