//
//  FileTypeConstants.swift
//  downloader
//
//  Created by LAP14812 on 05/07/2022.
//

import Foundation
public struct FileType{
    public static let pdf: [String] = ["pdf"]
    public static let video: [String] = ["mp4","mov","wmv","flv","avi","avchd","webm","mkv"]
    public static let audio: [String] = ["mp3", "m4a","flac","wav","wma","aac"]
    public static let zip: [String] = ["zip", "7z"]
    public static let image: [String] = ["jpeg","jpg","png","gif","tiff","psd","eps","ai","indd","raw"]
    public static let text: [String] = ["html", "txt", "doc", "docx", "odt","rtf","wpd", "tex"]
}
