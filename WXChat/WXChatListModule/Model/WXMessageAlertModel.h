//
//  WXMessageAlertModel.h
//  WXChat
//
//  Created by WDX on 2019/6/14.
//  Copyright © 2019 WDX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXMessageAlertModel : NSObject
///头像
@property (nonatomic, copy) NSString *avatarUrl;
///姓名
@property (nonatomic, copy) NSString *name;
///描述
@property (nonatomic, copy) NSString *descriptionText;
///状态
@property (nonatomic, copy) NSString *status;


//对接
///id
@property (nonatomic, copy) NSString *friendshowid;
///用户id
@property (nonatomic, copy) NSString *friendshowtgusetid;
///名字
@property (nonatomic, copy) NSString *friendshowtgusetname;
///好友id
@property (nonatomic, copy) NSString *friendshowfuserid;
///发起时间
@property (nonatomic, copy) NSString *friendshowktime;
///结束时间
@property (nonatomic, copy) NSString *friendshowjtime;
///备注验证
@property (nonatomic, copy) NSString *friendshowcontext;
///用户是否已同意 (0:申请 1:通过 2:拒绝)
@property (nonatomic, copy) NSString *friendshowifconsend;
///账号
@property (nonatomic, copy) NSString *tgusetAccount;
///头像
@property (nonatomic, copy) NSString *tgusetImg;

//"friendshowid": 8,
//"friendshowtgusetid": "201465",
//"friendshowfuserid": "00006",
//"friendshowktime": 1563254125000,
//"friendshowjtime": 1563257459000,
//"friendshowcontext": "加个好友",
//"friendshowifconsend": 1,
//"tgusetAccount": "13257313825",
//"tgusetImg": "http://106.52.2.54:8080/imag/13257313825/picture/6.jpg"

@end

NS_ASSUME_NONNULL_END
