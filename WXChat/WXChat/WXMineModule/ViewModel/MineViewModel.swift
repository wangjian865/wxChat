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
    @objc class func getUserInfo(_ account: String = "",
                           success: @escaping (_ model: UserInfoModel?) ->(),
                           failure: @escaping (_ error: NSError?) ->()) {
        var params: [String:Any] = [:]
        if account == ""{
            params = ["tgusetaccount":WXAccountTool.getUserPhone()]
        }else{
            params = ["tgusetaccount":account]
        }
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
    @objc class func addFriend(friendID: String,
                               context: String,
                               success: @escaping (_ response: String?) ->(),
                               failure: @escaping (_ error: NSError?) ->()) {
        
        let params = ["friendshowfuserid":friendID,"friendshowcontext":"交个朋友吧","friendshowtgusetname":"简问用户"]
        WXNetWorkTool.request(with: .post, urlString: WXApiManager.getRequestUrl("userFriend/addUserFriendConSend"), parameters: params, successBlock: { (result) in
            
            let resultModel = WXBaseModel.yy_model(with: result as! [String : Any])
            guard let temp = resultModel else {return }
            if temp.code.elementsEqual("200"){
                let temp = result as! [String : Any]
//                let str = temp["data"] as! String
                success("成功")
            }
        }) { (error) in
            
        }
    }
    //删除好友
    @objc class func deleteFriend(friendID: String,
                            success: @escaping (_ response: [String: Any]?) ->(),
                            failure: @escaping (_ error: NSError?) ->()){
        let urlString =  WXApiManager.getRequestUrl("manKeepToken/deleteFriend")
        let params:[String:Any] = ["friendfriendid":friendID]
        WXNetWorkTool.request(with: .post, urlString: urlString, parameters: params, successBlock: { (result) in
            success(result as? [String : Any])
        }) { (error) in
            
        }
    }
    ///判断用户是否为好友
    @objc class func judgeIsFriend(friendID: String,
                                   success: @escaping (_ response: String?) ->(),
                                   failure: @escaping (_ error: NSError?) ->()){
        let urlString =  WXApiManager.getRequestUrl("userFriend/SelectFriendBoolean")
        let params:[String:Any] = ["friendfriendid":friendID]
        WXNetWorkTool.request(with: .post, urlString: urlString, parameters: params, successBlock: { (result) in
            let resultModel = WXBaseModel.yy_model(with: result as! [String : Any])
            guard let temp = resultModel else {return }
            if temp.code.elementsEqual("200"){
                let temp = result as! [String : Any]
                let isFriend = temp["data"] as! Bool
                if isFriend{
                    success("是")
                }else{
                    success("否")
                }
            }
        }) { (error) in
            
        }
    }
    ///获取好友申请列表
    @objc class func getAddFriendList(success: @escaping (_ response: [WXMessageAlertModel]?) ->(),
                                      failure: @escaping (_ error: NSError?) ->()){
        let urlString =  WXApiManager.getRequestUrl("userFriend/selectUserFriendConSend")
        let params:[String:Any] = [:]
        WXNetWorkTool.request(with: .post, urlString: urlString, parameters: params, successBlock: { (temp) in
            let resultModel = WXBaseModel.yy_model(with: temp as! [String : Any])
            guard let result = resultModel else {return }
            if result.code.elementsEqual("200"){
                //转换模型数组
                if let successData = temp as? [String:Any] {
                    if let datas = successData["data"] as? [[String:Any]]{
                        var models :[WXMessageAlertModel] = []
                        for item in datas{
                            let model = WXMessageAlertModel.yy_model(with: item)
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
    ///同意/拒绝好友申请  1:同意 2:拒绝
    @objc class func handleFriendRequest(ifAgree: String,
                                         showId: String,
                                         success: @escaping (_ response: String?) ->(),
                                         failure: @escaping (_ error: NSError?) ->()){
        let urlString =  WXApiManager.getRequestUrl("userFriend/updateUserFriendConSend")
        let params:[String:Any] = ["friendshowifconsend":ifAgree,"friendshowid":showId]
        WXNetWorkTool.request(with: .post, urlString: urlString, parameters: params, successBlock: { (succsee) in
            success("成功")
        }) { (error) in
            
        }
    }
    ///删除好友请求
    @objc class func deleteAddRequest(showId: String,
                                      success: @escaping (_ response: String?) ->(),
                                      failure: @escaping (_ error: NSError?) ->()){
        let urlString =  WXApiManager.getRequestUrl("userFriend/deleteUserFriendConSendRecord")
        let params:[String:Any] = ["friendshowid":showId]
        WXNetWorkTool.request(with: .post, urlString: urlString, parameters: params, successBlock: { (succsee) in
            success("成功")
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
    class func updateUserInfo(nickName: String = "",
                              sex: String = "",
                              company: String = "",
                              position: String = "",
                              success: @escaping (_ response: [String: Any]?) ->(),
                              failure: @escaping (_ error: NSError?) ->()) {
    let urlString =  WXApiManager.getRequestUrl("manKeepToken/updateTgInfo")
        let params:[String:Any] = ["tgusetname":nickName,"tgusetsex":sex,"tgusetcompany":company,"tgusetposition":position]
    WXNetWorkTool.request(with: .post, urlString: urlString, parameters: params, successBlock: { (succsee) in
            success([:])
        }) { (error) in
        
        }
    }
//    参数名称    参数编码
//    用户ID    tgusetid
//    模糊查询参数    tgusetname
    //人脉  获取好友列表
    @objc class func getFriendList(nickName: String = "",
                                   success: @escaping (_ response: [FriendModel]) ->(),
                                   failure: @escaping (_ error: NSError?) ->()) {
        let urlString =  WXApiManager.getRequestUrl("manKeepToken/userFriends")
        let params:[String:Any] = ["tgusetname":nickName]
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
    @objc class func getFriendInfo(friendID: String,
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
                             logofiles: UIImage,
                             companysynopsis: String,
                             companyindustry: String,
                             companyregion: String,
                             success: @escaping (_ response: CompanyModel?) ->(),
                             failure: @escaping (_ error: NSError?) ->()){
        let urlString =  WXApiManager.getRequestUrl("companyAdd/addUserCompany")
        let params:[String:Any] = ["companyname":companyname,"companysynopsis":companysynopsis,"companyindustry":companyindustry,"companyregion":companyregion,"companyaccount":WXAccountTool.getUserPhone(),"companysystem":WXAccountTool.getUserID()]
        WXNetWorkTool.uploadFile(withUrl: urlString, imageName: ["comimg"], image: [logofiles], parameters: params, progressBlock: { (progress) in
            print(progress)
        }, successBlock: { (result) in
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
                                 logofiles: UIImage,
                                 companysynopsis: String,
                                 companyindustry: String,
                                 companyregion: String,
                                 companysystem: String = "",
                                 success: @escaping (_ response: CompanyModel?) ->(),
                                 failure: @escaping (_ error: NSError?) ->()){
        let urlString =  WXApiManager.getRequestUrl("companyAdd/updateCompanyInfo")
        let params:[String:Any] = ["companyid":companyid,"companyname":companyname,"companysynopsis":companysynopsis,"companyindustry":companyindustry,"companyregion":companyregion,"companysystem":companysystem]
        
        WXNetWorkTool.uploadFile(withUrl: urlString, imageName: ["logofiles"], image: [logofiles], parameters: params, progressBlock: { (progress) in
            print(progress)
        }, successBlock: { (result) in
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
                success([:])
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
                success([:])
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
                success([:])
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
        let urlString =  WXApiManager.getRequestUrl("company/addComAdm")
        let params:[String:Any] = ["tgusetids":tgusetids,"seanceshowidadmincompanyid":seanceshowidadmincompanyid]
        WXNetWorkTool.request(with: .post, urlString: urlString, parameters: params, successBlock: { (result) in
            print(result)
            let resultModel = WXBaseModel.yy_model(with: result as! [String : Any])
            guard let result = resultModel else {return }
            if result.code.elementsEqual("200"){
                MBProgressHUD.showSuccess("添加成功")
                success([:])
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
        let urlString =  WXApiManager.getRequestUrl("manKeepToken/deleteComTg")
        let params:[String:Any] = ["companytgusettgusetids":companysystem,"companytgusetcompanyid":companyid]
        WXNetWorkTool.request(with: .post, urlString: urlString, parameters: params, successBlock: { (result) in
            print(result)
            let resultModel = WXBaseModel.yy_model(with: result as! [String : Any])
            guard let result = resultModel else {return }
            if result.code.elementsEqual("200"){
                success([:])
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
                success([:])
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
    //个人人脉展示
    class func getPersonalInfo(userID: String,
                                   success: @escaping (_ response: UserMomentInfoModel?) ->(),
                                   failure: @escaping (_ error: NSError?) ->()) {
        let urlString =  WXApiManager.getRequestUrl("manKeepToken/selectUserFriendE")
        let params:[String:Any] = ["tgusetid":userID]
        WXNetWorkTool.request(with: .post, urlString: urlString, parameters: params, successBlock: { (temp) in
            let resultModel = WXBaseModel.yy_model(with: temp as! [String : Any])
            guard let result = resultModel else {return }
            if result.code.elementsEqual("200"){
                //转换模型数组
                if let successData = temp as? [String:Any] {
                    if let datas = successData["data"] as? [String:Any]{
                        let model = UserMomentInfoModel.yy_model(with: datas)
                        //遍历结束回调
                        success(model)
                    }
                }
                
            }else{
                //code != 200的情况
            }
        }) { (error) in
            
        }
    }
    ///用户申请加入公司
    @objc class func addCompanyApply(companyId: String,
                                     success: @escaping (_ response: String?) ->(),
                                     failure: @escaping (_ error: NSError?) ->()) {
        let urlString =  WXApiManager.getRequestUrl("company/addComApproval")
        let params:[String:Any] = ["approvalTgusetid":WXAccountTool.getUserID(),"approvalTgusetname":WXAccountTool.getUserName(),"approvalCompanyid":companyId]
        WXNetWorkTool.request(with: .post, urlString: urlString, parameters: params, successBlock: { (temp) in
            let resultModel = WXBaseModel.yy_model(with: temp as! [String : Any])
            guard let result = resultModel else {return }
            if result.code.elementsEqual("200"){
                success(result.msg)
            }else{
                //code != 200的情况
            }
        }) { (error) in
            
        }
    }
    ///获取群聊列表
    @objc class func getChatGroupList(success: @escaping (_ response: GroupListModel?) ->(),
                                 failure: @escaping (_ error: NSError?) ->()) {
        let urlString =  WXApiManager.getRequestUrl("manKeepToken/getSeaByTgid")
        let params:[String:Any] = ["tgusetid":WXAccountTool.getUserID()]
        WXNetWorkTool.request(with: .post, urlString: urlString, parameters: params, successBlock: { (temp) in
            let resultModel = WXBaseModel.yy_model(with: temp as! [String : Any])
            guard let result = resultModel else {return }
            if result.code.elementsEqual("200"){
                //转换模型数组
                if let successData = temp as? [String:Any] {
                    let model = GroupListModel.yy_model(with: successData)
                    success(model)
                }
                
            }else{
                //code != 200的情况
            }
        }) { (error) in
            
        }
    }
    //查看群聊下的用户
    class func getChatGroupUsers(groupId: String,
                               success: @escaping (_ response: [FriendModel]?) ->(),
                               failure: @escaping (_ error: NSError?) ->()) {
        let urlString =  WXApiManager.getRequestUrl("manKeepToken/getTgBySeaid")
        let params:[String:Any] = ["seancetgusetseanceshowid":groupId]
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
    ///创建群聊
    @objc class func createChatGroup(userIds: [String],
                               success: @escaping (_ response: String?) ->(),
                               failure: @escaping (_ error: NSError?) ->()) {
        let urlString =  WXApiManager.getRequestUrl("manKeepToken/addSea")
        let params:[String:Any] = ["seanceshowadmin":WXAccountTool.getUserID(),"tgusetids":userIds]
        WXNetWorkTool.request(with: .post, urlString: urlString, parameters: params, successBlock: { (temp) in
            let resultModel = WXBaseModel.yy_model(with: temp as! [String : Any])
            guard let result = resultModel else {return }
            if result.code.elementsEqual("200"){
                //转换模型数组
                if let successData = temp as? [String:Any] {
                    if let datas = successData["data"] as? String{
                        //遍历结束回调
                        success(datas)
                    }
                }
                
            }else{
                //code != 200的情况
            }
        }) { (error) in
            
        }
    }
    ///退出群聊
    @objc class func leaveChatGroup(groupId: String,
                                    success: @escaping (_ response: String?) ->(),
                                    failure: @escaping (_ error: NSError?) ->()) {
        let urlString =  WXApiManager.getRequestUrl("manKeepToken/outFromSea")
        let params:[String:Any] = ["seanceshowadmin":WXAccountTool.getUserID(),"seanceshowid":groupId]
        WXNetWorkTool.request(with: .post, urlString: urlString, parameters: params, successBlock: { (temp) in
            let resultModel = WXBaseModel.yy_model(with: temp as! [String : Any])
            guard let result = resultModel else {return }
            if result.code.elementsEqual("200"){
                success("success")
            }else{
                //code != 200的情况
            }
        }) { (error) in
            
        }
    }
    ///修改群组名
    class func renameChatGroup(managerID: String,
                               groupName: String,
                               groupId: String,
                               success: @escaping (_ response: String?) ->(),
                               failure: @escaping (_ error: NSError?) ->()){
        let urlString =  WXApiManager.getRequestUrl("manKeepToken/updateSeaName")
        let params:[String:Any] = ["seanceshowadmin":managerID,"seanceshowname":groupName,"seanceshowid":groupId]
        WXNetWorkTool.request(with: .post, urlString: urlString, parameters: params, successBlock: { (temp) in
            let resultModel = WXBaseModel.yy_model(with: temp as! [String : Any])
            guard let result = resultModel else {return }
            if result.code.elementsEqual("200"){
                success(result.msg)
            }else{
                //code != 200的情况
            }
        }) { (error) in
            
        }
    }
    ///添加群成员
    class func addGroupMember(groupID: String,
                              users: [String],
                              success: @escaping (_ response: String?) ->(),
                              failure: @escaping (_ error: NSError?) ->()){
        let urlString =  WXApiManager.getRequestUrl("manKeepToken/addSeaTg")
        let params:[String:Any] = ["seanceshowid":groupID,"tgusetids":users]
        WXNetWorkTool.request(with: .post, urlString: urlString, parameters: params, successBlock: { (temp) in
            let resultModel = WXBaseModel.yy_model(with: temp as! [String : Any])
            guard let result = resultModel else {return }
            if result.code.elementsEqual("200"){
                success(result.msg)
            }else{
                //code != 200的情况
            }
        }) { (error) in
            
        }
    }
    ///转让群聊
    class func changeOwner(groupID: String,
                           newOwnerID: String,
                           success: @escaping (_ response: String?) ->(),
                           failure: @escaping (_ error: NSError?) ->()){
        let urlString =  WXApiManager.getRequestUrl("manKeepToken/updateSeaadmin")
        //触发转让操作意味着本人是群主
        let params:[String:Any] = ["seanceshowid":groupID,"newAdminId":newOwnerID,"seanceshowadmin":WXAccountTool.getUserID()]
        WXNetWorkTool.request(with: .post, urlString: urlString, parameters: params, successBlock: { (temp) in
            let resultModel = WXBaseModel.yy_model(with: temp as! [String : Any])
            guard let result = resultModel else {return }
            if result.code.elementsEqual("200"){
                success(result.msg)
            }else{
                //code != 200的情况
            }
        }) { (error) in
            
        }
    }
    ///获取群主信息
    class func getGroupAdmin(groupID: String,
                             success: @escaping (_ response: String?) ->(),
                             failure: @escaping (_ error: NSError?) ->()){
        let urlString =  WXApiManager.getRequestUrl("manKeepToken/getSeaAdminInfo")
        let params:[String:Any] = ["seanceshowid":groupID]
        WXNetWorkTool.request(with: .post, urlString: urlString, parameters: params, successBlock: { (temp) in
            let resultModel = WXBaseModel.yy_model(with: temp as! [String : Any])
            guard let result = resultModel else {return }
            if result.code.elementsEqual("200"){
                let model = UserInfoModel.yy_model(with: result.data)
                success(model?.tgusetid)
            }else{
                //code != 200的情况
            }
        }) { (error) in
            
        }
    }
    ///退出登录
    class func logoutRequest(success: @escaping (_ response: String?) ->(),
                             failure: @escaping (_ error: NSError?) ->()){
        let urlString =  WXApiManager.getRequestUrl("manKeep/loginOut")
        let params:[String:Any] = [:]
        WXNetWorkTool.request(with: .post, urlString: urlString, parameters: params, successBlock: { (temp) in
            let resultModel = WXBaseModel.yy_model(with: temp as! [String : Any])
            guard let result = resultModel else {return }
            if result.code.elementsEqual("200"){
                success("成功")
            }else{
                //code != 200的情况
            }
        }) { (error) in
            
        }
    }
}

