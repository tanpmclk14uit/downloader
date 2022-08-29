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
    
    func setCurrentPreviewItemTo(position: Int){
        viewModel.currentPreviewItemIndex = position
    }
    
    var body: some View {
        ZStack(alignment: .top){
            Color.black.edgesIgnoringSafeArea(.all).opacity(viewModel.backgroundAlpha).animation(.easeInOut, value: true)
            
            GeometryReader { proxy in
                ZoomableScrollView(content:
                                    PageViewController(pages: viewModel.previewItems.map({
    
                    UICustomPreviewCell($0.previewItemURL)
                }), currentPage: $viewModel.currentPreviewItemIndex, slideAble: $viewModel.slideAble)
                                   , slideAble: $viewModel.slideAble, isInZoomMode: $viewModel.isInZoomMode)
            }.gesture(DragGesture().onChanged({ value in
                viewModel.onPanToDismissChange(value: value)
            }).onEnded({ value in
                viewModel.onPanToDismissEnded(value: value) {
                    dismissClosure?()
                }
            }))
            
            if(viewModel.shouldShowAppBar){
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
        }.environmentObject(viewModel)
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
