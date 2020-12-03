//
//  DetailsViewController.swift
//  ForaSoft
//
//  Created by Анастасия Улитина on 30.11.2020.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var albumTitle: UILabel!
    @IBOutlet weak var albumArtist: UILabel!
    @IBOutlet weak var albumYear: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private let networkManager = NetworkManager()
    
    var artist: String = ""
    var aTitle: String = ""
    var image: String = ""
    var aYear: String = ""
    
    private var albumIDString: String = ""
    
    var albumID: Int = 0 {
        didSet {
            albumIDString = String(albumID)
        }
    }
    
    var songList = [String]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        albumArtist.text = artist
        albumYear.text = String(aYear.prefix(4))
        albumTitle.text = aTitle
        songRequest()
        loadImage()
    }
    
    private func songRequest() {
        networkManager.fetchSongs(albumID: albumIDString) { [weak self] result in
            switch result {
            case .success(let songs):
                self?.songList = songs
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func loadImage() {
        let imageURL = URL(string: image)
        DispatchQueue.global().async {
            guard let url = imageURL, let imageData = try? Data(contentsOf: url) else { return }
            DispatchQueue.main.async {
                self.albumImage.image = UIImage(data: imageData)
            }
        }
    }
    
}


extension DetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.songCell, for: indexPath)
        
        DispatchQueue.main.async {
            cell.textLabel?.text = "\(indexPath.row + 1). " + self.songList[indexPath.row]
        }
        return cell
    }
    
}
