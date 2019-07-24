//
//  CompanyModel.h
//  WXChat
//
//  Created by WX on 2019/7/21.
//  Copyright © 2019 WDX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class FriendModel;
@interface CompanyModel : NSObject
//"companyid": 670845,
//"companyname": "娃哈哈1",
//"companycount": null,
//"companysynopsis": "是个垃圾公司1",
//"companylogo": "URL",
//"companyaddtime": null,
//"companyindustry": "服务1",
//"companyregion": "上海浦东1",
//"companysystem": "123456",
//"companyadmin": null,
//"companymaxuser": null
@property (nonatomic, copy)NSString *companyid;
@property (nonatomic, copy)NSString *companyname;
@property (nonatomic, copy)NSString *companycount;
@property (nonatomic, copy)NSString *companysynopsis;
@property (nonatomic, copy)NSString *companylogo;
@property (nonatomic, copy)NSString *companyaddtime;
@property (nonatomic, copy)NSString *companyindustry;
@property (nonatomic, copy)NSString *companyregion;
@property (nonatomic, copy)NSString *companysystem;
@property (nonatomic, copy)NSString *companyadmin;
@property (nonatomic, copy)NSString *companymaxuser;
@property (nonatomic, strong)NSArray<FriendModel *> *users;
@end

NS_ASSUME_NONNULL_END
