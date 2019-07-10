
//
//  File.swift
//  iTunesMedia
//
//  Created by Kaka on 7/10/19.
//  Copyright © 2019 Tiep Nguyen. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class MediaCell: UITableViewCell {
    let mediaImage = UIImageView()
    let mediaName = UILabel()
    let mediaType = UILabel()
    
    var media: Media? {
        didSet {
            guard let media = media else {
                return
            }
            mediaName.text = media.name
            mediaType.text = "Media type: \(media.kind)"
            mediaImage.sd_setImage(with: URL(string: media.imgUrl), completed: nil)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        mediaName.numberOfLines = 3
        mediaName.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        mediaImage.translatesAutoresizingMaskIntoConstraints = false
        mediaName.translatesAutoresizingMaskIntoConstraints = false
        mediaType.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(mediaImage)
        contentView.addSubview(mediaName)
        contentView.addSubview(mediaType)
        
        NSLayoutConstraint.activate([
            mediaImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            mediaImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            mediaImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            mediaImage.widthAnchor.constraint(equalTo: mediaImage.heightAnchor, multiplier: 1)
            ])
        
        NSLayoutConstraint.activate([
            mediaName.leadingAnchor.constraint(equalTo: mediaImage.trailingAnchor, constant: 10),
            mediaName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            mediaName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            ])
        
        NSLayoutConstraint.activate([
            mediaType.leadingAnchor.constraint(equalTo: mediaImage.trailingAnchor, constant: 10),
            mediaType.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            mediaType.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
            ])
    }
}
