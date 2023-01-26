//
//  ViewController.swift
//  Podcasts
//
//  Created by Brendon Crowe on 1/25/23.
//

import UIKit

class PodcastSearchController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchQuery = "" {
        didSet {
            DispatchQueue.main.async {
                self.loadPodcasts()
            }
        }
    }
    
    var podcasts = [Podcast]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configVC()
    }

    private func configVC() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "PodcastCell", bundle: nil), forCellReuseIdentifier: "podcastCell")
        searchBar.delegate = self
    }
    
    func loadPodcasts() {
        PodcastAPIClient.getPodcasts(searchQuery: searchQuery) { [weak self] result in
            switch result {
            case .failure:
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error", message: "Could not load podcasts")
                }
            case .success(let podcasts):
                self?.podcasts = podcasts
            }
        }
    }

}

extension PodcastSearchController: UITableViewDataSource, UISearchBarDelegate, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "podcastCell", for: indexPath) as? PodcastCell else {
            fatalError("could not dequeue a podcast cell")
        }
        let podcast = podcasts[indexPath.row]
        cell.configurePodcastCell(for: podcast)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
        }
    }
    
    // 1. get an instance of PodcastDetailController
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailController = storyboard?.instantiateViewController(withIdentifier: "PodcastDetailController") as? PodcastDetailController else {
            fatalError("could not load PodcastDetailController ")
        }
        // 2.get selected item, podcast
        let podcast = podcasts[indexPath.row]
        detailController.podcast = podcast
        // present the detail controller via push
        navigationController?.pushViewController(detailController, animated: true)
    }
        
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        guard let searchText = searchBar.text else {
            return
        }
        guard !searchText.isEmpty else {
            loadPodcasts()
            return
        }
        searchQuery = searchText.lowercased().addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "error"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
}
