//
//  HotelInfo.swift
//  Hotel
//
//  Created by yc on 2022/06/24.
//

import Foundation

struct HotelInfo: Codable {
    let msg: String
    let data: ProductData
    let code: Int
}
struct ProductData: Codable {
    let totalCount: Int
    let product: [Product]
}

struct Product: Codable {
    let id: Int
    let name: String
    let thumbnail: String
    let description: Description
    let rate: Float
}
struct Description: Codable {
    let imagePath: String
    let subject: String
    let price: Int
}
