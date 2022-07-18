//
//  DimenConstants.swift
//  downloader
//
//  Created by LAP14812 on 24/06/2022.
//

import Foundation
import UIKit

class Dimen {
    // text size
    public static let screenTitleTextSize: CGFloat = 26;
    public static let screenHeadlingTextSize: CGFloat = 22
    public static let itemTitleTextSize: CGFloat = 18;
    public static let itemNormalContentTextSize: CGFloat = 16;
    public static let itemAdditionalContentTextSize: CGFloat = 16;
    public static let screenNormalTextSize: CGFloat = 18;
    public static let screenAdditionalInformationTextSize: CGFloat = 16;
    // button icon size
    public static let buttonIconWidth: CGFloat = 24;
    public static let buttonIconHeight: CGFloat = 24;
    public static let normalButtonWidth: CGFloat = 100;
    public static let cellButtonWidth: CGFloat = 30;
    public static let cellButtonHeight: CGFloat = 30;
    // image size
    public static let imageIconWidth: CGFloat = 50;
    public static let imageIconHeight: CGFloat = 50;
    public static let imageTinyIconWidth: CGFloat = 24;
    public static let imageTinyIconHeight: CGFloat = 24;
    // Margin
    public static let screenDefaultMargin: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: -10, right: -10)
    public static let cellItemMargin: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: -10, right: -10)
    public static let toolBarMargin: UIEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: -10, right: -15)
    public static let cellItemByIconMargin: UIEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: -5, right: -5)

    // get font height
    public static func getFontHeight(font: UIFont)-> CGFloat{
        let temp: String = "temp"
        return temp.height(withConstrainedWidth: CGFloat.infinity, font: font)
    }
    // menu max width
    public static let menuMaxWidth: CGFloat = 250.0
    // top bar size
}
// MARK: - GET HEIGHT OF STRING
extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
    
        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}
