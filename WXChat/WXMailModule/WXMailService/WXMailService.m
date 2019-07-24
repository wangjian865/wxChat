//
//  WXMailService.m
//  WXChat
//
//  Created by WX on 2019/7/22.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "WXMailService.h"

@implementation WXMailService
+ (void)loginMail{
    NSString *urlStr = [WXApiManager getRequestUrl:@"oneemail/MailIMAPlogin"];
//    NSDictionary *params = @{@"companyid":textField.text,@"companytgusettgusetid":[WXAccountTool getUserID]};
//    [WXNetWorkTool requestWithType:WXHttpRequestTypePost urlString:urlStr parameters:params successBlock:^(id  _Nonnull responseBody) {
//        NSString *code = [NSString stringWithFormat:@"%@",responseBody[@"code"]];
//        if ([code isEqualToString:@"200"]){
//            //成功
//            self.companyView.hidden = NO;
//            CompanyModel *model = [CompanyModel yy_modelWithJSON:responseBody[@"data"]];
//            [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.companylogo] placeholderImage:[UIImage imageNamed:@"normal_icon"]];
//            self.companyNameLabel.text = model.companyname;
//            self.companyCountLabel.text = [NSString stringWithFormat:@"%@ 人",model.companycount];
//            self.companyDescriptionLabel.text = model.companysynopsis;
//        }else{
//            [MBProgressHUD showError:@"未检索到该公司"];
//            self.companyView.hidden = YES;
//        }
//    } failureBlock:^(NSError * _Nonnull error) {
//        self.companyView.hidden = YES;
//    }];

}
@end
