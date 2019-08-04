//
//  WXApiMacros.h
//  WXChat
//
//  Created by WX on 2019/7/8.
//  Copyright © 2019 WDX. All rights reserved.
//

#ifndef WXApiMacros_h
#define WXApiMacros_h

#define MainURL @"http://106.52.2.54:8080/SMIMQ/"

//获取验证码
#define API_LoginModule_getMessageCode @"manKeep/checkPhone"
//注册
#define API_LoginModule_register @"manKeep/register"
//短信登录
#define API_LoginModule_msgLogin @"manKeep/msmLogin"
//密码登录
#define API_LoginModule_pwdLogin @"manKeep/pwdLogin"
//找回密码
#define API_LoginModule_findPwd @"manKeep/updateTgusetPwd"
//查询用户个人信息
#define API_LoginModule_findUserInfo @"manKeepToken/findUserAccount"
//修改用户个人信息
#define API_LoginModule_updateUserInfo @"manKeepToken/updateTgInfo"
//修改用户头像
#define API_LoginModule_updateTgInfoImg @"manKeepToken/updateTgInfoImg"

#pragma mark -- 通讯录部分
//添加好友
#define API_FriendModule_addfriend @"manKeepToken/addfriend"
//删除好友
#define API_FriendModule_deletefriend @"manKeepToken/deletefriend"
//好友列表
#define API_FriendModule_friendList @"manKeepToken/showtgusetfriendlist"
//好友详细信息
#define API_FriendModule_friendInfo @"manKeepToken/showfriendInfo"

#pragma mark -- 人脉
//创建公司
#define API_RelationModule_createCompany @"companyAdd/addUserCompany"
//修改公司信息
#define API_RelationModule_updateCompanyInfo @"manKeepToken/updateCompanyInfo"
//批量添加公司用户
#define  API_RelationModule_addCompanyMember @"manKeepToken/addComTg"
//退出公司
#define API_RelationModule_deleteCompany @"manKeepToken/deletecomtg"
//批量添加公司管理员
#define API_RelationModule_addComAdm @"manKeepToken/addComAdm"
//移除管理员
#define API_RelationModule_deleteComAdm @"manKeepToken/deleteComAdm"
//查找公司
#define API_RelationModule_selectcompany @"manKeepToken/selectcompany"
//加入公司
//空缺
//获取公司成员列表
#define API_RelationModule_findTgfromCom @"manKeepToken/findTgfromCom"

#pragma mark -- 邮件
//邮件登入
#define API_MailModule_loginMail @"oneemail/MailIMAPlogin"
//查询用户邮件
#define API_MailModule_getUserMail @"oneemail/MailIMAP"
//删除用户邮件
#define API_MailModule_deleteMail @"oneemail/MailIMAPDe"
//发送邮件
#define API_MailModule_sendMail @"oneemail/MailSMTP"
//获取邮件详情
#define API_MailModule_getMailDetail @"oneemail/MailIMAPRD"
//回复邮件
#define API_MailModule_answerMail @"oneemail/MailSTMPreply"
//转发邮件
#define API_MailModule_resendMail @"163email/MailSMTPZ"

#pragma mark --企业圈
//获取我的企业圈列表
#define API_MomentModule_getMomentList @"enterprisez/tupshipshow"
//更换企业圈背景图
#define API_MomentModule_changeBackImage @"enterprisez/uEnterprise"
//查询企业圈详情
#define API_MomentModule_getMomentDetail @"enterprisez/MEnterpricezSelectDan"
//查看某人企业圈列表
#define API_MomentModule_getSomeBodyMomentList @"enterprisez/MEnterpriceSelectFriend"
//查看某人企业圈详情
#define API_MomentModule_getSomeBodyMomentDetail @"enterprisez/MEnterDanFriend"
//点赞
#define API_MomentModule_like @"Enterlike/enterpriselikeadd"
//取消点赞
#define API_MomentModule_unlike @"Enterlike/enterpriseliked"
//发布评论
#define API_MomentModule_comment @"comments/commentadd"
//删除评论(删除自己的评论)
#define API_MomentModule_deleteComment @"comments/commentdel"
//删除企业圈
#define API_MomentModule_deleteMoment @"enterprisez/DEnterpriseDel"
//企业圈 查询消息列表
#define API_MomentModule_getCommentList @"comments/commentsListLook"
//清空消息列表
#define API_MomentModule_deleteCommentList @"comments/commentRM"
//发布企业圈
#define API_MomentModule_sendMoment @"enterprisez/tupship"
#endif /* WXApiMacros_h */


