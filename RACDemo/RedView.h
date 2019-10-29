//
//  RedView.h
//  RACDemo
//
//  Created by yanjinchao on 2019/10/16.
//  Copyright © 2019 yanjinchao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ButtonClickDelegate <NSObject>
-(void)tapWithShopID:(NSString *)shopID withViewColor:(UIView *)view;
-(void)telphoto:(NSString *)photo;

@end




@interface RedView : UIView
@property (nonatomic,weak)id <ButtonClickDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
