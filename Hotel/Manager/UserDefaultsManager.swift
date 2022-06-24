//
//  UserDefaultsManager.swift
//  Hotel
//
//  Created by yc on 2022/06/24.
//

import Foundation

struct UserDefaultsManager {
    private let standard = UserDefaults.standard
    private let key = "Bookmark"
    
    func getBookmarkList() -> [Bookmark] {
        guard let value = standard.value(forKey: key) else { return [] }
        do {
            let data = try JSONSerialization.data(withJSONObject: value)
            let bookmarkList = try JSONDecoder().decode([Bookmark].self, from: data)
            return bookmarkList
        } catch {
            return []
        }
    }
    func addBookmark(item: Bookmark) {
        let newList = Array(Set(getBookmarkList() + [item]))
        setBookmarkList(list: newList)
    }
    func removeBookmark(item: Product) {
        var currentList = getBookmarkList()
        currentList.removeAll(where: { $0.product == item })
        setBookmarkList(list: currentList)
    }
    func setBookmarkList(list: [Bookmark]) {
        do {
            let encodedData = try JSONEncoder().encode(list)
            let jsonObject = try JSONSerialization.jsonObject(with: encodedData)
            standard.set(jsonObject, forKey: key)
        } catch {
            return
        }
    }
}
