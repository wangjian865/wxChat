//
//  GroupModel.h
//  WXChat
//
//  Created by WX on 2019/8/1.
//  Copyright © 2019 WDX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GroupModel : NSObject
//"seanceshowid": "1",
//"seanceshowname": "无语中",
//"seanceshowmaxuser": null,
//"seanceshowaddtime": null,
//"seanceshowadmin": "034617",
//"seanceshowcount": 1,
//"tgusets": null,
//"tgusetids": null
///群组id
@property (nonatomic, copy) NSString *seanceshowid;
///群组名
@property (nonatomic, copy) NSString *seanceshowname;
///可能是用户列表?
@property (nonatomic, copy) NSString *seanceshowmaxuser;
///创建时间
@property (nonatomic, copy) NSString *seanceshowaddtime;
///群组人数
@property (nonatomic, copy) NSString *seanceshowcount;
///啥?
@property (nonatomic, copy) NSString *tgusets;
///啥?
@property (nonatomic, copy) NSString *tgusetids;
@end

NS_ASSUME_NONNULL_END
