//
//  AlbumViewController.swift
//  ForaSoft
//
//  Created by Анастасия Улитина on 30.11.2020.
//

import UIKit

class AlbumViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private let itemPerRow: CGFloat = 3
    private let sectionInserts = UIEdgeInsets(top: 20, left: 19, bottom: 20, right: 19)
    
    let networkManager = NetworkManager()
    
    var albumArray = [Album]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
    }
}

//MARK: - CollectionView methods

extension AlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // Data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.albumCell , for: indexPath) as! AlbumCell
        if albumArray.count > 0 {
            let album = albumArray[indexPath.row]
            let imageURL = URL(string: album.artworkUrl100)
            DispatchQueue.global().async {
                guard let url = imageURL, let imageData = try? Data(contentsOf: url) else { return }
                DispatchQueue.main.async {
                    
                    cell.imageView.image = UIImage(data: imageData)
                    cell.layer.cornerRadius = cell.frame.height / 10
                    //tableView.reloadData()
                }
            }
            return cell
        }
        return cell
    }
    // Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: Segue.goToDetails, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.goToDetails {
            if let destinationVC = segue.destination as? DetailsViewController {
                if let index = collectionView.indexPathsForSelectedItems?.first {
                    let album = albumArray[index.row]
                    destinationVC.artist = album.artistName
                    destinationVC.aTitle = album.collectionName
                    destinationVC.aYear = album.releaseDate
                    destinationVC.image = album.artworkUrl100
                    destinationVC.albumID = album.collectionId
                }
            }
        }
    }
    
    
}
//MARK: - Search bar delegate methods
extension AlbumViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let album = searchBar.text {
            let encodeURL = album.replacingOccurrences(of: " ", with: "+")
            print(encodeURL)
            networkManager.fetchData(album: encodeURL) { [weak self] result in
                switch result {
                case .success(let anime):
                    self?.albumArray = anime
                case .failure(let error):
                    print(error)
                }
            }
        }
        DispatchQueue.main.async {
            self.collectionView.setContentOffset(CGPoint(x:0,y:0), animated: true)
            searchBar.resignFirstResponder()
        }
        
    }
}


//MARK: - Collection view flow layout methods

extension AlbumViewController: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingWith = sectionInserts.top * (itemPerRow + 1)
        let availableWidth = collectionView.bounds.width - paddingWith
        let widthPerItem = availableWidth / itemPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInserts
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }
    
}
