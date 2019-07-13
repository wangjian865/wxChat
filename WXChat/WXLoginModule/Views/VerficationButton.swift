//
//  VerficationButton.swift
//  login
//
//  Created by gwj on 2019/6/17.
//  Copyright © 2019 com.ailearn.student. All rights reserved.
//

import UIKit

class VerficationButton: UIButton {

    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                setTitle("获取验证码", for: .normal)
                backgroundColor = UIColor(red: 48.0 / 255.0, green: 134.0 / 255.0, blue: 191.0 / 255.0, alpha: 1.0)
                setTitleColor(.white, for: .normal)
            } else {
                addTimer()
                backgroundColor = .lightGray
                setTitleColor(.gray, for: .normal)
            }
        }
    }
    
    var duration = 60
    private var timer: Timer?
    
    private func addTimer() {
        timer = Timer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        if let timer = timer {
            RunLoop.current.add(timer, forMode: .default)
            timer.fire()
        }
    }
    
    @objc private func countDown() {
        
        if duration == 0 {
            timer?.invalidate()
            isEnabled = true
            duration = 60
            setTitle("重新发送(\(duration)秒)", for: .disabled)
            return
        }
        duration -= 1
        setTitle("重新发送(\(duration)秒)", for: .disabled)
    }
}
