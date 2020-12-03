//
//  Song.swift
//  ForaSoft
//
//  Created by Анастасия Улитина on 02.12.2020.
//

import Foundation

struct Songs: Decodable {
    let results: [Song]
}

struct Song: Decodable {
    let trackCount: Int?
    let trackName: String?
}
