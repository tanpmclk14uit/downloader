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
    
    let dismissClosure: (() -> Void)
    
    func setPreviewItems(_ previewItems: [CustomPreviewItem], currentIndex: Int = 0){
        viewModel.loadPreviewCellView(previewItems: previewItems)
        viewModel.currentPreviewItemIndex = currentIndex
    }
    
    func getCurrentPreviewItemIndex() -> Int{
        return viewModel.currentPreviewItemIndex
    }
    
    func getCurrentFrame() -> CGRect{
        return CGRect(x: viewModel.currentImagePosition.x, y: viewModel.currentImagePosition.y, width: viewModel.currentImageSize.width, height: viewModel.currentImageSize.height)
    }
    
    var body: some View {
        GeometryReader{ proxy in
            ZStack(alignment: .top){
                
                Color.black.edgesIgnoringSafeArea(.all).opacity(viewModel.backgroundAlpha).animation(.easeInOut, value: true)
                
                PageViewController(pages: viewModel.previewItemCells
                                   , currentPage: $viewModel.currentPreviewItemIndex, slideAble: $viewModel.slideAble, shouldShowAppBar: $viewModel.shouldShowAppBar)
                .simultaneousGesture(DragGesture().onChanged({ value in
                    viewModel.onPanToDismissChange(value: value)
                }).onEnded({ value in
                    viewModel.onPanToDismissEnded(value: value) {
                        dismissClosure()
                    }
                }))
                .onTapGesture {
                    viewModel.onTap()
                }
                
                if(viewModel.shouldShowAppBar && !viewModel.isInZoomMode){
                    HStack {
                        Button {
                            viewModel.currentImagePosition = CGPoint(x: proxy.size.width/2, y: proxy.size.height/2)
                            viewModel.startDismiss()
                            dismissClosure()
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
}


@available(iOS 13.0, *)
struct UICustomPreviewController_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            UICustomPreview(){
                print("close")
            }
        }
    }
}
