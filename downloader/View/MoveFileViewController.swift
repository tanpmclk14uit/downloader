//
//  MoveFileViewController.swift
//  downloader
//
//  Created by LAP14812 on 13/07/2022.
//

import UIKit

protocol MoveFileDelegate {
    func onMoveFileSuccess();
}

class MoveFileViewController: UIViewController {

    //MARK: - CONFIG UI
    lazy var titleName: UILabel = {
        let titleName = UILabel()
        titleName.translatesAutoresizingMaskIntoConstraints = false
        titleName.text = FolderItem.rootFolder().name
        titleName.textColor = .black
        titleName.textAlignment = .center
        titleName.font = UIFont.boldSystemFont(ofSize: DimenResource.screenTitleTextSize)
        return titleName
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: DimenResource.screenNormalTextSize)
        button.addTarget(self, action: #selector(onCancelClick), for: .touchUpInside)
        return button
    }()
    
    lazy var moveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Move", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: DimenResource.screenNormalTextSize)
        button.addTarget(self, action: #selector(onMoveClick), for: .touchUpInside)
        return button
    }()
    
    lazy var addFolder: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("New folder", for: .normal)
        button.sizeToFit()
        button.titleEdgeInsets.left = 10
        button.contentHorizontalAlignment = .left
        button.widthAnchor.constraint(equalToConstant: 150).isActive = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: DimenResource.screenNormalTextSize)
        button.setImage(UIImage(named: "add-folder"), for: .normal)
        return button
    }()
    
    lazy var textGuide: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.textAlignment = .center
        lable.textColor = .gray
        lable.font = UIFont.systemFont(ofSize: DimenResource.screenAdditionalInformationTextSize)
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
        fileCollectionView.layer.backgroundColor = ColorResource.white?.cgColor
        fileCollectionView.register(FileItemViewCellByList.self, forCellWithReuseIdentifier: FileItemViewCellByList.identifier)
        return fileCollectionView
    }()
    
    lazy var backButton: UIButton = {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.widthAnchor.constraint(equalToConstant: DimenResource.normalButtonWidth).isActive = true
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
        lable.font = UIFont.systemFont(ofSize: DimenResource.screenNormalTextSize)
        return lable
    }()
    
    
    //MARK: - CONFIG UI CONSTRAINT
    private func configTextGuideConstraint(){
        if #available(iOS 11.0, *) {
            textGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            textGuide.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        } else {
            textGuide.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            textGuide.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        }
        textGuide.heightAnchor.constraint(equalToConstant: DimenResource.getFontHeight(font: titleName.font)).isActive = true
        textGuide.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        
    }
    
    private func configFileCollectionViewConstraint(){
        fileCollectionView.topAnchor.constraint(equalTo: textGuide.bottomAnchor, constant: DimenResource.screenDefaultMargin.top).isActive = true
        if #available(iOS 11.0, *){
            fileCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: DimenResource.screenDefaultMargin.bottom).isActive = true
            fileCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: DimenResource.cellItemMargin.left).isActive = true
            fileCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: DimenResource.screenDefaultMargin.right).isActive = true
        }else{
            fileCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: DimenResource.screenDefaultMargin.bottom).isActive = true
            fileCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DimenResource.cellItemMargin.left).isActive = true
            fileCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: DimenResource.screenDefaultMargin.right).isActive = true
        }
    }
    
    //MARK: - SET VIEW CONTROLLER
    
    private let fileManager: DownloadFileManager = DownloadFileManager.sharedInstance()
    public var currentFolder: FolderItem?
    public var sourceFile: FileItem?
    var delegate: MoveFileDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cancelButton)
        navigationItem.titleView = titleName
        // set up tool bar
        navigationController?.isToolbarHidden = false
        toolbarItems = [UIBarButtonItem(customView: addFolder),UIBarButtonItem(customView: moveButton)]
        
        view.addSubview(textGuide)
        configTextGuideConstraint()
        view.addSubview(fileCollectionView)
        configFileCollectionViewConstraint()
        
        view.addSubview(emptyMessage)
        emptyMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyMessage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        addFolder.addTarget(self, action: #selector(showCreateFolderAlert), for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchAllFileOfFolder()
        setHeader()
        setMoveButton()
    }
    
    private func getCurrentFileItemSoryByDateASC()-> [FileItem]{
        // get all original list
        var fileItems = currentFolder!.getFileItems()
        // sort
        fileItems.sort { hls, fls in
            hls.createdDate > fls.createdDate
        }
        
        return fileItems
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
        textGuide.text = "Pick destination folder for \(sourceFile!.name)"
        
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
    
    private func setMoveButton(){
        if let currentFolder = currentFolder,
           let sourceFile = sourceFile{
            if(fileManager.canMove(sourceFile, to: currentFolder)){
                moveButton.isEnabled = true
            }else{
                moveButton.isEnabled = false
            }
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
            
            let contextMenuVC = CustomContextMenuViewController()
            contextMenuVC.modalPresentationStyle = .overCurrentContext
            contextMenuVC.contents = currentFolder!.getNamesOfParentFolder()
            contextMenuVC.delegate = self
            
            present(contextMenuVC, animated: false)
        }
    }
    
    @objc private func onCancelClick(){
        self.dismiss(animated: true)
    }
    
    @objc private func onMoveClick(){
        if(fileManager.moveFile(sourceFile!, toFolder: currentFolder!)){
           
            self.dismiss(animated: true)
            delegate?.onMoveFileSuccess()
        }else{
            showErrorNotification(message: "Move file failed!")
        }
    }
    
    @objc private func showCreateFolderAlert(){
        let alert = UIAlertController(
            title: "Create folder", message: "Please enter folder name", preferredStyle: .alert
        )
        alert.addTextField{ field in
            field.placeholder = "example"
            field.returnKeyType = .done
            field.keyboardType = .default
        }
        // add action to alert
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let alertFieldCount = 1;
        let createAction = UIAlertAction(title: "Create", style: .default, handler: { [weak self] _ in
            if let fields = alert.textFields, fields.count == alertFieldCount {
                if let self = self {
                    if let folderName = fields[0].text, !fields[0].text!.isEmpty {
                        if(self.fileManager.isExitsFolderName(folderName, inFolder: self.currentFolder!.url)){
                            self.showErrorNotification(message: "Folder name is exist!")
                        }else{
                            if(self.fileManager.createNewFolder(folderName, inFolder: self.currentFolder!)){
                                self.fetchAllFileOfFolder()
                            }else{
                                self.showErrorNotification(message: "Create folder fail!")
                            }
                        }
                    }else{
                        self.showErrorNotification(message: "Folder name can not place empty!")
                    }
                }
            }
        })
        alert.addAction(cancelAction)
        alert.addAction(createAction)
        alert.preferredAction = createAction
        
        present(alert, animated: true)
    }
    
    private func showErrorNotification(message: String){
        let emptyURLNotification = UIAlertController.notificationAlert(type: NotificationAlertType.Error, message: message)
        present(emptyURLNotification, animated: true)
    }
}

//MARK: - CONFIRM UI COLLECTION VIEW DELEGAE, DATASOURCE
extension MoveFileViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getCurrentFileItemSoryByDateASC().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FileItemViewCellByList.identifier, for: indexPath) as! FileItemViewCellByList
        cell.setCellData(fileItem: getCurrentFileItemSoryByDateASC()[indexPath.row] )
        cell.hideItemAction()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentSelectedItem = getCurrentFileItemSoryByDateASC()[indexPath.item]
        if(currentSelectedItem.isDir){
            let moveFileVC = MoveFileViewController()
            let folderItem = currentSelectedItem as! FolderItem
            moveFileVC.currentFolder = folderItem
            moveFileVC.sourceFile = sourceFile
            
            navigationController?.pushViewController(moveFileVC, animated: true)
        }
    }
    
    func reloadCollectionView(){
        self.fileCollectionView.reloadData()
        setEmptyListMessage()
    }
}

//MARK: - CONFIRM CustomContextMenuDelegate
extension MoveFileViewController: CustomContextMenuDelegate{
    func onItemClick(at position: Int) {
        if(position < navigationController?.viewControllers.count ?? 0){
            let targetController = (navigationController?.viewControllers[position])
            if let targetController = targetController{
                navigationController?.popToViewController(targetController, animated: true)
            }
        }
    }
}
