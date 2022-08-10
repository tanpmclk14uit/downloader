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
    
    func toString()-> String{
        return String(describing: self)
    }
}

enum LayoutType{
    case List
    case Grid
    case Pinterest
}

enum SignCellType{
    case number
    case remove
    case cancel
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

enum FilterByDownloadState{
    case Completed
    case Canceled
    case Pause
    case Error
    case Downloading
    case All
    
    func toString()-> String{
        return "\(String(describing: self)) process"
    }
}

enum SortBy{
    case Name
    case Date
    
    func toString()-> String{
        return String(describing: self)
    }
}

enum FilterByFileType{
    case All;
    case PDF;
    case Audio;
    case Video;
    case Zip;
    case Image;
    case Text;
    case Unknown;
    case Directory
}

public enum NotificationAlertType{
    case Error;
    case Information;
    case Success;
    case Warning;
}




