//
//  PasswordKeyBoard.swift
//  downloader
//
//  Created by LAP14812 on 29/07/2022.
//

import UIKit

class PasswordKeyBoard: UIView {
    lazy var keyBoardLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let width = (frame.width - 2*margin - 2*padding)/3
        let height = (frame.height*0.7 - 2*margin - 3*padding)/4
        layout.itemSize.width = min(width, height)
        layout.itemSize.height = min(width, height)
        return layout
    }()
    
    private lazy var keyBoard: UICollectionView = {
        let keyBoard = UICollectionView(frame: .zero, collectionViewLayout: keyBoardLayout)
        keyBoard.translatesAutoresizingMaskIntoConstraints = false
        keyBoard.isScrollEnabled = false
        keyBoard.delegate = self
        keyBoard.dataSource = self
        keyBoard.register(PasswordSignCell.self, forCellWithReuseIdentifier: PasswordSignCell.identifier)
        
        return keyBoard
    }()
    
    private let keys: [String] = ["1","2","3","4","5","6","7","8","9","cancel", "0" ,"remove"]

    var margin: CGFloat = 50
    var padding: CGFloat = 20
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(keyBoard)
        keyBoard.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        keyBoard.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        let width = keyBoardLayout.itemSize.width*3 + 3*padding
        let height = keyBoardLayout.itemSize.height*4  + 2*padding
        keyBoard.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        keyBoard.heightAnchor.constraint(equalToConstant: height).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configAutoConstraint(parent: UIView){
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
        bottomAnchor.constraint(equalTo: parent.bottomAnchor).isActive = true
        widthAnchor.constraint(equalTo: parent.widthAnchor).isActive = true
        heightAnchor.constraint(equalTo: parent.heightAnchor, multiplier: 0.7).isActive = true
    }
}

extension PasswordKeyBoard: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PasswordSignCell.identifier, for: indexPath) as! PasswordSignCell
        let content = keys[indexPath.row]
        switch(content){
        case "cancel":
            cell.setCell(content: content, type: .cancel)
        case "remove":
            cell.setCell(content: content, type: .remove)
        default:
            cell.setCell(content: content)
        }
        
        return cell
    }
}
