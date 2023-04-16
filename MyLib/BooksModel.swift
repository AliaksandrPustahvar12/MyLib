//
//  BooksModel.swift
//  MyLib
//
//  Created by Aliaksandr Pustahvar on 14.04.23.
//

import Foundation

struct Books: Decodable {
    var docs: [Book]
}

struct Book: Decodable {
    var title: String
    var firstPublishYear: Int?
    var coverI: Int?
    var authorName: [String]?
}
