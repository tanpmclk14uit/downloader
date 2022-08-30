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
    var currentPreviewItemIndex: Int = 0
    var currentImagePosition: CGPoint = .zero
    
    @Published var shouldShowAppBar: Bool = true
    @Published var slideAble: Bool = true
    @Published var backgroundAlpha: CGFloat = 1.0
    @Published var imageScale: CGFloat = 1.0
    @Published var lastScale: CGFloat = 1.0
    @Published var previewItemImages: [UICustomPreviewCell];
    @Published var isInPanMode: Bool;
    @Published var isInZoomMode: Bool;
    
    
    private let maxZoomScale: CGFloat = 4.0
    private let minZoomScale: CGFloat = 1.0
    private let minPanDetecable: CGFloat = 20
    private let panDistance: CGFloat = UIScreen.main.bounds.height/3
    
    private var isShowingAppBar: Bool = true
    
    


    init(){
        previewItemImages = []
        isInPanMode = false
        isInZoomMode = false
    }
    
    func loadPreviewCellView(previewItems: [CustomPreviewItem]){
        for previewItem in previewItems {
            previewItemImages.append(UICustomPreviewCell(previewItem.previewItemURL))
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
    
    func onPanToDismissEnded(value: DragGesture.Value, dismiss: (()-> Void)?){
        if(!isInZoomMode){
            if shouldDismiss() {
                backgroundAlpha = 0
                dismiss?()
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
