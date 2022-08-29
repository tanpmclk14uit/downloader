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
    
    
    init(_ url: URL?){
        viewModel.loadImageByImageURL(url)
    }
    
    var body: some View {
        
        VStack(alignment: .center){
            
            Spacer()
            
            switch(viewModel.loadingState){
                
            case .Loading:
                LoadingIndicator()
            case .Success:
                if let image = viewModel.image{
                    GeometryReader {proxy in
                        
                        let center = CGPoint(x: proxy.size.width/2, y: proxy.size.height/2)
                        
                        image
                            .resizable()
                            .scaledToFit()
                            .animation(.easeInOut, value: true)
                            .scaleEffect(parentViewModel.imageScale)
                            .position(parentViewModel.isInPanMode ? parentViewModel.currentImagePosition : center)
                           
                    }
                }
            case .Error:
                Text("Image loading failed,\nan error has occurred!")
                    .foregroundColor(.white)
                    .font(.system(size: 20))
                    .multilineTextAlignment(.center)
                    .padding()
            }
            
            
            Spacer()
        }.frame(width: UIScreen.main.bounds.width)
    }
}

@available(iOS 13.0.0, *)
struct UICustomPreviewCell_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            Color.black.edgesIgnoringSafeArea(.all)
            UICustomPreviewCell(URL(string: "https://images6.fanpop.com/image/photos/38500000/beautiful-wallpaper-1-beautiful-pictures-38538866-2560-1600.jpg")!)
        }
        
    }
}
