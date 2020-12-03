//
//  File.swift
//  ForaSoft
//
//  Created by Анастасия Улитина on 30.11.2020.
//

import Foundation

struct Albums: Decodable {
    let resultCount: Int
    let results: [Album]
}

struct Album: Decodable {
    let collectionId: Int
    let artistName: String
    let collectionName: String
    let artworkUrl100: String
    let trackCount: Int
    let releaseDate: String
}
