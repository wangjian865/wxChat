//
//  WXSearchResultViewController.h
//  WXChat
//
//  Created by WDX on 2019/6/10.
//  Copyright © 2019 WDX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXSearchResultViewController : UIViewController<UISearchResultsUpdating>
/**
 * 弱引用searchBar
 */
@property (nonatomic, weak) UISearchBar *searchBar;
@property (nonatomic, weak) UITextField *searchBarTextField;
@end

NS_ASSUME_NONNULL_END
