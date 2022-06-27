//
//  PagingIndicatorViewDelegate.swift
//  Hotel
//
//  Created by yc on 2022/06/27.
//

import Foundation

protocol PagingIndicatorViewDelegate: AnyObject {
    /// 더보기 버튼을 눌렀을 때 호출되는 메서드
    func showMoreItem()
}
