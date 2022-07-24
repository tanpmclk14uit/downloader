//
//  DownloadItemViewCellDelegate.swift
//  downloader
//
//  Created by LAP14812 on 07/07/2022.
//

import Foundation

protocol DownloadItemCellDelegate{
    func pauseClick(downloadItem: DownloadItem);
    func resumeClick(downloadItem: DownloadItem);
    func cancelClick(downloadItem: DownloadItem);
}
