//
//  MoreSettingCellItem.swift
//  downloader
//
//  Created by LAP14812 on 19/07/2022.
//

import UIKit

class MoreSettingActionItem: UIView {
    
    
    private lazy var leadingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var trailingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "forward")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var content: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.text = "Content"
        lable.textAlignment = .left
        lable.font = UIFont.systemFont(ofSize: Dimen.screenAdditionalInformationTextSize)
        return lable
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        
        addSubview(leadingImageView)
        configLeadingImageConstraint()
        
        addSubview(content)
        configContentConstraint()
        
        addSubview(trailingImageView)
        configTrailingImageConstraint()
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLeadingImage(leading: UIImage?){
        leadingImageView.image = leading
    }
    
    func setHasTrailingIcon(_ hasTrailingIcon: Bool){
        if(hasTrailingIcon){
            addSubview(trailingImageView)
            configTrailingImageConstraint()
        }else{
            trailingImageView.removeFromSuperview()
        }
    }
    
    func setContent(content: String){
        self.content.text = content
    }
    
    private func configContentConstraint(){
        content.leadingAnchor.constraint(equalTo: leadingImageView.trailingAnchor, constant: Dimen.screenDefaultMargin.left).isActive = true
        content.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        content.heightAnchor.constraint(equalToConstant: Dimen.getFontHeight(font: content.font)).isActive = true
        content.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
    }
    
    func configAutoConstraint(parent: UIView, top: UIView){
        self.topAnchor.constraint(equalTo: top.bottomAnchor, constant: Dimen.screenDefaultMargin.top).isActive = true
        self.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
        self.widthAnchor.constraint(equalTo: parent.widthAnchor).isActive = true
        self.heightAnchor.constraint(equalToConstant: Dimen.moreSettingContainerHeight).isActive = true
    }
    
    private func configLeadingImageConstraint(){
        leadingImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Dimen.screenDefaultMargin.left).isActive = true
        leadingImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        leadingImageView.heightAnchor.constraint(equalToConstant: Dimen.buttonIconHeight).isActive = true
        leadingImageView.widthAnchor.constraint(equalToConstant: Dimen.buttonIconWidth).isActive = true
    }
    
    private func configTrailingImageConstraint(){
        trailingImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: Dimen.screenDefaultMargin.right).isActive = true
        trailingImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        trailingImageView.heightAnchor.constraint(equalToConstant: Dimen.buttonIconHeight).isActive = true
        trailingImageView.widthAnchor.constraint(equalToConstant: Dimen.buttonIconWidth).isActive = true
    }

}
