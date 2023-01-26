//
//  PodcastDetailViewController.swift
//  Podcasts
//
//  Created by Brendon Crowe on 1/25/23.
//

import UIKit

class PodcastDetailController: UIViewController {
    
    
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var podcastImageView: UIImageView!
    @IBOutlet weak var collectionNameLabel: UILabel!
    
    var podcast: Podcast?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    func updateUI() {
        if let podcast = podcast {
            artistNameLabel.text = podcast.artistName
            collectionNameLabel.text = podcast.collectionName
            
            podcastImageView.getImage(with: podcast.artworkUrl600) { [weak self] result in
                switch result {
                case .failure(let appError):
                    DispatchQueue.main.async {
                        self?.podcastImageView.image = UIImage(systemName: "exclamationmark.triangle.fill")
                        print("Error loading image \(appError)")
                    }
                case .success(let image):
                    DispatchQueue.main.async {
                        self?.podcastImageView.image = image
                    }
                }
            }
        }
    }
}
