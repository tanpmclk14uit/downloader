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
    var previewItems: [CustomPreviewItem];
    
    var shouldShowAppBar: Bool = true
    var currentImagePosition: CGPoint = .zero
    var currentImageOffset: CGSize = .zero
    
    @Published var slideAble: Bool = true
    @Published var backgroundAlpha: CGFloat = 1.0
    @Published var imageScale: CGFloat = 1.0
    @Published var lastScale: CGFloat = 1.0
    
    private let maxZoomScale: CGFloat = 4.0
    private let minZoomScale: CGFloat = 1.0
    
    private let minPanDetecable: CGFloat = 20
    private let panDistance: CGFloat = UIScreen.main.bounds.height/3
    @Published var isInPanMode: Bool;
    @Published var isInZoomMode: Bool;


    init(){
        previewItems = []
        isInPanMode = false
        isInZoomMode = false
        previewItems = loadDataForPreview()
    }

    
    func onPanToDismissChange(value: DragGesture.Value){
        if(isInZoomMode){
            
            
        }else{
            if (abs(value.translation.height) > minPanDetecable){
                slideAble = false
                
                shouldShowAppBar = false
                
                backgroundAlpha = max( 1.0 - (abs(value.translation.height) / panDistance), 0.3)
                
                imageScale = max( 1.0 - (abs(value.translation.height) / panDistance), 0.5)
                
                currentImagePosition = value.location
                
                currentImageOffset = value.translation
                
                isInPanMode = true
            }
        }
    }
    
    func onPanToDismissEnded(value: DragGesture.Value, dismiss: (()-> Void)?){
        if(isInZoomMode){
            
        }else{
            if shouldDismiss() {
                backgroundAlpha = 0
                dismiss?()
            }else{
                shouldShowAppBar = true
                backgroundAlpha = 1
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

@available(iOS 13, *)
extension UICustomPreviewViewModel{
    private func loadDataForPreview()-> [CustomPreviewItem]{
        let sampleImageURL1 = URL(string: "https://images6.fanpop.com/image/photos/38500000/beautiful-wallpaper-1-beautiful-pictures-38538866-2560-1600.jpg")!  as CustomPreviewItem
        let sampleImageURL2 =  URL(string: "https://images.unsplash.com/photo-1526547541286-73a7aaa08f2a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8Mnx8fGVufDB8fHx8&w=1000&q=80")!  as CustomPreviewItem
        return [sampleImageURL1,
                sampleImageURL2,
                sampleImageURL1]
    }
}
