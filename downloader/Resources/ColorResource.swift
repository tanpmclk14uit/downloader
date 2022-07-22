//
//  ColorResource.swift
//  downloader
//
//  Created by LAP14812 on 20/07/2022.
//

import UIKit

class ColorResource{
    public static let backGroundColor: UIColor? = UIColor(hex: "#F5F5F5")
    public static let thumbnailBackgroundColor: UIColor? = UIColor(hex: "#F7F7F7")
    public static let white: UIColor? = UIColor(hex: "#FFFFFF")
}

//MARK: - Extension get color by hex 6 or 8 bit
extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }else{
                if hexColor.count == 6 {
                    let scanner = Scanner(string: hexColor)
                    var hexNumber: UInt64 = 0
                    if scanner.scanHexInt64(&hexNumber) {
                        r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                        g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                        b = CGFloat((hexNumber & 0x0000ff) >> 0) / 255
                        self.init(red: r, green: g, blue: b, alpha: 1)
                        return
                    }
                }
            }
        }
        
        return nil
    }
}
