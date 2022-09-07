//
//  UICustomPreviewViewModel.swift
//  downloader
//
//  Created by LAP14812 on 19/08/2022.
//

import Foundation
import SwiftUI


@available(iOS 13.0, *)
class UICustomPreviewViewModel: ObservableObject{
    
    var currentImagePosition: CGPoint = .zero
    
    @Published var currentPreviewItemIndex: Int = 0 {
        didSet{
            let currentPreviewItemURL = previewItems[currentPreviewItemIndex].previewItemURL
            currentPreviewCell = previewItemCells[currentPreviewItemIndex]
            currentPreviewCell!.loadPreviewItem(url: currentPreviewItemURL)
        }
    }
    @Published var previewItemCells: [UICustomPreviewCell];
    @Published var shouldShowAppBar: Bool = true
    @Published var slideAble: Bool = true
    @Published var backgroundAlpha: CGFloat = 1.0
    @Published var imageScale: CGFloat = 1.0
    @Published var lastScale: CGFloat = 1.0
    @Published var isInPanMode: Bool;
    @Published var isInZoomMode: Bool;
    @Published var currentImageSize: CGSize = .zero
    var currentPreviewCell: UICustomPreviewCell?
    
    private var previewItems: [CustomPreviewItem]
    
    private let maxZoomScale: CGFloat = 4.0
    private let minZoomScale: CGFloat = 1.0
    private let minPanDetecable: CGFloat = 20
    private let panDistance: CGFloat = UIScreen.main.bounds.height/3
    private let maxCountOfCell: Int = 3
    
    private var isShowingAppBar: Bool = true
    
    
    init(){
        previewItemCells = []
        previewItems = []
        isInPanMode = false
        isInZoomMode = false
    }
    
    func loadPreviewCellView(previewItems: [CustomPreviewItem]){
        for previewItem in previewItems {
            self.previewItemCells.append(UICustomPreviewCell())
            self.previewItems.append(previewItem)
        }
    }
    
    func onTap(){
        shouldShowAppBar = !shouldShowAppBar
        isShowingAppBar = !isShowingAppBar
    }
    
    func onPanToDismissChange(value: DragGesture.Value){
        if(!isInZoomMode){
            if (abs(value.translation.height) > minPanDetecable){
                slideAble = false
                
                shouldShowAppBar = false
                
                backgroundAlpha = max( 1.0 - (abs(value.translation.height) / panDistance), 0.3)
                
                imageScale = max( 1.0 - (abs(value.translation.height) / panDistance), 0.5)
                
                currentImagePosition = value.location
                
                isInPanMode = true
            }
        }
    }
    
    func startDismiss(){
        if let currentPreviewCell = currentPreviewCell {
            currentImageSize = currentPreviewCell.getCurrentImageSize(imageScale: imageScale)
        }
        imageScale = 1.0
        shouldShowAppBar = false
        backgroundAlpha = 0
    }
    
    func onPanToDismissEnded(value: DragGesture.Value, dismiss: (()-> Void)){
        if(!isInZoomMode){
            if shouldDismiss() {
                startDismiss()
                dismiss()
            }else{
                backgroundAlpha = 1
                shouldShowAppBar = isShowingAppBar
                imageScale = 1
            }
            isInPanMode = false
            slideAble = true
        }
    }
    
    private func shouldDismiss() -> Bool{
        return imageScale < 0.65
    }
    
    func adjustScale(from value: MagnificationGesture.Value){
        let delta = value / lastScale
        imageScale *= delta
        lastScale = value
    }
    
    func getMinimumScaleAllowed() -> CGFloat{
        return max(imageScale, minZoomScale)
    }
    
    func getMaximumScaleAllowed() -> CGFloat{
        return min(imageScale, maxZoomScale)
    }
    
    func validateScaleLimits(){
        imageScale = getMaximumScaleAllowed()
        imageScale = getMinimumScaleAllowed()
    }
}
