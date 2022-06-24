//
//  SortType.swift
//  Hotel
//
//  Created by yc on 2022/06/25.
//

import Foundation

enum SortType: String, CaseIterable {
    case registerDescending = "최신 항목 순"
    case registerAscending = "오래된 항목 순"
    case ratingDescending = "높은 평점 순"
    case ratingAscending = "낮은 평점 순"
    
    var title: String { self.rawValue }
}
