//
//  UICustomPreviewController.swift
//  downloader
//
//  Created by LAP14812 on 17/08/2022.
//

import SwiftUI


@available(iOS 13.0, *)
struct UICustomPreview: View {
    @ObservedObject private var viewModel = UICustomPreviewViewModel()
    
    let dismissClosure: (() -> Void)?
    
    func setPreviewItems(_ previewItems: [CustomPreviewItem]){
        viewModel.previewItems = previewItems
    }
    
    var body: some View {
        ZStack(alignment: .top){
            Color.black.edgesIgnoringSafeArea(.all)
            
            GeometryReader {_ in
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(viewModel.previewItems, id: \.previewItemURL){ previewItem in
                            UICustomPreviewCell(previewItem.previewItemURL)
                        }
                    }
                }
            }
            
            
            HStack {
                Button {
                    dismissClosure?()
                } label: {
                    Text("Close")
                        .font(Font.system(size: 18))
                        .foregroundColor(.white)
                        .padding(10)
                }
                
                Spacer()
            }
        }
    }
}

@available(iOS 13.0, *)
struct UICustomPreviewController_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            UICustomPreview(dismissClosure: nil)
        }
    }
}
