//
//  FriendModel.h
//  WXChat
//
//  Created by WX on 2019/7/16.
//  Copyright © 2019 WDX. All rights reserved.
//
/*
 *
 "tgusetid": "078910",
 "tgusetname": "哈哈1",
 "tgusetaccount": "123456",
 "tgusetpassword": null,
 "tgusetimg": "url1",
 "tgusetcompany": "娃哈哈1",
 "tgusetposition": "boss1",
 "tgusetreghtdate": null,
 "tgusetsex": "nv",
 "tgusetadbox": null,
 "tgusetsalt": null,
 "tgusetnterprise": null,
 "seanceshows": null,
 "friendid": null,
 "friendtgusetid": null,
 "friendfriendid": "078910",
 "friendaddtime": 1560487675000,
 "friendrecord": "三号
 */
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FriendModel : NSObject
@property (nonatomic, copy)NSString *tgusetid;
@property (nonatomic, copy)NSString *tgusetname;
@property (nonatomic, copy)NSString *tgusetaccount;
@property (nonatomic, copy)NSString *tgusetpassword;
@property (nonatomic, copy)NSString *tgusetimg;
@property (nonatomic, copy)NSString *tgusetcompany;
@property (nonatomic, copy)NSString *tgusetposition;
@property (nonatomic, copy)NSString *tgusetreghtdate;
@property (nonatomic, copy)NSString *tgusetsex;
@property (nonatomic, copy)NSString *tgusetsalt;
@property (nonatomic, copy)NSString *tgusetnterprise;
@property (nonatomic, copy)NSString *seanceshows;
@property (nonatomic, copy)NSString *friendid;
@property (nonatomic, copy)NSString *friendtgusetid;
@property (nonatomic, copy)NSString *friendfriendid;
@property (nonatomic, copy)NSString *friendaddtime;
@property (nonatomic, copy)NSString *friendrecord;

///好友申请列表字段
//@property (nonatomic, assign)long long friendshowktime;
/////申请附带的文字
//@property (nonatomic, copy)NSString *friendshowcontext;
/////好友id
//@property (nonatomic, copy)NSString *friendshowfuserid;
/////用户是否同意
@end

NS_ASSUME_NONNULL_END
