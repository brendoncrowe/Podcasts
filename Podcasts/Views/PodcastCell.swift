//
//  PodcastCell.swift
//  Podcasts
//
//  Created by Brendon Crowe on 1/25/23.
//

import UIKit

class PodcastCell: UITableViewCell {
    
    @IBOutlet weak var podcastImage: UIImageView!
    @IBOutlet weak var collectionName: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        podcastImage.layer.cornerRadius = podcastImage.frame.width/9
    }
    
    func configurePodcastCell(for podcast: Podcast) {
        collectionName.text = podcast.collectionName
        artistNameLabel.text = podcast.artistName
        
        podcastImage.getImage(with: podcast.artworkUrl600) { [weak self] (result) in
            switch result{
            case .failure:
                DispatchQueue.main.async {
                    self?.podcastImage.image = UIImage(systemName: "exclamationmark.square")
                }
            case .success(let image):
                DispatchQueue.main.async {
                    self?.podcastImage.image = image
                }
            }
        }
    }
    
    func configureFavCell(for favoritePod: Podcast) {
        collectionName.text = favoritePod.collectionName
        
        podcastImage.getImage(with: favoritePod.artworkUrl600) { [weak self] (result) in
            switch result{
            case .failure:
                DispatchQueue.main.async {
                    self?.podcastImage.image = UIImage(systemName: "exclamationmark.square")
                }
            case .success(let image):
                DispatchQueue.main.async {
                    self?.podcastImage.image = image
                }
            }
        }
    }
}
