//
//  Enum.swift
//  downloader
//
//  Created by LAP14812 on 24/06/2022.
//

import Foundation

enum DownloadState {
    case Completed
    case Canceled
    case Pause
    case Error
    case Downloading
}

enum LayoutState{
    case List
    case Grid
    case WaterFallImage
}

enum SortDIV{
    case Asc
    case Desc
    
    mutating func reverse(){
        if(self == SortDIV.Asc){
            self = SortDIV.Desc
        }else{
            self = SortDIV.Asc
        }
    }
}

enum FilterByState{
    case Completed
    case Canceled
    case Pause
    case Error
    case Downloading
    case All
}

enum BasicSort{
    case Name
    case Date
}



