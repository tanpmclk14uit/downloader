//
//  ViewController.swift
//  downloader
//
//  Created by LAP14812 on 07/06/2022.
//

import UIKit

class MainViewController: UIViewController {
    
    lazy var helloWorld: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.text = "Hello world"
        lable.textColor = .black
        lable.font = UIFont.systemFont(ofSize: 20)
        return lable
    }()
    lazy var helloWorldUIButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        var config = UIButton.Configuration.filled()
        config.title = "Hello word"
        button.configuration = config
        return button
    }()
    
    lazy var mainController = MainController(message: "hello")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.addArrangedSubview(helloWorld)
        stackView.addArrangedSubview(helloWorldUIButton)
        view.addSubview(stackView)
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        helloWorldUIButton.addTarget(self, action: #selector(didTapHelloButton), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    @objc private func didTapHelloButton(){
        mainController.print()
    }
}

