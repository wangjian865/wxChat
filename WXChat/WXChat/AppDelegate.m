//
//  AppDelegate.m
//  WXChat
//
//  Created by WDX on 2019/4/25.
//  Copyright © 2019 WDX. All rights reserved.
//

#import "AppDelegate.h"
#import "WXTabBarController.h"
#import "DemoCallManager.h"
#import "DemoConfManager.h"
#import "WXAccountTool.h"
#import <IQKeyboardManager.h>
#import "NSString+Letter.h"
#import "JPUSHService.h"
#import <UserNotifications/UserNotifications.h>
#import <AdSupport/AdSupport.h>
@interface AppDelegate ()<EMChatManagerDelegate,JPUSHRegisterDelegate,EMClientDelegate>
@end
//JPUSH
static NSString *appKey = @"3c3c96021e26f9166346c483";
static NSString *channel = @"Publish channel";
@implementation AppDelegate

+ (AppDelegate *)sharedInstance
{
    return ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    ///键盘设置
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].toolbarDoneBarButtonItemText = @"完成";
    ///easeUI注册
    [[EaseSDKHelper shareHelper] hyphenateApplication:application didFinishLaunchingWithOptions:launchOptions];
    //环信服务注册

    EMOptions *options = [EMOptions optionsWithAppkey:@"1111190604042820#bambooslip"];
    
    options.apnsCertName = @"生产推送";

    [[EMClient sharedClient] initializeSDKWithOptions:options];
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    //极光
    [self _initJPushNotificationWithOptions:launchOptions];
    //默认登录的状态
    if ([WXAccountTool isLogin]){
        
        EMError *error = [[EMClient sharedClient] loginWithUsername:WXAccountTool.getHuanXinID password:@"123456"];
        if (!error) {
            NSLog(@"登录成功");
            [DemoCallManager sharedManager];
            [DemoConfManager sharedManager];
            //环信添加监听在线推送消息
            [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
            EMCallOptions *callOptions = [[EMClient sharedClient].callManager getCallOptions];
            //当对方不在线时，是否给对方发送离线消息和推送，并等待对方回应
            callOptions.isSendPushIfOffline = NO;
            //设置视频分辨率：自适应分辨率、352 * 288、640 * 480、1280 * 720
            callOptions.videoResolution = EMCallVideoResolutionAdaptive;
            //最大视频码率，范围 50 < videoKbps < 5000, 默认0, 0为自适应，建议设置为0
            callOptions.maxVideoKbps = 0;
            //最小视频码率
            callOptions.minVideoKbps = 0;
            //是否固定视频分辨率，默认为NO
            callOptions.isFixedVideoResolution = NO;
            [[EMClient sharedClient].callManager setCallOptions:callOptions];
            
            self.window.rootViewController = [[WXTabBarController alloc] init];
            [self.window makeKeyAndVisible];
        }else{
            //未登录状态
            UIViewController *loginVC = [UIStoryboard storyboardWithName:@"Login" bundle:nil].instantiateInitialViewController;
            self.window.rootViewController = loginVC;
            [self.window makeKeyAndVisible];

        }
    }else{
//        self.window.rootViewController = [[WXTabBarController alloc] init];
//        [self.window makeKeyAndVisible];
        //未登录状态
        UIViewController *loginVC = [UIStoryboard storyboardWithName:@"Login" bundle:nil].instantiateInitialViewController;
        self.window.rootViewController = loginVC;
        [self.window makeKeyAndVisible];
    }
    [self _initNotification];
    // 设置应用程序的图标右上角的数字
    [application setApplicationIconBadgeNumber:0];
    
    
    return YES;
}
///极光
- (void)_initJPushNotificationWithOptions:(NSDictionary *)launchOptions{
    ///JPUSH服务
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    if (@available(iOS 12.0, *)) {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
    } else {
        // Fallback on earlier versions
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义 categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    // Optional
    // 获取 IDFA
    // 如需使用 IDFA 功能请添加此代码并在初始化方法的 advertisingIdentifier 参数中填写对应值
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    // notice: 2.1.5 版本的 SDK 新增的注册方法，改成可上报 IDFA，如果没有使用 IDFA 直接传 nil
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:0
            advertisingIdentifier:advertisingId];
}
///环信
- (void)_initNotification
{
    //注册登录状态监听
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLoginState:) name:ACCOUNT_LOGIN_CHANGED object:nil];
    
    //环信推送
    EMPushOptions *pushOptions = [[EMClient sharedClient] pushOptions];
    //显示内容
    pushOptions.displayStyle = 1;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0 ), ^{
        
        EMError *error = [[EMClient sharedClient] updatePushOptionsToServer];
        if(!error) {
            // 成功
        }else {
            // 失败
        }
    });
    // 注册APNS离线推送  iOS8 注册APNS
    UIApplication *application = [UIApplication sharedApplication];
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge |
        UIUserNotificationTypeSound |
        UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
}
//监听环信在线推送消息
- (void)messagesDidReceive:(NSArray *)aMessages{
    if ([WXAccountTool getDisturbState]){
        ///禁止推送
        return;
    }
    if (aMessages.count == 0) {
        return;
    }
    for (EMMessage * message in aMessages) {
        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
        switch (state) {
                //前台运行
            case UIApplicationStateActive:
                [self showPushNotificationMessage:message];
                break;
                //待激活状态
            case UIApplicationStateInactive:
                [self showPushNotificationMessage:message];
                
                break;
                //后台运行
            case UIApplicationStateBackground:
                [self showPushNotificationMessage:message];
                break;
               
            default:
                break;
        }
    }
    
}
//监听环信之后  发送本地通知
- (void)showPushNotificationMessage:(EMMessage *)message{
    EMPushOptions *options = [[EMClient sharedClient] pushOptions];
    options.displayStyle = 1;
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; //触发通知的时间
    if (options.displayStyle == 1) {
        EMMessageBody *messageBody = message.body;
        NSString *messageStr = nil;
        switch (messageBody.type) {
            case 1:{
                messageStr = ((EMTextMessageBody *)messageBody).text;
            }
                break;
            case 2:{
                messageStr = @"发来一张图片";
            }
                break;
            case 4:{
                messageStr = @"发来ta的位置";
            }
                break;
            case 5:{
                messageStr = @"发来一段语音";
            }
                break;
            default:
                break;
        }
        
        notification.alertBody = [NSString stringWithFormat:@"%@",messageStr];
        notification.userInfo = @{@"msgtype":@(1),@"mid":message.messageId,@"f":message.from};
        notification.alertAction = NSLocalizedString(@"open", @"Open");
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.repeatInterval = 0;
        notification.soundName= UILocalNotificationDefaultSoundName;
        //发送通知
        UIApplication *application = [UIApplication sharedApplication];
        [application scheduleLocalNotification:notification];
        application.applicationIconBadgeNumber += 1;
    }
}
//本地通知点击事件
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    // 必须要监听--应用程序在后台的时候进行的跳转
    if (application.applicationState == UIApplicationStateInactive) {
        [self messageClickHandleWith:notification];
    }
}
//私信消息推送点击事件
- (void)messageClickHandleWith:(UILocalNotification *)notification
{
    NSDictionary * dic = [notification userInfo];
    UIViewController * controller = [self getCurrentVC];
    
}

//获取当前controller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    //app默认windowLevel是UIWindowLevelNormal，如果不是，找到UIWindowLevelNormal的
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    id  nextResponder = nil;
    UIViewController *appRootVC=window.rootViewController;
    //    如果是present上来的appRootVC.presentedViewController 不为nil
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    }else{
        
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }
    
    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        UITabBarController * tabbar = (UITabBarController *)nextResponder;
        UINavigationController * nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        //        UINavigationController * nav = tabbar.selectedViewController ; 上下两种写法都行
        result=nav.childViewControllers.lastObject;
        
    }else if ([nextResponder isKindOfClass:[UINavigationController class]]){
        UIViewController * nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
    }else{
        result = nextResponder;
    }
    return result;
}

////远程消息推送点击处理
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    if(userInfo){

    }
}
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {///极光
    [[EMClient sharedClient] registerForRemoteNotificationsWithDeviceToken:deviceToken completion:^(EMError *aError) {
        if (!aError){
            //注册成功
            EMPushOptions *option = [[EMClient sharedClient] pushOptions];
            option.displayStyle = EMPushDisplayStyleSimpleBanner;
            if ([WXAccountTool getDisturbState]){
                ///免打扰设置
                option.noDisturbStatus = EMPushNoDisturbStatusDay;
            }else{
                option.noDisturbStatus = EMPushNoDisturbStatusClose;
            }
            [[EMClient sharedClient] updatePushOptionsToServer];
            
//            EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
        }
    }];
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

//apns推送 (此处为了接收)
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {

    // Required, iOS 7 Support
    NSString *customizeField1 = [userInfo valueForKey:@"url"];
    if (customizeField1 != nil && ![customizeField1 isEqual:@""]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"moment_NewMessage" object:nil userInfo:[customizeField1 convert2DictionaryWithJSONString:customizeField1]];
    }
    
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    application.applicationIconBadgeNumber = 0;
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}

// 当掉线时，iOS SDK 会自动重连，只需要监听重连相关的回调，无需进行任何操作。
- (void)connectionStateDidChange:(EMConnectionState)aConnectionState
{
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
//EMClientDelegate
- (void)userAccountDidLoginFromOtherDevice
{
    [[EMClient sharedClient] logout:NO];
    [self showAlertWithMessage:@"你的账号已在其他地方登录,请重新登录"];
    [self loginStateChange:NO huanxinID:@""];
}
- (void)autoLoginDidCompleteWithError:(EMError *)error
{
    if (error) {
        [self showAlertWithMessage:@"自动登录失败，请重新登录"];
        
        [self loginStateChange:NO huanxinID:@""];
    }
}

- (void)userAccountDidRemoveFromServer
{
    [[EMClient sharedClient] logout:NO];
    [self showAlertWithMessage:@"你的账号已被从服务器端移除"];
    
    [self loginStateChange:NO huanxinID:@""];
}

- (void)userDidForbidByServer
{
    [[EMClient sharedClient] logout:NO];
    [self showAlertWithMessage:@"账号被禁用"];
    
    [self loginStateChange:NO huanxinID:@""];
}

- (void)loginStateChange:(BOOL)isLogin huanxinID:(NSString *)ID{
    UIViewController *rootController = nil;
    BOOL loginSuccess = isLogin;
    //此时只是后台登录成功
    if (!loginSuccess){
        EMError *error = [[EMClient sharedClient] logout:true];
        if (!error){
            UIViewController *loginVC = [UIStoryboard storyboardWithName:@"Login" bundle:nil].instantiateInitialViewController;
            self.window.rootViewController = loginVC;
            [self.window makeKeyAndVisible];
        }else{
            [MBProgressHUD showError:@"服务器异常"];
        }
        
        return;
    }
    EMError *error = [[EMClient sharedClient] loginWithUsername:WXAccountTool.getHuanXinID password:@"123456"];
    if (!error) {
        NSLog(@"登录成功");
        [DemoCallManager sharedManager];
        [DemoConfManager sharedManager];
        //环信添加监听在线推送消息
        [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
        EMCallOptions *callOptions = [[EMClient sharedClient].callManager getCallOptions];
        //当对方不在线时，是否给对方发送离线消息和推送，并等待对方回应
        callOptions.isSendPushIfOffline = NO;
        //设置视频分辨率：自适应分辨率、352 * 288、640 * 480、1280 * 720
        callOptions.videoResolution = EMCallVideoResolutionAdaptive;
        //最大视频码率，范围 50 < videoKbps < 5000, 默认0, 0为自适应，建议设置为0
        callOptions.maxVideoKbps = 0;
        //最小视频码率
        callOptions.minVideoKbps = 0;
        //是否固定视频分辨率，默认为NO
        callOptions.isFixedVideoResolution = NO;
        [[EMClient sharedClient].callManager setCallOptions:callOptions];
        rootController = [[WXTabBarController alloc] init];
    }else {//环信登录失败
        [MBProgressHUD showError:@"登录环信服务器失败,请重新尝试"];
        return;
    }
    self.window.rootViewController = rootController;
    [self.window makeKeyAndVisible];
}

///delegate

///在前台得到推送信息
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger options))completionHandler  API_AVAILABLE(ios(10.0)){
    completionHandler(UNNotificationPresentationOptionSound);
    NSDictionary * userInfo = notification.request.content.userInfo;
    NSString *customizeField1 = [userInfo valueForKey:@"url"];
    if (customizeField1 != nil && customizeField1 != @""){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"moment_NewMessage" object:nil userInfo:[customizeField1 convert2DictionaryWithJSONString:customizeField1]];
    }
    NSLog(@"收到了吗");
}
///从后台点击推送
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    NSLog(@"收到了吗");
}

/*
 * @brief handle UserNotifications.framework [openSettingsForNotification:]
 * @param center [UNUserNotificationCenter currentNotificationCenter] 新特性用户通知中心
 * @param notification 当前管理的通知对象
 */
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(nullable UNNotification *)notification  API_AVAILABLE(ios(10.0)){
    NSLog(@"收到了吗");
}

@end
