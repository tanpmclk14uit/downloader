//
//  ViewController.swift
//  downloader
//
//  Created by LAP14812 on 07/06/2022.
//

import UIKit

class ViewController: UIViewController {

    lazy var helloWorld: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.text = "Hello world"
        lable.textColor = .black
        lable.font = UIFont.systemFont(ofSize: 20)
        return lable
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(helloWorld)
        helloWorld.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        helloWorld.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        // Do any additional setup after loading the view.
    }
}

