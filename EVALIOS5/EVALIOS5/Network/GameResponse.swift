//
//  GameResponse.swift
//  EVALIOS5
//
//  Created by Student08 on 25/10/2023.
//

import Foundation

struct GameResponse: Codable {
    let featuredWin: [Game]
    let featuredMac: [Game]
    let featuredLinux: [Game]

    enum CodingKeys: String, CodingKey {
        case featuredWin = "featured_win"
        case featuredMac = "featured_mac"
        case featuredLinux = "featured_linux"
    }
}

struct Game: Codable {
    let id: Int?
    let name: String?
    let discounted: Bool?
    let discountPercent: Int?
    let originalPrice: Int?
    let finalPrice: Int?
    let currency: String?
    let smallImage: String?
    let largeImage: String?
    let windowsAvailable: Bool?
    let macAvailable: Bool?
    let linuxAvailable: Bool?
    let controllerSupport: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case discounted
        case discountPercent = "discount_percent"
        case originalPrice = "original_price"
        case finalPrice = "final_price"
        case currency
        case smallImage = "small_capsule_image"
        case largeImage = "large_capsule_image"
        case windowsAvailable = "windows_available"
        case macAvailable = "mac_available"
        case linuxAvailable = "linux_available"
        case controllerSupport
    }
}

