//
//  ghunterChatViewController.m
//  ghunter
//
//  Created by chensonglu on 14-8-27.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//  聊天界面

#import "ghunterChatViewController.h"
#import "ghunterWordChange.h"
#import "AFNetworkTool.h"

@interface ghunterChatViewController ()
@property (strong, nonatomic) IBOutlet UIView *chatView;
@property (strong, nonatomic)NSMutableArray *chatcontentArray;
@property (assign,nonatomic)BOOL isSender;
@property (assign,nonatomic)BOOL isSendimg;

@property (weak, nonatomic) IBOutlet UILabel *to_username;
@property(strong,nonatomic)UIScrollView* scrollView;
@property(strong,nonatomic)UIPageControl* pageControl;
- (IBAction)faceBtn:(UIButton *)sender;
@property(strong,nonatomic)UIView *faceView;
// 添加图片的View
@property(strong,nonatomic)UIView *addImgView;

@property (strong, nonatomic) IBOutlet UIView *bg;

@property(strong,nonatomic)UIImageView *imgFromAlbumBtn;
@property(strong,nonatomic)UIImageView *imgFromCameraBtn;

@property(strong,nonatomic)HPGrowingTextView *chatTextField;
@property(strong,nonatomic)NSMutableArray* myChatArr;
@property(assign,nonatomic)BOOL isAnimating;

// chat ImG
@property (weak, nonatomic) IBOutlet UIImageView *addImgBtn;
@property (weak, nonatomic) IBOutlet UIButton *faceBtn;

@end

@implementation ghunterChatViewController{
    UIActionSheet *saveAction;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     _bg.backgroundColor = Nav_backgroud;
    // 记录达到了聊天界面
    ghunter_onchatpage = YES;
    ghunter_chatuid = [self.sender_uid integerValue];
    
    // Do any additional setup after loading the view from its nib.
    page = 1;
    if(self.userDic.count!=0)
    {
        self.sender_uid = [_userDic objectForKey:@"uid"];
        [self.to_username setText:[_userDic objectForKey:@"username"]];
    }
    else
    {
        [self.to_username setText:self.sender_username];
    }
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chatAddImage)];
    [self.addImgBtn setUserInteractionEnabled:YES];
    [self.addImgBtn addGestureRecognizer:gesture];
    
    [self.faceBtn setBackgroundImage:[UIImage imageNamed:@"comment_facebg_pressed"] forState:UIControlStateHighlighted];
    
    self.chatcontentArray = [[NSMutableArray alloc]init];
    _myChatArr=[[NSMutableArray alloc] init];
    // _wrongLabel=[[UILabel alloc] init];
    chatTable = [[PullTableView alloc]initWithFrame:CGRectMake(0, 64, mainScreenWidth, mainScreenheight - 64 - 44)];
    chatTable.showsVerticalScrollIndicator = NO;
    chatTable.delegate = self;
    chatTable.dataSource = self;
    chatTable.pullDelegate = self;
    chatTable.backgroundColor = [UIColor clearColor];
    chatTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:chatTable];
    
    _isSender = NO;
    _isAnimating = NO;
    _isSendimg = NO;
    
    _chatTextField=[[HPGrowingTextView alloc] initWithFrame:CGRectMake(70, 6, mainScreenWidth - 108, 30)];
    _chatTextField.isScrollable = NO;
    _chatTextField.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    _chatTextField.backgroundColor=[UIColor colorWithRed:228/255.0 green:227/255.0 blue:220/255.0 alpha:1.0];
    _chatTextField.minNumberOfLines = 1;
    _chatTextField.maxNumberOfLines = 5;
    // you can also set the maximum height in points with maxHeight
    // textView.maxHeight = 200.0f;
    _chatTextField.returnKeyType = UIReturnKeyDone; //just as an example
    _chatTextField.font = [UIFont systemFontOfSize:15.0f];
    _chatTextField.delegate = self;
    _chatTextField.layer.cornerRadius=6.0;
    _chatTextField.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    [self.chatView addSubview:_chatTextField];
    _chatView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    [self.to_username setText:self.sender_username];
    
    _faceView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, 170)];
    _scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, 140)];
    for (int i=0; i<3; i++) {
        UIView* face=[[UIView alloc] initWithFrame:CGRectMake(mainScreenWidth*i, 0,mainScreenWidth, 140)];
        for (int j=0; j<3; j++) {
            //column numer
            for (int k=0; k<7; k++) {
                UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
                
                button.tag=j*7+k+(i*21)+1;
                NSString *imageName;
                if(button.tag==21||button.tag==42||button.tag==63)
                {
                    [button setImage:[UIImage imageNamed:@"emoji_delete.png"] forState:UIControlStateNormal];
                    [button setFrame:CGRectMake(0+k*mainScreenWidth/7, 0+j*45, 45, 45)];
                }
                else
                {
                    imageName=[NSString stringWithFormat:@"%zd.png",button.tag];
                    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
                    [button setFrame:CGRectMake(10+k*mainScreenWidth/7, 10+j*45, 25, 25)];
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
    _faceView.backgroundColor = [UIColor colorWithRed:228/255.0 green:227/255.0 blue:220/255.0 alpha:1.0];
    [_faceView addSubview:_scrollView];
    
    UIButton* sendBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    sendBtn.frame=CGRectMake(mainScreenWidth-50-10, 143, 50, 25);
    [sendBtn addTarget:self action:@selector(sendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    
    sendBtn.titleLabel.font=[UIFont systemFontOfSize:12];
    [sendBtn setBackgroundImage:[UIImage imageNamed:@"input_circle_bg.png"] forState:UIControlStateNormal];
    [_faceView addSubview:sendBtn];
    [self.view addSubview:_faceView];
    _faceView.hidden=YES;
    
    _addImgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, 170)];
    _addImgView.backgroundColor = [UIColor whiteColor];
    

    
    _imgFromAlbumBtn = [[UIImageView alloc] initWithFrame:CGRectMake(mainScreenWidth/4 - 30, 50, 40, 40)];
    _imgFromCameraBtn = [[UIImageView alloc] initWithFrame:CGRectMake(0.75*mainScreenWidth-30, 50, 40, 40)];
    
    UILabel *albumLabel = [[UILabel alloc] initWithFrame:CGRectMake(mainScreenWidth/4 - 30, 95, 40, 15)];
    UILabel *cameraLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.75*mainScreenWidth - 30, 95, 40, 15)];
    [albumLabel setText:@"相册"];
    albumLabel.textAlignment = NSTextAlignmentCenter;
    [albumLabel setTextColor:[UIColor darkGrayColor]];
    [albumLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [cameraLabel setText:@"拍照"];
    [cameraLabel setFont:[UIFont systemFontOfSize:15.0f]];
    cameraLabel.textAlignment = NSTextAlignmentCenter;
    [cameraLabel setTextColor:[UIColor darkGrayColor]];
    UITapGestureRecognizer *ablumGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getChatImgFromAlbum)];
    UITapGestureRecognizer *cameraGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getChatImgFromCamera)];
    
    [_imgFromAlbumBtn setUserInteractionEnabled:YES];
    [_imgFromCameraBtn setUserInteractionEnabled:YES];
    [_imgFromCameraBtn addGestureRecognizer:cameraGesture];
    [_imgFromAlbumBtn addGestureRecognizer:ablumGesture];
    [_imgFromAlbumBtn setImage:[UIImage imageNamed:@"手机照片"]];
    [_imgFromCameraBtn setImage:[UIImage imageNamed:@"相机拍照"]];
    [_addImgView addSubview:_imgFromCameraBtn];
    [_addImgView addSubview:_imgFromAlbumBtn];
    [_addImgView addSubview:albumLabel];
    [_addImgView addSubview:cameraLabel];
    
    [self.view addSubview:_addImgView];
    [_addImgView setHidden:YES];
    
    // 聊天输入框的位置
    // [[AFNetworkTool getDeviceString] isEqualToString:@"iPhone 4"] || [[AFNetworkTool getDeviceString] isEqualToString:@"iPhone 4S"]
    if ( [[AFNetworkTool getDeviceString] rangeOfString:@"iPhone4"].location!=NSNotFound ) {
        [self.chatView setFrame:CGRectMake(0, self.view.frame.size.height - 44, 320, 44)];
    }else{
        [self.chatView setFrame:CGRectMake(0, self.view.frame.size.height - self.chatView.frame.size.height, self.view.frame.size.width, self.chatView.frame.size.height)];
    }
    [self.view addSubview:self.chatView];
    
    [self startLoad];
    [ghunterRequester postwithDelegate:self withUrl:[NSString stringWithFormat:@"%@?page=%zd&uid=%@",URL_GET_CHAT_HISTORY,page,self.sender_uid] withUserInfo:REQUEST_FOR_GET_CHAT_HISTORY withDictionary:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    // 即时聊天的监听器
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"get_chat_message"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(get_chat_message:)
                                                 name:@"get_chat_message"
                                               object:nil];
    
    // table 背景色
    [chatTable setBackgroundColor:[UIColor colorWithRed:228/255.0 green:227/255.0 blue:220/255.0 alpha:1.0]];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tabBarController.tabBar setHidden:YES];
    
    // 这样才能右滑返回上一个页面
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.alpha = 0;
    [self.navigationController.view sendSubviewToBack:self.navigationController.navigationBar];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self callBackBlock];
}

// 回调方法
- (void)viewDidDisappear:(BOOL)animated {
    _callBackBlock();
    
}

-(void)viewDidAppear:(BOOL)animated{
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"get_chat_message"
                                                  object:nil];
    
    // 不应该在viewDidAppear里面加入这句话
    ghunter_chatuid = 0;
    ghunter_onchatpage = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Keyboard Notification

// 这里有Bug
- (void)keyboardWillShow:(NSNotification *)notification {
    [_chatTextField becomeFirstResponder];
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:keyboardRect fromView:[[UIApplication sharedApplication] keyWindow]];
    // 获得键盘高度
    CGFloat keyboardHeight = keyboardFrame.size.height;
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         
                         // get a rect for the textView frame
                         CGRect containerFrame = _chatView.frame;
                         
                         containerFrame.origin.y = mainScreenheight-containerFrame.size.height-keyboardHeight;
                         _chatView.frame = containerFrame;
                         
                         CGRect frame1 = chatTable.frame;
                         frame1.size.height = containerFrame.origin.y - 64;
                         [chatTable setFrame:frame1];
                         
                         // 滚动到最后一行
                         if(_chatcontentArray.count > 0)
                         {
                             NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.chatcontentArray count] - 1 inSection:0];
                             [chatTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
                         }
                     }];    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    if (_faceView.hidden == NO) {
        _faceView.hidden = YES;
    }
    if (_addImgView.hidden == NO) {
        _addImgView.hidden = YES;
    }
    NSDictionary *userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         
                         CGRect containerFrame = _chatView.frame;
                         // containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
                         // _chatView.frame = containerFrame;
                         
                         // CGRect frame = self.chatView.frame;
                         containerFrame.origin.y = mainScreenheight - containerFrame.size.height;
                         self.chatView.frame = containerFrame;
                         
                         CGRect frame1 = chatTable.frame;
                         frame1.size.height = mainScreenheight - 64 - containerFrame.size.height;
                         chatTable.frame = frame1;
                     }];
}

#pragma mark- HPGrowingTextView
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
    CGRect r = _chatView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    _chatView.frame = r;
    
    
    CGRect frame1=chatTable.frame;
    frame1.size.height=r.origin.y-64;
    [chatTable setFrame:frame1];
    if(_chatcontentArray.count!=0)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.chatcontentArray count] - 1 inSection:0];
        [chatTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
    }
}

#pragma mark - UITableViewDelegate UITableViewDatasource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //这里可以把已发送的内容取消
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.chatcontentArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *message = [self.chatcontentArray objectAtIndex:indexPath.row];
    
    if(![[message objectForKey:@"sender_uid"] isEqualToString:[ghunterRequester getUserInfo:UID]]){
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"chatPosterView" owner:self options:nil];
        cell = [nibs objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *avatar = (UIImageView *)[cell viewWithTag:1];
        UILabel *dateline = (UILabel *)[cell viewWithTag:2];
        UIImageView *dateline_bg = (UIImageView *)[cell viewWithTag:5];
        //需要对content进行处理
        UILabel *content = (UILabel *)[cell viewWithTag:3];
        UIImageView *bg = (UIImageView *)[cell viewWithTag:4];
        // 私信图片
        UIImageView *photoImageView = (UIImageView *)[cell viewWithTag:22];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconTaped:)];
        avatar.userInteractionEnabled = YES;
        avatar.tag = indexPath.row;
        [avatar addGestureRecognizer:tap];
        avatar.layer.masksToBounds = YES;
        avatar.layer.cornerRadius = avatar.frame.size.height/2;
        [avatar sd_setImageWithURL:[message objectForKey:@"sender_avatar"] placeholderImage:[UIImage imageNamed:@"avatar"]];
        NSString *datelineDescription = [ghunterRequester getTimeDescripton:[message objectForKey:@"dateline"]];
        CGSize dateline_bgSize = [datelineDescription sizeWithFont:dateline.font];
        
        dateline.textAlignment = UITextAlignmentCenter;
        [dateline setText:datelineDescription];
        
        CGRect dateline_bgFrame = dateline_bg.frame;
        dateline_bgFrame.origin.x = (cell.frame.size.width - dateline_bgSize.width) / 2.0 - 5.0;
        dateline_bgFrame.size.width = dateline_bgSize.width + 20.0;
        dateline_bg.frame = dateline_bgFrame;
        [dateline_bg setImage:[UIImage imageNamed:@"chat_time_bg"]];
        
        if ([[message objectForKey:@"msg_tag"] integerValue] == 1) {
            // 如果是图片消息
            [content removeFromSuperview];
            
            bg.layer.masksToBounds = YES;
            bg.layer.cornerRadius = Radius;
            [bg setFrame:CGRectMake(bg.frame.origin.x, bg.frame.origin.y, 100, (bg.frame.size.height +  70))];
            
            CGFloat top = 10; // 顶端盖高度
            CGFloat bottom = dateline_bg.frame.size.height - top - 1; // 底端盖高度
            CGFloat left = 10; // 左端盖宽度
            CGFloat right = dateline_bg.frame.size.width - left - 1; // 右端盖宽度
            UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
            // 指定为拉伸模式，伸缩后重新赋值
            UIImage *image = [UIImage imageNamed:@"conversation"];
            image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
            [bg setImage:image];
            
            photoImageView.frame = CGRectMake(bg.frame.origin.x+5, bg.frame.origin.y+5, bg.frame.size.width-10, bg.frame.size.height-10);
            //  photoImageView.layer.masksToBounds = YES;
            photoImageView.clipsToBounds = YES;
            photoImageView.layer.cornerRadius = 6.0;
            photoImageView.hidden = NO;
            photoImageView.userInteractionEnabled = YES;
            
            [photoImageView sd_setImageWithURL:[message objectForKey:@"tinyurl"] placeholderImage:[UIImage imageNamed:@"avatar"]];
            
            [photoImageView sd_setImageWithURL:[message objectForKey:@"largeurl"] placeholderImage:[UIImage imageNamed:@"avatar"]];
            
            UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2viewLargeImage:) ];
            [photoImageView setTag:indexPath.row];
            [photoImageView addGestureRecognizer:tap2];
            
            // 长按图片
            UILongPressGestureRecognizer *long_press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(saveImage:)];
            [photoImageView addGestureRecognizer:long_press];
            
            //[bg addSubview:photoImageView];
            [cell setFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height+60)];
        }else{
            NSString *contentStr = [message objectForKey:@"content"];
            NSAttributedString* str1 = [ghunterWordChange wordChange:contentStr];
            NSString *newString = [contentStr substringWithRange:NSMakeRange(0, [contentStr length] - (contentStr.length-str1.string.length)*4/7)];
            CGSize labelSize = [newString sizeWithFont:content.font
                                     constrainedToSize:CGSizeMake(content.frame.size.width, MAXFLOAT)
                                         lineBreakMode:NSLineBreakByWordWrapping];
            
            CGFloat heightAdded = labelSize.height - content.frame.size.height;//添加内容之后控件增长的高
            if(heightAdded <= 0){
                heightAdded = 0;
            }
            [content setFrame:CGRectMake(content.frame.origin.x, content.frame.origin.y, labelSize.width, (content.frame.size.height + heightAdded + 5))];
            
            [content setAttributedText:str1];
            bg.layer.masksToBounds = YES;
            bg.layer.cornerRadius = Radius;
            [bg setFrame:CGRectMake(bg.frame.origin.x, bg.frame.origin.y, labelSize.width  +20, (bg.frame.size.height + heightAdded + 5))];
            
            
            CGFloat top = 10; // 顶端盖高度
            CGFloat bottom = dateline_bg.frame.size.height - top - 1; // 底端盖高度
            CGFloat left = 10; // 左端盖宽度
            CGFloat right = dateline_bg.frame.size.width - left - 1; // 右端盖宽度
            UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
            // 指定为拉伸模式，伸缩后重新赋值
            UIImage *image = [UIImage imageNamed:@"conversation"];
            image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
            [bg setImage:image];
            [cell setFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height + heightAdded)];
        }
    }else if([[message objectForKey:@"sender_uid"] isEqualToString:[ghunterRequester getUserInfo:UID]]){
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"chatReceiverView" owner:self options:nil];
        cell = [nibs objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *avatar = (UIImageView *)[cell viewWithTag:1];
        UILabel *dateline = (UILabel *)[cell viewWithTag:2];
        dateline.textAlignment = UITextAlignmentCenter;
        
        UIImageView *dateline_bg = (UIImageView *)[cell viewWithTag:5];
        UILabel *content = (UILabel *)[cell viewWithTag:3];
        UIImageView *bg = (UIImageView *)[cell viewWithTag:4];
        UIImageView *photoImageView = (UIImageView *)[cell viewWithTag:22];
        UIActivityIndicatorView* act=(UIActivityIndicatorView*)[cell viewWithTag:20];
        UILabel* wrongLabel=(UILabel*)[cell viewWithTag:21];
        wrongLabel.textColor = [UIColor redColor];   // 发送失败
        [wrongLabel setFont:[UIFont systemFontOfSize:12.0f]];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconTaped:)];
        avatar.userInteractionEnabled = YES;
        avatar.tag = indexPath.row;
        [avatar addGestureRecognizer:tap];
        avatar.layer.masksToBounds = YES;
        avatar.layer.cornerRadius = avatar.frame.size.height/2;
        [avatar sd_setImageWithURL:[message objectForKey:@"sender_avatar"] placeholderImage:[UIImage imageNamed:@"avatar"]];
        
        if([message objectForKey:@"sender_avatar"]==nil)
        {
            NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:USERINFODIC];
            [avatar sd_setImageWithURL:[dic objectForKey:@"tiny_avatar"]];
        }
        NSString *datelineDescription = [ghunterRequester getTimeDescripton:[message objectForKey:@"dateline"]];
        
        CGRect datelineFrame = dateline.frame;
        CGSize dateline_bgSize = [datelineDescription boundingRectWithSize:CGSizeMake(datelineFrame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f]} context:nil].size;
        
        CGRect dateline_bgFrame = dateline_bg.frame;
        dateline_bgFrame.origin.x = (cell.frame.size.width - dateline_bgSize.width) / 2.0 - 3.0;
        dateline_bgFrame.size.width = dateline_bgSize.width + 10.0;
        dateline_bg.frame = dateline_bgFrame;
        [dateline_bg setImage:[UIImage imageNamed:@"chat_time_bg"]];
        
        [dateline setText:datelineDescription];
        
        if ([[message objectForKey:@"msg_tag"] integerValue] == 1) {
            // 如果是图片消息
            [content removeFromSuperview];
            
            bg.layer.masksToBounds = YES;
            bg.layer.cornerRadius = Radius;
            [bg setFrame:CGRectMake(bg.frame.origin.x + (bg.frame.size.width-100), bg.frame.origin.y, 100, (bg.frame.size.height +  70))];
            
            CGFloat top = 10; // 顶端盖高度
            CGFloat bottom = dateline_bg.frame.size.height - top - 1; // 底端盖高度
            CGFloat left = 10; // 左端盖宽度
            CGFloat right = dateline_bg.frame.size.width - left - 1; // 右端盖宽度
            UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
            // 指定为拉伸模式，伸缩后重新赋值
            UIImage *image = [UIImage imageNamed:@"conversation_g"];
            image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
            [bg setImage:image];
            
            photoImageView.frame = CGRectMake(bg.frame.origin.x+5, bg.frame.origin.y+5, bg.frame.size.width-10, bg.frame.size.height-10);
            photoImageView.hidden = NO;
            photoImageView.layer.masksToBounds = YES;
            photoImageView.contentMode = UIViewContentModeScaleAspectFill;
            photoImageView.userInteractionEnabled = YES;
            photoImageView.clipsToBounds = YES;
            photoImageView.layer.cornerRadius = 6.0;
            
            UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2viewLargeImage:) ];
            [photoImageView setTag:indexPath.row];
            [photoImageView addGestureRecognizer:tap2];
            [photoImageView setUserInteractionEnabled:YES];
            
            // 长按图片
            UILongPressGestureRecognizer *long_press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(saveImage:)];
            [photoImageView addGestureRecognizer:long_press];
            
            //[bg addSubview:photoImageView];
            [cell setFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height+60)];
            
            // 设置指示器的位置
            CGRect actFrame = act.frame;
            actFrame.origin.x = bg.frame.origin.x - 25 + (bg.frame.size.width-100);
            actFrame.origin.y = bg.frame.origin.y + 83;  //todo 位置不准确啊
            act.frame = actFrame;
            // 发送失败也显示在这里
            NSString *faildStr = @"失败";
            CGRect wrongFrame = wrongLabel.frame;
            wrongFrame.origin.x = actFrame.origin.x - 3 + (bg.frame.size.width-100);
            wrongFrame.origin.y = actFrame.origin.y - 50;
            wrongFrame.size = [faildStr boundingRectWithSize:CGSizeMake(MAXFLOAT,MAXFLOAT ) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f]} context:nil].size;
            wrongLabel.frame = wrongFrame;
            
            act.hidden = YES;
            wrongLabel.hidden = YES;
            if ([message objectForKey:@"state"] != nil) {
                
                [photoImageView setImage:[message objectForKey:@"send_img"]];
                
                if ([[message objectForKey:@"state"] isEqualToString:@"sending"]) {
                    // 正在发送
                    act.hidden = NO;
                    
                }else if([[message objectForKey:@"state"] isEqualToString:@"succeed"]){
                    // 发送成功
                    act.hidden = YES;
                }else{
                    // 发送失败，显示失败label
                    wrongLabel.hidden = NO;
                }
            }else{
                // [photoImageView setImageWithURL:[message objectForKey:@"tinyurl"]placeholderImage:[UIImage imageNamed:@"avatar"]];
                [photoImageView sd_setImageWithURL:[NSURL URLWithString:[message objectForKey:@"largeurl"] ] placeholderImage:[UIImage imageNamed:@"avatar"]];
            }
        }else{
            NSString *contentStr = [message objectForKey:@"content"];
            NSAttributedString* str2=[ghunterWordChange wordChange:contentStr];
            // str2.string.length+=(contentStr.length-str2.string.length)/3*12;
            NSString * newString = [contentStr substringWithRange:NSMakeRange(0, [contentStr length] - (contentStr.length-str2.string.length)*4/7)];
            
            CGSize labelSize = [newString sizeWithFont:content.font
                                     constrainedToSize:CGSizeMake(content.frame.size.width, MAXFLOAT)
                                         lineBreakMode:NSLineBreakByWordWrapping];
            //  labelSize.width+=(contentStr.length-str2.string.length)/3*12;
            CGFloat heightAdded = labelSize.height - content.frame.size.height;//添加内容之后控件增长的高
            
            if(heightAdded <= 0){
                heightAdded = 0;
            }
            CGFloat contentToRight = content.frame.origin.x + content.frame.size.width;
            CGFloat bgToRight = bg.frame.origin.x + bg.frame.size.width;
            [content setFrame:CGRectMake(contentToRight - labelSize.width, content.frame.origin.y, labelSize.width, (content.frame.size.height + heightAdded + 5))];
            [content setAttributedText:str2];
            bg.layer.masksToBounds = YES;
            bg.layer.cornerRadius = 4.0;
            [bg setFrame:CGRectMake(bgToRight - labelSize.width - 20, bg.frame.origin.y, labelSize.width + 20, (bg.frame.size.height + heightAdded + 5))];
            
            // 设置指示器的位置
            CGRect actFrame = act.frame;
            actFrame.origin.x = bg.frame.origin.x - 25;
            actFrame.origin.y = bg.frame.origin.y + 20;  //todo 位置不准确啊
            act.frame = actFrame;
            // 发送失败也显示在这里
            NSString *faildStr = @"失败";
            CGRect wrongFrame = wrongLabel.frame;
            wrongFrame.origin.x = actFrame.origin.x - 3;
            wrongFrame.origin.y = actFrame.origin.y - 2;
            wrongFrame.size = [faildStr boundingRectWithSize:CGSizeMake(MAXFLOAT,MAXFLOAT ) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f]} context:nil].size;
            wrongLabel.frame = wrongFrame;
            
            act.hidden = YES;
            wrongLabel.hidden = YES;
            if ([message objectForKey:@"state"] != nil) {
                if ([[message objectForKey:@"state"] isEqualToString:@"sending"]) {
                    // 正在发送
                    act.hidden = NO;
                }else if([[message objectForKey:@"state"] isEqualToString:@"succeed"]){
                    // 发送成功
                    act.hidden = YES;
                }else{
                    // 发送失败，显示失败label
                    wrongLabel.hidden = NO;
                }
            }
            
            CGFloat top = 10; // 顶端盖高度
            CGFloat bottom = dateline_bg.frame.size.height - top - 1; // 底端盖高度
            CGFloat left = 10; // 左端盖宽度
            CGFloat right = dateline_bg.frame.size.width - left - 1; // 右端盖宽度
            UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
            // 指定为拉伸模式，伸缩后重新赋值
            UIImage *image = [UIImage imageNamed:@"conversation_g"];
            image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
            [bg setImage:image];
            //    UIMenuController *menu = [UIMenuController sharedMenuController];
            //    [menu setTargetRect:[content frame] inView: [self view]];
            //    [menu setMenuVisible: YES animated: YES];
            [cell setFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height + heightAdded)];
        }
    }
    return cell;
}

// 点击私信图片，查看大图
// 为什么没用呢
-(void)tap2viewLargeImage:(UITapGestureRecognizer *)sender{
    // 取消
    [_chatTextField resignFirstResponder];
    
    UIImageView *imgview = (UIImageView *)sender.view;
    
    [SJAvatarBrowser showImage:imgview];
}

// 长按保存图片
-(void)saveImage:(UIGestureRecognizer *)sender{
    NSInteger row = [sender.view tag];
    if(UIGestureRecognizerStateBegan == sender.state) {
        saveAction = [[UIActionSheet alloc] initWithTitle:@"保存图片到相册?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
        saveAction.tag = row;
        [saveAction showInView:sender.view];
    }
}

#pragma mark - UIActionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(actionSheet == saveAction) {
        if(buttonIndex == 0) {
            // 保存图片到本地
            NSInteger row = [actionSheet tag];
            NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:1];
            UITableViewCell *cell = [chatTable cellForRowAtIndexPath:path];
            UIImageView *photoImageView = (UIImageView *)[cell viewWithTag:22];
            
            // UIImageWriteToSavedPhotosAlbum(photoImageView.image, nil, nil, nil);
            UIImageWriteToSavedPhotosAlbum(photoImageView.image, self,
                                           @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
    }
}

// 写到文件的完成时执行
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if ( error ) {
        [ProgressHUD show:@"保存失败"];
        [saveAction endEditing:YES];
    }else{
        [ProgressHUD show:@"已保存到相册"];
        [saveAction endEditing:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    if (action == @selector(copy:)) {
        if ( [_chatcontentArray count] > indexPath.row && [[[_chatcontentArray objectAtIndex:indexPath.row] objectForKey:@"msg_tag"] integerValue] != 1 ) {
            return YES;
        }
        return NO;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    if (action == @selector(copy:)) {
        NSDictionary *dic = [self.chatcontentArray objectAtIndex:indexPath.row];
        [UIPasteboard generalPasteboard].string = [dic objectForKey:@"content"];
    }
}

#pragma mark - Request method

- (void)requestFinished:(ASIHTTPRequest *)request {
    int responseCode=[request responseStatusCode];
    NSError *error;
    NSData *responseData = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    NSString *error_number = [dic objectForKey:ERROR];
    if([[request.userInfo objectForKey:REQUEST_TYPE] isEqual:REQUEST_FOR_GET_CHAT_HISTORY])
    {
        [self endLoad];
        if (responseCode==200 && [error_number intValue] == 0)
        {
            [self.chatcontentArray removeAllObjects];
            page = 2;
            NSMutableArray *array = [dic valueForKey:@"messages"];
            array = (NSMutableArray *)[[array reverseObjectEnumerator] allObjects];
            [self.chatcontentArray addObjectsFromArray:array];
            
            [chatTable reloadData];
            //            _chatTextField.text = @"";
            if([self.chatcontentArray count] > 0) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.chatcontentArray count] - 1 inSection:0];
                [chatTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
            }
        }else if ([dic objectForKey:@"msg"]){
            [ghunterRequester showTip:[dic objectForKey:@"msg"]];
        }else{
            [ghunterRequester noMsg];
        }
    }else if([[request.userInfo objectForKey:REQUEST_TYPE] isEqual:REQUEST_FOR_LOADMORE_CHAT_HISTORY])
    {
        if (responseCode==200 && [error_number intValue] == 0)
        {
            page++;
            NSMutableArray *array = [dic valueForKey:@"messages"];
            array = (NSMutableArray *)[[array reverseObjectEnumerator] allObjects];
            NSRange range = NSMakeRange(0, [array count]);
            [self.chatcontentArray insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
            [chatTable reloadData];
        }else if ([dic objectForKey:@"msg"]){
            [ghunterRequester showTip:[dic objectForKey:@"msg"]];
        }else{
            [ghunterRequester noMsg];
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    [self endLoad];
    _isAnimating=YES;
    [chatTable reloadData];
    [ghunterRequester showTip:@"网络异常"];
    
    // 找到提交发送按钮的时候，在userInfo后面追加的index数字
    NSRange requestChat = [[request.userInfo objectForKey:REQUEST_TYPE] rangeOfString:REQUEST_FOR_SEND_CHAT];
    if ( requestChat.location != NSNotFound ) {
        NSArray *split = [[request.userInfo objectForKey:REQUEST_TYPE] componentsSeparatedByString:@","];
        NSInteger index = [split[1] integerValue];
        if ( index < [self.chatcontentArray count] ) {
            // 发送私信成功
            [[self.chatcontentArray objectAtIndex:index] setObject:@"failed" forKey:@"state"];
            // 更新UI数据
            [chatTable reloadData];
        }
    }
}
//#pragma mark - UIScrollViewDelegate
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if([self.chatTextField isFirstResponder])
//    {
//        [self.chatTextField resignFirstResponder];
//    }
//}

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
    [ghunterRequester postwithDelegate:self withUrl:[NSString stringWithFormat:@"%@?page=%zd&uid=%@",URL_GET_CHAT_HISTORY,page,self.sender_uid] withUserInfo:REQUEST_FOR_LOADMORE_CHAT_HISTORY withDictionary:nil];
    chatTable.pullTableIsRefreshing = NO;
}

- (void)loadMoreDataToTable
{
    page = 1;
    [ghunterRequester postwithDelegate:self withUrl:[NSString stringWithFormat:@"%@?page=%zd&uid=%@",URL_GET_CHAT_HISTORY,(long)page,self.sender_uid] withUserInfo:REQUEST_FOR_GET_CHAT_HISTORY withDictionary:nil];
    chatTable.pullTableIsLoadingMore = NO;
}

#pragma mark - HPGrowingTextView delegate
- (BOOL)growingTextView:(HPGrowingTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        if([self.chatTextField.text length] == 0){
            return NO;
        }
        [self didSendTextMsg:[self.chatTextField text]];
        self.chatTextField.text = @"";
        
        return NO;
    }
    return YES;
}
- (BOOL)growingTextViewShouldBeginEditing:(HPGrowingTextView *)textView
{
    _faceView.hidden=YES;
    _isSender=NO;
    return YES;
}

#pragma mark - Custom Methods
- (void)startLoad{
    self.loadingView = [[ghunterLoadingView alloc] initWithSuperView:self.view withGif:@"loading2" withIndicator:@"正在加载..."];
    [self.loadingView startAnimition];
}

- (void)endLoad{
    [self.loadingView inValidate];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)showUserCenter:(id)sender {
    ghunterUserCenterViewController *userCenter = [[ghunterUserCenterViewController alloc] init];
    userCenter.uid = self.sender_uid;
    [self.navigationController pushViewController:userCenter animated:YES];
}

// 使键盘下降的按钮
- (IBAction)down_keyboard:(id)sender {
    // CGRect containerFrame = _chatView.frame;
    // containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
    // _chatView.frame = containerFrame;
    
    CGRect frame = self.chatView.frame;
    frame.origin.y = mainScreenheight - self.chatView.frame.size.height;
    self.chatView.frame = frame;
    
    CGRect frame1=chatTable.frame;
    frame1.size.height=mainScreenheight-64-_chatView.frame.size.height;
    chatTable.frame=frame1;
    if(_chatcontentArray.count!=0)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.chatcontentArray count] - 1 inSection:0];
        [chatTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
    }
    
    _faceView.hidden=YES;
    _addImgView.hidden = YES;
    [self.chatTextField resignFirstResponder];
}

- (void)iconTaped:(UITapGestureRecognizer *)sender {
    NSUInteger tag = sender.view.tag;
    NSDictionary *message = [self.chatcontentArray objectAtIndex:tag];
    ghunterUserCenterViewController *userCenter = [[ghunterUserCenterViewController alloc] init];
    userCenter.uid = [message objectForKey:@"sender_uid"];
    [self.navigationController pushViewController:userCenter animated:YES];
}
- (IBAction)faceBtn:(UIButton *)sender {
    _isSender = !_isSender;
    
    // 隐藏添加图片的弹框
    _addImgView.hidden = YES;
    _isSendimg = NO;
    
    if(_isSender)
    {
        [_chatTextField resignFirstResponder];  // 撤销第一响应者
        _faceView.hidden = NO;
        CGRect r = _chatView.frame;
        r.origin.y = mainScreenheight-170-r.size.height;
        _chatView.frame = r;
        [_faceView setFrame:CGRectMake(0, mainScreenheight-170,mainScreenWidth, 170)];
        
        CGRect frame1 = chatTable.frame;
        frame1.size.height = r.origin.y-64;
        [chatTable setFrame:frame1];
        if(_chatcontentArray.count!=0)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.chatcontentArray count] - 1 inSection:0];
            [chatTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
        }
        return;
    }
    else
    {
        _faceView.hidden=YES;
        [_chatTextField becomeFirstResponder];
    }
}

// 私信添加图片
-(void)chatAddImage{
    _isSendimg = !_isSendimg;
    _faceView.hidden = YES;
    _isSender = NO;
    if( _isSendimg )
    {
        [_chatTextField resignFirstResponder];
        _addImgView.hidden = NO;
        CGRect r = _chatView.frame;
        r.origin.y = mainScreenheight - 170 - r.size.height;
        _chatView.frame = r;
        [_addImgView setFrame:CGRectMake(0, mainScreenheight-170,mainScreenWidth, 170)];
        
        CGRect frame1 = chatTable.frame;
        frame1.size.height = r.origin.y - 64;
        [chatTable setFrame:frame1];
        if(_chatcontentArray.count!=0)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.chatcontentArray count] - 1 inSection:0];
            [chatTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
        }
        return;
    }
    else
    {
        _addImgView.hidden = YES;
        [_chatTextField becomeFirstResponder];
    }
}

// 从相册选择
-(void)getChatImgFromAlbum{
    
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = 1;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups=NO;
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
// 拍照上传
-(void)getChatImgFromCamera{
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    [imgPicker setAllowsEditing:YES];
    [imgPicker setDelegate:self];
    [imgPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [self.navigationController presentViewController:imgPicker animated:YES completion:nil];
}

#pragma mark - ZYQAssetPickerControllerDelegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    for (NSInteger i = 0; i < assets.count; i++) {
        ALAsset *asset = assets[i];
        UIImage *tempImg = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        // 从相册得到图片
        [self sendImageMsg:tempImg];
    }
}

#pragma mark - UIImagePickerDelegate
// 成功获得相片还是视频后的回调 UIImagePickerController
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image=[info objectForKey:UIImagePickerControllerEditedImage];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    // 从相机获得照片
    [self sendImageMsg:image];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    return;
}


#pragma mark - Custom methods

// 发送私信，表情下面的那一栏
-(void)sendBtnClick:(UIButton*)sender
{
    if([self.chatTextField.text length] == 0)
    {
        return;
    }
    [self didSendTextMsg:self.chatTextField.text];
    self.chatTextField.text = @"";
}

-(void)didSendTextMsg:(NSString *)content{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    // 接口参数
    [dic setObject:@"0" forKey:@"msg_tag"];
    [dic setObject:self.sender_uid forKey:@"to_uid"];
    [dic setObject:content forKey:@"content"];
    
    //接受者-内容-时间-发送者头像-发送者id
    NSDate *senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *sendDateTime = [dateformatter stringFromDate:senddate];
    
    //[message objectForKey:@"sender_uid"]
    //接受者-内容-时间-发送者头像-发送者id
    NSMutableDictionary* localDic=[[NSMutableDictionary alloc] init];
    [localDic setObject:self.sender_uid forKey:@"to_uid"];
    [localDic setObject:content forKey:@"content"];
    [localDic setObject:sendDateTime forKey:@"dateline"];
    [localDic setObject:[ghunterRequester getUserInfo:UID] forKey:@"sender_uid"];
    [localDic setObject:@"sending" forKey:@"state"];
    [localDic setObject:@"msg_tag" forKey:@"0"];
    
    [self.chatcontentArray addObject:localDic];
    [chatTable reloadData];
    
    // 滚动到最后一行
    NSInteger index = [self.chatcontentArray count] - 1;
    if(index > 0)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [chatTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
    }else{
        index = 0;
    }
    
    // post 方法发送私信
    [AFNetworkTool httpPostWithUrl:URL_SEND_MESSAGE andParameters:dic success:^(NSData *data) {
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (!error) {
            // 请求成功，这里得到json数据
            if ( [[json objectForKey:@"error"] integerValue] == 0 ) {
                if ( index < [self.chatcontentArray count] ) {
                    // 发送私信成功
                    [[self.chatcontentArray objectAtIndex:index] setObject:@"succeed" forKey:@"state"];
                    // 更新UI数据
                    [chatTable reloadData];
                }
            }else{
                // 发送私信失败
                [[self.chatcontentArray objectAtIndex:index] setObject:@"failed" forKey:@"state"];
                // 更新UI数据
                [chatTable reloadData];
            }
        }
    } fail:^{
        // 发送私信失败
        [[self.chatcontentArray objectAtIndex:index] setObject:@"failed" forKey:@"state"];
        // 更新UI数据
        [chatTable reloadData];
    }];
}

// 删除的方案
-(void)selected:(UIButton*)btn
{
    NSString *str;
    NSString *path=[[NSBundle mainBundle]pathForResource:@"face.plist" ofType:nil];
    NSDictionary *dic=[[NSDictionary alloc]initWithContentsOfFile:path];
    NSArray* allKeys=[dic allKeys];
    NSString* imageStr;
    str=[NSString stringWithFormat:@"emoji_%zd.png",btn.tag];
    if(btn.tag==21||btn.tag==42||btn.tag==63)
    {
        if(self.chatTextField.text.length>0)
        {
            NSMutableString* oldStr1=[[NSMutableString alloc] initWithString:self.chatTextField.text];
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
            int keySum=0;
            for(NSString* key in allKeys)
            {
                if([appendStr isEqualToString:key])
                {
                    keySum++;
                }
            }
            if(keySum!=0&&[self.chatTextField.text hasSuffix:@"]"])
            {
                NSString* newString=[self.chatTextField.text substringWithRange:NSMakeRange(0, self.chatTextField.text.length-appendStr.length)];
                self.chatTextField.text=newString;
            }
            else
            {
                NSString * newString = [self.chatTextField.text substringWithRange:NSMakeRange(0, [self.chatTextField.text length] - 1)];
                self.chatTextField.text=newString;
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
        self.chatTextField.text = self.chatTextField.text;
    }
    else
    {
        self.chatTextField.text=[self.chatTextField.text stringByAppendingString:imageStr];
    }
}

// selector for 获取最新的聊天消息
-(void)get_chat_message:(NSNotification *)notification{
    NSMutableDictionary *chat = [notification object];
    NSInteger chatUid = [[chat objectForKey:@"from_uid"]integerValue];
    
    if (ghunter_chatuid == chatUid) {
        NSInteger mid = [[chat objectForKey:@"mid"]integerValue];
        [AFNetworkTool httpRequestWithUrl:[NSString stringWithFormat:@"%@?mid=%zd", URL_GET_CHAT_MESSAGE, mid] params:nil success:^(NSData *data) {
            NSError *error;
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if ([[result objectForKey:@"error"]integerValue] == 0 ) {
                NSMutableDictionary *msg = [[NSMutableDictionary alloc] init];
                
                [msg setObject:[result objectForKey:@"content"] forKey:@"content"];
                [msg setObject:[result objectForKey:@"dateline"] forKey:@"dateline"];
                [msg setObject:[result objectForKey:@"mid"] forKey:@"mid"];
                [msg setObject:[result objectForKey:@"sender_uid"] forKey:@"sender_uid"];
                [msg setObject:[result objectForKey:@"sender_username"] forKey:@"sender_username"];
                [msg setObject:[result objectForKey:@"sender_avatar"] forKey:@"sender_avatar"];
                
                [msg setObject:[result objectForKey:@"msg_tag"] forKey:@"msg_tag"];
                [msg setObject:[result objectForKey:@"tinyurl"] forKey:@"tinyurl"];
                [msg setObject:[result objectForKey:@"largeurl"] forKey:@"largeurl"];
                
                [self.chatcontentArray addObject:msg];
                [chatTable reloadData];
                
                if ( [self.chatcontentArray count] > 0 ) {
                    // 滚到最后一行去
                    NSInteger index = [self.chatcontentArray count] - 1;
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                    [chatTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
                }
            }else{
                // error
            }
        } fail:^{
        }];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if([touch.view isMemberOfClass:[UIButton class]] ){
        return NO;
    }else
        return YES;
}

#pragma mark --私信发送图片
// 发送私信图片
-(void)sendImageMsg:(UIImage *)image{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.sender_uid forKey:@"to_uid"];
    [dic setObject:[ghunterRequester getUserInfo:API_SESSION_ID] forKey:@"api_session_id"];
    [dic setObject:API_TOKEN_NUM forKey:@"api_token"];
    [dic setObject:@"1" forKey:@"msg_tag"];   // 发送图片的标志
    // [dic setObject:@"" forKey:@"content"];
    
    //接受者-内容-时间-发送者头像-发送者id
    NSDate *senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *sendDateTime = [dateformatter stringFromDate:senddate];
    
    //[message objectForKey:@"sender_uid"]
    //接受者-内容-时间-发送者头像-发送者id
    NSMutableDictionary* localDic=[[NSMutableDictionary alloc] init];
    [localDic setObject:self.sender_uid forKey:@"to_uid"];
    [localDic setObject:@"[图片]" forKey:@"content"];
    [localDic setObject:sendDateTime forKey:@"dateline"];
    [localDic setObject:[ghunterRequester getUserInfo:UID] forKey:@"sender_uid"];
    [localDic setObject:@"sending" forKey:@"state"];
    [localDic setObject:@"1" forKey:@"msg_tag"];   // 发送的是图片
    [localDic setObject:image forKey:@"send_img"];
    
    [self.chatcontentArray addObject:localDic];
    [chatTable reloadData];
    
    NSInteger index = [self.chatcontentArray count] - 1;
    if(index > 0)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [chatTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
    }else{
        index = 0;
    }
    
    NSMutableArray *imgArr = [[NSMutableArray alloc] initWithCapacity:1];
    [imgArr addObject:image];
    [AFNetworkTool uploadImage:imgArr forKey:@"image" andParameters:dic toApiUrl:URL_SEND_MESSAGE success:^(NSData *data) {
        NSError *error;
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (!error) {
            // 请求成功，这里得到json数据
            if ( [[json objectForKey:@"error"] integerValue] == 0 ) {
                // 发送图片成功
                [localDic setObject:@"succeed" forKey:@"state"];
                [chatTable reloadData];
            }else{
                [ProgressHUD show:[json objectForKey:@"msg"]];
            }
        }
    } fail:^{
        NSLog(@"请求失败");
    }];
}

@end
