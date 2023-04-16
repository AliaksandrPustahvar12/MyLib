//
//  ServiceApi.swift
//  MyLib
//
//  Created by Aliaksandr Pustahvar on 14.04.23.
//

import Foundation
import UIKit

class ServiceApi {
    
    let urlString = "https://openlibrary.org/search.json?q=miss+marple"
    
    func getBooks(completion: @escaping(Books) -> ()) {
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data else { return }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            if let booksData = try? decoder.decode(Books.self, from: data) {
                completion(booksData)
            }
            else {
                print("Fail")
            }
        }
        task.resume()
    }
    
    func getImage(id: Int, callback: @escaping((UIImage?) -> Void)){
        guard let url = URL(string: "https://covers.openlibrary.org/b/id/\(id)-M.jpg") else {
            callback(nil)
            return
        }
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url)
                if let coverImage = UIImage(data: data) {
                    callback(coverImage)
                }
            }
            catch {
                callback(nil)
                print( "Error!")
            }
        }
    }
}

