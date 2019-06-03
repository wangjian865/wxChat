//
//  WXFoldingCell.swift
//  WXChat
//
//  Created by WDX on 2019/5/28.
//  Copyright © 2019 WDX. All rights reserved.
//

import UIKit

class WXFoldingCell: FoldingCell {

    override func awakeFromNib() {
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        super.awakeFromNib()
    }
    
    override func animationDuration(_ itemIndex: NSInteger, type _: FoldingCell.AnimationType) -> TimeInterval {
        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }
    
}
