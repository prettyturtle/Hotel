//
//  Bookmark.swift
//  Hotel
//
//  Created by yc on 2022/06/24.
//

import Foundation

struct Bookmark: Codable, Hashable {
    let product: Product
    let isCheck: Bool
    let registerDate: Date
}
