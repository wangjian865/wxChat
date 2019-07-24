//
//  MomentViewModel.swift
//  WXChat
//
//  Created by WX on 2019/7/22.
//  Copyright © 2019 WDX. All rights reserved.
//

import Foundation
class MomentViewModel: NSObject {
    
    //查看好友朋友圈
    class func serachMyMoment(success: @escaping (_ model: UserInfoModel?) ->(),
                           failure: @escaping (_ error: NSError?) ->()) {
        let params = ["tgusetaccount":WXAccountTool.getUserPhone()]
        WXNetWorkTool.request(with: .post, urlString: WXApiManager.getRequestUrl("enterprisez/tupshipshow"), parameters: params, successBlock: { (result) in
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
    
}
