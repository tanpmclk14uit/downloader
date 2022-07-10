//
//  ImageViewController.swift
//  downloader
//
//  Created by LAP14812 on 08/07/2022.
//

import UIKit

class ImageViewController: UIViewController {
    
    //MARK: - Config ui element
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let errorMessage: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.text = "This type of image is not supported!"
        lable.textColor = .gray
        lable.textAlignment = .center
        lable.numberOfLines = 2
        return lable
    }()
    private func configImageViewConstraint(){
        if #available(iOS 11.0, *) {
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        } else {
            // Fallback on earlier versions
            imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        }
    }
    
    //MARK: Define ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(imageView)
        configImageViewConstraint()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(onBackPress))
    }
    
    func setImageDataByImageURL(_ url: URL){
        do{
            if(url.pathExtension == "gif"){
                imageView.image = try UIImage.gifImageWithData(Data(contentsOf: url))
            }else{
                imageView.image = try UIImage(data: Data(contentsOf: url))
            }
        }catch{
            imageView.isHidden = true
            view.addSubview(errorMessage)
            
            errorMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            errorMessage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        }
    }
    
    @objc func onBackPress(){
        self.dismiss(animated: true)
    }
    
}
