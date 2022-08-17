//
//  CustomImageViewController.swift
//  downloader
//
//  Created by LAP14812 on 08/08/2022.
//

import UIKit

class CustomPreviewController: UIViewController {
    
    //MARK: - Config UI Element
    private lazy var dismissImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.setTitle("Close", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.addTarget(self, action: #selector(onBackPress), for: .touchUpInside)
        return button
    }()
    
    private lazy var imageCollectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize.width = view.frame.width
        layout.itemSize.height = view.frame.height
        return layout
    }()
    
    private lazy var imageCollectionView: UICollectionView = {
        let collectionView =  UICollectionView(frame: CGRect.zero, collectionViewLayout: imageCollectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isScrollEnabled = true
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .clear
        collectionView.register(CustomPreviewImageCell.self, forCellWithReuseIdentifier: CustomPreviewImageCell.identifier)
        return collectionView
    }()
    
    // MARK: - Config UI Constraint
    private func configImageViewConstraint(){
        dismissImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dismissImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        dismissImage.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        dismissImage.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    private func configBackButtonConstraint(){
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func configImageConllectionViewConstraint(){
        imageCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        imageCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        imageCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    //MARK: Set Up ViewController
    private var viewTranslation = CGPoint(x: 0, y: 0)

    /** panDistance define min distance that user must pan to dismiss controller */
    private var panDistance: CGFloat = 0.0
    
    private var isShowingAppbar: Bool = true
    
    private var isInZoomMode: Bool = false
    
    private var currentSize = CGSize(width: 0, height: 0)
    
    var previewItems: [CustomPreviewItem] = []
    var delegate: CustomPreviewControllerDelegate?
    private var animator = PopAnimator()
    
    var currentPreviewItemPosition: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.transitioningDelegate = self
        
        setUpContentView()
        
        panDistance = view.frame.height/2
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(reverseVisibilityOfAppBar)))
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(onUserPanToDissmiss)))
    }
    
    override func viewDidLayoutSubviews() {
        guard !previewItems.isEmpty else{
            return
        }
        let indexPath = IndexPath(item: currentPreviewItemPosition, section: 0)
        imageCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        imageCollectionView.layoutIfNeeded()
        previewItemAt(position: currentPreviewItemPosition)
    }
    
    private func setUpContentView(){
        view.backgroundColor = .black
        
        view.addSubview(imageCollectionView)
        configImageConllectionViewConstraint()
        
        view.addSubview(backButton)
        configBackButtonConstraint()
    }
    
    
    
    @objc private func onUserPanToDissmiss(sender: UIPanGestureRecognizer){
        setVisibilityOfAppbar(visible: false)
        
        guard let currentCell = getCurrentCellOfPosition(position: currentPreviewItemPosition) else {
            return
        }
        
        let imageSize = currentCell.imageSize
        switch sender.state {
        case .changed:
            viewTranslation = sender.translation(in: view)
            self.navigationController?.navigationBar.isHidden = true
            // set background alpha
            let backgroundAlpha = max( 1.0 - (abs(viewTranslation.y) / panDistance), 0.3)
            view.backgroundColor = view.backgroundColor?.withAlphaComponent(backgroundAlpha)
            
            // scale image
            let scale = max( 1.0 - (abs(viewTranslation.y) / panDistance), 0.5)
            let imageViewWidth = currentCell.imageView.frame.width * scale
            let imageViewHeight = currentCell.imageView.frame.height * scale
            let scaleX = imageViewWidth/currentCell.imageView.frame.width
            let scaleY = imageViewHeight/currentCell.imageView.frame.height
            
            currentSize = CGSize(width: imageSize.width * scale, height: imageSize.height * scale)
            currentCell.imageView.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
            currentCell.imageView.center = sender.location(in: view)
            
        case .ended:
            let scale = 1.0 - (abs(viewTranslation.y) / panDistance)
            if scale > 0.7 {
                // quit animation, recover last state
                self.navigationController?.navigationBar.isHidden = true
                
                setVisibilityOfAppbar(visible: self.isShowingAppbar)
                
                UIView.animate(
                    withDuration: 0.5,
                    delay: 0,
                    usingSpringWithDamping: 1,
                    initialSpringVelocity: 0.5,
                    options: .curveEaseOut,
                    animations: {
                        currentCell.imageView.transform = .identity
                        currentCell.imageView.center = currentCell.contentView.center
                        self.view.backgroundColor = self.view.backgroundColor?.withAlphaComponent(1)
                    })
            } else { // dismiss
                currentCell.imageSize = currentSize
                dismiss(animated: true, completion: nil)
            }
        default:
            break
        }
    }
    
    @objc private func reverseVisibilityOfAppBar(){
        if(!isInZoomMode){
            isShowingAppbar = !isShowingAppbar
            setVisibilityOfAppbar(visible: isShowingAppbar)
        }
    }
    
    /** This func call to set visibility of all view on screen except for main image*/
    private func setVisibilityOfAppbar(visible: Bool){
        backButton.isHidden = !visible
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        setVisibilityOfAppbar(visible: false)
        if let cell = getCurrentCellOfPosition(position: currentPreviewItemPosition){
            view.frame = CGRect(origin: cell.frame.origin, size: cell.imageSize)
            view.center = cell.imageView.center
            imageCollectionView.removeFromSuperview()
            dismissImage.image = cell.imageView.image
            view.addSubview(dismissImage)
            configImageViewConstraint()
        }
        super.dismiss(animated: flag, completion: completion)
    }
    
    @objc func onBackPress(){
        self.dismiss(animated: true)
    }
}
// MARK: - Confirm Collection View Data Source
extension CustomPreviewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return previewItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomPreviewImageCell.identifier, for: indexPath) as! CustomPreviewImageCell
        // set cell delegate
        cell.delegate = self
        if let delegate = self.delegate{
            // set place holder for image
            cell.imageView.image = delegate.previewController(self, defaultPlaceHolderForItemAt: indexPath.item)
        }
        // load image by URL
        if let previewItemURL = previewItems[indexPath.item].previewItemURL {
            cell.setImageDataByImageURL(previewItemURL)
        }
        
        return cell
    }
    
    func getCurrentCellOfPosition(position: Int) -> CustomPreviewImageCell?{
        guard !previewItems.isEmpty else{
            return nil
        }
        let indexPath = IndexPath(item: position, section: 0)
        let currentCell = imageCollectionView.cellForItem(at: indexPath) as? CustomPreviewImageCell
        return currentCell
    }
    
    /** This func will call when user  slide to view orther image*/
    private func previewItemAt(position: Int){
        if(position != currentPreviewItemPosition){
            let cell = getCurrentCellOfPosition(position: currentPreviewItemPosition)
            if let cell = cell {
                // reset zoom scale of previous item
                cell.resetZoomScale()
            }
            // set current preview item
            currentPreviewItemPosition = position
            // Do any additional setup after user slide to new image.
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let currentIndexPath = imageCollectionView.indexPathsForVisibleItems.first{
            previewItemAt(position: currentIndexPath.item)
        }
    }
}
// MARK: - Confirm Delegate Flow Layout
extension CustomPreviewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
//MARK: - Confirm Transitioning Delegate
extension CustomPreviewController: UIViewControllerTransitioningDelegate{
    
    func getOriginFrameForItemAt(position: Int) -> CGRect?{
        if let delegate = delegate{
            let animationView = delegate.previewController(self, transitionViewForItemAt: position)
            guard let animationView = animationView else {
                return nil
            }
            let selectedCellSuperview = animationView.superview ?? UIView()
            return selectedCellSuperview.convert(animationView.frame, to: nil)
        }else{
            return nil
        }
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let originFrame = getOriginFrameForItemAt(position: currentPreviewItemPosition){
            animator.originFrame = originFrame
            animator.presenting = true
            return animator
        }else{
            return nil
        }
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let originFrame = getOriginFrameForItemAt(position: currentPreviewItemPosition){
            animator.originFrame = originFrame
            animator.presenting = false
            return animator
        }else{
            return nil
        }
    }
}
//MARK: - Confirm Custom Image Cell Delegate
extension CustomPreviewController: CustomPreviewImageCellDelegate{
    func setZoomState(isInZoomState: Bool) {
        self.isInZoomMode = isInZoomState
        if(isInZoomState){
            setVisibilityOfAppbar(visible: false)
        }
    }
}

