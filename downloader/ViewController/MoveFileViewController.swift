//
//  MoveFileViewController.swift
//  downloader
//
//  Created by LAP14812 on 13/07/2022.
//

import UIKit

class MoveFileViewController: UIViewController {

    //MARK: - CONFIG UI
    lazy var titleName: UILabel = {
        let titleName = UILabel()
        titleName.translatesAutoresizingMaskIntoConstraints = false
        titleName.text = "Downloads"
        titleName.textColor = .black
        titleName.textAlignment = .center
        titleName.font = UIFont.boldSystemFont(ofSize: Dimen.screenTitleTextSize)
        return titleName
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: Dimen.screenNormalTextSize)
        button.addTarget(self, action: #selector(onCancelClick), for: .touchUpInside)
        return button
    }()
    
    lazy var moveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Move", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: Dimen.screenNormalTextSize)
        button.addTarget(self, action: #selector(onMoveClick), for: .touchUpInside)
        return button
    }()
    
    lazy var buttonAddFolder: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("New folder", for: .normal)
        button.sizeToFit()
        button.titleEdgeInsets.left = 10
        button.contentHorizontalAlignment = .left
        button.widthAnchor.constraint(equalToConstant: 150).isActive = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: Dimen.screenNormalTextSize)
        button.setImage(UIImage(named: "add-folder"), for: .normal)
        return button
    }()
    
    lazy var textGuide: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.textAlignment = .center
        lable.text = "Pick destination folder"
        lable.textColor = .gray
        lable.font = UIFont.systemFont(ofSize: Dimen.screenAdditionalInformationTextSize)
        return lable
    }()
    
    lazy var listLayout: MaintainOffsetFlowLayout = {
        let layout = MaintainOffsetFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize.width = view.frame.width-20
        layout.itemSize.height = 60
        return layout
    }()
    
    lazy var fileCollectionView: UICollectionView = {
        let fileCollectionView = UICollectionView(frame: .zero, collectionViewLayout: listLayout)
        fileCollectionView.translatesAutoresizingMaskIntoConstraints = false
        fileCollectionView.dataSource = self
        fileCollectionView.delegate = self
        fileCollectionView.register(FileItemViewCellByList.self, forCellWithReuseIdentifier: FileItemViewCellByList.identifier)
        return fileCollectionView
    }()
    
    lazy var backButton: UIButton = {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.widthAnchor.constraint(equalToConstant: Dimen.normalButtonWidth).isActive = true
        backButton.contentHorizontalAlignment = .left
        backButton.titleLabel?.lineBreakMode = .byTruncatingTail
        return backButton
    }()
    
    lazy var emptyMessage: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.textColor = .gray
        lable.numberOfLines = 2
        lable.textAlignment = .center
        lable.font = UIFont.systemFont(ofSize: Dimen.screenNormalTextSize)
        return lable
    }()
    
    
    //MARK: - CONFIG UI CONSTRAINT
    private func configTextGuideConstraint(){
        if #available(iOS 11.0, *) {
            textGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            textGuide.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Dimen.screenDefaultMargin.left).isActive = true
            textGuide.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: Dimen.screenDefaultMargin.right).isActive = true
        } else {
            textGuide.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            textGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Dimen.screenDefaultMargin.left).isActive = true
            textGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Dimen.screenDefaultMargin.right).isActive = true
        }
        textGuide.heightAnchor.constraint(equalToConstant: Dimen.getFontHeight(font: titleName.font)).isActive = true
    }
    
    private func configFileCollectionViewConstraint(){
        fileCollectionView.topAnchor.constraint(equalTo: textGuide.bottomAnchor, constant: Dimen.screenDefaultMargin.top).isActive = true
        if #available(iOS 11.0, *){
            fileCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Dimen.screenDefaultMargin.bottom).isActive = true
            fileCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Dimen.cellItemMargin.left).isActive = true
            fileCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: Dimen.screenDefaultMargin.right).isActive = true
        }else{
            fileCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Dimen.screenDefaultMargin.bottom).isActive = true
            fileCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Dimen.cellItemMargin.left).isActive = true
            fileCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Dimen.screenDefaultMargin.right).isActive = true
        }
    }
    
    //MARK: - SET VIEW CONTROLLER
    
    private let fileManager: DownloadFileManager = DownloadFileManager.sharedInstance()
    var currentFolder: FolderItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        fetchAllFileOfFolder()
        setHeader()
        
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cancelButton)
        navigationItem.titleView = titleName
        // set up tool bar
        navigationController?.isToolbarHidden = false
        toolbarItems = [UIBarButtonItem(customView: buttonAddFolder),UIBarButtonItem(customView: moveButton)]
        
        view.addSubview(textGuide)
        configTextGuideConstraint()
        view.addSubview(fileCollectionView)
        configFileCollectionViewConstraint()
        
        view.addSubview(emptyMessage)
        emptyMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyMessage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func fetchAllFileOfFolder(){
        DispatchQueue.global(qos: .utility).async { [weak self] in
            if let currentFolder = self?.currentFolder {
                self?.fileManager.fetchAllFile(ofFolder: currentFolder, withAfterCompleteHandler: {
                    DispatchQueue.main.async {
                        self?.reloadCollectionView()
                    }
                })
            }
        }
    }
    
    private func setHeader(){
        // add title view
        titleName.text = currentFolder!.name
        navigationItem.titleView = titleName
        
        if(currentFolder!.isRootFolder){
            navigationItem.leftBarButtonItem = nil
        }else{
            backButton.setTitle(currentFolder!.directParentName, for: .normal)
            
            backButton.addTarget(self, action: #selector(onBackButtonClick), for: .touchUpInside)
            let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(onBackButtonLongClick))
            
            backButton.addGestureRecognizer(longPressGesture)
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        }
    }
    
    private func setEmptyListMessage(){
        if(currentFolder!.allFileItems.count == 0){
                emptyMessage.text = "Your folder is empty!"
        }else{
            emptyMessage.text = nil
        }
    }
    
    @objc private func onBackButtonClick(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func onBackButtonLongClick(sender: UILongPressGestureRecognizer){
        if(sender.state == UIGestureRecognizer.State.began){
            
        }
    }
    
    @objc private func onCancelClick(){
        self.dismiss(animated: true)
    }
    
    @objc private func onMoveClick(){
        print("move")
    }
}

//MARK: - CONFIRM UI COLLECTION VIEW DELEGAE, DATASOURCE
extension MoveFileViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentFolder!.allFileItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FileItemViewCellByList.identifier, for: indexPath) as! FileItemViewCellByList
        cell.setCellData(fileItem: currentFolder!.allFileItems[indexPath.row] as! FileItem)
        cell.hideItemAction()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentSelectedItem = currentFolder!.allFileItems[indexPath.item] as! FileItem
        if(currentSelectedItem.isDir){
            let moveFileVC = MoveFileViewController()
            let folderItem = currentSelectedItem as! FolderItem
            moveFileVC.currentFolder = folderItem
            
            navigationController?.pushViewController(moveFileVC, animated: true)
        }
    }
    
    func reloadCollectionView(){
        self.fileCollectionView.reloadData()
        setEmptyListMessage()
    }
    
}
