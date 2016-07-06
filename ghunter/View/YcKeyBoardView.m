//
//  YcKeyBoardView.m
//  KeyBoardAndTextView
//


#import "YcKeyBoardView.h"

@interface YcKeyBoardView()<UITextViewDelegate>
@property (nonatomic,assign) CGFloat textViewWidth;
@property (nonatomic,assign) BOOL isChange;
@property (nonatomic,assign) BOOL reduce;
@property (nonatomic,assign) CGRect originalKey;
@property (nonatomic,assign) CGRect originalText;
@end

@implementation YcKeyBoardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        self.userInteractionEnabled = YES;
        [self initTextView:frame];
    }
    return self;
}
-(void)initTextView:(CGRect)frame
{
    
    self.textView=[[UITextView alloc]init];
    self.textView.delegate=self;
    CGFloat textX=kStartLocation*0.5;
    self.textViewWidth=frame.size.width-2*textX;
    self.textView.frame=CGRectMake(textX+70, kStartLocation*0.2,self.textViewWidth -100, frame.size.height-2*kStartLocation*0.2);
    self.textView.backgroundColor=[UIColor colorWithRed:231.0/255 green:231.0/255 blue:231.0/255 alpha:1.0];
    self.textView.layer.cornerRadius = 5.0;
    self.textView.font=[UIFont systemFontOfSize:13.0];
    [self addSubview:self.textView];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(textX+70, kStartLocation*0.2,self.textViewWidth -100, frame.size.height-2*kStartLocation*0.2)];
    [btn addTarget:self action:@selector(btn:) forControlEvents:(UIControlEventTouchUpInside)];
    btn.backgroundColor = [UIColor clearColor];
    [self addSubview:btn];

    button1 = [[UIButton alloc]initWithFrame:CGRectMake(5,5 , 35, 35)];
    button1.tag = 1001;
    [button1 addTarget:self action:@selector(btn1:) forControlEvents:(UIControlEventTouchUpInside)];
    button1.userInteractionEnabled = YES;
    [button1 setImage:[UIImage imageNamed:@"表情"] forState:(UIControlStateNormal)];
    [self addSubview:button1];

    button2 = [[UIButton alloc]initWithFrame:CGRectMake(45, 5, 35, 35)];
     button2.tag = 1002;
    [button2 setImage:[UIImage imageNamed:@"添加"] forState:(UIControlStateNormal)];
    [button2 addTarget:self action:@selector(btn2:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:button2];
    
    
    button3 = [[UIButton alloc]initWithFrame:CGRectMake(mainScreenWidth-40, 5, 35, 35)];
    button3.tag = 1005;
    [button3 setImage:[UIImage imageNamed:@"三角下"] forState:(UIControlStateNormal)];
    [button3 addTarget:self action:@selector(btn3:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:button3];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]){
        
        if([self.delegate respondsToSelector:@selector(keyBoardViewHide: textView:)]){
            
            [self.delegate keyBoardViewHide:self textView:self.textView];
        }
        return NO;
    }
    
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView
{
    NSString *content=textView.text;
    
    CGSize contentSize=[content sizeWithFont:[UIFont systemFontOfSize:13.0]];
    if(contentSize.width>self.textViewWidth){
        if(!self.isChange){
            CGRect keyFrame=self.frame;
            self.originalKey=keyFrame;
            keyFrame.size.height+=keyFrame.size.height;
            keyFrame.origin.y-=keyFrame.size.height*0.25;
            self.frame=keyFrame;
            
            CGRect textFrame=self.textView.frame;
            self.originalText=textFrame;
            textFrame.size.height+=textFrame.size.height*0.5+kStartLocation*0.2;
            self.textView.frame=textFrame;
            self.isChange=YES;
            self.reduce=YES;
        }
    }
    if(contentSize.width<=self.textViewWidth){
        if(self.reduce){
            self.frame=self.originalKey;
            self.textView.frame=self.originalText;
            self.isChange=NO;
            self.reduce=NO;
        }
    }
}

-(void)btn1:(UIButton *)btn{
    //创建通知
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:@"1001",@"textOne", nil];

    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi3" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
-(void)btn2:(UIButton *)btn{
    //添加 字典，将label的值通过key值设置传递
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:@"1002",@"textOne", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi2" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}
-(void)btn3:(UIButton *)btn{
    //添加 字典，将label的值通过key值设置传递
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:@"1005",@"textOne", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];

    
}

-(void)btn:(UIButton *)btn{
    //添加 字典，将label的值通过key值设置传递
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:@"1009",@"textOne", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi9" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
//-(void)changeImg:(UITapGestureRecognizer *)tap{
//    //添加 字典，将label的值通过key值设置传递
//    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:@"1009",@"textOne", nil];
//    //创建通知
//    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi9" object:nil userInfo:dict];
//    //通过通知中心发送通知
//    [[NSNotificationCenter defaultCenter] postNotification:notification];
//}

@end
