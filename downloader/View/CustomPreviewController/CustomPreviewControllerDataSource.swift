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
    
    /** get url or other information to set up preview*/
    func previewController(_ controller: CustomPreviewController, previewItemAt index: Int) -> CustomPreviewItem
}


