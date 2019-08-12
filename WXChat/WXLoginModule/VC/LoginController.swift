//
//  ViewController.swift
//  login
//
//  Created by gwj on 2019/6/17.
//  Copyright © 2019 com.ailearn.student. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    @IBOutlet weak var scrollerView: UIScrollView!
    @IBOutlet weak var codeView: ZJLoginView!
    @IBOutlet weak var passwordView: ZJLoginView!
    @IBOutlet weak var loginButton: ZJButton!
    @IBOutlet weak var methodButton: UIButton!
    
    private var isFirstPage = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultSetting()
    }
    
    private func defaultSetting() {
        scrollerView.isPagingEnabled = true
        loginButton.isEnabled = false
        passwordView.type = .password
        codeView.stateChanged = {[weak self](isEnable: Bool) in
            self?.loginButton.isEnabled = isEnable
        }
        passwordView.stateChanged = {[weak self](isEnable: Bool) in
            self?.loginButton.isEnabled = isEnable
        }
    }
    
    @IBAction func getVerficationCode(_ sender: UIButton) {
        print("2")

    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        let account: String
        let pwd: String
        if isFirstPage {
            account = codeView.accountText ?? ""
            pwd = codeView.passwordText ?? ""
        } else {
            account = passwordView.accountText ?? ""
            pwd = passwordView.passwordText ?? ""
        }
        
        //判断手机号码是否合法 ？ 要验证吗？还是直接登录，等后台返回错误信息？
//        if !account.isTelNumber() {
//            print("请输入正确的手机号码")
//        }
        loginRequest(isFirstPage, account, pwd)
        
    }
    func loginRequest(_ isFirst: Bool,_ account: String,_ pwd: String){
        var urlString = ""
        var params:[String:String] = [:]
        if isFirstPage {
            urlString = WXApiManager.getRequestUrl("manKeep/msmLogin")
            params["tgusetaccount"] = account
            params["code"] = pwd
        }else{
            //密码登录
            urlString = WXApiManager.getRequestUrl("manKeep/pwdLogin") 
            params["tgusetaccount"] = account
            params["tgusetpassword"] = pwd
        }
        //    FIXME: 调用登录方法
        
        WXNetWorkTool.request(with: .post, urlString: urlString, parameters: params, successBlock: { (result) in
            print(result)
            let model = WXBaseModel.yy_model(with: result as! [String : Any])
            if model!.code.elementsEqual("200"){
                //登录成功
                //保存token
                let token = model?.data["x-auth-token"] as! String
                let huanxinID = model?.data["account"] as! String
                
                UserDefaults.standard.set(token, forKey: "token")
                UserDefaults.standard.set(account ,forKey: "account")
                UserDefaults.standard.set(huanxinID, forKey: "huanxinID")
                //环信登录成功后切换页面
                AppDelegate.sharedInstance()?.loginStateChange(true, huanxinID: huanxinID)
                self.getUserInfo()
            }
        }) { (error) in
            
            print(error)
        }
        
    }
    //登录成功后请求一下个人数据
    func getUserInfo() {
        let params = ["tgusetaccount":WXAccountTool.getUserPhone()]
        WXNetWorkTool.request(with: .post, urlString: WXApiManager.getRequestUrl("manKeepToken/findUserAccount"), parameters: params, successBlock: { (result) in
            print(result)
            let resultModel = WXBaseModel.yy_model(with: result as! [String : Any])
            guard let result = resultModel else {return }
            if result.code.elementsEqual("200"){
                //获取到用户信息并存储
                let model = UserInfoModel.yy_model(with: result.data)
                UserDefaults.standard.set(model?.tgusetid, forKey: "userID")
                UserDefaults.standard.set(model?.tgusetname, forKey: "userName")
                UserDefaults.standard.set(model?.tgusetimg, forKey: "userImage")
                WXCacheTool.wx_saveModel(model as Any, key: "userInfo")
            }
        }) { (error) in
            
            print(error)
        }
    }
    @IBAction func getPassword(_ sender: UIButton) {
        let vc = GetPasswordViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func loginByPassword(_ sender: UIButton) {
        
        if isFirstPage {
            let point = CGPoint(x: UIScreen.main.bounds.width, y: 0)
            passwordView.reset()
            scrollerView.setContentOffset(point, animated: true)
            methodButton.setTitle("验证码登录", for: .normal)
        } else {
            codeView.reset()
            methodButton.setTitle("密码登录", for: .normal)
            scrollerView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            
        }
        loginButton.isEnabled = false
        isFirstPage.toggle()
    }
}

class AiLabelTextField: UITextField {
    //最小输入字符数
    var limitCount = 6
    
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        super.rightViewRect(forBounds: bounds)
        return CGRect(x: bounds.size.width - 40, y: bounds.midY - 12, width: 24, height: 24)
    }
    
    deinit {
        print("AiLabelTextField dealloc")
    }
}
