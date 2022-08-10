//
//  CustomImageViewController.swift
//  downloader
//
//  Created by LAP14812 on 08/08/2022.
//

import UIKit

class CustomImageViewController: UIViewController {
    
    //MARK: - Config UI Element
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var errorMessage: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.text = "This type of image is not supported!"
        lable.textColor = .gray
        lable.textAlignment = .center
        lable.numberOfLines = 2
        return lable
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setTitle("Close", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(onBackPress), for: .touchUpInside)
        return button
    }()

    // MARK: - Config UI Constraint
    private func configImageViewConstraint(){
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
       
        let width = view.frame.width
        let height = width / imageRatio
        imageView.widthAnchor.constraint(equalToConstant: width).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    //MARK: Set Up ViewController
    
    var imageRatio: CGFloat = 1.0
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpContentView()
    
        panDistance = view.frame.height/2
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeVisibilityOfAppBar)))
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(onUserPanToDissmiss)))
    }

    
    private func setUpContentView(){
        setUpAppBar()
        view.addSubview(imageView)
        configImageViewConstraint()
    }

    
    private func setUpAppBar(){
        let nav = self.navigationController?.navigationBar
            nav?.barStyle = UIBarStyle.black
            nav?.tintColor = UIColor.white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    func setImageDataByImageURL(_ url: URL){
        do{
            let image: UIImage?
            if(url.pathExtension == "gif"){
                image =  try UIImage.gifImageWithData(Data(contentsOf: url))
            }else{
                image = try UIImage(data: Data(contentsOf: url))
            }
            if let image = image {
                imageView.image = image
                self.imageRatio = image.size.width / image.size.height
            }
        }catch{
            imageView.isHidden = true
            view.addSubview(errorMessage)
            
            errorMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            errorMessage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        }
    }
    
    var viewTranslation = CGPoint(x: 0, y: 0)
    var panDistance: CGFloat = 0.0
    @objc private func onUserPanToDissmiss(sender: UIPanGestureRecognizer){
        switch sender.state {
        case .changed:
            viewTranslation = sender.translation(in: view)
            guard abs(viewTranslation.y) > 10 else {
                return
            }
            self.navigationController?.navigationBar.isHidden = true
            // set background alpha
            let backgroundAlpha = max( 1.0 - (abs(viewTranslation.y) / panDistance), 0.3)
            view.backgroundColor = view.backgroundColor?.withAlphaComponent(backgroundAlpha)
            
            // scale image
            let scale = max( 1.0 - (abs(viewTranslation.y) / panDistance), 0.5)
            let imageViewWidth = imageView.frame.width * scale
            let imageViewHeight = imageView.frame.height * scale
            let scaleX = imageViewWidth/imageView.frame.width
            let scaleY = imageViewHeight/imageView.frame.height
            
            self.imageView.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
            self.imageView.center = sender.location(in: view)
           
        case .ended:
            // quit animation, recover last state
            let scale = 1.0 - (abs(viewTranslation.y) / panDistance)
            if scale > 0.7 {
                self.navigationController?.navigationBar.isHidden = true
                view.backgroundColor = view.backgroundColor?.withAlphaComponent(1)
               
                UIView.animate(
                    withDuration: 0.5,
                    delay: 0,
                    usingSpringWithDamping: 1,
                    initialSpringVelocity: 0.5,
                    options: .curveEaseOut,
                    animations: {
                        self.imageView.transform = .identity
                        self.imageView.center = self.view.center
                    })
                
            } else  // dismiss
            {
                view.frame = imageView.frame
                view.center = imageView.center
                
                dismiss(animated: true, completion: nil)
            }
        default:
            break
        }
    }
    
    @objc private func changeVisibilityOfAppBar(){
        let nav = self.navigationController?.navigationBar
        if let nav = nav{
            nav.isHidden = !nav.isHidden
        }
    }

    @objc func onBackPress(){
        self.navigationController?.navigationBar.isHidden = true
        self.dismiss(animated: true)
    }
}
