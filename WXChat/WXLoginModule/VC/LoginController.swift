//
//  ViewController.swift
//  login
//
//  Created by gwj on 2019/6/17.
//  Copyright © 2019 com.ailearn.student. All rights reserved.
//

import UIKit

class LoginController: UIViewController ,UITextViewDelegate{
    @IBOutlet weak var scrollerView: UIScrollView!
    @IBOutlet weak var codeView: ZJLoginView!
    @IBOutlet weak var passwordView: ZJLoginView!
    @IBOutlet weak var loginButton: ZJButton!
    @IBOutlet weak var methodButton: UIButton!
    @IBOutlet weak var icon: UIImageView!
    
    private var isFirstPage = true
    
    var agreementLabel = UITextView()
    var button = UIButton.init(type: .custom)
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultSetting()
        let text = NSMutableAttributedString(string: "勾选即表示您同意")
        text.addAttribute(NSAttributedString.Key.font,
                          value: UIFont.systemFont(ofSize: 13),
                          range: NSRange(location: 0, length: text.length))
        
        let serviceText = NSMutableAttributedString(string: "《竹简服务协议》")
        serviceText.addAttribute(NSAttributedString.Key.font,
                                 value: UIFont.systemFont(ofSize: 13),
                                 range: NSRange(location: 0, length: serviceText.length))
        
        serviceText.addAttribute(NSAttributedString.Key.link,
                                 value: "http://service",
                                 range: NSRange(location: 0, length: serviceText.length))
        let privateText = NSMutableAttributedString(string: "《隐私策略》")
        privateText.addAttribute(NSAttributedString.Key.font,
                                 value: UIFont.systemFont(ofSize: 13),
                                 range: NSRange(location: 0, length: privateText.length))
        
        privateText.addAttribute(NSAttributedString.Key.link,
                                 value: "http://private",
                                 range: NSRange(location: 0, length: privateText.length))
        // Adding it all together
        text.append(serviceText)
        text.append(privateText)
        agreementLabel.attributedText = text
        agreementLabel.textAlignment = .center
        agreementLabel.delegate = self
        agreementLabel.isEditable = false
        view.addSubview(agreementLabel)
        
        button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "userList_select"), for: .normal)
        view.addSubview(button)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        agreementLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(icon.snp_bottom).offset(15)
            make.height.equalTo(30)
        }
        button.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(40)
            make.centerY.equalTo(self.agreementLabel)
            make.width.height.equalTo(14)
        }
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return false
    }
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if let operation = URL.scheme, operation.elementsEqual("http"){
            let vc = WXWebViewController.init()
            if URL.absoluteString.contains("service"){
                vc.title = "竹简服务协议"
            }else{
                vc.title = "隐私策略"
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        return false
    }
    private func defaultSetting() {
        scrollerView.isPagingEnabled = true
        loginButton.isEnabled = false
        passwordView.type = .password
        codeView.type = .verficationCode
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
        
        params["equipmentId"] = JPUSHService.registrationID() ?? ""
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
            }else if model!.code.elementsEqual("401"){
                MBProgressHUD.showError("登录失败,请检查账号密码是否正确")
            }else{
                if let msg = model?.msg{
                    MBProgressHUD.showError(msg)
                }
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
                UserDefaults.standard.set(model?.tgusetposition, forKey: "userPosition")
                UserDefaults.standard.set(model?.tgusetcompany, forKey: "userCompany")
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
