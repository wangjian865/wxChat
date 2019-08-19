//
//  ApprovalModel.h
//  WXChat
//
//  Created by WX on 2019/8/18.
//  Copyright © 2019 WDX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ApprovalModel : NSObject
@property (nonatomic, copy) NSString *approvalId;

@property (nonatomic, copy) NSString *approvalTgusetid;

@property (nonatomic, copy) NSString *approvalTgusetname;

@property (nonatomic, copy) NSString *approvalApprovalid;

@property (nonatomic, copy) NSString *approvalCompanyid;

@property (nonatomic, copy) NSString *approvalContent;

@property (nonatomic, assign) long long approvalCreatetime;

@property (nonatomic, copy) NSString *approvalApprovaltime;

@property (nonatomic, copy) NSString *state;

@property (nonatomic, copy) NSString *tgusetImg;
@end

NS_ASSUME_NONNULL_END
