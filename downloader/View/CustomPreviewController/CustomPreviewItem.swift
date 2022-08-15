//
//  CustomPreviewItem.swift
//  downloader
//
//  Created by LAP14812 on 15/08/2022.
//

import UIKit

@objc public protocol CustomPreviewItem: NSObjectProtocol {
    /**
     * @abstract The URL of the item to preview.
     */
    var previewItemURL: URL? { get }

    /**
     * @abstract The item's title this will be used as apparent item title.
     * @discussion The title replaces the default item display name. This property is optional.
     */
    @objc optional var previewItemTitle: String? { get }
}

/**
 * @abstract This category makes NSURL instances as suitable items for the Preview Controller.
 */
extension NSURL : CustomPreviewItem {
}
