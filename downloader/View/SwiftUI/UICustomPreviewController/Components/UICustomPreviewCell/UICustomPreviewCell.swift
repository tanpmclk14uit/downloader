//
//  UICustomPreviewCell.swift
//  downloader
//
//  Created by LAP14812 on 22/08/2022.
//

import SwiftUI

@available(iOS 13.0, *)
struct UICustomPreviewCell: View {
    
    @ObservedObject private var viewModel = UICustomPreviewCellViewModel()
    @EnvironmentObject var parentViewModel: UICustomPreviewViewModel
    
    func loadPreviewItem(url: URL?){
        viewModel.loadImageByImageURL(url)
    }
    
    func getCurrentImageSize(imageScale: CGFloat) -> CGSize{
        let imageRatio = viewModel.imageSize.width/viewModel.imageSize.height
        let width = UIScreen.main.bounds.width * imageScale
        let height = width/imageRatio
        return CGSize(width: width, height: height)
    }
    
    var body: some View {
        
        GeometryReader {proxy in
            
            VStack(alignment: .center){
                
                switch(viewModel.loadingState){
                    
                case .Loading:
                    LoadingIndicator()
                case .Success:
                    if let image = viewModel.image{
                        
                        let center = CGPoint(x: proxy.size.width/2, y: proxy.size.height/2)
                        
                        ZoomableScrollView(content:
                                            image
                            .resizable()
                            .scaledToFit()
                            .animation(.easeInOut, value: true)
                            .scaleEffect(parentViewModel.imageScale)
                            .position(parentViewModel.isInPanMode ? parentViewModel.currentImagePosition : center)
                                           , isInZoomMode: $parentViewModel.isInZoomMode, imageSize: $viewModel.imageSize)
                        
                        .onTapGesture {
                            // Applying onTapGesture here to helf view (SwiftUI Code) detect
                            // double tap gesture in ZoomableScrollView(UIKit code)
                        }
                        
                    }
                case .Error:
                    Text("Image loading failed,\nan error has occurred!")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                        .multilineTextAlignment(.center)
                        .padding()
                }
            }
        }.frame(width: UIScreen.main.bounds.width)
    }
}

@available(iOS 13.0.0, *)
struct UICustomPreviewCell_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            Color.black.edgesIgnoringSafeArea(.all)
            UICustomPreviewCell()
        }
        
    }
}
