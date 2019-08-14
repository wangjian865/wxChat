//
//  UITextField+Extension.swift
//  login
//
//  Created by gwj on 2019/6/24.
//  Copyright © 2019 com.ailearn.student. All rights reserved.
//
import UIKit
import Foundation
extension String {
    func isTelNumber() ->Bool {
        //手机号码最少11位
        if self.count < 11 {
            return false
        }
//        let mobile = "^1((3[0-9]|4[57]|5[0-35-9]|7[0678]|8[0-9])\\d{8}$)"
        let mobile = "^1+[3578]+\\d{9}"
        let  CM = "(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
        let  CU = "(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
        let  CT = "(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
        
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        let regextestcm = NSPredicate(format: "SELF MATCHES %@",CM )
        let regextestcu = NSPredicate(format: "SELF MATCHES %@" ,CU)
        let regextestct = NSPredicate(format: "SELF MATCHES %@" ,CT)
        if ((regextestmobile.evaluate(with: self) == true)
            || (regextestcm.evaluate(with: self)  == true)
            || (regextestct.evaluate(with: self) == true)
            || (regextestcu.evaluate(with: self) == true)) {
            
            return true
        } else {
            return false
        }
    }
    
    //是否为密码
    func isPassword(pwd: String) -> Bool {
        if pwd.count > 1 {
            return true
        } else {
            return false
        }
    }
    
    //删除文字中的表情
    private func disableEmoji(text: String) -> String {
        let regex = try!NSRegularExpression.init(pattern: "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]",
                                                 options: .caseInsensitive)
        let modifiedString = regex.stringByReplacingMatches(in: text, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange.init(location: 0, length: text.count), withTemplate: "")
        return modifiedString
    }
}
