//
//  TopBarContainer.swift
//  downloader
//
//  Created by LAP14812 on 20/07/2022.
//

import UIKit

class TopBarContainer: UIView {
    lazy var titleName: UILabel = {
        let titleName = UILabel()
        titleName.translatesAutoresizingMaskIntoConstraints = false
        titleName.text = "More"
        titleName.textAlignment = .center
        titleName.textColor = .black
        titleName.font = UIFont.boldSystemFont(ofSize: DimenResource.screenTitleTextSize)
        return titleName
    }()
    
    lazy var backButton: UIButton = {
        let backButton = UIButton(type: .system)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setTitle("Back", for: .normal)
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.contentHorizontalAlignment = .left
        backButton.titleLabel?.lineBreakMode = .byTruncatingTail
        return backButton
    }()
    
    private func configTitleNameConstraint(){
        titleName.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        titleName.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 15).isActive = true
        titleName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: DimenResource.defaultBackButtonWidth + DimenResource.screenDefaultMargin.left).isActive = true
        titleName.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -DimenResource.defaultBackButtonWidth).isActive = true
        titleName.heightAnchor.constraint(equalToConstant: DimenResource.getFontHeight(font: titleName.font)).isActive = true
    }
    
    private func configBackButtonConstraint(){
        backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: DimenResource.screenDefaultMargin.left).isActive = true
        backButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 15).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: DimenResource.defaultBackButtonWidth).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: DimenResource.getFontHeight(font: (backButton.titleLabel?.font)!)).isActive = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
        self.addSubview(titleName)
        configTitleNameConstraint()
        
        
    }
    
    private var onBackButtonClickListener: (()->Void)?
    
    func enableBackButton(onBackButtonClickListener: @escaping () -> Void){
        self.addSubview(backButton)
        configBackButtonConstraint()
        self.onBackButtonClickListener = onBackButtonClickListener
        backButton.addTarget(self, action: #selector(onBackButtonClick), for: .touchUpInside)
    }
    
    @objc private func onBackButtonClick(){
        onBackButtonClickListener?()
    }
    
    
    
    func configAutoLayoutConstraint(parent: UIView){
        self.topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
        self.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
        self.widthAnchor.constraint(equalTo: parent.widthAnchor).isActive = true
        self.heightAnchor.constraint(equalTo: parent.heightAnchor, multiplier: 0.1).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitleName(name: String){
        titleName.text = name
    }
    
}
