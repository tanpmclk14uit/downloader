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
        lable.font = UIFont.systemFont(ofSize: DimenResource.screenAdditionalInformationTextSize)
        return lable
    }()
    
    private lazy var enableActionButton: UISwitch = {
        let button = UISwitch()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button;
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        
        addSubview(leadingImageView)
        configLeadingImageConstraint()
        
        addSubview(content)
        configContentConstraint()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLeadingImage(leading: UIImage?){
        if(leading == nil){
            leadingImageView.widthAnchor.constraint(equalToConstant: 0).isActive = true
        }else{
            leadingImageView.image = leading
        }
    }
    
    func buildAsSwitchButton() -> MoreSettingActionItem{
        self.addSubview(enableActionButton)
        self.configSwitchEnableButtonConstraint()
        enableActionButton.addTarget(self, action: #selector(onChangeSwitchButton), for: .valueChanged)
        return self;
    }
    
    func buildAsActionButton() -> MoreSettingActionItem{
        self.addSubview(trailingImageView)
        self.configTrailingImageConstraint()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onClick))
        addGestureRecognizer(tapGesture)
        return self;
    }
    
    func setContent(content: String){
        self.content.text = content
    }
    
    private var switchHandler: ((_ sender: UISwitch) -> Void)?
    private var clickHandler: (() -> Void)?
    
    func setOnClickListener(clickHandler: @escaping () -> Void){
        self.clickHandler = clickHandler
    }
    
    func setOnSwitchListener(switchHandler: @escaping (_ sender: UISwitch)-> Void){
        self.switchHandler = switchHandler
    }
    
    @objc private func onChangeSwitchButton(sender: UISwitch){
        switchHandler?(sender)
    }
    
    @objc private func onClick(){
        clickHandler?()
    }
    
    private func configContentConstraint(){
        content.leadingAnchor.constraint(equalTo: leadingImageView.trailingAnchor, constant: DimenResource.screenDefaultMargin.left).isActive = true
        content.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        content.heightAnchor.constraint(equalToConstant: DimenResource.getFontHeight(font: content.font)).isActive = true
        content.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
    }
    
    func configAutoConstraint(parent: UIView, top: UIView, constant: CGFloat = DimenResource.screenDefaultMargin.top){
        self.topAnchor.constraint(equalTo: top.bottomAnchor, constant: constant).isActive = true
        self.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
        self.widthAnchor.constraint(equalTo: parent.widthAnchor).isActive = true
        self.heightAnchor.constraint(equalToConstant: DimenResource.moreSettingContainerHeight).isActive = true
    }
    
    private func configLeadingImageConstraint(){
        leadingImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: DimenResource.screenDefaultMargin.left).isActive = true
        leadingImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        leadingImageView.heightAnchor.constraint(equalToConstant: DimenResource.buttonIconHeight).isActive = true
        leadingImageView.widthAnchor.constraint(equalToConstant: DimenResource.buttonIconWidth).isActive = true
    }
    
    private func configTrailingImageConstraint(){
        trailingImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: DimenResource.screenDefaultMargin.right).isActive = true
        trailingImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        trailingImageView.heightAnchor.constraint(equalToConstant: DimenResource.buttonIconHeight).isActive = true
        trailingImageView.widthAnchor.constraint(equalToConstant: DimenResource.buttonIconWidth).isActive = true
    }
    
    private func configSwitchEnableButtonConstraint(){
        enableActionButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: DimenResource.screenDefaultMargin.right).isActive = true
        enableActionButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        enableActionButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        enableActionButton.widthAnchor.constraint(equalToConstant: 55).isActive = true
    }

}
