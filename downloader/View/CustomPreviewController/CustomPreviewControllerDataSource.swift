//
//  CustomPreviewControllerDataSource.swift
//  downloader
//
//  Created by LAP14812 on 12/08/2022.
//

import Foundation
import UIKit

protocol CustomPreviewControllerDataSource{
    func numberOfPreviewItems(in controller: CustomPreviewController) -> Int
    
    func previewController(_ controller: CustomPreviewController, previewItemAt index: Int) -> CustomPreviewItem
}


