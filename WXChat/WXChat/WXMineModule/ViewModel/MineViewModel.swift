//
//  MineViewModel.swift
//  WXChat
//
//  Created by WX on 2019/7/17.
//  Copyright © 2019 WDX. All rights reserved.
//

import Foundation
class MineViewModel: NSObject {
    //获取个人信息
    class func getUserInfo(success: @escaping (_ model: UserInfoModel?) ->(),
                           failure: @escaping (_ error: NSError?) ->()) {
        let params = ["tgusetaccount":WXAccountTool.getUserPhone()]
        WXNetWorkTool.request(with: .post, urlString: WXApiManager.getRequestUrl("manKeepToken/findUserAccount"), parameters: params, successBlock: { (result) in
            print(result)
            let resultModel = WXBaseModel.yy_model(with: result as! [String : Any])
            guard let result = resultModel else {return }
            if result.code.elementsEqual("200"){
                //获取到用户信息并存储
                let model = UserInfoModel.yy_model(with: result.data)
                success(model)
                if let temp = model{
                    WXCacheTool.wx_saveModel(temp, key: "userInfo")
                }
            }
        }) { (error) in
            failure(error as NSError)
        }
    }
    //添加好友
//    class func addFriend() {
//
//    }
    //删除好友
    class func deleteFriend(friendID: String,
                            success: @escaping (_ response: [String: Any]?) ->(),
                            failure: @escaping (_ error: NSError?) ->()){
        let urlString =  WXApiManager.getRequestUrl("manKeepToken/deletefriend")
        let params:[String:Any] = ["friendtgusetid":"","friendfriendid":friendID]
        WXNetWorkTool.request(with: .post, urlString: urlString, parameters: params, successBlock: { (succsee) in
            
        }) { (error) in
            
        }
    }
    //更新头像
    class func updateUserIcon(image: UIImage,
                              success: @escaping (_ response: [String: Any]?) ->(),
                              failure: @escaping (_ error: NSError?) ->()){
        let urlString =  WXApiManager.getRequestUrl("manKeepToken/updateTgInfoImg")
        let params:[String:Any] = ["tgusetid":"","imgs":"","tgusetaccount":""]
        WXNetWorkTool.request(with: .post, urlString: urlString, parameters: params, successBlock: { (succsee) in
            
        }) { (error) in
            
        }
    }
    //修改用户信息
    class func updateUserInfo(id: String = "",
                              nickName: String = "",
                              sex: String = "",
                              company: String = "",
                              position: String = "",
                              success: @escaping (_ response: [String: Any]?) ->(),
                              failure: @escaping (_ error: NSError?) ->()) {
    let urlString =  WXApiManager.getRequestUrl("manKeepToken/updateTgInfo")
        let params:[String:Any] = ["tgusetid":id,"tgusetname":nickName,"tgusetsex":sex,"tgusetcompany":company,"codes":position]
    WXNetWorkTool.request(with: .post, urlString: urlString, parameters: params, successBlock: { (succsee) in
    
        }) { (error) in
        
        }
    }
//    参数名称    参数编码
//    用户ID    tgusetid
//    模糊查询参数    tgusetname
    //人脉  获取好友列表
    class func getFriendList(nickName: String = "",
                             success: @escaping (_ response: [FriendModel]) ->(),
                             failure: @escaping (_ error: NSError?) ->()) {
        let urlString =  WXApiManager.getRequestUrl("manKeepToken/showTgusetFriendList")
        let params:[String:Any] = ["tgusetid":WXAccountTool.getUserID(),"tgusetname":nickName]
        WXNetWorkTool.request(with: .post, urlString: urlString, parameters: params, successBlock: { (temp) in
            let resultModel = WXBaseModel.yy_model(with: temp as! [String : Any])
            guard let result = resultModel else {return }
            if result.code.elementsEqual("200"){
                //转换模型数组
                if let successData = temp as? [String:Any] {
                    if let datas = successData["data"] as? [[String:Any]]{
                        var models :[FriendModel] = []
                        for item in datas{
                            let model = FriendModel.yy_model(with: item)
                            if let mo = model{
                                models.append(mo)
                            }
                            
                        }
                        //遍历结束回调
                        success(models)
                    }
                }
                
                
            }else{
                //code != 200的情况
            }
        }) { (error) in
            
        }
    }
    //人脉 好友详情
    class func getFriendInfo(friendID: String,
                             success: @escaping (_ response: FriendModel?) ->(),
                             failure: @escaping (_ error: NSError?) ->()) {
        let urlString =  WXApiManager.getRequestUrl("manKeepToken/showFriendInfo")
        let params:[String:Any] = ["friendid":friendID]
        WXNetWorkTool.request(with: .post, urlString: urlString, parameters: params, successBlock: { (result) in
            print(result)
            let resultModel = WXBaseModel.yy_model(with: result as! [String : Any])
            guard let result = resultModel else {return }
            if result.code.elementsEqual("200"){
                //转换模型数组
                let model = FriendModel.yy_model(with: result.data)
                success(model)
            }else{
                print(result.msg)
            }
        }) { (error) in
            
        }
    }
    
    //人脉 创建公司
    /*
     String    companyname    2-40个字符    True    公司名称
     String    logofiles    图片    True    公司logo(路径)
     String    companysynopsis
     True    公司简介
     String    companyindustry    2-40个字符    True    公司行业
     String    companyregion    2-40个字符    True    公司地区
     String    tgusetaccount        true    用户手机号
     */
    class func createCompany(companyname: String,
                             logofiles: String,
                             companysynopsis: String,
                             companyindustry: String,
                             companyregion: String,
                             tgusetaccount: String,
                             success: @escaping (_ response: CompanyModel?) ->(),
                             failure: @escaping (_ error: NSError?) ->()){
        let urlString =  WXApiManager.getRequestUrl("manKeepToken/createCompany")
        let params:[String:Any] = ["companyname":companyname,"logofiles":logofiles,"companysynopsis":companysynopsis,"companyindustry":companyindustry,"companyregion":companyregion,"tgusetaccount":tgusetaccount]
//        WXNetWorkTool.uploadFile(withUrl: urlString, image: UIImage.init(named: "normal_icon")!, parameters: params, successBlock: { (success) in
//
//        }) { (error) in
//
//        }
        WXNetWorkTool.request(with: .post, urlString: urlString, parameters: params, successBlock: { (result) in
            print(result)
            let resultModel = WXBaseModel.yy_model(with: result as! [String : Any])
            guard let result = resultModel else {return }
            if result.code.elementsEqual("200"){
                //转换模型数组
                let model = CompanyModel.yy_model(with: result.data)
                success(model)
            }else{
                print(result.msg)
            }
        }) { (error) in

        }
    }
    //人脉 公司修改
    class func updateCompanyInfo(companyid: String,
                                 companyname: String,
                                 logofiles: String,
                                 companysynopsis: String,
                                 success: @escaping (_ response: CompanyModel?) ->(),
                                 failure: @escaping (_ error: NSError?) ->()){
        let urlString =  WXApiManager.getRequestUrl("manKeepToken/updateCompanyInfo")
        let params:[String:Any] = ["companyid":companyid,"companyname":companyname,"logofiles":logofiles,"companysynopsis":companysynopsis]
        WXNetWorkTool.request(with: .post, urlString: urlString, parameters: params, successBlock: { (result) in
            print(result)
            let resultModel = WXBaseModel.yy_model(with: result as! [String : Any])
            guard let result = resultModel else {return }
            if result.code.elementsEqual("200"){
                //转换模型数组
                let model = CompanyModel.yy_model(with: result.data)
                success(model)
            }else{
                print(result.msg)
            }
        }) { (error) in
            
        }
    }
    //人脉 解散公司   over
    class func deleCompany(companyid: String,
                           success: @escaping (_ response: [String:Any]?) ->(),
                           failure: @escaping (_ error: NSError?) ->()){
        let urlString =  WXApiManager.getRequestUrl("manKeepToken/deleteCom")
        let params:[String:Any] = ["companyid":companyid]
        WXNetWorkTool.request(with: .post, urlString: urlString, parameters: params, successBlock: { (result) in
            print(result)
            let resultModel = WXBaseModel.yy_model(with: result as! [String : Any])
            guard let result = resultModel else {return }
            if result.code.elementsEqual("200"){
                MBProgressHUD.showSuccess("公司已解散")
            }else{
                print(result.msg)
            }
        }) { (error) in
            
        }
    }
    //人脉 添加公司用户
    //id 用,分割
    class func addCompanyUser(companytgusettgusetids: String,
                              companytgusetcompanyid: String,
                              success: @escaping (_ response: [String:Any]?) ->(),
                              failure: @escaping (_ error: NSError?) ->()){
        let urlString =  WXApiManager.getRequestUrl("manKeepToken/addComTg")
        let params:[String:Any] = ["companytgusettgusetids":companytgusettgusetids,"companytgusetcompanyid":companytgusetcompanyid]
        WXNetWorkTool.request(with: .post, urlString: urlString, parameters: params, successBlock: { (result) in
            print(result)
            let resultModel = WXBaseModel.yy_model(with: result as! [String : Any])
            guard let result = resultModel else {return }
            if result.code.elementsEqual("200"){
                MBProgressHUD.showSuccess("添加成功")
            }else{
                print(result.msg)
            }
        }) { (error) in
            
        }
    }
    //人脉 退出公司
    class func leaveCompany(companyid: String,
                            success: @escaping (_ response: [String:Any]?) ->(),
                            failure: @escaping (_ error: NSError?) ->()) {
        let urlString =  WXApiManager.getRequestUrl("company/deleteCompanyT")
        let params:[String:Any] = ["companyid":companyid]
        WXNetWorkTool.request(with: .post, urlString: urlString, parameters: params, successBlock: { (result) in
            print(result)
            let resultModel = WXBaseModel.yy_model(with: result as! [String : Any])
            guard let result = resultModel else {return }
            if result.code.elementsEqual("200"){
                MBProgressHUD.showSuccess("已退出")
            }else{
                print(result.msg)
            }
        }) { (error) in
            
        }
    }
    //人脉 添加公司管理员
    //tgusetids可以传多个   用,分割
    class func addCompanyAdmin(tgusetids: String,
                               seanceshowidadmincompanyid: String,
                               success: @escaping (_ response: [String:Any]?) ->(),
                               failure: @escaping (_ error: NSError?) ->()) {
        let urlString =  WXApiManager.getRequestUrl("manKeepToken/addComAdm")
        let params:[String:Any] = ["tgusetids":tgusetids,"seanceshowidadmincompanyid":seanceshowidadmincompanyid]
        WXNetWorkTool.request(with: .post, urlString: urlString, parameters: params, successBlock: { (result) in
            print(result)
            let resultModel = WXBaseModel.yy_model(with: result as! [String : Any])
            guard let result = resultModel else {return }
            if result.code.elementsEqual("200"){
                MBProgressHUD.showSuccess("添加成功")
            }else{
                print(result.msg)
            }
        }) { (error) in
            
        }
    }
    //人脉  删除公司人员
//    companysystem 可以穿多个   ,分隔
    class func deleCompanyUser(companysystem: String,
                                companyid: String,
                                success: @escaping (_ response: [String:Any]?) ->(),
                                failure: @escaping (_ error: NSError?) ->()) {
        let urlString =  WXApiManager.getRequestUrl("company/companyDeleteUser")
        let params:[String:Any] = ["companysystem":companysystem,"companyid":companyid]
        WXNetWorkTool.request(with: .post, urlString: urlString, parameters: params, successBlock: { (result) in
            print(result)
            let resultModel = WXBaseModel.yy_model(with: result as! [String : Any])
            guard let result = resultModel else {return }
            if result.code.elementsEqual("200"){
                MBProgressHUD.showSuccess("已删除")
            }else{
                print(result.msg)
            }
        }) { (error) in
            
        }
    }
    //人脉 删除公司管理员
    //seanceshowidadmincompanyid: 公司id
//    tgusetids  用户id
    class func deleCompanyAdmin(tgusetids: String,
                                seanceshowidadmincompanyid: String,
                                success: @escaping (_ response: [String:Any]?) ->(),
                                failure: @escaping (_ error: NSError?) ->()) {
        let urlString =  WXApiManager.getRequestUrl("company/deleteComAdm")
        let params:[String:Any] = ["tgusetids":tgusetids,"seanceshowidadmincompanyid":seanceshowidadmincompanyid]
        WXNetWorkTool.request(with: .post, urlString: urlString, parameters: params, successBlock: { (result) in
            print(result)
            let resultModel = WXBaseModel.yy_model(with: result as! [String : Any])
            guard let result = resultModel else {return }
            if result.code.elementsEqual("200"){
                MBProgressHUD.showSuccess("已删除")
            }else{
                print(result.msg)
            }
        }) { (error) in
            
        }
    }
    //人脉 查询用户的公司
    class func searchUserCompanys(success: @escaping (_ response: [CompanyModel]?) ->(),
                                  failure: @escaping (_ error: NSError?) ->()) {
        let urlString =  WXApiManager.getRequestUrl("company/selectUserCompanys")
        let params:[String:Any] = [:]
        WXNetWorkTool.request(with: .post, urlString: urlString, parameters: params, successBlock: { (temp) in
            let resultModel = WXBaseModel.yy_model(with: temp as! [String : Any])
            guard let result = resultModel else {return }
            if result.code.elementsEqual("200"){
                //转换模型数组
                if let successData = temp as? [String:Any] {
                    if let datas = successData["data"] as? [[String:Any]]{
                        var models :[CompanyModel] = []
                        for item in datas{
                            let model = CompanyModel.yy_model(with: item)
                            if let mo = model{
                                models.append(mo)
                            }
                            
                        }
                        //遍历结束回调
                        success(models)
                    }
                }
                
                
            }else{
                //code != 200的情况
            }
        }) { (error) in
            
        }
    }
    //搜索公司
    //用户搜索公司
    //公司id
    class func searchCompany(companyid: String,
                              success: @escaping (_ response: CompanyModel?) ->(),
                              failure: @escaping (_ error: NSError?) ->()) {
        let urlString =  WXApiManager.getRequestUrl("company/selectCompany")
        let params:[String:Any] = ["companyid":companyid,"companytgusettgusetid":WXAccountTool.getUserID()]
        WXNetWorkTool.request(with: .post, urlString: urlString, parameters: params, successBlock: { (result) in
            print(result)
            let resultModel = WXBaseModel.yy_model(with: result as! [String : Any])
            guard let result = resultModel else {return }
            if result.code.elementsEqual("200"){
                let model = CompanyModel.yy_model(with: result.data)
                success(model)
            }else{
                print(result.msg)
            }
        }) { (error) in
            
        }
    }
    
    //查询公司用户
    class func getCompanyUserList(companyid: String,
                                  success: @escaping (_ response: [SearchUserModel]?) ->(),
                                  failure: @escaping (_ error: NSError?) ->()) {
        let urlString =  WXApiManager.getRequestUrl("company/companyUsers")
        let params:[String:Any] = ["companyid":companyid]
        WXNetWorkTool.request(with: .post, urlString: urlString, parameters: params, successBlock: { (temp) in
            let resultModel = WXBaseModel.yy_model(with: temp as! [String : Any])
            guard let result = resultModel else {return }
            if result.code.elementsEqual("200"){
                //转换模型数组
                if let successData = temp as? [String:Any] {
                    if let datas = successData["data"] as? [[String:Any]]{
                        var models :[SearchUserModel] = []
                        for item in datas{
                            let model = SearchUserModel.yy_model(with: item)
                            if let mo = model{
                                models.append(mo)
                            }
                            
                        }
                        //遍历结束回调
                        success(models)
                    }
                }
                
                
            }else{
                //code != 200的情况
            }
        }) { (error) in
            
        }
    }
    
    //查询公司管理员
    class func getCompanyAdminList(companyid: String,
                                  success: @escaping (_ response: [SearchUserModel]?) ->(),
                                  failure: @escaping (_ error: NSError?) ->()) {
        let urlString =  WXApiManager.getRequestUrl("company/companyUserAdmins")
        let params:[String:Any] = ["companyid":companyid]
        WXNetWorkTool.request(with: .post, urlString: urlString, parameters: params, successBlock: { (temp) in
            let resultModel = WXBaseModel.yy_model(with: temp as! [String : Any])
            guard let result = resultModel else {return }
            if result.code.elementsEqual("200"){
                //转换模型数组
                if let successData = temp as? [String:Any] {
                    if let datas = successData["data"] as? [[String:Any]]{
                        var models :[SearchUserModel] = []
                        for item in datas{
                            let model = SearchUserModel.yy_model(with: item)
                            if let mo = model{
                                models.append(mo)
                            }
                            
                        }
                        //遍历结束回调
                        success(models)
                    }
                }
                
                
            }else{
                //code != 200的情况
            }
        }) { (error) in
            
        }
    }
    
}

