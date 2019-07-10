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
    private var toolBar = UIToolbar()
    private var picker  = UIPickerView()
    
    private var mediaTypes:[(name: String, type: MediaType)] = [
        ("Apple Music", .appleMusic),
        ("iTunes Music", .itunesMusic),
        ("iOS Apps", .iosApps),
        ("Audio Books", .audiobooks),
        ("Books", .books),
        ("TV Shows", .tvShows),
        ("Movies", .movies),
        ("iTunesU", .itunesU),
        ("Podcasts", .podcasts),
        ("Music Videos", .musicVideos)
    ]
    
    private var tmpType = MediaType.appleMusic
    private var pickerIndex = 0
    private var currentType = MediaType.appleMusic {
        didSet {
            loadData()
        }
    }
    
    private var medias = [Media]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupUI()
        loadData()
        setupTableView()
    }
    
    // MARK: -  Setup UI
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
    
    private func setupNavBar() {
        let rightBarButton = UIBarButtonItem(title: "MediaType", style: .done, target: self, action: #selector(changeMediaType))
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    // MARK: -  Handle Media Type changed
    @objc func changeMediaType() {
        createMediaTypePicker()
        createPickerToolBar()
    }
    
    @objc func onDoneButtonTapped() {
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
        
        // update Media Type
        currentType = tmpType
    }
    
    // MARK: -  create Media Type Picer
    private func createMediaTypePicker() {
        picker = UIPickerView.init()
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = UIColor.white
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        self.view.addSubview(picker)
        picker.selectRow(pickerIndex, inComponent: 0, animated: true)
    }
    
    private func createPickerToolBar() {
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .blackTranslucent
        toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
        self.view.addSubview(toolBar)
    }
    
    // MARK: -  UITableViewDataSource & Delegate
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
    
    // MARK: -  Config Loading Indicator
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
    
    // MARK: -  Load data from Service
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

extension MediaListViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return mediaTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return mediaTypes[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tmpType = mediaTypes[row].type
        pickerIndex = row
    }
}
