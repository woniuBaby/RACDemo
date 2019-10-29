//
//  RedView.m
//  RACDemo
//
//  Created by yanjinchao on 2019/10/16.
//  Copyright © 2019 yanjinchao. All rights reserved.
//

#import "RedView.h"


@interface RedView()

@property(nonatomic ,strong) UIButton *redBtn;

@end

@implementation RedView
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init
{
    if (self = [super init]) {
        _redBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _redBtn.backgroundColor = [UIColor blackColor];
        _redBtn.frame = CGRectMake(0, 0, 50, 50);
        [self addSubview:_redBtn];
        [_redBtn addTarget:self action:@selector(redBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tap];
        
        
    }
    return self;
}
//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    self.redBtn.frame = self.bounds;
//}
- (void)redBtnClick:(UIButton *)btn
{
    NSLog(@"%s 点击了RedView的RedBtn", __FUNCTION__);
}

-(void)tap:(UITapGestureRecognizer *)tap{
    UIView *view = tap.view;
    [self.delegate tapWithShopID:@"我的名字是阎晋超" withViewColor:view];
}



@end
