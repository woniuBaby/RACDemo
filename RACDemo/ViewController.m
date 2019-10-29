//
//  ViewController.m
//  RACDemo
//
//  Created by yanjinchao on 2019/10/16.
//  Copyright © 2019 yanjinchao. All rights reserved.
//

#import "ViewController.h"
#import "RedView.h"
#import <ReactiveObjC/ReactiveObjC.h>
@interface ViewController ()<ButtonClickDelegate>
@property (nonatomic,strong)RedView *redView;
@property (nonatomic,assign)NSInteger num;

//.订阅信号量   定时器相关的
//RACDisposable *disposable
@property (nonatomic,strong)RACDisposable *dispose;
@property (nonatomic,assign)NSInteger time;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor yellowColor];
    self.title = @"首页";
    [self racReplaceDelegate];
    
//    2 监听事件
    [self observeControlBtn];
    
//    3KVO 监听事件
    [self observeKVOevent];
    
//    4  textField
    [self textFieldOberveEvent];
//    5定时器
    [self dingshiqi];
//    6RAC  使用
    [self RACUsing];
}




#pragma mark - RAC代替Delegate
- (void)racReplaceDelegate
{
    _redView = [[RedView alloc]init];
    _redView.frame = CGRectMake(100, 100, 100, 100);
//    _redView.center = self.view.center;
    _redView.backgroundColor = [UIColor redColor];
    _redView.delegate = self;
    [self.view addSubview:_redView];
    
    // RAC:判断下一个方法有没有调用,如果调用了就会自动发送一个信号给你
    // 监听_redView有没有调用redBtnClick:,如果调用了就会转换成信号
    [[_redView rac_signalForSelector:@selector(redBtnClick:)] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%s 知道了红色View的RedBtnClick,可以做事情了", __FUNCTION__);
        NSLog(@"%s x = %@", __FUNCTION__, x);
        
        
        NSLog(@"%@",x[0]);
        
        
        UIButton *btn = x[0];
        [btn setBackgroundColor:[self RandomColor]];
    }];
    
    
    
    
    [[self rac_signalForSelector:@selector(tapWithShopID:withViewColor:) fromProtocol:@protocol(ButtonClickDelegate)] subscribeNext:^(RACTuple * _Nullable x) {
        NSLog(@"tap点击事件的x为:%@",x);
    }];
    
    
    
}
- (UIColor*)RandomColor {
    
    NSInteger aRedValue =arc4random() %255;
    
    NSInteger aGreenValue =arc4random() %255;
    
    NSInteger aBlueValue =arc4random() %255;
    
    UIColor*randColor = [UIColor colorWithRed:aRedValue /255.0f green:aGreenValue /255.0f blue:aBlueValue /255.0f alpha:1.0f];
    
    return randColor;
    
}


#pragma mark - 事件监测

-(void)observeControlBtn{
    UIButton *a =[UIButton new];
    a.frame = CGRectMake(100, 220, 150, 50);
    [a setTitle:@"这是一个按钮" forState:UIControlStateNormal];
    a.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:a];
    
    [[a rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        UIButton *btn = x;
        NSLog(@"%@",btn.currentTitle);
        
    }];
}


#pragma mark KVC监测
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.num++;
}
-(void)observeKVOevent{
    [[self rac_valuesForKeyPath:@"num" observer:self] subscribeNext:^(id  _Nullable x) {
       NSLog(@"%@",x);
    }];
    
    [RACObserve(self, self.num) subscribeNext:^(id  _Nullable x) {
        NSLog(@"KVO简写:::%@",x);
    }];
    
}
#pragma mark textFiled
-(void)textFieldOberveEvent{


    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(100, 300, 200, 40)];

    textField.backgroundColor = [UIColor grayColor]; // 设置背景颜色

    textField.alpha = 1.0; // 设置透明度，范围从0.0-1.0之间

    textField.textColor = [UIColor redColor];// 设置文字的颜色

    textField.text = @"默认的文字"; // 设置默认的文字

    textField.clearsOnBeginEditing = YES; // 当第二次输入的时候，清空上一次的内容

    textField.placeholder = @"这是提示文字";// 显示提示文件，当输入文字时将自动消失

    textField.font = [UIFont boldSystemFontOfSize:25.0f]; // 设置字体的大小

    textField.textAlignment = NSTextAlignmentCenter;// 设置文字的对其方式

    [self.view addSubview:textField];

    [[textField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
       NSLog(@"%@",x);
    }];

    
    
}
#pragma mark - 定时器
-(void)dingshiqi{
    UIButton *a =[UIButton new];
    a.frame = CGRectMake(100, 360, 230, 40);
    [a setTitle:@"发送验证码" forState:UIControlStateNormal];
    a.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:a];
    self.time = 10;
    @weakify(self);
    [[a rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        
      self.dispose =  [[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
          self.time--;
          [a setTitle:[NSString stringWithFormat:@"验证码已经发送,%ld秒后刷新",(long)self.time] forState:UIControlStateNormal];
          if (self.time == 0) {
              [a setTitle:@"发送验证码" forState:UIControlStateNormal];
              self.time = 10;
              [self.dispose dispose];
          }
        }];
        //延时操作
//         [[RACScheduler mainThreadScheduler] afterDelay:1 schedule:^{
//
//        }];
        
        
    }];
    
    
    //旁边加一个textview  看看是否受影响
    UITextView* textView = [[UITextView alloc] initWithFrame:CGRectMake(100, 410, 200, 40)];
    textView.backgroundColor = [UIColor grayColor];
    //文本
    textView.text = @"看看滑动期间是不是会引起定时器的 不精准性   因为runloop的原因";
    //字体
    textView.font = [UIFont boldSystemFontOfSize:12.0];
    //对齐
    textView.textAlignment = NSTextAlignmentCenter;
    //字体颜色
    textView.textColor = [UIColor redColor];
    //允许编辑
    textView.editable = YES;
    
//    textView.delegate = self;
    [self.view addSubview:textView];
    
    


}
#pragma mark - RAC  创建信号量   订阅信号量  发送信号量

-(void)RACUsing{
    
    UIButton *a =[UIButton new];
    a.frame = CGRectMake(100, 460, 100, 40);
    [a setTitle:@"RACUsing" forState:UIControlStateNormal];
    a.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:a];
    
    [[a rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
    
        //1、创建信号量
        RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            NSLog(@"创建信号量");
            
            //3、发布信息
            [subscriber sendNext:@"I'm send next data"];
            [subscriber sendNext:a];
            NSLog(@"那我啥时候运行");
            
            return [RACDisposable disposableWithBlock:^{
               NSLog(@"销毁吗?");
            }];
        }];
        
        //2、订阅信号量
        [signal subscribeNext:^(id  _Nullable x) {
            if ([x isKindOfClass:[UIButton class]]) {
                UIButton *N = x;
                [x setBackgroundColor:[self RandomColor]];
                NSLog(@"%@",N.titleLabel.text);
            } else {
                NSLog(@"%@",x);
            }
            
            
        }];
        
        
    }];
    
}

-(void)disposableYanJiu{
    [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        
        return NULL;
    }];
}




@end
