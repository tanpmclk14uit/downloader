//
//  DownloadItemViewCell.swift
//  downloader
//
//  Created by LAP14812 on 22/06/2022.
//

import UIKit

class DownloadItemViewCell: UITableViewCell {
    //MARK: - CONFIG UI
    private lazy var downloadItemTitle: UILabel = {
        let downloadItemTitle = UILabel()
        downloadItemTitle.translatesAutoresizingMaskIntoConstraints = false
        downloadItemTitle.text = "Download item title"
        downloadItemTitle.font = UIFont.boldSystemFont(ofSize: DimenResource.itemTitleTextSize)
        return downloadItemTitle
    }()
    
    private lazy var downloadItemStatus: UILabel = {
        let downloadItemStatus = UILabel()
        downloadItemStatus.translatesAutoresizingMaskIntoConstraints = false
        downloadItemStatus.text = "Download item status"
        downloadItemStatus.font = UIFont.systemFont(ofSize: DimenResource.itemNormalContentTextSize)
        return downloadItemStatus
    }()
     
    private lazy var buttonActionShape: CAShapeLayer = {
        let shapePlayer = CAShapeLayer();
        let centerPoint = CGPoint(x: DimenResource.cellButtonWidth/2   , y: DimenResource.cellButtonHeight/2)
        let circularPath = UIBezierPath(arcCenter: centerPoint, radius: DimenResource.cellButtonWidth/2, startAngle: -CGFloat.pi/2, endAngle: 3*CGFloat.pi/2, clockwise: true)
        
        shapePlayer.path = circularPath.cgPath
        shapePlayer.fillColor = UIColor(white: 1, alpha: 0).cgColor
        shapePlayer.strokeColor = UIColor.systemBlue.cgColor
        shapePlayer.lineWidth = 3.5
        
        shapePlayer.lineCap = CAShapeLayerLineCap.round
        return shapePlayer
    }()
    
    private lazy var downloadItemButtonAction: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .gray

        buttonActionShape.frame = button.bounds
        button.layer.addSublayer(buttonActionShape)
        button.setImage(UIImage(named: "pause"), for: .normal)
        return button
    }()
    
    private lazy var cancelDownloadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "cancel"), for: .normal)
        button.tintColor = .gray
        return button
    }()
    
    private lazy var itemCellLayout: UIView = {
        let layout = UIView()
        layout.translatesAutoresizingMaskIntoConstraints = false
        layout.backgroundColor = .white
        layout.addSubview(downloadItemButtonAction)
        layout.addSubview(cancelDownloadButton)
        
        // config button download action
        downloadItemButtonAction.centerYAnchor.constraint(equalTo: layout.centerYAnchor).isActive = true
        downloadItemButtonAction.trailingAnchor.constraint(equalTo: layout.trailingAnchor, constant: DimenResource.cellItemMargin.right).isActive = true
        downloadItemButtonAction.widthAnchor.constraint(equalToConstant: DimenResource.cellButtonWidth).isActive = true
        downloadItemButtonAction.heightAnchor.constraint(equalToConstant: DimenResource.cellButtonHeight).isActive = true
        // config cancel download button
        cancelDownloadButton.centerYAnchor.constraint(equalTo: layout.centerYAnchor).isActive = true
        cancelDownloadButton.trailingAnchor.constraint(equalTo: downloadItemButtonAction.leadingAnchor, constant: DimenResource.cellItemMargin.right).isActive = true
        cancelDownloadButton.widthAnchor.constraint(equalToConstant: DimenResource.buttonIconWidth).isActive = true
        cancelDownloadButton.heightAnchor.constraint(equalToConstant: DimenResource.buttonIconHeight).isActive = true
        // config content tile & status
        let contentLayout = UIStackView()
        contentLayout.translatesAutoresizingMaskIntoConstraints = false
        contentLayout.axis = .vertical
        contentLayout.distribution = .fillEqually
        layout.addSubview(contentLayout)
        contentLayout.addArrangedSubview(downloadItemTitle)
        contentLayout.addArrangedSubview(downloadItemStatus)
        contentLayout.leadingAnchor.constraint(equalTo: layout.leadingAnchor, constant: DimenResource.cellItemMargin.left).isActive = true
        contentLayout.trailingAnchor.constraint(equalTo: cancelDownloadButton.leadingAnchor, constant: DimenResource.cellItemMargin.right).isActive = true
        contentLayout.centerYAnchor.constraint(equalTo: layout.centerYAnchor).isActive = true
        contentLayout.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return layout
    }()
    //MARK: - CONFIG CELL CONSTRAINT
    private func configItemCellConstraint(){
        itemCellLayout.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DimenResource.cellItemMargin.left).isActive = true
        itemCellLayout.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: DimenResource.cellItemMargin.right).isActive = true
        itemCellLayout.heightAnchor.constraint(equalToConstant: 60).isActive = true
        itemCellLayout.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
     }
    // MARK: - INIT ITEM CELL
    public var delegate: DownloadItemCellDelegate?
    public static let identifier: String = "DownloadItemCell"
    private var currentDownloadItem: DownloadItem?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.addSubview(itemCellLayout)
        configItemCellConstraint()
        
        self.downloadItemButtonAction.addTarget(self, action: #selector(actionButtonClick), for: .touchUpInside)
        
        self.cancelDownloadButton.addTarget(self, action: #selector(cancelDownloadButtonClick), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setDownloadItemDownloadDuration(_ durationString: String?){
        self.downloadItemStatus.text = durationString
    }
    
    func setUpDataCell(downloadItem: DownloadItem){
        currentDownloadItem = downloadItem
        buttonActionShape.strokeEnd = downloadItem.progress
        setUpCellByDownloadState(downLoadState: downloadItem.state)
    }
    
    func getCurrentDownloadItem()-> DownloadItem?{
        return self.currentDownloadItem
    }
    
    func updateProgressBar(progress: Double){
        if let currentDownloadItem = currentDownloadItem {
            currentDownloadItem.progress = progress
            currentDownloadItem.progress = min(1, progress)
            currentDownloadItem.progress = max(0, progress)
            buttonActionShape.strokeEnd = currentDownloadItem.progress
        }
    }
    
    func setProgressBarColorByInternetConnectionState(hasInternetConection: Bool){
        if(hasInternetConection){
            buttonActionShape.strokeColor = UIColor.systemBlue.cgColor
        }else{
            buttonActionShape.strokeColor = UIColor.red.cgColor
        }
       
    }
    
    func setUpCellByDownloadState(downLoadState: String){
        downloadItemTitle.text = currentDownloadItem?.name
        switch(downLoadState){
        case String(describing: DownloadState.Completed):do {
            cancelDownloadButton.isHidden = true
            downloadItemButtonAction.isHidden = true
            downloadItemStatus.text = currentDownloadItem?.state ?? ""
            break
        }
        case String(describing: DownloadState.Pause):do {
            downloadItemButtonAction.setImage(UIImage(named: "play"), for: .normal)
            cancelDownloadButton.isHidden = false
            downloadItemButtonAction.isHidden = false
            downloadItemStatus.text = currentDownloadItem?.state ?? ""
            break
        }
        case String(describing: DownloadState.Canceled): do {
            cancelDownloadButton.isHidden = true
            downloadItemButtonAction.isHidden = true
            downloadItemStatus.text = currentDownloadItem?.state ?? ""
            break
        }
        case String(describing: DownloadState.Error):do {
            cancelDownloadButton.isHidden = true
            downloadItemButtonAction.isHidden = true
            downloadItemStatus.text = currentDownloadItem?.state ?? ""
            break
        }
        case String(describing: DownloadState.Downloading):do {
            downloadItemButtonAction.setImage(UIImage(named: "pause"), for: .normal)
            cancelDownloadButton.isHidden = true
            downloadItemButtonAction.isHidden = false
            downloadItemStatus.text = currentDownloadItem?.durationString ?? String(describing: DownloadState.Downloading)
            break
        }
        default:
            break;
        }
        if let currentDownloadItem = currentDownloadItem {
            buttonActionShape.strokeEnd = currentDownloadItem.progress
        }
    }
    // MARK: - CONFIG BUTTON EVENT
    @objc func actionButtonClick(){
        switch(currentDownloadItem?.state){
        case String(describing: DownloadState.Pause):
            delegate?.resumeClick(downloadItem: currentDownloadItem!)
        case String(describing: DownloadState.Error):
            break;
        case String(describing: DownloadState.Completed):
            break;
        case String(describing: DownloadState.Canceled):
            break;
        case String(describing: DownloadState.Downloading):
            delegate?.pauseClick(downloadItem: currentDownloadItem!)
            break;
        default:
            break;
        }
    }
    
    @objc func cancelDownloadButtonClick(){
        delegate?.cancelClick(downloadItem: currentDownloadItem!)
    }
}
