//
//  UICustomPreviewCellViewModel.swift
//  downloader
//
//  Created by LAP14812 on 22/08/2022.
//

import Foundation
import SwiftUI

//MARK: - Loading State Enum
/** Note: Move this enum to file that constain all enum of app*/
enum LoadingState{
    case Loading
    case Error
    case Success
}

//MARK: - UI Custom Preview Cell View Model
@available(iOS 13, *)
final class UICustomPreviewCellViewModel: ObservableObject{
    @Published var image: Image?
    @Published var loadingState: LoadingState = LoadingState.Loading
    
    let maximumZoomScale: CGFloat = 4
    
    
    func loadImageByImageURL(_ url: URL?){
        if(image == nil){
            loadingState = LoadingState.Loading
            guard let url = url else {
                print("Image url is nil")
                loadingState = LoadingState.Error
                return
            }
            
            DispatchQueue.global().async { [weak self] in
                if let self = self{
                    do{
                        let image = try UIImage(data: Data(contentsOf: url))
                        if let image = image {
                            DispatchQueue.main.async { [self] in
                                let imageRatio = image.size.width / image.size.height
                                let imageWidth = UIScreen.main.bounds.width
                                let imageHeight = imageWidth/imageRatio
                                DispatchQueue.global().async {
                                    let imageSize = CGSize(width: imageWidth, height: imageHeight)
                                    let optimizedImage = self.getAndOptimizeImage(withURL: url, to: imageSize, scale: self.maximumZoomScale)
                                    // save optimized image to cache if needed
                                    DispatchQueue.main.async {
                                        if let optimizedImage = optimizedImage {
                                            self.image = Image(uiImage: optimizedImage)
                                            self.loadingState = .Success
                                        }
                                    }
                                }
                            }
                        }
                    }catch{
                        print("Get image error!")
                        self.loadingState = LoadingState.Error
                    }
                }
            }
        }
    }
    
    private func getAndOptimizeImage(withURL: URL,
                                     to pointSize: CGSize,
                                     scale: CGFloat = UIScreen.main.scale) -> UIImage?{
        // Create an CGImageSource that represent an image
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithURL(withURL as CFURL, imageSourceOptions) else {
            return nil
        }
        
        // Calculate the desired dimension
        let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
        
        // Perform downsampling
        let downsampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
        ] as CFDictionary
        
        guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else {
            return nil
        }
        
        // Return the downsampled image as UIImage
        let imageData = UIImage(cgImage: downsampledImage).jpegData(compressionQuality: 0.5)
        guard let imageData = imageData else{
            return nil
        }
        return UIImage(data: imageData)
    }
}
