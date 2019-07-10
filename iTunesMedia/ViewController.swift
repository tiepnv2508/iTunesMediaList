//
//  ViewController.swift
//  iTunesMedia
//
//  Created by Kaka on 7/10/19.
//  Copyright © 2019 Tiep Nguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ItunesServices.shared.fetchItunesMedia(mediaType: .appleMusic) { (result) in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error.description)
            }
        }
    }
}

