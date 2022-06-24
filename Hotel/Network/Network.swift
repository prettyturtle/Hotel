//
//  API.swift
//  Hotel
//
//  Created by yc on 2022/06/24.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestError
    case jsonError
    case unknown
}

struct Network {
    
    /// 숙소 정보 API를 이용하여 숙소 정보 리스트(`[Product]`)를 completion으로 전달하는 메서드
    func get(page: Int, completion: @escaping (Result<[Product], NetworkError>) -> Void) {
        let urlString = "https://www.gccompany.co.kr/App/json/\(page).json"
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(.failure(.requestError))
                return
            }
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                completion(.failure(.requestError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.unknown))
                return
            }
            
            do {
                let hotelInfo = try JSONDecoder().decode(HotelInfo.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(hotelInfo.data.product))
                }
            } catch {
                completion(.failure(.jsonError))
            }
        }.resume()
    }
}
