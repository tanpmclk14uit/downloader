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
    
    init(_ url: URL?){
        viewModel.loadImageByImageURL(url)
    }
    
    var body: some View {
        ZStack {
            
            Color.black.edgesIgnoringSafeArea(.all)
            VStack(alignment: .center){
                
                Spacer()
                
                switch(viewModel.loadingState){
                    
                case .Loading:
                    LoadingIndicator()
                case .Success:
                    if let image = viewModel.image{
                        image
                            .resizable()
                            .scaledToFit()
                            
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
}

@available(iOS 13.0.0, *)
struct UICustomPreviewCell_Previews: PreviewProvider {
    static var previews: some View {
        UICustomPreviewCell(URL(string: "https://images6.fanpop.com/image/photos/38500000/beautiful-wallpaper-1-beautiful-pictures-38538866-2560-1600.jpg")!)
    }
}
