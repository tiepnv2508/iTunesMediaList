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
    
    private func loadData() {
        ItunesServices.shared.fetchItunesMedia(mediaType: currentType) { [weak self](result) in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let data):
                strongSelf.medias = data.results
            case .failure(let error):
                strongSelf.showError("Oopssssss!!!", message: error.description)
            }
        }
    }
}
