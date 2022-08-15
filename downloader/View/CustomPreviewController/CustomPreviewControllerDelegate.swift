//
//  CustomPreviewControllerDelegate.swift
//  downloader
//
//  Created by LAP14812 on 14/08/2022.
//

import UIKit

protocol CustomPreviewControllerDelegate{
    func previewController(_ controller: CustomPreviewController, transitionViewForItemAt position: Int) -> UIView?
    
    func previewController(_ controller: CustomPreviewController, defaultPlaceHolderForItemAt position: Int) -> UIImage?
}

extension CustomPreviewControllerDelegate{
    func previewController(_ controller: CustomPreviewController, defaultPlaceHolderForItemAt position: Int) -> UIImage?{
        return nil
    }
}
