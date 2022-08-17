//
//  ContentSizedTableView.swift
//  downloader
//
//  Created by LAP14812 on 12/07/2022.
//

import UIKit

class ContentSizedTableView: UITableView {
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height - 0.5)
    }
}
