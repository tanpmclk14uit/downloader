//
//  PasswordSignCell.swift
//  downloader
//
//  Created by LAP14812 on 29/07/2022.
//

import UIKit

class PasswordSignCell: UICollectionViewCell {
    
    private lazy var signButton: PasscodeSignButton = {
        let button = PasscodeSignButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.borderColor = .black
        button.highlightBackgroundColor = ColorResource.darkGray!
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitleColor(UIColor.white, for: .highlighted)
        return button
    }()
    
    public static let identifier: String = "PasswordSignCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(signButton)
        
        signButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        signButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        signButton.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        signButton.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        signButton.borderRadius = contentView.frame.height/2
    }
    
    func setCell(content: String, type: SignCellType = SignCellType.number){
        switch(type){
        case .number:
            signButton.setTitle(content, for: .normal)
        case .cancel:
            signButton.setTitle("Cancel", for: .normal)
        case .remove:
            signButton.setImage(UIImage(named: "remove"), for: .normal)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
