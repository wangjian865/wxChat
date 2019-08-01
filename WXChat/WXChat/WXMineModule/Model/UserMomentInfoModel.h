//
//  UserMomentInfoModel.h
//  WXChat
//
//  Created by WX on 2019/7/28.
//  Copyright © 2019 WDX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserMomentInfoModel : NSObject
///图片
@property (nonatomic, strong) NSArray<NSString *> *urlName;
///职位
@property (nonatomic, copy) NSString *tgusetPosition;
///头像
@property (nonatomic, copy) NSString *tgusetImg;
///账号  手机号
@property (nonatomic, copy) NSString *tgusetAccount;
///用户名
@property (nonatomic, copy) NSString *tgusetName;
///性别
@property (nonatomic, copy) NSString *tgusetSex;
///id
@property (nonatomic, copy) NSString *tgusetId;
///公司
@property (nonatomic, copy) NSString *tgusetCompany;
@end

NS_ASSUME_NONNULL_END
