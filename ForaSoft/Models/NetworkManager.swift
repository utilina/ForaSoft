//
//  NetworkManager.swift
//  ForaSoft
//
//  Created by Анастасия Улитина on 30.11.2020.
//

import Foundation

struct NetworkManager {
    
    //base url for fetching albums
    private let albumURL = "https://itunes.apple.com/search?entity=album&term="
    private let songURL = "https://itunes.apple.com/lookup?entity=song&id="
    
    //Errors
    enum NetworkError: Error {
        case noDataAvilable
        case canNotProcessData
    }
    
    //fetch data from api to send it to VC
    func fetchData(album: String, completion: @escaping(Result<[Album], NetworkError>) -> Void) {
        //Create url, check it
        let completeURL = albumURL + album
        if let requestURL = URL(string: completeURL) {
            let session = URLSession(configuration: .default)
            let dataTask = session.dataTask(with: requestURL) { (data, response, error) in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
                // Check if there is a fetched data
                guard let jsonData = data else {
                    completion(.failure(.noDataAvilable))
                    return
                }
                do {
                    // Decode fetched data to Albums type
                    let decoder = JSONDecoder()
                    let decodedData = try decoder.decode(Albums.self, from: jsonData)
                    let albums = decodedData.results.sorted(by: { $0.collectionName < $1.collectionName })
                    //print(albums)
                    // Pass data
                    completion(.success(albums))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(.canNotProcessData))
                }
            }
            dataTask.resume()
        }
    }
    
    func fetchSongs(albumID: String, completion: @escaping(Result<[String], NetworkError>) -> Void) {
        //Create url, check it
        var songArray = [String]()
        let completeURL = songURL + albumID
        if let requestURL = URL(string: completeURL) {
            let session = URLSession(configuration: .default)
            let dataTask = session.dataTask(with: requestURL) { (data, response, error) in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
                guard let jsonData = data else {
                    completion(.failure(.noDataAvilable))
                    return
                }
                do {
                    //Decode fetched data to Songs type
                    let decoder = JSONDecoder()
                    let decodedData = try decoder.decode(Songs.self, from: jsonData)
                    let songs = decodedData.results
                    for result in songs {
                        if let songName = result.trackName {
                            songArray.append(songName)
                        }
                    }
                    completion(.success(songArray))
                } catch {
                    completion(.failure(.canNotProcessData))
                }
            }
            dataTask.resume()
        }
    }
    
    
}
