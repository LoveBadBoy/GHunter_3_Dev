//
//  ghunterSkillViewController.m
//  ghunter
//
//  Created by 汪睦雄 on 15/8/7.
//  Copyright (c) 2015年 ghunter. All rights reserved.
//

#import "ghunterSkillViewController.h"
#import "ghunterWordChange.h"
#import "AFNetworkTool.h"
#import "UMSocialQQHandler.h"
#import <TencentOpenAPI/TencentApiInterface.h>
#import "WXApi.h"


@interface ghunterSkillViewController()
@property(nonatomic, retain) NSString *sendStr;
@property(strong,nonatomic) UIActionSheet *actionBack;
@property(strong,nonatomic) UIActionSheet * deleteComment;
@property (nonatomic,assign) int height;
@property (nonatomic,assign) CGFloat keyBoardHeight;
@property (nonatomic,assign) CGRect originalKey;
@property (nonatomic,assign) CGRect originalText;
@property(strong,nonatomic) UIView *popReportView;
@property(strong,nonatomic) UILabel *textTip;
@property(strong,nonatomic) HPGrowingTextView *text;
@property(strong,nonatomic)HPGrowingTextView *chatTextField;
@property(strong,nonatomic) UIActionSheet *onSell;
@property(strong,nonatomic)UIActionSheet *unSell;
@property (strong, nonatomic) IBOutlet UIView *bg;

/*
 round view
 */
@property (strong, nonatomic) IBOutlet UILabel *downLabel;
@property (strong, nonatomic) IBOutlet UIImageView *downImageView;

@property (strong, nonatomic) IBOutlet UIImageView *skillCollect;

@property (assign,nonatomic)BOOL isSender;
@property (assign,nonatomic)BOOL changeSomething;
@property(strong,nonatomic)UIScrollView* scrollView;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;

@property(strong,nonatomic)UITextView* textView;

@property (strong, nonatomic) IBOutlet UIButton *PLunBtn;

@property (strong, nonatomic) IBOutlet UILabel *PLunLabel;

@property (strong, nonatomic) IBOutlet UIView *chatToolBar;

@property (strong, nonatomic) IBOutlet UILabel *chatLabel;

@property (strong, nonatomic) IBOutlet UIImageView *commentImgV;


- (IBAction)buyBtn:(UIButton *)sender;
- (IBAction)chatBtn:(UIButton *)sender;  // 修改技能
- (IBAction)reviseSkill:(UIButton *)sender;
- (IBAction)downBtn:(UIButton *)sender;

- (IBAction)privateMessage:(UIButton *)sender;

- (IBAction)keyboardDown:(id)sender;

- (IBAction)beginEditText:(id)sender;
@end

@implementation ghunterSkillViewController

#pragma mark - UIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    addarray = [NSMutableArray array];
    arraynumber = [NSMutableArray array];
    dataimgarr = [NSMutableArray array];
    imgarr = [NSMutableArray array];
    skdic = [[NSMutableDictionary alloc] init];
    btnarray = [NSMutableArray array];
    imgArray = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // 键盘view
    textbg = [[UIView alloc]initWithFrame:CGRectMake(0, mainScreenheight-self.keyBoardHeight, mainScreenWidth, 40)];
    textbg.backgroundColor = [UIColor whiteColor];
    textbg.userInteractionEnabled  = YES;
    
    // 相册背景
    _bastview = [[UIView alloc] initWithFrame:CGRectMake(100, 300, mainScreenWidth, 44)];
    _bastview.backgroundColor = RGBCOLOR(245, 245, 245);
    
    UIButton * sendPhotoBtn = [[UIButton alloc] initWithFrame:CGRectMake(mainScreenWidth - 40, 10, 30, 20)];
    [sendPhotoBtn setTitle:@"发送" forState:UIControlStateNormal];
    sendPhotoBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    sendPhotoBtn.titleLabel.textColor = [UIColor whiteColor];
    sendPhotoBtn.backgroundColor = [UIColor orangeColor];
    sendPhotoBtn.alpha = 1;
    [sendPhotoBtn addTarget:self action:@selector(sendPhoto) forControlEvents:UIControlEventTouchUpInside];
    [_bastview addSubview:sendPhotoBtn];
    
    self.img0 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 25, 25)];
    self.img1 = [[UIImageView alloc]initWithFrame:CGRectMake(40, 7, 25, 25)];
    self.img2 = [[UIImageView alloc]initWithFrame:CGRectMake(70, 7, 25, 25)];
    self.img3 = [[UIImageView alloc]initWithFrame:CGRectMake(100, 7, 25, 25)];
    self.img0.userInteractionEnabled = YES;
    self.img1.userInteractionEnabled = YES;
    self.img2.userInteractionEnabled = YES;
    self.img3.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap0 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(img0_tap:)];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(img1_tap:)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(img2_tap:)];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(img3_tap:)];
    [self.img0 addGestureRecognizer:tap0];
    [self.img1 addGestureRecognizer:tap1];
    [self.img2 addGestureRecognizer:tap2];
    [self.img3 addGestureRecognizer:tap3];
    
    
    labelxx = [[UILabel alloc]initWithFrame:CGRectMake(mainScreenWidth-70, 5, 60, 30)];
    labelxx.textColor = [UIColor grayColor];
    labelxx.font = [UIFont systemFontOfSize:14];
    
    // 添加表情的view
    _whitview = [[UIView alloc]initWithFrame:CGRectMake(0, mainScreenheight-170, mainScreenWidth, 170)];
    _whitview.backgroundColor = [UIColor whiteColor];
    _scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, 140)];
    
    for (int i=0; i<3; i++) {
        UIView* face=[[UIView alloc] initWithFrame:CGRectMake(320*i, 0, 320, 140)];
        for (int j=0; j<3; j++) {
            //column numer
            for (int k=0; k<7; k++) {
                UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
                
                button.tag=j*7+k+(i*21)+1;
                NSString *imageName;
                if(button.tag==21||button.tag==42||button.tag==63)
                {
                    [button setImage:[UIImage imageNamed:@"emoji_delete.png"] forState:UIControlStateNormal];
                    [button setFrame:CGRectMake(0+k*45, 0+j*45, 45, 45)];
                }
                else
                {
                    imageName=[NSString stringWithFormat:@"%zd.png",button.tag];
                    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
                    [button setFrame:CGRectMake(10+k*45, 10+j*45, 25, 25)];
                }
                [button setBackgroundColor:[UIColor clearColor]];
                [button addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
                face.backgroundColor=[UIColor whiteColor];
                [face addSubview:button];
            }
        }
        [_scrollView addSubview:face];
    }
    _scrollView.contentSize=CGSizeMake(mainScreenWidth*3, 140);
    _scrollView.delegate=self;
    _scrollView.pagingEnabled=YES;
    _scrollView.bounces=NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _whitview.backgroundColor = [UIColor grayColor];
    
    UIButton* sendBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    sendBtn.frame=CGRectMake(255, 143, 50, 25);
    [sendBtn addTarget:self action:@selector(sendBtnClick2:) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    
    sendBtn.titleLabel.font=[UIFont systemFontOfSize:12];
    [sendBtn setBackgroundImage:[UIImage imageNamed:@"input_circle_bg.png"] forState:UIControlStateNormal];
    [_whitview addSubview:sendBtn];
    [self.whitview addSubview:_scrollView];
    _bg.backgroundColor = Nav_backgroud;
    self.currentPage = 1;
    CGSize width = CGSizeMake(mainScreenWidth,mainScreenheight);
    // 据偶去任务详情
    [self didGetSkillshowIsloading:YES isWithComments:YES];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
//    self.navigationController.navigationBar.alpha = 0;
    [self.navigationController.view sendSubviewToBack:self.navigationController.navigationBar];
   
    self.view.backgroundColor = RGBCOLOR(228, 227, 220);
    scrollPanel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, mainScreenheight)];
    scrollPanel.backgroundColor = [UIColor clearColor];
    scrollPanel.alpha = 0;
    [self.view addSubview:scrollPanel];
    
    markView = [[UIView alloc] initWithFrame:scrollPanel.bounds];
    markView.backgroundColor = [UIColor blackColor];
    markView.alpha = 0.0;
    [scrollPanel addSubview:markView];
    
    myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, mainScreenheight)];
    [scrollPanel addSubview:myScrollView];
    myScrollView.pagingEnabled = YES;
    myScrollView.delegate = self;
    CGSize contentSize = myScrollView.contentSize;
    contentSize.height = self.view.bounds.size.height;
    contentSize.width = mainScreenWidth;
    myScrollView.contentSize = contentSize;
    
    
    _isSender=NO;
    
    self.smallBuyView.userInteractionEnabled = YES;
    self.smallBuyView.clipsToBounds = YES;
    self.smallBuyView.layer.cornerRadius = 2.0;
    self.buyButton.userInteractionEnabled = YES;
    self.downAva.clipsToBounds=YES;
    self.risiveAva.clipsToBounds=YES;
    self.smallResiveView.clipsToBounds = YES;
    self.smallResiveView.layer.cornerRadius = 2.0;
    self.smallDownView.clipsToBounds = YES;
    self.smallDownView.layer.cornerRadius = 2.0;
    
    self.sendStr = @"";
    page = 1;
    collected = NO;
    requested = NO;
    
    
    skill=[[NSMutableDictionary alloc] init];
    skillcommentArray=[[NSMutableArray alloc] init];
    //    UIImageView *imagebg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mainScreenWidth, 150)];
    //    imagebg.image = [UIImage imageNamed:@"banner_init"];
    //
    //    headview  =[[UIView alloc]initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 150)];
    //    [headview addSubview:imagebg];
    
    taskTable = [[PullTableView alloc]initWithFrame:CGRectMake(0, 64, mainScreenWidth, mainScreenheight - 64 - 44) style:UITableViewStylePlain];
    taskTable.delegate = self;
    taskTable.dataSource = self;
    taskTable.pullDelegate = self;
    //    taskTable.tableHeaderView = headview;
    taskTable.backgroundColor = [UIColor clearColor];
    taskTable.showsVerticalScrollIndicator = NO;
    taskTable.showsHorizontalScrollIndicator = NO;
    taskTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:taskTable];
    tasktailView = [[UIView alloc] initWithFrame:CGRectMake(0, mainScreenheight - 44, self.view.frame.size.width, 44)];
//    self.buyView.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    [self.view addSubview:tasktailView];
    
    // 添加照片的view
    view1 = [[UIView alloc]initWithFrame:CGRectMake(0, mainScreenheight-160, mainScreenWidth, 160)];
    view1.backgroundColor = [UIColor grayColor];
    
    UIButton *img = [[UIButton alloc]initWithFrame:CGRectMake(70, 15, 70, 70)];
    [img setImage:[UIImage imageNamed:@"相册"] forState:(UIControlStateNormal)];
    [img addTarget:self action:@selector(getChatImgFromAlbum2) forControlEvents:(UIControlEventTouchUpInside)];
    [view1 addSubview:img];
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(70, 90, 70, 25)];
    label1.text = @"相册";
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont systemFontOfSize:15];
    [view1 addSubview:label1];
    
    UIButton *img2 = [[UIButton alloc]initWithFrame:CGRectMake(mainScreenWidth-140, 15, 70, 70)];
    [img2 setImage:[UIImage imageNamed:@"相机"] forState:(UIControlStateNormal)];
    [img2 addTarget:self action:@selector(getChatImgFromCamera2) forControlEvents:(UIControlEventTouchUpInside)];
    [view1 addSubview:img2];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(mainScreenWidth-140, 90, 70, 25)];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.text = @"相机";
    label2.font = [UIFont systemFontOfSize:15];
    [view1 addSubview:label2];
    
    // 创建聊天页面
    [self createChatView];
    [self.chatToolBar addSubview:self.chatLabel];
}

- (void)img0_tap:(UITapGestureRecognizer *)sender {
    if ([dataimgarr count]==0) {
        
    }else{
        [self scorll1];
        [self scoroll];
    }
}
-(void)button1:(UIButton *)btn{
    if (btn.selected==NO) {
        UIButton * btn1 = (UIButton *)btn;
        [btn1 setImage:[UIImage imageNamed:@"radio_normal"] forState:(UIControlStateNormal)];
        NSString *Str = [NSString stringWithFormat:@"%ld",(long)btn.tag];
        [addarray replaceObjectAtIndex:btn.tag withObject:Str];
        btn.selected =YES;
    }else{
        UIButton * btn1 = (UIButton *)btn;
        [btn1 setImage:[UIImage imageNamed:@"define_tag"] forState:(UIControlStateNormal)];
        [addarray replaceObjectAtIndex:btn.tag withObject:@"5"];
        btn.selected = NO;
    }
}

-(void)scrollView:(UITapGestureRecognizer *)btn{
    dangtext.delegate = self;
    dangtext.returnKeyType = UIReturnKeySend;
    [dangtext becomeFirstResponder];
    [scrollView removeFromSuperview];
    NSInteger sdrr;
    NSArray* reversedArray = [[addarray reverseObjectEnumerator] allObjects];
    for(id object in reversedArray) {
        NSString *Str = [NSString stringWithFormat:@"%@",object];
        sdrr = [Str integerValue];
        if (([object isEqualToString:@"5"])) {
            NSLog(@"1");
        }else{
            [dataimgarr removeObjectAtIndex:sdrr];
        }
    }
    
    [self imgarr];
    [addarray removeAllObjects];
    for (int i = 0; i<dataimgarr.count; i++) {
        [addarray addObject:@"5"];
    }
}


- (void)img1_tap:(UITapGestureRecognizer *)sender {
    if ([dataimgarr count]==0) {
        NSLog(@"kong");
    }else{
        if ([dataimgarr count]==1) {
            NSLog(@"2");
        }else{
            [self scorll2];
            [self scoroll];
        }
    }
    
}


- (void)img2_tap:(UITapGestureRecognizer *)sender {
    if ([dataimgarr count]==0) {
        //        NSLog(@"kong");
    }else{
        if ([dataimgarr count]==2) {
            NSLog(@"3");
        }else{
            [self scorll3];
            [self scoroll];
        }
    }
}

- (void)img3_tap:(UITapGestureRecognizer *)sender {
    if ([dataimgarr count]==0) {
        NSLog(@"kong");
    }else{
        if ([dataimgarr count]==3) {
            NSLog(@"4");
        }else{
            [self scorll4];
            [self scoroll];
        }
    }
    
    
}

-(void)scorll1{
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, mainScreenheight)];
    scrollView.contentSize = CGSizeMake(dataimgarr.count*scrollView.frame.size.width, scrollView.frame.size.height);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.clipsToBounds = NO;
    scrollView.pagingEnabled = YES;
    scrollView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:scrollView];
}

-(void)scorll2{
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, mainScreenheight)];
    scrollView.contentSize = CGSizeMake(dataimgarr.count*scrollView.frame.size.width, scrollView.frame.size.height);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.clipsToBounds = NO;
    scrollView.pagingEnabled = YES;
    scrollView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:scrollView];
    [scrollView setContentOffset:CGPointMake(mainScreenWidth,0) animated:NO];
}

-(void)scorll3{
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, mainScreenheight)];
    scrollView.contentSize = CGSizeMake(dataimgarr.count*scrollView.frame.size.width, scrollView.frame.size.height);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.clipsToBounds = NO;
    scrollView.pagingEnabled = YES;
    scrollView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:scrollView];
    [scrollView setContentOffset:CGPointMake(mainScreenWidth*2,0) animated:NO];
}

-(void)scorll4{
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, mainScreenheight)];
    scrollView.contentSize = CGSizeMake(dataimgarr.count*scrollView.frame.size.width, scrollView.frame.size.height);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.clipsToBounds = NO;
    scrollView.pagingEnabled = YES;
    scrollView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:scrollView];
    [scrollView setContentOffset:CGPointMake(mainScreenWidth*3,0) animated:NO];
}
//图片浏览器
-(void)scoroll{
    [dangtext resignFirstResponder];
    for (int i = 0; i<dataimgarr.count; i++) {
        UIImageView *image2 = [[UIImageView alloc]initWithFrame:CGRectMake(mainScreenWidth*i, 100, mainScreenWidth, 300)];
        [image2 setImage:[dataimgarr objectAtIndex:i]];
        image2.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrollView:)];
        [image2 addGestureRecognizer:singleTap];
        [scrollView addSubview:image2];
        
        UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(mainScreenWidth-60, 20, 30, 30)];
        [button1 addTarget:self action:@selector(button1:) forControlEvents:(UIControlEventTouchUpInside)];
        button1.tag = i;
        [button1 setImage:[UIImage imageNamed:@"define_tag"] forState:(UIControlStateNormal)];
        button1.selected = NO;
        [image2 addSubview:button1];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
//    self.navigationController.navigationBar.alpha = 0;
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController.view sendSubviewToBack:self.navigationController.navigationBar];
    
    [self.view endEditing:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.loopView resetTheLoop];
    if(!imgondar_islogin) {
        [tasktailView setUserInteractionEnabled:YES];
    }else {
        [tasktailView setUserInteractionEnabled:YES];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.view endEditing:YES];
    
    if (!self.changeSomething) {
        [self callBackBlock]();
    }
}

- (void)dealloc{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark - ASIHttpRequest


-(void)requestFinished:(ASIHTTPRequest *)request
{
    int responseCode=[request responseStatusCode];
    NSError *error;
    NSData *responseData = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    NSString *error_number = [dic objectForKey:ERROR];
    if([[request.userInfo objectForKey:REQUEST_TYPE] isEqual:REQUEST_FOR_CHANGE_SKILL])
    {
        [self endLoad];
        //        NSLog(@"大大---------%@",dic);
        if(responseCode==200 && [error_number integerValue]==0)
        {
            // 操作提示
            [ProgressHUD show:[dic objectForKey:@"msg"]];
            
            // 上架技能，下架技能成功
            NSInteger action = self.downLabel.tag;
            if (action == 1) {
                // 下架技能成功
                self.downLabel.text = @"上架";
                [self.downImageView setImage:[UIImage imageNamed:@"skillshow_online"]];
                isShow = NO;
            }else{
                // 上架技能成功
                self.downLabel.text = @"下架";
                [self.downImageView setImage:[UIImage imageNamed:@"skillshow_offline"]];
                isShow = YES;
            }
        }
        else if([dic objectForKey:@"msg"]){
            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
        }else{
            [ghunterRequester noMsg];
        }
    }
    if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_REPORT]){
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            [ghunterRequester performSelectorOnMainThread:@selector(showTip:) withObject:[dic objectForKey:@"msg"] waitUntilDone:false];
        }else if([dic objectForKey:@"msg"]){
            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
        }else{
            [ghunterRequester noMsg];
        }
    }
    
    else if([[request.userInfo objectForKey:REQUEST_TYPE] isEqual:REQUEST_FOR_GET_SKILL_CONTENT])
    {
        
    }
    else if([[request.userInfo objectForKey:REQUEST_TYPE] isEqual:REQUEST_FOR_NEW_ADD_COLLECTION] || [[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_NEW_DELETE_COLLECTION])
    {
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            collected = !collected;
            if (!collected) {
                
                [self.skillCollect setImage:[UIImage imageNamed:@"收藏"]];
                
                collected = NO;
            } else {
                
                [self.skillCollect setImage:[UIImage imageNamed:@"收藏-拷贝"]];
                
                collected = YES;
            }
            NSString *errorMsg = [dic objectForKey:@"msg"];
            [ghunterRequester performSelectorOnMainThread:@selector(showTip:) withObject:errorMsg waitUntilDone:false];
        }
        else if([dic objectForKey:@"msg"]){
            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
        }else{
            [ghunterRequester noMsg];
        }
    }
    //    NSLog(@"---------%@",skillcommentArray);
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    [self endLoad];
    taskTable.pullTableIsRefreshing = NO;
    taskTable.pullTableIsLoadingMore = NO;
    [ghunterRequester performSelectorOnMainThread:@selector(showTip:) withObject:@"网络连接异常" waitUntilDone:false];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[Monitor sharedInstance].Identify isEqualToString:@"PL"]||[Monitor sharedInstance].Identify ==nil) {
        Monitor * hehe = [Monitor sharedInstance];
        hehe.plbante = @"kkk";
        if (skillcommentArray.count==0) {
            
        }else{
            
            NSDictionary *dic = [skillcommentArray objectAtIndex:indexPath.row - 1];
            
            namedic = [dic objectForKey:@"username"];
            
            [skdic setObject:[dic objectForKey:@"cid"] forKey:@"reply_cid"];
            
            [dangtext becomeFirstResponder];
            dangtext.returnKeyType=UIReturnKeySend;
            
            [self.view addSubview:textbg];
            [self createChatView];
            [textbg addSubview:dangtext];
            [textbg addSubview:biaoqingBtn];
            [textbg addSubview:addBtn2];
            [textbg addSubview:downBtn3];
            
            nameLb = [[UILabel alloc] initWithFrame:CGRectMake(85, 11, 150, 20)];
            nameLb.text = [NSString stringWithFormat:@"回复%@ ：", namedic];
            nameLb.textColor = [UIColor grayColor];
            nameLb.textAlignment = NSTextAlignmentLeft;
            nameLb.backgroundColor = [UIColor clearColor];
            nameLb.font = [UIFont systemFontOfSize:10];
            
            [textbg addSubview:nameLb];
        }
        
    }else{
        
        
        if (indexPath.row == 0) {
            return;
        }
        
        if(self.skillid)
        {
            NSDictionary *dic = [skillcommentArray objectAtIndex:indexPath.row-1];
            NSInteger isprivate = [[dic objectForKey:@"isprivate"] integerValue];
            // 匿名评价，不能点击查看
            if (isprivate == 1) {
                return;
            }
            ghunterCheckEvaluationViewController *evaView = [[ghunterCheckEvaluationViewController alloc] init];
            evaView.tid = [dic objectForKey:@"tid"];
            [self.navigationController pushViewController:evaView animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height+40;
    }else{
        NSDictionary* comment;
        
        comment = [skillcommentArray objectAtIndex:indexPath.row - 1];
        if ([[Monitor sharedInstance].Identify isEqualToString:@"PL"]) {
            NSArray *picsarray = [comment objectForKey:@"pics"];
            if (picsarray.count ==0) {
                UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
                return cell.frame.size.height;
            }else{
                UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
                return cell.frame.size.height;
            }
        }else{
            
            UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
            return cell.frame.size.height;
        }
    }
}
// 点击评论/评价按钮
//- (void)commentHunter:(UITapGestureRecognizer *)sender{
//    NSUInteger tag = sender.view.tag;
//
//    ghunterUserCenterViewController *userCenter = [[ghunterUserCenterViewController alloc] init];
//    NSDictionary *comment;
//
//    comment = [skillcommentArray objectAtIndex:tag];
//    userCenter.uid = [comment objectForKey:UID];
//
//    [self.navigationController pushViewController:userCenter animated:YES];
//}
-(void)pullimage:(UITapGestureRecognizer *)tap{
    //     NSUInteger tag = tap.view.tag;
    
    [SJAvatarBrowser showImage:(UIImageView*)tap.view];
}
#pragma mark - SOLoopViewDelegate
//- (NSInteger)countOfImageForSOLoopView:(SOLoopView *)loopView
//{
//    return [imgarr count];
//}
////
//- (UIView *)viewForSOLoopView:(SOLoopView *)loopView atIndex:(NSInteger)index
//{
//    NSURL *imageURL = [NSURL URLWithString:imgarr[index]];
//    UIImageView *imageView = [UIImageView new];
//    [imageView sd_setImageWithURL:imageURL];
//    imageView.contentMode = UIViewContentModeScaleAspectFill;
//
//    return imageView;
//}
//
//- (void)SOLoopView:(SOLoopView *)loopView selectViewAtIndex:(NSInteger)index
//{
//     UIImageView *imageView;
//     NSInteger count = imgarr.count;
//    if (count == 0) {
//        return;
//    }
//    if (imgarr.count<2) {
//        NSURL *imageURL = [NSURL URLWithString:imgarr[index]];
//        imageView = [UIImageView new];
//        [imageView sd_setImageWithURL:imageURL];
//        imageView.contentMode = UIViewContentModeScaleAspectFill;
//        [SJAvatarBrowser showImage:(UIImageView*)imageView];
//    }else
//    {
//        // 1.封装图片数据
//        NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
//        for (int i = 0; i<count; i++) {
//            // 替换为中等尺寸图片
//            NSString *url = [imgarr[i] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
//            MJPhoto *photo = [[MJPhoto alloc] init];
//            photo.url = [NSURL URLWithString:url]; // 图片路径
//            photo.srcImageView = imageView; // 来源于哪个UIImageView
//            [photos addObject:photo];
//        }
//
//        // 2.显示相册
//        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
//        browser.currentPhotoIndex = index; // 弹出相册时显示的第一张图片是？
//        browser.photos = photos; // 设置所有的图片
//        [browser show];
//    }
//}

#pragma mark - UITableviewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(!requested){
        return 0;
    }
    return [skillcommentArray count]+1;
}

#pragma mark=======显示===========
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *info;
    NSDictionary *owner;
    NSDictionary *stat;
    NSDictionary* skillInfo;
    
    
    info=[skill objectForKey:@"info"];
    owner=[skill objectForKey:@"owner"];
    stat=[skill objectForKey:@"stat"];
    picArray = [skill objectForKey:@"images"];
    
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSArray *subviews = [[NSArray alloc] initWithArray:cell.contentView.subviews];
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
    
    if (indexPath.row == 0) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"skillContent" owner:self options:nil];
        cell = [nibs objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        UIImageView *icon = (UIImageView *)[cell viewWithTag:1];
        UILabel *name = (UILabel *)[cell viewWithTag:2];
        UIImageView *gender = (UIImageView *)[cell viewWithTag:81];
        UILabel *distance = (UILabel *)[cell viewWithTag:5];
        UIView *userBG = (UIView *)[cell viewWithTag:8];
        UILabel *dateline = (UILabel *)[cell viewWithTag:9];
        UIImageView *catalog = (UIImageView *)[cell viewWithTag:10];
        OHAttributedLabel *bounty = (OHAttributedLabel *)[cell viewWithTag:11];
        UILabel *taskTitle = (UILabel *)[cell viewWithTag:12];
        description = (OHAttributedLabel *)[cell viewWithTag:13];
        UIView *ServiceMode = (UIView *)[cell viewWithTag:30];
        UILabel *ServiceModeLabel = (UILabel *)[cell viewWithTag:31];
        UIView *ServiceTime = (UIView *)[cell viewWithTag:40];
        UILabel *ServiceTimeLabel = (UILabel *)[cell viewWithTag:41];
        UIView *ServiceLocation = (UIView *)[cell viewWithTag:50];
        UILabel *ServiceLocationLabel = (UILabel *)[cell viewWithTag:51];
        description.delegate = self;
        
        UILabel *trade_dateline = (UILabel *)[cell viewWithTag:14];
        trade_dateline.hidden = YES;
        
        UIButton *report = (UIButton *)[cell viewWithTag:15];
        taskBG = (UIView *)[cell viewWithTag:16];
        UIImageView *people = (UIImageView *)[cell viewWithTag:200];
        UIImageView *fire = (UIImageView *)[cell viewWithTag:201];

        UILabel *biddingBum = (UILabel *)[cell viewWithTag:17];
        UILabel *hotNum = (UILabel *)[cell viewWithTag:18];
        UIView *stateBG = (UIView *)[cell viewWithTag:20];
        UILabel *commentNum = (UILabel *)[cell viewWithTag:19];
        UIView *commentBG = (UIView *)[cell viewWithTag:21];
        UIImageView *task_round = (UIImageView *)[cell viewWithTag:23];
        UILabel* goldLabel=(UILabel*)[cell viewWithTag:99];
        UIView * ageview = (UIView *)[cell viewWithTag:58];
        ageview.layer.cornerRadius = 2.0;
        taskTitle.textColor = RGBCOLOR(0, 0, 0);
        description.textColor = RGBCOLOR(102, 102, 102);
        
       
        NSString *servicemode = [info objectForKey:@"sev_mode"];
        if ([servicemode isEqualToString:@"1"]) {
            ServiceModeLabel.text = @"线上服务";
        }else if ([servicemode isEqualToString:@"2"])
        {
            ServiceModeLabel.text = @"线下服务";
        }else if ([servicemode isEqualToString:@"3"])
        {
            ServiceModeLabel.text = @"邮寄给你";
        }else if ([servicemode isEqualToString:@"4"])
        {
            ServiceModeLabel.text = @"找我自取";
        }
        NSString *servicetime = [info objectForKey:@"sev_time"];
        if ([servicetime isEqualToString:@"1"]) {
            ServiceTimeLabel.text = @"无限制";
        }else if ([servicetime isEqualToString:@"2"])
        {
            ServiceTimeLabel.text = @"上午 09:00-12:00";
        }else if ([servicetime isEqualToString:@"3"])
        {
            ServiceTimeLabel.text = @"下午 12:00-17:00";
        }else if ([servicetime isEqualToString:@"4"])
        {
            ServiceTimeLabel.text = @"晚上 17:00-24:00";
        }else if ([servicetime isEqualToString:@"23"])
        {
            ServiceTimeLabel.text = @"上午 09:00-12:00下午 12:00-17:00";
        }else if ([servicetime isEqualToString:@"24"])
        {
            ServiceTimeLabel.text = @"上午 09:00-12:00晚上 17:00-24:00";
        }else if ([servicetime isEqualToString:@"34"])
        {
            ServiceTimeLabel.text = @"下午 12:00-17:00晚上 17:00-24:00";
        }
        NSString *serviceLocation = [info objectForKey:@"sev_location"];
        ServiceLocationLabel.text =serviceLocation;
        
        
        CGFloat spaceTitle2Description = description.frame.origin.y - (taskTitle.frame.origin.y + taskTitle.frame.size.height);
        NSString *titleStr;
        
        titleStr = [info objectForKey:@"skill"];
        
        CGSize titleSize = [titleStr sizeWithFont:taskTitle.font constrainedToSize:CGSizeMake(taskTitle.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        CGRect titleFrameOrigin = taskTitle.frame;
        CGFloat diffTitle = titleSize.height - titleFrameOrigin.size.height;
        titleFrameOrigin.size.height = titleSize.height;
        [taskTitle setFrame:titleFrameOrigin];
        //        NSString * jinengStr = [NSString stringWithFormat:@"Ta的技能: %@", titleStr];
        
        [taskTitle setText:titleStr];
        
        NSString *descriptionSelf = [info objectForKey:@"description"];
        NSString *descriptionStr;
        
        
        descriptionStr = [NSString stringWithFormat:@"技能详情: %@",descriptionSelf];
        NSMutableAttributedString *descriptionattrStr                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              = [NSMutableAttributedString attributedStringWithString:descriptionStr];
        [descriptionattrStr setFont:[UIFont systemFontOfSize:12.0] range:NSMakeRange(0, 5)];
        [descriptionattrStr setFont:[UIFont systemFontOfSize:12.0] range:NSMakeRange(5, [descriptionSelf length])];
        [descriptionattrStr setTextColor:[UIColor colorWithRed:137.0/255.0 green:137.0/255.0 blue:137.0/255.0 alpha:1.0] range:NSMakeRange(0,5)];
        [descriptionattrStr setTextColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0] range:NSMakeRange(5, [descriptionSelf length])];
        
        CGSize descriptionSize = [descriptionStr sizeWithFont:[UIFont systemFontOfSize:12.0] constrainedToSize:CGSizeMake(description.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        CGRect descriptionFrameOrigin = description.frame;
        CGFloat diffDescription = descriptionSize.height - descriptionFrameOrigin.size.height+10;
        descriptionFrameOrigin.origin.y = taskTitle.frame.origin.y + taskTitle.frame.size.height + spaceTitle2Description;
        descriptionFrameOrigin.size.height = descriptionSize.height;
        [description setAttributedText:descriptionattrStr];
        
        
        int j =0;
        UIImageView *imageviewstr;
        for (NSDictionary *dic in picArray) {
            int x = j%3;
            int y = j/3;
            
            NSURL *url = [dic objectForKey:@"largeurl"];
            
            imageviewstr = [[UIImageView alloc]initWithFrame:CGRectMake(8+78*x,diffDescription+description.frame.origin.y+diffTitle+78*y +85+120+5, 70, 70)];
            imageviewstr.tag = 100+j;
            imageviewstr.userInteractionEnabled = YES;
            [imageviewstr sd_setImageWithURL:url placeholderImage:nil];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pic_taped:)];
            [imageviewstr addGestureRecognizer:tap];

            [taskBG addSubview:imageviewstr];
            j++;
        }
        
        
        
        if (picArray.count <=3&&picArray.count>0) {
            taskBG.frame = CGRectMake(0, taskBG.frame.origin.y, taskBG.frame.size.width, description.frame.origin.y+diffDescription+diffTitle+85+120+120);
        }else if (picArray.count >3&&picArray.count<=6) {
            taskBG.frame = CGRectMake(0, taskBG.frame.origin.y, taskBG.frame.size.width, description.frame.origin.y+diffDescription+diffTitle+140+145+120);
        }else if (picArray.count >6) {
            taskBG.frame = CGRectMake(0, taskBG.frame.origin.y, taskBG.frame.size.width, description.frame.origin.y+diffDescription+diffTitle+140+225+120);
        }else if (picArray.count == 0)
        {
            taskBG.frame = CGRectMake(0, taskBG.frame.origin.y, taskBG.frame.size.width, description.frame.origin.y+diffDescription+diffTitle+120+100);
        }
        
        
        
        
        //分割线
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, mainScreenWidth, 0.5)];
        line.backgroundColor = RGBCOLOR(235, 235, 235);
        [taskBG addSubview:line];
        
        icon.layer.masksToBounds =YES;
        icon.layer.cornerRadius = 25;
        [icon sd_setImageWithURL:[owner objectForKey:TINY_AVATAR] placeholderImage:[UIImage imageNamed:@"avatar"]];
        
        [icon setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconTaped)];
        [icon addGestureRecognizer:tap];
        icon.userInteractionEnabled = YES;
        [name setText:[owner objectForKey:@"username"]];
        
        if ([[owner objectForKey:@"uid"] isEqualToString:[ghunterRequester getUserInfo:UID]]) {
            [distance setText:@"0m"];
        }
        
        NSString *distanceStr = [ghunterRequester calculateDistanceWithLatitude:[info objectForKey:@"latitude"] withLongitude:[info objectForKey:@"longitude"]];
        distance.textColor = [UIColor grayColor];
        distance.textAlignment = NSTextAlignmentRight;
        [distance setText:distanceStr];
        
        
        CGSize nameSize = [[owner objectForKey:@"username"] sizeWithFont:name.font];
        
        // 性别图标
        if([[owner objectForKey:@"sex"] isEqualToString:@"0"]){
            [gender setImage:[UIImage imageNamed:@"female"]];
        }else{
            [gender setImage:[UIImage imageNamed:@"male"]];
        }
        
        CGRect nameTitleFrame = name.frame;
        if (nameSize.width > 76) {
            nameTitleFrame.size.width = nameSize.width;
        }
        name.frame = nameTitleFrame;
        
        CGRect nameFrame = name.frame;
        CGRect genderFrame = gender.frame;
        genderFrame.origin.x = nameSize.width + nameFrame.origin.x + 5;
        gender.frame = genderFrame;
        
        CGRect disFrame = distance.frame;
        disFrame.origin.x = name.frame.origin.x + name.frame.size.width + 23;
        
        // 职业前图标
        UIImageView * industryImg = [[UIImageView alloc] initWithFrame:CGRectMake(gender.frame.origin.x + gender.frame.size.width + 5, name.frame.origin.y + 14, 12, 12)];
        NSDictionary * dict = [owner objectForKey:@"wicon"];
        NSString * IndustryStr = [dict objectForKey:@"word"];
        if (![IndustryStr isEqualToString:@""]) {
            
            NSString * tmpString = [IndustryStr substringWithRange:NSMakeRange(0, 1)];
            if ([tmpString isEqualToString:@"I"]) {
                
                industryImg.image = [UIImage imageNamed:@"信"];
            }else {
                
                industryImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", tmpString]];
            }
        }
        [cell addSubview:industryImg];
        
        UILabel * jobLb = [[UILabel alloc] initWithFrame:CGRectMake(industryImg.frame.origin.x + industryImg.frame.size.width + 5, name.frame.origin.y + 11, 80, 17)];
        //        jobLb.textColor = [UIColor blackColor];
        jobLb.textColor = RGBCOLOR(102, 102, 102);
        jobLb.font = [UIFont systemFontOfSize:10];
        jobLb.text = [owner objectForKey:@"job"];
        [cell addSubview:jobLb];
        
        UIImageView * levelImgV = (UIImageView *)[cell viewWithTag:56];
        NSInteger i = [NSString stringWithFormat:@"%@",[owner objectForKey:@"level"]].intValue;
        levelImgV.image = [UIImage imageNamed:[NSString stringWithFormat:@"等级%ld", (long)i]];
        
        UIImageView * trueName = (UIImageView *)[cell viewWithTag:456];
        if([[owner objectForKey:@"is_identity"] isEqualToString:@"1"]){
            
            trueName.image = [UIImage imageNamed:@"实名认证"];
            
            TQStarRatingView *star = [[TQStarRatingView alloc] initWithFrame:CGRectMake(trueName.frame.origin.x + trueName.frame.size.width + 12, levelImgV.frame.origin.y + 2, 50, 10) numberOfStar:5];
            [star setScore:[[owner objectForKey:@"kopubility"] floatValue]];
            [star setuserInteractionEnabled:NO];
            
            [userBG addSubview:star];
        }else{
            TQStarRatingView *star = [[TQStarRatingView alloc] initWithFrame:CGRectMake(levelImgV.frame.origin.x + levelImgV.frame.size.width + 12, levelImgV.frame.origin.y + 2, 50, 10) numberOfStar:5];
            [star setScore:[[owner objectForKey:@"kopubility"] floatValue]];
            [star setuserInteractionEnabled:NO];
            [userBG addSubview:star];
        }
        
        NSString *datelineDescription = [ghunterRequester getTimeDescripton:[info objectForKey:@"dateline"]];
        [dateline setText:datelineDescription];
        dateline.textColor = [UIColor grayColor];
        NSString *bountyStr;
        NSString *bountySelf;
        
        goldLabel.text=@"售";
        goldLabel.font = [UIFont systemFontOfSize:14];
        // 技能分类图片
        NSInteger fcid = [[info objectForKey:@"fcid"] integerValue];
        [catalog setImage:[UIImage imageNamed:[ghunterRequester getSkillCatalogImg:fcid]]];
        bountySelf=[info objectForKey:@"price"];
        NSString* priceunit=[info objectForKey:@"priceunit"];
        bountyStr = [NSString stringWithFormat:@"%@元/%@", bountySelf, priceunit];
        
        NSMutableAttributedString *attrStr = [NSMutableAttributedString attributedStringWithString:bountyStr];
        //        [attrStr setFont:[UIFont systemFontOfSize:15.0] range:NSMakeRange([bountySelf length], 1)];
        //        [attrStr setFont:[UIFont systemFontOfSize:15.0] range:NSMakeRange(0, [bountySelf length])];
        [attrStr setTextColor:[UIColor colorWithRed:234/255.0 green:85/255.0 blue:20/255.0 alpha:1.0]];
        [attrStr setFont:[UIFont systemFontOfSize:14]];
        [bounty setAttributedText:attrStr];
        
        CGRect bountyFrame = bounty.frame;
        
        bountyFrame.origin.x = goldLabel.frame.origin.x + 35;
        bountyFrame.origin.y = goldLabel.frame.origin.y + 5;
        
        bounty.frame = bountyFrame;
        
        
        
        CGRect taskBGFrame = taskBG.frame;
        if(skillInfo.count!=0)
        {
            taskBGFrame.size.height+=(diffTitle+diffDescription+80);
        }
        else
        {
            taskBGFrame.size.height += (diffTitle + diffDescription);
        }
//        [taskBG setFrame:taskBGFrame];
        NSString *modeLabel = [info objectForKey:@"sev_mode"];
        NSString *timeLabel = [info objectForKey:@"sev_time"];
        NSString *locationLabel = [info objectForKey:@"sev_location"];
        //服务方式
        if ([modeLabel isEqualToString:@"1"]) {
            ServiceModeLabel.text = @"线上服务";
        }else if ([modeLabel isEqualToString:@"2"])
        {
            ServiceModeLabel.text = @"线下服务";
            
        }else if ([modeLabel isEqualToString:@"3"])
        {
            ServiceModeLabel.text = @"邮寄给你";
            
        }else if ([modeLabel isEqualToString:@"4"])
        {
            ServiceModeLabel.text = @"找我自取";
            
        }
        //服务地址
        if (locationLabel.length != 0) {
            ServiceLocationLabel.text = locationLabel;
        }else
        {
            ServiceLocationLabel.text = @"无限制";
            
        }
        //服务时间
        if ([timeLabel isEqualToString:@"1"]) {
            ServiceTimeLabel.text = @"无限制";
        }else if ([timeLabel isEqualToString:@"2"])
        {
            ServiceTimeLabel.text = @"上午9:00-12:00";
            
        }else if ([timeLabel isEqualToString:@"3"])
        {
            ServiceTimeLabel.text = @"下午12:00-17:00";
            
        }else if ([timeLabel isEqualToString:@"4"])
        {
            ServiceTimeLabel.text = @"晚上17:00-24:00";
            
        }else if ([timeLabel isEqualToString:@"23"])
        {
            ServiceTimeLabel.text = @"上午9:00-12:00下午12:00-17:00";
            
        }else if ([timeLabel isEqualToString:@"24"])
        {
            ServiceTimeLabel.text = @"上午9:00-12:00晚上17:00-24:00";
            
        }else if ([timeLabel isEqualToString:@"34"])
        {
            ServiceTimeLabel.text = @"下午12:00-17:00晚上17:00-24:00";
            
        }
        
        //图片

        
        
        
        ServiceMode.frame = CGRectMake(0, taskBG.frame.size.height+100,103, 60);
        ServiceTime.frame = CGRectMake(ServiceMode.frame.size.width+5, taskBG.frame.size.height+100, 103, 60);
        
        ServiceLocation.frame = CGRectMake(ServiceTime.frame.size.width+5+ServiceTime.frame.origin.x, taskBG.frame.size.height+100, 104, 60);
        
        CGFloat top = 20; // 顶端盖高度
        CGFloat bottom = task_round.frame.size.height - top - 1; // 底端盖高度
        CGFloat left = 20; // 左端盖宽度
        CGFloat right = task_round.frame.size.width - left - 1; // 右端盖宽度
        UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
        // 指定为拉伸模式，伸缩后重新赋值
        UIImage *image = [UIImage imageNamed:@"task_angle_round"];
        image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        
        picArray=[skill objectForKey:@"images"];
        
        
        CGRect stateBGSize = stateBG.frame;
        stateBGSize.origin.y = taskBG.frame.size.height-30;
        [stateBG setFrame:stateBGSize];
        
        [biddingBum setText:[NSString stringWithFormat:@"%@人购买",[stat objectForKey:@"salenum"]]];
        
        [hotNum setText:[NSString stringWithFormat:@"%@热度",[stat objectForKey:@"hot"]]];
        CGSize biddingBumSize = [biddingBum.text sizeWithFont:[UIFont systemFontOfSize:10.0] constrainedToSize:CGSizeMake(biddingBum.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        CGSize hotNumSize = [hotNum.text sizeWithFont:[UIFont systemFontOfSize:10.0] constrainedToSize:CGSizeMake(hotNum.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        hotNum.frame = CGRectMake(mainScreenWidth-10-hotNumSize.width, hotNum.frame.origin.y, hotNumSize.width, hotNum.frame.size.height);
        fire.frame = CGRectMake(mainScreenWidth-10-hotNumSize.width-5-fire.frame.size.width, fire.frame.origin.y, fire.frame.size.width, fire.frame.size.height);
        biddingBum.frame = CGRectMake(mainScreenWidth-10-hotNumSize.width-5-fire.frame.size.width-15-biddingBumSize.width, biddingBum.frame.origin.y, biddingBumSize.width, biddingBum.frame.size.height);
        people.frame = CGRectMake(mainScreenWidth-10-hotNumSize.width-5-fire.frame.size.width-15-biddingBumSize.width-5-people.frame.size.width, people.frame.origin.y, people.frame.size.width, people.frame.size.height);
        
        if([[owner objectForKey:@"uid"] isEqualToString:[ghunterRequester getUserInfo:UID]]){
            report.hidden = YES;
        }else{
            report.hidden = NO;
        }
        [report addTarget:self action:@selector(report:) forControlEvents:UIControlEventTouchUpInside];
        
        // 评论数目
        [commentNum setText:[NSString stringWithFormat:@"%zd条评价",[skillcommentArray count]]];
        CGRect oldFrame = commentBG.frame;
        oldFrame.origin.y = stateBG.frame.origin.y+stateBG.frame.size.height;
        commentBG.frame=oldFrame;
        
        NSString *comentcount = [[skill objectForKey:@"stat"] objectForKey:@"commentCount"];
        NSString *comstr = [NSString stringWithFormat:@"(评论%@)",comentcount];
        
        
        
        Coment = [[UIButton alloc]initWithFrame:CGRectMake(0, taskBG.frame.size.height+170, mainScreenWidth/2, 30)];
        [Coment addTarget:self action:@selector(coment:) forControlEvents:(UIControlEventTouchUpInside)];
        Coment.titleLabel.font = [UIFont systemFontOfSize:12];
        [Coment setTitle:comstr forState:(UIControlStateNormal)];
        Coment.tag = indexPath.row;
        
        Coment.backgroundColor = [UIColor whiteColor];
        [cell addSubview:Coment];
        
        redlin1 = [[UILabel alloc]initWithFrame:CGRectMake(0, Coment.frame.origin.y+Coment.frame.size.height-0.2, mainScreenWidth/2-0.5, 1.5)];
        redlin1.backgroundColor = RGBCOLOR(234, 85, 19);
        [cell addSubview:redlin1];
        
        
        UILabel *liness = [[UILabel alloc]initWithFrame:CGRectMake(mainScreenWidth/2-0.5, taskBG.frame.size.height+175, 1, 20)];
        liness.backgroundColor =  RGBCOLOR(229, 229, 229);
        [cell addSubview:liness];
        cell.frame=CGRectMake(0, 0, mainScreenWidth, commentBG.frame.origin.y+commentBG.frame.size.height+100+60);
        
        
        // 评价数目
        NSString *soldnum = [[skill objectForKey:@"stat"] objectForKey:@"soldnum"];
        NSString *soldstr = [NSString stringWithFormat:@"(评价%@)",soldnum];
        Evaluation = [[UIButton alloc]initWithFrame:CGRectMake(mainScreenWidth/2, taskBG.frame.size.height+170, mainScreenWidth/2, 30)];
        [Evaluation addTarget:self action:@selector(Evaluation:) forControlEvents:(UIControlEventTouchUpInside)];
        Evaluation.tag = indexPath.row;
        Evaluation.titleLabel.font = [UIFont systemFontOfSize:12];
        Evaluation.backgroundColor = [UIColor whiteColor];
        [Evaluation setTitle:soldstr forState:(UIControlStateNormal)];
        [cell addSubview:Evaluation];
        [Evaluation setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        redlin2 = [[UILabel alloc]initWithFrame:CGRectMake(mainScreenWidth/2, Coment.frame.origin.y+Coment.frame.size.height-0.2, mainScreenWidth/2-0.5, 1.5)];
        redlin2.backgroundColor = RGBCOLOR(234, 85, 19);
        [cell addSubview:redlin2];
        
        
        if (flagClick == NO) {
            
            redlin1.backgroundColor = RGBCOLOR(234, 85, 19);
            [Coment setTitleColor:RGBCOLOR(234, 85, 19) forState:UIControlStateNormal];
            [Evaluation setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            redlin2.backgroundColor = [UIColor whiteColor];
        }else if (flagClick == YES) {
            
            redlin1.backgroundColor = [UIColor whiteColor];
            [Coment setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [Evaluation setTitleColor:RGBCOLOR(234, 85, 19) forState:UIControlStateNormal];
            redlin2.backgroundColor = RGBCOLOR(234, 85, 19);
        }
        return cell;
    }
    else{
        if (  [[Monitor sharedInstance].Identify isEqualToString:@"PL"]) {
            
            NSDictionary* comment;
            comment = [skillcommentArray objectAtIndex:indexPath.row - 1];
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"commentCell" owner:self options:nil];
            cell = [nibs objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *lines = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, mainScreenWidth, 0.5)];
            lines.backgroundColor = RGBCOLOR(221, 221, 222);
            [cell addSubview:lines];
            UIImageView *icon = (UIImageView *)[cell viewWithTag:1];
            UILabel *username = (UILabel *)[cell viewWithTag:2];
            UILabel *dateline = (UILabel *)[cell viewWithTag:4];
            UILabel *line = (UILabel *)[cell viewWithTag:6];
            dateline.textColor = [UIColor grayColor];
            
            username.font = [UIFont systemFontOfSize:12];
            username.textColor = RGBCOLOR(102, 102, 102);
            
            UILabel *commentContent =[[UILabel alloc]initWithFrame:CGRectMake(58, 30, ScreenWidthFull-63, 0)];
            commentContent.font = [UIFont systemFontOfSize:13];
            NSString *contenttext = [comment objectForKey:@"content"];
            CGRect ssss;
            NSDictionary *adssada = @{NSFontAttributeName : [UIFont systemFontOfSize:13]};
            ssss = [contenttext boundingRectWithSize:CGSizeMake(ScreenWidthFull-63, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:adssada context:nil];
            
            [commentContent setFrame:CGRectMake(58, 30, mainScreenWidth-63, ssss.size.height+2)];
            
            NSMutableAttributedString* str=[NSMutableAttributedString attributedStringWithAttributedString:[ghunterWordChange wordChange:contenttext]];
            [str addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:42.0/255.0 green:42.0/255.0 blue:42.0/255.0 alpha:1.0]} range:NSMakeRange(0, str.length)];
            [commentContent setAttributedText:str];
            [commentContent setNumberOfLines:0];
            [cell addSubview:commentContent];
            
            NSString * usernameStr;
            
            [icon sd_setImageWithURL:[comment objectForKey:@"tiny_avatar"] placeholderImage:[UIImage imageNamed:@"avatar"]];
            if(![comment objectForKey:@"tiny_avatar"])
            {
                [icon sd_setImageWithURL:[comment objectForKey:@"thumb_avatar"] placeholderImage:[UIImage imageNamed:@"avatar"]];
            }
            usernameStr = [comment objectForKey:@"username"];
            icon.layer.cornerRadius = icon.frame.size.height / 2;
            icon.clipsToBounds = YES;
            icon.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentHunter:)];
            icon.tag = indexPath.row - 1;
            [icon addGestureRecognizer:tap];
            
            NSString *datelineStr = [comment objectForKey:@"dateline"];
            [username setText:[NSString stringWithFormat:@"%@:",usernameStr]];
            CGRect commentContentFrame = commentContent.frame;
            
            UIImage* image=[UIImage imageNamed:@"emoji_1"];
            CGFloat imageHeight=image.size.height;
            
            if(ssss.size.height<imageHeight)
            {
                ssss.size.height=imageHeight+3;
            }
            if(commentContentFrame.size.height>135)
            {
                commentContentFrame.size.height-=9;
            }
            if(commentContentFrame.size.height>65&&commentContentFrame.size.height<135)
            {
                commentContentFrame.size.height-=3;
            }
            
            CGRect cellFrame = cell.frame;
            cellFrame.size.height =commentContent.frame.origin.y + ssss.size.height+10;
            [cell setFrame:cellFrame];
            
            [dateline setText:[ghunterRequester getTimeDescripton:datelineStr]];
            if(indexPath.row == 1){
                line.hidden = YES;
            }
            
            if([[comment objectForKey:UID] isEqualToString:[ghunterRequester getUserInfo:UID]]){
                UILongPressGestureRecognizer *long_press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(commentHunter:)];
                cell.tag = indexPath.row;
                [cell addGestureRecognizer:long_press];
            }
            [cell bringSubviewToFront:commentContent];
            NSArray *picsarray = [comment objectForKey:@"pics"];
            if (picsarray==0) {
                
            }else{
                for (int i = 0; i<picsarray.count; i++) {
                    //cell 评论图片
                    UIImageView *pullimage= [[UIImageView alloc]initWithFrame:CGRectMake(i*60+60, commentContentFrame.origin.y+ssss.size.height+5, 50, 50)];
                    NSURL *imgurl = [NSURL URLWithString:[[picsarray objectAtIndex:picsarray.count - 1 - i]objectForKey:@"largeurl"]];
                    pullimage.tag = i;
                    [pullimage sd_setImageWithURL:imgurl placeholderImage:[UIImage imageNamed:@"avatar"]];
                    [cell addSubview:pullimage];
                    pullimage.userInteractionEnabled = YES;
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pullimage:)];
                    pullimage.tag = i;
                    [pullimage addGestureRecognizer:tap];
                    
                    cellFrame.size.height = commentContent.frame.origin.y + ssss.size.height + pullimage.frame.size.height + 15;
                }
            }
            cell.backgroundColor = [UIColor whiteColor];
            cell.frame = cellFrame;
            
            if([[comment objectForKey:UID] isEqualToString:[ghunterRequester getUserInfo:UID]]){
                UILongPressGestureRecognizer *long_press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(comment_longpressed:)];
                cell.tag = indexPath.row;
                [cell addGestureRecognizer:long_press];
            }
            
            
            return cell;
        }
        
        if (  [[Monitor sharedInstance].Identify isEqualToString:@"PJ"]) {
            
            NSDictionary* comment;
            comment=[skillcommentArray objectAtIndex:indexPath.row-1];
            
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"skillEvaContent" owner:self options:nil];
            cell = [nibs objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIImageView *icon = (UIImageView *)[cell viewWithTag:10];
            UILabel *username = (UILabel *)[cell viewWithTag:11];
            
            UILabel *dateline = (UILabel *)[cell viewWithTag:12];
            UIView *commentBG = (UIView *)[cell viewWithTag:19];
            NSString *usernameStr;
            
            [icon sd_setImageWithURL:[comment objectForKey:@"owner_avatar"] placeholderImage:[UIImage imageNamed:@"avatar"]];
            if(![comment objectForKey:@"owner_avatar"])
            {
                [icon sd_setImageWithURL:[comment objectForKey:@"thumb_avatar"] placeholderImage:[UIImage imageNamed:@"avatar"]];
            }
            
            // 名字
            usernameStr=[comment objectForKey:@"owner_username"];
            [username setText:[NSString stringWithFormat:@"%@:",usernameStr]];
            username.font=[UIFont boldSystemFontOfSize:12];
            
            CGRect usernameFrame = username.frame;
            usernameFrame.origin.y = icon.frame.origin.y;
            username.frame = usernameFrame;
            
            // 时间
            NSString *datelineStr = [comment objectForKey:@"dateline"];
            [dateline setText:[ghunterRequester getTimeDescripton:datelineStr]];
            dateline.textColor = [UIColor grayColor];
            dateline.textAlignment = NSTextAlignmentRight;
            CGRect dateFrame = dateline.frame;
            dateFrame.origin.x = mainScreenWidth - dateline.frame.size.width - 10;
            dateline.frame = dateFrame;
            
            // 头像
            icon.layer.cornerRadius = icon.frame.size.height / 2;
            icon.clipsToBounds = YES;
            icon.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentHunter:)];
            icon.tag = indexPath.row - 1;
            [icon addGestureRecognizer:tap];
            
            // 综合评价
            UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(username.frame.origin.x, username.frame.origin.y + username.frame.size.height + 2, 60, 15)];
            label.font=[UIFont systemFontOfSize:12];
            label.text=@"综合评价：";
            label.textColor=[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
            [cell addSubview:label];
            
            // 评价内容
            UILabel * EvaContent =[[UILabel alloc]initWithFrame:CGRectMake(username.frame.origin.x, label.frame.origin.y + label.frame.size.height - 2, ScreenWidthFull-63, 40)];
            EvaContent.textColor = [UIColor blackColor];
            EvaContent.font=[UIFont systemFontOfSize:12];
            EvaContent.layer.cornerRadius=8.0;
            [cell addSubview:EvaContent];
            EvaContent.numberOfLines = 0;
            EvaContent.text = [[comment objectForKey:@"description"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSString * evaString = [comment objectForKey:@"description"];
            
            CGSize EvaSize = [evaString sizeWithFont:EvaContent.font constrainedToSize:CGSizeMake(EvaContent.frame.size.width, MAXFLOAT)];
            
            CGRect commentContentFrame = EvaContent.frame;
            commentContentFrame.size.height = EvaSize.height + 10;
            [EvaContent setFrame:commentContentFrame];
            
            // 星级
            TQStarRatingView* starLabel=[[TQStarRatingView alloc] initWithFrame:CGRectMake(label.frame.size.width + label.frame.origin.x + 3, label.frame.origin.y, 50, 10) numberOfStar:5];
            [starLabel setScore:[[comment objectForKey:@"valuation"] floatValue]];
            [starLabel setuserInteractionEnabled:NO];
            [cell addSubview:starLabel];
            
            CGRect cellFrame = cell.frame;
            cellFrame.size.height = EvaContent.frame.origin.y + EvaSize.height + 9;
            [cell setFrame:cellFrame];
            
            
            CGRect bgFrame = commentBG.frame;
            bgFrame.size.height = cell.frame.size.height;
            commentBG.frame = bgFrame;
            
            UILabel * lineLb = [[UILabel alloc] initWithFrame:CGRectMake(0, cell.frame.size.height - 1, mainScreenWidth, 0.5)];
            lineLb.backgroundColor = RGBCOLOR(235, 235, 235);
            [cell addSubview:lineLb];
            
            if(indexPath.row == 1){
                if ([skillcommentArray count]==1) {
                    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:commentBG.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(10, 10)];
                    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                    maskLayer.frame = commentBG.bounds;
                    maskLayer.path = maskPath.CGPath;
                    commentBG.layer.mask = maskLayer;
                } else {
                    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:commentBG.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
                    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                    maskLayer.frame = commentBG.bounds;
                    maskLayer.path = maskPath.CGPath;
                    commentBG.layer.mask = maskLayer;
                }
            }
            if(indexPath.row==[skillcommentArray count]) {
                if ([skillcommentArray count]==1) {
                    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:commentBG.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(10, 10)];
                    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                    maskLayer.frame = commentBG.bounds;
                    maskLayer.path = maskPath.CGPath;
                    commentBG.layer.mask = maskLayer;
                } else {
                    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:commentBG.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
                    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                    maskLayer.frame = commentBG.bounds;
                    maskLayer.path = maskPath.CGPath;
                    commentBG.layer.mask = maskLayer;
                }
            }
            if([[comment objectForKey:UID] isEqualToString:[ghunterRequester getUserInfo:UID]]){
                UILongPressGestureRecognizer *long_press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(commentHunter:)];
                cell.tag = indexPath.row;
                [cell addGestureRecognizer:long_press];
            }
            [cell bringSubviewToFront:EvaContent];
            cell.backgroundColor = [UIColor whiteColor];
            
            return cell;
        }
    }
    return cell;
}
// 点击查看大图
- (void)pic_taped:(UITapGestureRecognizer *)sender {
    
    
    CGSize scrollSize = myScrollView.contentSize;
    scrollSize.width = mainScreenWidth * [picArray count];
    myScrollView.contentSize = scrollSize;
    [self tappedWithObject:sender.view];
    
    //        [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
    //    [SJAvatarBrowser showImage:(UIImageView*)sender.view];
    
}
#pragma mark - custom delegate
- (void) tappedWithObject:(id)sender
{
    [self.view bringSubviewToFront:scrollPanel];
    [UIView animateWithDuration:0.5 animations:^{
        scrollPanel.alpha = 1.0;
    }];
    UIImageView *tmpView = sender;
    currentIndex = (tmpView.tag - 100);
    //转换后的rect
    CGRect convertRect = [[tmpView superview] convertRect:tmpView.frame toView:self.view];
    CGPoint contentOffset = myScrollView.contentOffset;
    contentOffset.x = currentIndex*mainScreenWidth;
    myScrollView.contentOffset = contentOffset;
    //添加
    [self addSubImageView];
    ImgScrollView *tmpImgScrollView = [[ImgScrollView alloc] initWithFrame:(CGRect){contentOffset,myScrollView.bounds.size}];
    [tmpImgScrollView setContentWithFrame:convertRect];
    [tmpImgScrollView setImage:tmpView.image];
    [myScrollView addSubview:tmpImgScrollView];
    tmpImgScrollView.i_delegate = self;
    [self performSelector:@selector(setOriginFrame:) withObject:tmpImgScrollView afterDelay:0.1];
}
#pragma mark - custom method
- (void) addSubImageView
{
    for (UIView *tmpView in myScrollView.subviews)
    {
        [tmpView removeFromSuperview];
    }
    for (NSUInteger i = 0; i < [picArray count]; i++)
    {
        if (i == currentIndex)
        {
            continue;
        }
        UIImageView *tmpView = (UIImageView *)[self.view viewWithTag:(100 + i)];
        
        //转换后的rect
        CGRect convertRect = [[tmpView superview] convertRect:tmpView.frame toView:self.view];
        ImgScrollView *tmpImgScrollView = [[ImgScrollView alloc] initWithFrame:(CGRect){i * myScrollView.bounds.size.width,0,myScrollView.bounds.size}];
        [tmpImgScrollView setContentWithFrame:convertRect];
        [tmpImgScrollView setImage:tmpView.image];
        [myScrollView addSubview:tmpImgScrollView];
        tmpImgScrollView.i_delegate = self;
        [tmpImgScrollView setAnimationRect];
    }
}

- (void) setOriginFrame:(ImgScrollView *) sender
{
    [UIView animateWithDuration:0.4 animations:^{
        [sender setAnimationRect];
        markView.alpha = 1.0;
    }];
}

#pragma mark - scroll delegate
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    currentIndex = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
}
- (void) tapImageViewTappedWithObject:(id)sender
{
    ImgScrollView *tmpImgView = sender;
    [UIView animateWithDuration:0.5 animations:^{
        markView.alpha = 0;
        [tmpImgView rechangeInitRdct];
    } completion:^(BOOL finished) {
        scrollPanel.alpha = 0;
    }];
}

#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:0.1f];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:0.1f];
}

#pragma mark - Refresh and load more methods

- (void)refreshTable
{
    [imgarr removeAllObjects];
    
    Monitor *monitor = [Monitor sharedInstance];
    monitor.Identify = @"PL";
    self.currentPage = 1;
    self.valuePage = 1;
    [self didGetSkillshowIsloading:NO isWithComments:YES];
}

- (void)loadMoreDataToTable
{
    if ( [[Monitor sharedInstance].Identify isEqualToString:@"PL"]) {
        [self didGetCommentsIsLoading:NO page:self.currentPage];
    }else{
        [self didGetSkillValuationIsloading:NO withPage:self.valuePage];
    }
}

#pragma mark - CustomMethod

- (void)startLoad{
    loadingView = [[ghunterLoadingView alloc] initWithSuperView:self.view withGif:@"loading2" withIndicator:@"正在加载..."];
    [loadingView startAnimition];
}

- (void)endLoad{
    [loadingView inValidate];
}

- (IBAction)back:(id)sender {
    if (self.fromPush) {
        // 推送过来的任务
        self.callBackBlock();
        [self.whitview removeFromSuperview];
        [textbg removeFromSuperview];
        [view1 removeFromSuperview];
        [dangtext resignFirstResponder];
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        self.callBackBlock();
        [self.navigationController popViewControllerAnimated:YES];
        [self.whitview removeFromSuperview];
        [textbg removeFromSuperview];
        [view1 removeFromSuperview];
        [dangtext resignFirstResponder];
    }
}


#pragma mark --- 分享
- (IBAction)share:(id)sender {
    shareAlertView = [[SIAlertView alloc] initWithTitle:nil andMessage:nil];
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"shareView" owner:self options:nil];
    
    UIView *taskFilter = [[UIView alloc] init];
    taskFilter = [nibs objectAtIndex:0];
    

    CGRect width = taskFilter.frame;
    width.size.width = mainScreenWidth - 20;
    taskFilter.frame = width;
    
    [shareAlertView setCornerRadius:8.0];
    CGRect taskfilterFrame = taskFilter.frame;
    shareAlertView.containerFrame = CGRectMake((mainScreenWidth - taskfilterFrame.size.width) / 2.0, (mainScreenheight - taskfilterFrame.size.height - 10), taskfilterFrame.size.width, taskfilterFrame.size.height);
    shareAlertView.showView = taskFilter;
    UIButton *weixincircle = (UIButton *)[taskFilter viewWithTag:1];
    UIButton *weixinfried = (UIButton *)[taskFilter viewWithTag:2];
    UIButton *weibo = (UIButton *)[taskFilter viewWithTag:3];
    UIButton *qzone = (UIButton*)[taskFilter viewWithTag:6];
    UIButton *qq = (UIButton*)[taskFilter viewWithTag:7];
    UIButton *copy = (UIButton *)[taskFilter viewWithTag:4];
    UIButton *cancel = (UIButton *)[taskFilter viewWithTag:5];
    UIView *shareView = (UIView *)[taskFilter viewWithTag:111];
    shareView.frame = CGRectMake(0, 0,mainScreenWidth-20, shareView.frame.size.height);
    [weixincircle addTarget:self action:@selector(shareToPlatforms:) forControlEvents:UIControlEventTouchUpInside];
    [weixinfried addTarget:self action:@selector(shareToPlatforms:) forControlEvents:UIControlEventTouchUpInside];
    [weibo addTarget:self action:@selector(shareToPlatforms:) forControlEvents:UIControlEventTouchUpInside];
    [cancel addTarget:self action:@selector(shareToPlatforms:) forControlEvents:UIControlEventTouchUpInside];
    [copy addTarget:self action:@selector(shareToPlatforms:) forControlEvents:UIControlEventTouchUpInside];
    [qzone addTarget:self action:@selector(shareToPlatforms:) forControlEvents:UIControlEventTouchUpInside];
    [qq addTarget:self action:@selector(shareToPlatforms:) forControlEvents:UIControlEventTouchUpInside];
    
    shareAlertView.transitionStyle = SIAlertViewTransitionStyleSlideFromBottom;
    
    [shareAlertView show];
}

// 分享任务到第三方平台
-(void)shareToPlatforms:(id)sender{
    [shareAlertView dismissAnimated:YES];
    
    UIButton *btn = (UIButton *)sender;
    int code = [AFNetworkTool getHunterID:[[ghunterRequester getUserInfo:UID] intValue] :0];
    NSString *shareUrl = [NSString stringWithFormat:@"http://apiadmin.imgondar.com/mobile/skillshow/view?sid=%@&code=%zd",self.skillid, code];
    
    NSDictionary* info = [skill objectForKey:@"info"];
    NSDictionary* owner = [skill objectForKey:@"owner"];
    NSString *imgUrl = [owner objectForKey:TINY_AVATAR];
    
    if ( [btn tag] == 1 ) {
        // wxcircle
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:imgUrl];
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareUrl;
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:[NSString stringWithFormat:@"【赏金猎人】出售技能：「%@」￥%@/%@", [info objectForKey:@"skill"], [info objectForKey:@"price"],[info objectForKey:@"priceunit"]] image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                [AFNetworkTool share_record:self.skillid :SHARETYPE_SKILLSHOW :self.skillid:SHAREPLATFORM_WXMOMENTS];
            }
        }];
        
    }else if([btn tag] == 2){
        // weixinfriends
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:imgUrl];
        [UMSocialData defaultData].extConfig.wechatSessionData.url = shareUrl;
        [UMSocialData defaultData].extConfig.wechatSessionData.title =APP_NAME;
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:[NSString stringWithFormat:@"【琐事不愁，赚钱交友】出售技能：「%@」￥%@/%@", [info objectForKey:@"skill"], [info objectForKey:@"price"],[info objectForKey:@"priceunit"]] image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                [AFNetworkTool share_record:self.skillid :SHARETYPE_SKILLSHOW :self.skillid :SHAREPLATFORM_WECHAT];
            }
        }];
    }else if([btn tag] == 3){
        // weibo
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:SHARE_IMG_URL];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:[NSString stringWithFormat:@"#赏金猎人#我在@赏金猎人imGondar 发现技能【￥%@/%@】出售技能「%@」赶快戳进来看看 http://mob.imGondar.com/skillshow/view?id=%@&code=%zd",[info objectForKey:@"price"],[info objectForKey:@"priceunit"],[info objectForKey:@"skill"],self.skillid, code] image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
            [AFNetworkTool share_record:self.skillid :SHARETYPE_SKILLSHOW :self.skillid :SHAREPLATFORM_SINAWEIBO];
        }];
    }else if([btn tag] == 4){
        // copy
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:shareUrl];
        [ProgressHUD show:@"已复制到剪贴板"];
        [shareAlertView dismissAnimated:YES];
    }else if([btn tag] == 5){
        // cancel
        [shareAlertView dismissAnimated:YES];
    }else if([btn tag] == 6){
        // qzone
        if (![QQApiInterface isQQInstalled]) {
            [AFNetworkTool isInstallQQ];
            return;
        }

        [UMSocialData defaultData].extConfig.qzoneData.url = shareUrl;
        [UMSocialData defaultData].extConfig.qzoneData.title = APP_NAME;
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:imgUrl];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:[NSString stringWithFormat:@"【琐事不愁，赚钱交友】出售技能：「%@」￥%@/%@", [info objectForKey:@"skill"], [info objectForKey:@"price"],[info objectForKey:@"priceunit"]] image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                [AFNetworkTool share_record:self.skillid :SHARETYPE_SKILLSHOW :self.skillid:SHAREPLATFORM_QZONE];
            }
        }];
    }else if([btn tag] == 7){
        // qq
        if (![QQApiInterface isQQInstalled]) {
            [AFNetworkTool isInstallQQ];
            return;
        }

        [UMSocialData defaultData].extConfig.qqData.url = shareUrl;
        [UMSocialData defaultData].extConfig.qqData.title = APP_NAME;
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:imgUrl];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:[NSString stringWithFormat:@"【琐事不愁，赚钱交友】出售技能：「%@」￥%@/%@", [info objectForKey:@"skill"], [info objectForKey:@"price"],[info objectForKey:@"priceunit"]]  image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                [AFNetworkTool share_record:self.skillid :SHARETYPE_SKILLSHOW :self.skillid:SHAREPLATFORM_QQ];
            }
        }];
    }
}

#pragma mark --- 收藏
// 收藏技能
- (IBAction)collect:(id)sender {
    if (!imgondar_islogin) {
        [ProgressHUD show:UNLOGIN_ERROR];
        return;
    }
    NSString* str=[NSString stringWithFormat:@"?type=1&oid=%@", self.skillid];
    if(collected)
    {
        [ghunterRequester getwithDelegate:self withUrl:URL_DELETE_COLLECTION withUserInfo:REQUEST_FOR_NEW_DELETE_COLLECTION withString:str];
    }
    else
    {
        [ghunterRequester getwithDelegate:self withUrl:URL_ADD_COLLECTION withUserInfo:REQUEST_FOR_NEW_ADD_COLLECTION withString:str];
    }
}

#pragma mark - 修改任务&申请退款
- (void)report:(id)sender{
    if(imgondar_islogin) {
        reportAlertView = [[SIAlertView alloc] initWithTitle:nil andMessage:nil];
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"reportView" owner:self options:nil];
        self.popReportView = [[UIView alloc] init];
        self.popReportView = [nibs objectAtIndex:0];
        [reportAlertView setCornerRadius:8.0];
        CGRect width = self.popReportView.frame;
        width.size.width = mainScreenWidth - 20;
        self.popReportView.frame = width;
        
        CGRect taskfilterFrame = self.popReportView.frame;
        reportAlertView.containerFrame = CGRectMake((mainScreenWidth - taskfilterFrame.size.width) / 2.0, mainScreenheight - taskfilterFrame.size.height - 10, taskfilterFrame.size.width, taskfilterFrame.size.height);
        reportAlertView.showView = self.popReportView;
        UIButton *cancel = (UIButton *)[self.popReportView viewWithTag:1];
        UIButton *confirm = (UIButton *)[self.popReportView viewWithTag:2];
        self.text = (HPGrowingTextView *)[self.popReportView viewWithTag:3];
        self.textTip = (UILabel *)[self.popReportView viewWithTag:4];
        self.text.delegate = self;
        
        [cancel addTarget:self action:@selector(cancelReport:) forControlEvents:UIControlEventTouchUpInside];
        [confirm addTarget:self action:@selector(confirmReport:) forControlEvents:UIControlEventTouchUpInside];
        reportAlertView.transitionStyle = SIAlertViewTransitionStyleSlideFromBottom;
        reportAlertView.backgroundStyle = SIAlertViewBackgroundStyleSolid;
        [reportAlertView show];
        
    }
}

- (void)fadeIn:(UIView *)popView{
    popView.transform = CGAffineTransformMakeScale(1.3, 1.3);
    popView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        popView.alpha = 1;
        popView.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)fadeOut:(UIView *)popView{
    [UIView animateWithDuration:0.3 animations:^{
        popView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        popView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [popView removeFromSuperview];
        }
    }];
}

- (void)cancelReport:(id)sender{
    [reportAlertView dismissAnimated:YES];
    
}

- (void)confirmReport:(id)sender{
    if ([self.text.text length] == 0) {
        [self.text resignFirstResponder];
        
        return;
    }
    [reportAlertView dismissAnimated:YES];
    self.text = (HPGrowingTextView *)[self.popReportView viewWithTag:3];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.skillid forKey:@"oid"];
    [dic setObject:@REPORT_TYPE_SKILLSHOW forKey:@"type"];   // 举报技能
    [dic setObject:self.text.text forKey:@"content"];
    [ghunterRequester postwithDelegate:self withUrl:URL_REPORT_TASK withUserInfo:REQUEST_FOR_REPORT withDictionary:dic];
}

#pragma mark --- 显示评价 ---
-(void)Evaluation:(UIButton *)btn{
    
    self.commentImgV.image = [UIImage imageNamed:@"评论灰"];
    
    flagClick = YES;
    self.valuePage = 1;
    [self didGetSkillValuationIsloading:NO withPage:self.valuePage];
    
    self.PLunLabel.textColor = [UIColor grayColor];
    self.PLunBtn.enabled = NO;
    
    Monitor *monitor = [Monitor sharedInstance];
    monitor.Identify = @"PJ";
    
    [Coment setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [Evaluation setTitleColor:RGBCOLOR(234, 85, 19) forState:UIControlStateNormal];
    redlin1.backgroundColor = [UIColor whiteColor];
    redlin2.backgroundColor = RGBCOLOR(234, 85, 19);
}


#pragma mark --- 显示评论 ---
-(void)coment:(UIButton *)btn{
    
    self.commentImgV.image = [UIImage imageNamed:@"ic_privatemse"];
    
    flagClick = NO;
    self.PLunLabel.textColor = RGBCOLOR(234, 85, 19);
    self.PLunBtn.enabled = YES;
    
    self.currentPage = 1;
    [self didGetCommentsIsLoading:NO page:self.currentPage];
    
    Monitor *monitor = [Monitor sharedInstance];
    monitor.Identify = @"PL";
    
    [Coment setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [Evaluation setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    redlin1.backgroundColor = [UIColor redColor];
    redlin2.backgroundColor = [UIColor grayColor];
}


#pragma mark - Action
- (void)iconTaped{
    ghunterUserCenterViewController *userCenter = [[ghunterUserCenterViewController alloc] init];
    NSDictionary *owner = [skill objectForKey:@"owner"];
    userCenter.uid = [owner objectForKey:UID];
    [self.navigationController pushViewController:userCenter animated:YES];
}


// 点击评论/评价按钮
- (void)commentHunter:(UITapGestureRecognizer *)sender{
    NSUInteger tag = sender.view.tag;
    if ([[Monitor sharedInstance].Identify isEqualToString:@"PL"]) {
        NSDictionary *comment;
        ghunterUserCenterViewController *userCenter = [[ghunterUserCenterViewController alloc] init];
        
        comment = [skillcommentArray objectAtIndex:tag];
        userCenter.uid = [comment objectForKey:UID];
        [self.navigationController pushViewController:userCenter animated:YES];
        
    }else{
        ghunterUserCenterViewController *userCenter = [[ghunterUserCenterViewController alloc] init];
        NSDictionary *comment;
        
        comment = [skillcommentArray objectAtIndex:tag];
        // isprivate == 1  是私密评价
        NSInteger isprivate = [[comment objectForKey:@"isprivate"] integerValue];
        if ( isprivate == 1 ) {
            return;
        }
        userCenter.uid = [comment objectForKey:@"owner_uid"];
        
        [self.navigationController pushViewController:userCenter animated:YES];
    }
}

#pragma mark - UITextfieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isMatchedByRegex:@"[0-9\\.]"]) {
        return  YES;
        
    } else if ([string isEqualToString:@""]){
        return YES;
    } else {
        return NO;
    }
    return YES;
}

- (BOOL) textFieldShouldEndEditing:(UITextField *)textField {
    
    return YES;
}
#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    if(self.text.text.length != 0){
        nameLb.alpha = 1;
        self.textTip.hidden = YES;
    }else{
        self.textTip.hidden = NO;
        nameLb.alpha = 0;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    self.chatLabel.text = text;
    if ([text isEqualToString:@"\n"]){
        //        return NO;
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        reportAlertView.frame = [[UIScreen mainScreen] bounds];
        [UIView commitAnimations];
        
        if (dangtext.text.length == 0) {
            return NO;
        }else{
            [self startLoad];
            if ([[Monitor sharedInstance].plbante isEqualToString:@"kkk"]) {
                NSString *strname = [NSString stringWithFormat:@"回复了@%@ ：%@",namedic,dangtext.text];
                [skdic setObject:strname forKey:@"content"];
            }else{
                [skdic setObject:dangtext.text forKey:@"content"];
            }
            
            [skdic setObject:[[skill objectForKey:@"info"] objectForKey:@"sid"] forKey:@"oid"];
            [self commskill];
        }
        
        [self.chatToolBar removeFromSuperview];
        
        [dangtext resignFirstResponder];
        [textbg removeFromSuperview];
        dangtext.text = @"";
        [self.bastview removeFromSuperview];
        [self.whitview removeFromSuperview];
        [view1 removeFromSuperview];
        [self.chatToolBar removeFromSuperview];
    }
    return YES;
}

#pragma mark--- 举报框让键盘谈起
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    reportAlertView.frame = CGRectMake(0, -245  , ScreenWidthFull, ScreenHeightFull);
    [UIView commitAnimations];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:0.1f];
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        if(actionSheet == self.onSell)
        {
            self.downLabel.tag = 1;
            
            NSMutableDictionary* dic=[[NSMutableDictionary alloc] init];
            [dic setObject:@"1" forKey:@"isShow"];
            NSString* urlStr=[NSString stringWithFormat:@"%@?sid=%zd",URL_CHANGE_SKILL,self.skillid.intValue];
            
            [self startLoad];
            [ghunterRequester postwithDelegate:self withUrl:urlStr withUserInfo:REQUEST_FOR_CHANGE_SKILL withDictionary:dic];
        }
        else if(actionSheet == self.unSell)
        {
            // isshow = 2 上架技能
            self.downLabel.tag = 2;
            // self.downLabel.text = @"下架";   // 这里有错
            NSMutableDictionary* dic=[[NSMutableDictionary alloc] init];
            [dic setObject:@"2" forKey:@"isShow"];
            NSString* urlStr = [NSString stringWithFormat:@"%@?sid=%zd", URL_CHANGE_SKILL, self.skillid.intValue];
            
            [self startLoad];
            [ghunterRequester postwithDelegate:self withUrl:urlStr withUserInfo:REQUEST_FOR_CHANGE_SKILL withDictionary:dic];
        }
        else if (actionSheet == self.deleteComment){
            NSDictionary *dic = [skillcommentArray objectAtIndex:(self.deleteComment.tag - 1)];
            [self didDeleteCommentIsloading:YES withID:[dic objectForKey:@"cid"]];
        }
        
        [self performSelector:@selector(refreshTable) withObject:nil afterDelay:0.1f];
        
        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }
    else if (buttonIndex == 1){
        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }
}


#pragma mark - addressbook
- (void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person {
    [self dismissViewControllerAnimated:YES completion:NULL];
}


//- (void) setOriginFrame:(ImgScrollView *) sender
//{
//    [UIView animateWithDuration:0.4 animations:^{
//        [sender setAnimationRect];
//        markView.alpha = 0.0;
//    }];
//}

#pragma mark --- 购买
// 点击购买技能
- (IBAction)buyBtn:(UIButton *)sender {
    if (!imgondar_islogin) {
        [self click2Login];
        return;
    }
    if (!isShow) {
        [ProgressHUD show:SKILLSHOW_UNLINE];
        return;
    }
    ghunterSkillReleaseViewController* buySkill=[[ghunterSkillReleaseViewController alloc] init];
    buySkill.skillDic = skill;
    [self.navigationController pushViewController:buySkill animated:YES];
}

#pragma mark==========技能评论==========
// 添加表情
-(void)biaoqing{
    if (dangtext.text.length == 0) {
        
        [self.view addSubview:textbg];
        [self createChatView];
        [textbg addSubview:dangtext];
        [textbg addSubview:biaoqingBtn];
        [textbg addSubview:addBtn2];
        [textbg addSubview:downBtn3];
        
        [dangtext resignFirstResponder];
        
        CGRect textfram;
        textfram.origin.y = mainScreenheight - 210;
        textfram.origin.x = 0;
        textfram.size.width = mainScreenWidth;
        textfram.size.height= 45;
        textbg.frame = textfram;
        
        CGRect bastfram;
        bastfram.origin.x = 0;
        bastfram.origin.y =mainScreenheight-255;
        bastfram.size.width = mainScreenWidth;
        bastfram.size.height= 45;
        self.bastview.frame = bastfram;
        
        [self.view addSubview:_whitview];
        [view1 removeFromSuperview];
        
    }else {
        
        textbg.frame = CGRectMake(0, mainScreenheight - 210, mainScreenWidth, 40);
        [dangtext resignFirstResponder];
        
        CGRect textfram;
        textfram.origin.y = mainScreenheight - 210;
        textfram.origin.x = 0;
        textfram.size.width = mainScreenWidth;
        textfram.size.height= 45;
        textbg.frame = textfram;
        
        CGRect bastfram;
        bastfram.origin.x = 0;
        bastfram.origin.y =mainScreenheight-255;
        bastfram.size.width = mainScreenWidth - 160;
        bastfram.size.height= 45;
        self.bastview.frame = bastfram;
        [self.view addSubview:self.bastview];
        [self.view addSubview:_whitview];
        [view1 removeFromSuperview];
    }
}

#pragma mark --- 照片 ---
// 添加图片
-(void)zhaopian{
    
    if (dangtext.text.length == 0) {
        
        [self.view addSubview:textbg];
        [self createChatView];
        [textbg addSubview:dangtext];
        [textbg addSubview:biaoqingBtn];
        [textbg addSubview:addBtn2];
        [textbg addSubview:downBtn3];
        
        [dangtext resignFirstResponder];
        
        
        [self.view addSubview:view1];
        
        // 图片背景
        CGRect bastfram = self.bastview.frame;
        bastfram.origin.x = 0;
        bastfram.origin.y = view1.frame.origin.y - 44;
        bastfram.size.width = mainScreenWidth;
        bastfram.size.height= 45;
        self.bastview.frame = bastfram;
        [self.view addSubview:_bastview];
        textbg.frame = CGRectMake(0, mainScreenheight - 160 - 44 - 44, mainScreenWidth, 40);
        
    }else {
        
        textbg.frame = CGRectMake(0, mainScreenheight - 244, mainScreenWidth, 40);
        [dangtext resignFirstResponder];
        
        CGRect textfram;
        textfram.origin.y = mainScreenheight - 240;
        textfram.origin.x = 0;
        textfram.size.width = mainScreenWidth;
        textfram.size.height= 45;
        textbg.frame = textfram;
        
        // 图片背景
        CGRect bastfram = self.bastview.frame;
        bastfram.origin.x = 0;
        bastfram.origin.y = view1.frame.origin.y - 44;
        bastfram.size.width = mainScreenWidth;
        bastfram.size.height= 45;
        self.bastview.frame = bastfram;
        [self.view addSubview:self.bastview];
        [self.view addSubview:view1];
        [_whitview removeFromSuperview];
    }
}

#pragma mark --- 收起键盘
-(void)shouqi{
    if (dangtext.text.length == 0) {
        
        [dangtext resignFirstResponder];
        //    [textbg removeFromSuperview];
        textbg.frame = CGRectMake(0, mainScreenheight, mainScreenWidth, 40);
        [self.bastview removeFromSuperview];
        [self.whitview removeFromSuperview];
        [view1 removeFromSuperview];
    }else {
        
        [dangtext resignFirstResponder];
        textbg.frame = CGRectMake(0, mainScreenheight, mainScreenWidth, 40);
        [self.bastview removeFromSuperview];
        [self.whitview removeFromSuperview];
        [_whitview removeFromSuperview];
        [view1 removeFromSuperview];
    }
}


#pragma mark --- 点击评论按钮 ---
- (IBAction)chatBtn:(id)sender {
    if (!imgondar_islogin) {
        [self click2Login];
        return;
    }
    
    if (dangtext.text.length == 0) {
        [self.view addSubview:textbg];
        [self createChatView];
        [textbg addSubview:dangtext];
        [textbg addSubview:biaoqingBtn];
        [textbg addSubview:addBtn2];
        [textbg addSubview:downBtn3];
    }else {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taskTitle:) name:UIKeyboardWillShowNotification object:nil];
        [dangtext becomeFirstResponder];
    }
}

-(void)imgarr{
    
    [self.view addSubview:self.bastview];
    [self.bastview addSubview:self.img0];
    [self.bastview addSubview:self.img1];
    [self.bastview addSubview:self.img2];
    [self.bastview addSubview:self.img3];
    [_bastview addSubview:labelxx];
    if([dataimgarr count] == 0) {
        [self.img0 setImage:[UIImage imageNamed:@"add_picture"]];
        self.img1.image = nil;
        self.img2.image = nil;
        self.img3.image = nil;
        labelxx.text = @"0/4";
    } else if ([dataimgarr count] == 1) {
        [self.img0 setImage:(UIImage *)[dataimgarr objectAtIndex:0]];
        [self.img1 setImage:[UIImage imageNamed:@"add_picture"]];
        self.img2.image = nil;
        self.img3.image = nil;
        labelxx.text = @"1/4";
    } else if ([dataimgarr count] == 2) {
        [self.img0 setImage:(UIImage *)[dataimgarr objectAtIndex:0]];
        [self.img1 setImage:(UIImage *)[dataimgarr objectAtIndex:1]];
        [self.img2 setImage:[UIImage imageNamed:@"add_picture"]];
        self.img3.image = nil;
        labelxx.text = @"2/4";
    } else if ([dataimgarr count] == 3) {
        [self.img0 setImage:(UIImage *)[dataimgarr objectAtIndex:0]];
        [self.img1 setImage:(UIImage *)[dataimgarr objectAtIndex:1]];
        [self.img2 setImage:(UIImage *)[dataimgarr objectAtIndex:2]];
        [self.img3 setImage:[UIImage imageNamed:@"add_picture"]];
        labelxx.text = @"3/4";
    } else if ([dataimgarr count] == 4) {
        [self.img0 setImage:(UIImage *)[dataimgarr objectAtIndex:0]];
        [self.img1 setImage:(UIImage *)[dataimgarr objectAtIndex:1]];
        [self.img2 setImage:(UIImage *)[dataimgarr objectAtIndex:2]];
        [self.img3 setImage:(UIImage *)[dataimgarr objectAtIndex:3]];
        labelxx.text = @"4/4";
    }
    
}

#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    for (NSUInteger i = 0; i < assets.count; i++) {
        ALAsset *asset = assets[i];
        UIImage *tempImg = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        [dataimgarr addObject:tempImg];
    }
    [self imgarr];
    
    [addarray removeAllObjects];
    for (int i = 0; i<dataimgarr.count; i++) {
        [addarray addObject:@"5"];
    }
}
#pragma mark - UIImagePickerDelegate
// 成功获得相片还是视频后的回调 UIImagePickerController
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    Piimage=[info objectForKey:UIImagePickerControllerEditedImage];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        UIImageWriteToSavedPhotosAlbum(Piimage, nil, nil, nil);
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    [dataimgarr addObject:Piimage];
    [self imgarr];
    
    [addarray removeAllObjects];
    for (int i = 0; i<dataimgarr.count; i++) {
        [addarray addObject:@"5"];
    }
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    return;
    
}
-(void)keyboardShow:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY=keyBoardRect.size.height;
    self.keyBoardHeight=deltaY;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        textbg.transform = CGAffineTransformIdentity;
        textbg.transform=CGAffineTransformMakeTranslation(0, -deltaY-45);
    }];
    
    CGRect textfram;
    textfram.origin.y =  mainScreenheight-deltaY-45;
    textfram.origin.x = 0;
    textfram.size.width = mainScreenWidth;
    textfram.size.height= 45;
    textbg.frame = textfram;
    CGRect bastfram;
    bastfram.origin.x = 0;
    bastfram.origin.y = view1.frame.origin.y - 44;
    bastfram.size.width = mainScreenWidth;
    bastfram.size.height= 45;
    self.bastview.frame = bastfram;
}

#pragma mark --- 发送表情 ---
-(void)sendBtnClick2:(UIButton *)btn{
    [self startLoad];
    [skdic setObject:dangtext.text forKey:@"content"];
    [skdic setObject:[[skill objectForKey:@"info"] objectForKey:@"sid"] forKey:@"oid"];
    [self commskill];
    
    [self.chatToolBar removeFromSuperview];
    [dangtext resignFirstResponder];
    [textbg removeFromSuperview];
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:0.1f];
}

#pragma mark --- 选择表情---
-(void)selected:(UIButton*)btn
{
    NSMutableString *str = [[NSMutableString alloc] init];
    NSString *path=[[NSBundle mainBundle]pathForResource:@"face.plist" ofType:nil];
    NSDictionary *dic=[[NSDictionary alloc]initWithContentsOfFile:path];
    NSArray* allKeys=[dic allKeys];
    NSString* imageStr;
    str = [NSMutableString stringWithFormat:@"emoji_%zd.png",btn.tag];
    if(btn.tag==21||btn.tag==42||btn.tag==63)
    {
        if(dangtext.text.length>0)
        {
            NSMutableString* oldStr1=[[NSMutableString alloc] initWithString:dangtext.text];
            NSArray* strArr1=[oldStr1 componentsSeparatedByString:@"["];
            NSMutableArray* strArr2=[[NSMutableArray alloc] init];
            for(NSString* str in strArr1)
            {
                NSArray* arr=[str componentsSeparatedByString:@"]"];
                [strArr2 addObjectsFromArray:arr];
                for(NSString* str1 in strArr2)
                {
                    if(str1==nil||[str1 isEqual:@""])
                    {
                        [strArr2 removeObject:str1];
                    }
                }
            }
            NSString* appendStr=[NSString stringWithFormat:@"[%@]",[strArr2 lastObject]];
            NSInteger keySum=0;
            for(NSString* key in allKeys)
            {
                if([appendStr isEqualToString:key])
                {
                    keySum++;
                }
            }
            if(keySum!=0&&[dangtext.text hasSuffix:@"]"])
            {
                NSString* newString=[dangtext.text substringWithRange:NSMakeRange(0, dangtext.text.length-appendStr.length)];
                dangtext.text=newString;
            }
            else
            {
                NSString * newString = [dangtext.text substringWithRange:NSMakeRange(0, [dangtext.text length] - 1)];
                dangtext.text=newString;
            }
        }
        
    }
    for(NSString* key in allKeys)
    {
        if([str isEqualToString:[dic objectForKey:key]])
        {
            imageStr=[NSString stringWithFormat:@"%@",key];
        }
    }
    if(imageStr==nil)
    {
        dangtext.text=dangtext.text;
    }
    else
    {
        dangtext.text=[dangtext.text stringByAppendingString:imageStr];
    }
    
}


-(void)getChatImgFromCamera2{
    
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    [imgPicker setAllowsEditing:YES];
    [imgPicker setDelegate:self];
    [imgPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [self.navigationController presentViewController:imgPicker animated:YES completion:nil];
    
}
-(void)assetPickerControllerDidCancel:(ZYQAssetPickerController *)picker{
    
}

// 从相册选择
-(void)getChatImgFromAlbum2{
    // 本地图片
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = (4 - [dataimgarr count]);
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = NO;
    picker.delegate = self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        } else {
            return YES;
        }
    }];
    [self presentViewController:picker animated:YES completion:NULL];
    
}
-(void)keyboardHide:(NSNotification *)note
{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        
        textbg.transform=CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)reviseSkill:(UIButton *)sender {
    
    // 点击“修改技能”，去修改技能页面（同发布技能页面）
    ghunterReleaseSkillViewController* changeSkill=[[ghunterReleaseSkillViewController alloc] init];
    changeSkill.skillDic = skill;
    self.changeSomething = YES;
    changeSkill.callBackBlock = ^{
        self.changeSomething = NO;
    };
    [self.navigationController pushViewController:changeSkill animated:YES];
     
    
//    ghunterReleaseViewController * vc = [[ghunterReleaseViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)downBtn:(UIButton *)sender {
    if([self.downLabel.text isEqualToString:@"下架"])
    {
        self.onSell = [[UIActionSheet alloc] initWithTitle:@"确定要下架此技能秀吗？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
        [self.onSell showInView:self.view];
    }
    else
    {
        self.unSell = [[UIActionSheet alloc] initWithTitle:@"确定要上架此技能秀吗？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
        [self.unSell showInView:self.view];
    }
}

#pragma mark --- 私信
- (IBAction)privateMessage:(UIButton *)sender {
    if ( !imgondar_islogin ) {
        [self click2Login];
        return;
    }
    NSDictionary * ownerInfo = [skill objectForKey:@"owner"];
    
    ghunterChatViewController *chat = [[ghunterChatViewController alloc] init];
    chat.sender_uid = [ownerInfo objectForKey:@"uid"];
    chat.sender_username = [ownerInfo objectForKey:@"username"];
    
    [chat setCallBackBlock:^{}];
    [self.navigationController pushViewController:chat animated:YES];
}

#pragma mark --- 键盘下降
- (IBAction)keyboardDown:(id)sender {
    
    [dangtext resignFirstResponder];
    [textbg removeFromSuperview];
    [self.bastview removeFromSuperview];
    [self.whitview removeFromSuperview];
    [view1 removeFromSuperview];
    [self.chatToolBar removeFromSuperview];
}

#pragma mark --- 选择完图片后在编辑文字
- (IBAction)beginEditText:(id)sender {
    
    [self.view addSubview:textbg];
    [self createChatView];
    [textbg addSubview:dangtext];
    [textbg addSubview:biaoqingBtn];
    [textbg addSubview:addBtn2];
    [textbg addSubview:downBtn3];
}

-(void)updatePage{
    [self refreshTable];
}

// 根据技能秀是否显示，设置立即购买按钮的样式
-(void)setBuyButtonStatus:(BOOL)is_show{
    if (is_show) {
        [_smallBuyView setBackgroundColor:[UIColor colorWithRed:234/255.0 green:85/255.0 blue:20/255.0 alpha:1.0f]];
        [_buyAva setImage:[UIImage imageNamed:@"立即购买"]];
    }else{
        [_smallBuyView setBackgroundColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0f]];
        [_buyAva setImage:[UIImage imageNamed:@"立即购买"]];
    }
}

// 点击评论发送按钮
-(void)didGetCommentsIsLoading:(BOOL)isloading page:(NSInteger)p{
    Monitor *Deposit = [Monitor sharedInstance];
    NSString *strs = @"PL";
    Deposit.Identify = strs;
    [AFNetworkTool httpRequestWithUrl:[NSString stringWithFormat:@"%@?oid=%@&type=%@&page=%zd",URL_GET_SKILL_PINGLUN,self.skillid, @"4", self.currentPage] success:^(NSData *data) {
        NSError *error;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        // 请求成功，这里得到json数据
        if ( [[dic objectForKey:@"error"] integerValue] == 0 ) {
            if (isloading) {
                [self endLoad];
            }
            if ( p == 1 ) {
                self.currentPage = 2;
                [skillcommentArray removeAllObjects];
                [skillcommentArray addObjectsFromArray:[dic valueForKey:@"comments"]];
            }else{
                self.currentPage ++;
                [skillcommentArray addObjectsFromArray:[dic valueForKey:@"comments"]];
            }
            taskTable.pullTableIsLoadingMore = NO;
            [taskTable reloadData];
        }else{
            [self endLoad];
            [ProgressHUD show:[dic objectForKey:@"msg"]];
            taskTable.pullTableIsLoadingMore = NO;
        }
    } fail:^{
        [ProgressHUD show:HTTPREQUEST_ERROR];
        [self endLoad];
    }];
}
//// 采用afn获取技能评价列表
-(void)didGetSkillValuationIsloading:(BOOL)isloading withPage:(NSInteger)p{
    [AFNetworkTool httpRequestWithUrl:[NSString stringWithFormat:@"%@?showid=%@&page=%zd", URL_GET_SKILL_COMMENT, self.skillid, p] success:^(NSData *data) {
        if (isloading) {
            [self endLoad];
        }
        NSError *error;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        // 请求成功，这里得到json数据
        if ( [[dic objectForKey:@"error"] integerValue] == 0 ) {
            NSArray *array = [dic valueForKey:@"valuations"];
            if (p==1) {
                self.valuePage = 2;
                [skillcommentArray removeAllObjects];
                [skillcommentArray addObjectsFromArray:array];
            }else{
                self.valuePage++;
            }
            [taskTable reloadData];
            taskTable.pullTableIsLoadingMore = NO;
            taskTable.pullTableIsRefreshing = NO;
        }else{
            [ProgressHUD show:[dic objectForKey:@"msg"]];
            taskTable.pullTableIsRefreshing = NO;
            taskTable.pullTableIsLoadingMore = NO;
        }
    } fail:^{
        [ProgressHUD show:HTTPREQUEST_ERROR];
        if (isloading) {
            [self endLoad];
        }
    }];
}

// 评论技能post提交数据
-(void)commskill{
    [skdic setObject:API_TOKEN_NUM forKey:API_TOKEN];
    [skdic setObject:@"4" forKey:@"type"];
    [AFNetworkTool uploadImage:dataimgarr forKey:@"images[]" andParameters:skdic toApiUrl:URL_COMMENT_skill success:^(NSData *data) {
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if ([[result objectForKey:@"error"] intValue]==0) {
            self.currentPage = 1;
            [self endLoad];
            [dataimgarr removeAllObjects];
            [dangtext resignFirstResponder];
            [self.bastview removeFromSuperview];
            self.bastview=nil;
            self.bastview.hidden = YES;
            [_whitview removeFromSuperview];
            [view1 removeFromSuperview];
            
        }else{
            [ProgressHUD show:[result objectForKey:@"msg"]];
            [self endLoad];
        }
    } fail:^{
        [ProgressHUD show:HTTPREQUEST_ERROR];
        [self endLoad];
    }];
}

// 获取技能详情数据
-(void)didGetSkillshowIsloading:(BOOL)isloading isWithComments:(BOOL)isWithComments{
    if (isloading) {
        [self startLoad];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@?showid=%@", URL_GET_SKILL_CONTENT,self.skillid];
    [AFNetworkTool httpRequestWithUrl:url params:nil success:^(NSData *data) {
        NSError *error;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if ([[dic objectForKey:@"error"]integerValue] == 0) {
            if (isloading) {
                [self endLoad];
            }
            
            skill = [dic objectForKey:@"skillshow"];
            if (skill) {
                [btnarray addObject:@"0"];
            }else{
                [btnarray addObject:@"0"];
            }
            NSArray *imgArrays = [skill objectForKey:@"images"];
            for (int i = 0; i < imgArrays.count; i++) {
                NSString *imgstr = [NSString stringWithFormat:@"%@",[[imgArrays objectAtIndex:i] objectForKey:@"largeurl"]];
                [imgarr addObject:imgstr];
            }
            //            SOLoopView *loopView = [[SOLoopView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 150)];
            //            loopView.delegate = self;
            //            loopView.contentMode = UIViewContentModeScaleAspectFill;
            //            loopView.showPageControlAtBottom = YES;
            //            [headview addSubview:loopView];
            
            //            [self.loopView reloadData];
            //            [taskTable reloadData];
            
            NSDictionary *info = [skill objectForKey:@"info"];
            NSString* isOwner=[info objectForKey:@"isowner"];
            NSString* isCollect=[info objectForKey:@"iscollect"];
            showStr = [info objectForKey:@"isShow"];
            
            if (!imgondar_islogin) {
                    CGRect  buyframe = _buyView.frame;
                    buyframe.size.width = mainScreenWidth;
                    _buyView.frame = buyframe;
                //未登录
                [tasktailView addSubview:self.buyView];
                self.buyView.userInteractionEnabled = YES;
            }
            else
            {
                if([showStr isEqualToString:@"0"])
                {
                    isShow = NO;
                }else if([showStr isEqualToString:@"1"])
                {
                    isShow=NO;
                    self.downLabel.text=@"上架";
                }else if([showStr isEqualToString:@"2"])
                {
                    isShow=YES;
                    self.downLabel.text=@"下架";
                }
                
                if ([isCollect isEqualToString:@"0"]) {
                    [self.skillCollect setImage:[UIImage imageNamed:@"收藏"]];
                    collected = NO;
                } else {
                    [self.skillCollect setImage:[UIImage imageNamed:@"收藏-拷贝"]];
                    collected = YES;
                }
                for (UIView *view in [tasktailView subviews]) {
                    [view removeFromSuperview];
                }
                if([isOwner isEqualToString:@"1"])
                {
                    CGRect  resiveframe = _resiveView.frame;
                    resiveframe.size.width = mainScreenWidth;
                    _resiveView.frame = resiveframe;
                    [tasktailView addSubview:_resiveView];
                }
                else
                {
                    CGRect  buyframe = _buyView.frame;
                    buyframe.size.width = mainScreenWidth;
                    _buyView.frame = buyframe;
                    [tasktailView addSubview:_buyView];
                    if ([isCollect isEqualToString:@"0"]) {
                        [self.skillCollect setImage:[UIImage imageNamed:@"收藏"]];
                        collected = NO;
                    } else {
                        [self.skillCollect setImage:[UIImage imageNamed:@"收藏-拷贝"]];
                        collected = YES;
                    }
                    [self setBuyButtonStatus:isShow];
                }
            }
            requested = YES;
            [taskTable reloadData];
            
            taskTable.pullTableIsRefreshing = NO;
            
            if (isWithComments) {
                [self didGetCommentsIsLoading:NO page:self.currentPage];
            }
        }else{
            if (isloading) {
                [self endLoad];
            }
            taskTable.pullTableIsLoadingMore = NO;
            [ProgressHUD show:[dic objectForKey:@"msg"]];
        }
    } fail:^{
        taskTable.pullTableIsLoadingMore = NO;
        if (isloading) {
            [self endLoad];
        }
    }];
}

#pragma mark - custom method
- (void) addSubImgView
{
    for (UIView *tmpView in myScrollView.subviews)
    {
        [tmpView removeFromSuperview];
    }
    for (NSUInteger i = 0; i < [imgArray count]; i++)
    {
        if (i == currentIndex)
        {
            continue;
        }
        UIImageView *tmpView = (UIImageView *)[self.view viewWithTag:(100 + i)];
        
        //转换后的rect
        CGRect convertRect = [[tmpView superview] convertRect:tmpView.frame toView:self.view];
        ImgScrollView *tmpImgScrollView = [[ImgScrollView alloc] initWithFrame:(CGRect){i * myScrollView.bounds.size.width,0,myScrollView.bounds.size}];
        [tmpImgScrollView setContentWithFrame:convertRect];
        [tmpImgScrollView setImage:tmpView.image];
        [myScrollView addSubview:tmpImgScrollView];
        tmpImgScrollView.i_delegate = self;
        [tmpImgScrollView setAnimationRect];
    }
}


// 聊天背景
- (void) createChatView {
    dangtext = [[UITextView alloc]initWithFrame:CGRectMake(80,3 , 200, 35)];
    dangtext.delegate = self;
    dangtext.backgroundColor = [UIColor redColor];
    dangtext.returnKeyType = UIReturnKeySend;
    [dangtext.layer setCornerRadius:5];
    [dangtext becomeFirstResponder];
    dangtext.font = [UIFont systemFontOfSize:14];
    dangtext.backgroundColor = RGBCOLOR(221, 221, 211);
    
    biaoqingBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 3, 30, 30)];
    [biaoqingBtn addTarget:self action:@selector(biaoqing) forControlEvents:(UIControlEventTouchUpInside)];
    [biaoqingBtn setImage:[UIImage imageNamed:@"comment_facebg_normal"] forState:(UIControlStateNormal)];
    
    addBtn2 = [[UIButton alloc]initWithFrame:CGRectMake(45, 3, 30, 30)];
    [addBtn2 addTarget:self action:@selector(zhaopian) forControlEvents:(UIControlEventTouchUpInside)];
    [addBtn2 setImage:[UIImage imageNamed:@"添加"] forState:(UIControlStateNormal)];
    
    downBtn3 = [[UIButton alloc]initWithFrame:CGRectMake(mainScreenWidth-37, 3, 34, 30)];
    [downBtn3 addTarget:self action:@selector(shouqi) forControlEvents:(UIControlEventTouchUpInside)];
    [downBtn3 setImage:[UIImage imageNamed:@"down_keyboard"] forState:(UIControlStateNormal)];
}


#pragma mark --- 发送图片 ---
- (void) sendPhoto {
    if (imgarr.count == 0) {
        return;
    }
    [self startLoad];
    [skdic setObject:dangtext.text forKey:@"content"];
    [skdic setObject:[[skill objectForKey:@"info"] objectForKey:@"sid"] forKey:@"oid"];
    
    [self commskill];
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:0.1f];
    
    [textbg removeFromSuperview];
}


#pragma mark --- 长按删除
- (void)comment_longpressed:(UILongPressGestureRecognizer *)sender {
    if(UIGestureRecognizerStateBegan == sender.state) {
        self.deleteComment = [[UIActionSheet alloc] initWithTitle:@"删除评论?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
        self.deleteComment.tag = sender.view.tag;
        [self.deleteComment showInView:self.view];
    }
}



#pragma mark - 删除评论
-(void)didDeleteCommentIsloading:(BOOL)isloading withID:(NSString *)cid{
    if (isloading) {
        [self startLoad];
    }
    [AFNetworkTool httpRequestWithUrl:[NSString stringWithFormat:@"%@?cid=%@", URL_DELETE_COMMENT, cid] params:nil success:^(NSData *data) {
        if (isloading) {
            [self endLoad];
        }
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        [ProgressHUD show:[result objectForKey:@"msg"]];
        
        if ([[result objectForKey:@"error"]integerValue] == 0) {
            // 删除评论
            [self didGetSkillshowIsloading:NO isWithComments:YES];
        }else{
            
        }
    } fail:^{
        [ProgressHUD show:HTTPREQUEST_ERROR];
        if (isloading) {
            [self endLoad];
        }
    }];
}

#pragma mark ---点击文本中的链接响应时间---- littlebear  2015-12-10
-(BOOL)attributedLabel:(OHAttributedLabel *)attributedLabel shouldFollowLink:(NSTextCheckingResult *)linkInfo{
    // [linkInfo URL];
    if ( [linkInfo URL] ) {
        ghunterWebViewController *webView = [[ghunterWebViewController alloc] init];
        webView.webTitle = [NSMutableString stringWithString:APP_NAME];
        webView.urlPassed = [NSMutableString stringWithString:[[linkInfo URL] absoluteString]];
//        [self.navigationController pushViewController:webVriew animated:YES];
        return  NO;
    }
    return YES;
}

// 未登录，需要点击去登陆
-(void)click2Login{
    ghunterLoginViewController *login = [[ghunterLoginViewController alloc] init];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:login] animated:YES completion:nil];
    [login setCallBackBlock:^{
        [self performSelector:@selector(refreshTable) withObject:nil afterDelay:0.1f];
    }];
}

@end