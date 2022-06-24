//
//  ImageLoader.swift
//  Hotel
//
//  Created by yc on 2022/06/24.
//

import UIKit

enum ImageLoaderError: Error {
    case invalidURL
    case unknown
}

struct ImageLoader {
    
    /// 사진의 URL
    let urlString: String
    
    /// 사진의 URL을 통해 UIImage를 completion으로 전달하는 메서드
    func getImage(completion: @escaping (Result<UIImage, ImageLoaderError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil,
                  (response as? HTTPURLResponse)?.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data) else {
                completion(.failure(.unknown))
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(image))
            }
        }.resume()
    }
}
