//
//  CompanyFooter.swift
//  login
//
//  Created by gwj on 2019/7/1.
//  Copyright © 2019 com.ailearn.student. All rights reserved.
//

import UIKit

class CompanyFooter: UIView {
    
    var createActionClosure: (()->Void)?
    var joinActionClosure: (()->Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func createCompany(_ sender: UIButton) {
        createActionClosure?()
    }
    
    @IBAction func joinCompany(_ sender: UIButton) {
        joinActionClosure?()
    }
    

    
}
