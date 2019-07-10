//
//  MediaListViewController.swift
//  iTunesMedia
//
//  Created by Kaka on 7/10/19.
//  Copyright © 2019 Tiep Nguyen. All rights reserved.
//

import Foundation
import UIKit

class MediaListViewController: UITableViewController {
    private let mediaCellReuseId = "MediaCellReuseId"
    weak var activityIndicator: UIActivityIndicatorView!
    
    private var currentType = MediaType.appleMusic
    
    private var medias = [Media]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
        setupTableView()
    }
    
    private func setupUI() {
        self.title = "Itunes Media"
        
        //Loading Indicator
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(activityIndicator)
        self.activityIndicator = activityIndicator
        
        NSLayoutConstraint.activate([
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            ])
        
        // Configure Refresh Control
        tableView.refreshControl = UIRefreshControl()
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .white
        tableView.register(MediaCell.self, forCellReuseIdentifier: mediaCellReuseId)
        tableView.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medias.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: mediaCellReuseId) as? MediaCell
        if cell == nil {
            cell = MediaCell(style: .default, reuseIdentifier: mediaCellReuseId)
        }
        cell?.media = medias[indexPath.row]
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if tableView.refreshControl!.isRefreshing {
            loadData()
        }
    }
    
    private func displayLoading() {
        if !tableView.refreshControl!.isRefreshing {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        }
    }
    
    private func stopLoading() {
        if activityIndicator.isAnimating {
            activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
        }
        if tableView.refreshControl!.isRefreshing {
            tableView.refreshControl?.endRefreshing()
        }
    }
    
    private func loadData() {
        displayLoading()
        ItunesServices.shared.fetchItunesMedia(mediaType: currentType) { [weak self](result) in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let data):
                strongSelf.medias = data.results
                strongSelf.stopLoading()
            case .failure(let error):
                strongSelf.stopLoading()
                strongSelf.showError("Oopssssss!!!", message: error.description)
            }
        }
    }
}
