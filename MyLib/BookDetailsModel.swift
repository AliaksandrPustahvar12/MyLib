//
//  BookDetailsModel.swift
//  MyLib
//
//  Created by Aliaksandr Pustahvar on 17.04.23.
//

import Foundation

struct BookDetails: Decodable {
    let title: String
    let description: Description?
}

struct Description: Decodable {
    let value: String?
}

struct BookDetailsShort: Decodable {
    let description: String?
}
