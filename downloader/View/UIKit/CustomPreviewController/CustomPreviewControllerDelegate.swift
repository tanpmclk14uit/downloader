//
//  CustomPreviewControllerDelegate.swift
//  downloader
//
//  Created by LAP14812 on 14/08/2022.
//

import UIKit

protocol CustomPreviewControllerDelegate{
    /**OPTIONAL: Confirm it and then return a cell or an image in cell that you want to perform zoom transition
     Default return is nil so that controller will use default transition to present or dismiss**/
    func previewController(_ controller: CustomPreviewController, transitionViewForItemAt position: Int) -> UIView?
    
    /**OPTIONAL: Confirm it and then return image place holder for  preview item
     It may be ether an image in small resolution or a default image which represent for preview item when it is loading**/
    func previewController(_ controller: CustomPreviewController, defaultPlaceHolderForItemAt position: Int) -> UIImage?
}

extension CustomPreviewControllerDelegate{
    func previewController(_ controller: CustomPreviewController, defaultPlaceHolderForItemAt position: Int) -> UIImage?{
        return nil
    }
    
    func previewController(_ controller: CustomPreviewController, transitionViewForItemAt position: Int) -> UIView?{
        return nil
    }
}
