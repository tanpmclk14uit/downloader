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
    @Published var currentPreviewItemPosition: Int;
    @Published var previewItems: [CustomPreviewItem];
    
    init(){
        currentPreviewItemPosition = 0
        previewItems = [URL(string: "https://images6.fanpop.com/image/photos/38500000/beautiful-wallpaper-1-beautiful-pictures-38538866-2560-1600.jpg")!  as CustomPreviewItem,
                        URL(string: "https://images.unsplash.com/photo-1526547541286-73a7aaa08f2a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8Mnx8fGVufDB8fHx8&w=1000&q=80")!  as CustomPreviewItem,
                        URL(string: "https://images6.fanpop.com/image/photos/38500000/beautiful-wallpaper-1-beautiful-pictures-38538866-2560-1600.jpg")!  as CustomPreviewItem]
    }
}
