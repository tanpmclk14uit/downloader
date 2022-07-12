//
//  ContextMenuCell.swift
//  downloader
//
//  Created by LAP14812 on 12/07/2022.
//

import UIKit

class ContextMenuCell: UITableViewCell {
    
    private lazy var title: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.textColor = .black
        lable.font = UIFont.systemFont(ofSize: Dimen.itemNormalContentTextSize)
        return lable
    }()
    
    private func configTitleConstraint(){
        title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Dimen.cellItemMargin.top).isActive = true
        title.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Dimen.cellItemMargin.bottom).isActive = true
        title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Dimen.cellItemMargin.left).isActive = true
        title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Dimen.cellItemMargin.right).isActive = true
    }
    
    public static let identifier: String = "ContextMenuCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.addSubview(title)
        self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        configTitleConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setTitle(title: String){
        self.title.text = title
    }
    
}
