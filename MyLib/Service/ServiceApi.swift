//
//  ServiceApi.swift
//  MyLib
//
//  Created by Aliaksandr Pustahvar on 14.04.23.
//

import Foundation
import UIKit

class ServiceApi {
    func getBooks(completion: @escaping(Books?) -> Void) {
        let urlString = "https://openlibrary.org/search.json?q=miss+marple"
        guard let url = URL(string: urlString) else {
            completion(nil)
            print("Wrong URL")
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, _, _ in
            do {
                guard let data else {
                    completion(nil)
                    print("No data")
                    return
                }
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let booksData = try decoder.decode(Books.self, from: data)
                completion(booksData)
            } catch {
                completion(nil)
                print("Parsing error")
            }
        }
        task.resume()
    }
    func getImage(id: Int, callback: @escaping((UIImage?) -> Void)) {
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
            } catch {
                callback(nil)
                print( "Error parsing cover! url: \(url)")
            }
        }
    }
    func getBookDescription(id: String, completion: @escaping(BookDetails?) -> Void) {
        guard let url = URL(string: "https://openlibrary.org\(id).json") else {
            completion(nil)
            print("Wrong URL")
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, _, _ in
            do {
                guard let data else {
                    completion(nil)
                    print("No data")
                    return
                }
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let details = try decoder.decode(BookDetails.self, from: data)
                completion(details)
            } catch {
                completion(nil)
                print("Parsing error")
            }
        }
        task.resume()
    }
    func getBookDescriptionShort(id: String, completion: @escaping(BookDetailsShort?) -> Void) {
        guard let url = URL(string: "https://openlibrary.org\(id).json") else {
            completion(nil)
            print("Wrong URL")
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, _, _ in
            do {
                guard let data else {
                    completion(nil)
                    print("No data")
                    return
                }
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let details = try decoder.decode(BookDetailsShort.self, from: data)
                completion(details)
            } catch {
                completion(nil)
                print("Parsing error")
            }
        }
        task.resume()
    }
}
