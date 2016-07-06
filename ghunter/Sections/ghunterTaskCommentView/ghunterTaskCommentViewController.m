//
//  ghunterTaskCommentViewController.m
//  ghunter
//
//  Created by chensonglu on 14-8-15.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//查看自己发布任务的评价(未知)

#import "ghunterTaskCommentViewController.h"

@interface ghunterTaskCommentViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet OHAttributedLabel *bounty;
@property (weak, nonatomic) IBOutlet UILabel *dateline;
@property (strong, nonatomic) IBOutlet UIView *bg;
@property (weak, nonatomic) IBOutlet UIImageView *owner_icon;
@property (weak, nonatomic) IBOutlet UILabel *owner_content;
@property (strong, nonatomic) IBOutlet UIImageView *owner_back;
@property (weak, nonatomic) IBOutlet UIImageView *hunter_icon;
@property (weak, nonatomic) IBOutlet UILabel *hunter_content;
@property (strong, nonatomic) IBOutlet UIView *bgnav;
@property (strong, nonatomic) IBOutlet UIImageView *hunter_back;
@property (strong, nonatomic) IBOutlet UIImageView *point;
@end

@implementation ghunterTaskCommentViewController

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
     _bgnav.backgroundColor = Nav_backgroud;
    // Do any additional setup after loading the view from its nib.
    [ghunterRequester getwithDelegate:self withUrl:URL_SHOW_TASK_VALUATION withUserInfo:REQUEST_FOR_SHOW_TASK_COMMENT withString:[NSString stringWithFormat:@"?tid=%@",self.tid]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ASIHttpRequest

-(void)requestFinished:(ASIHTTPRequest *)request
{
    int responseCode=[request responseStatusCode];
    NSError *error;
    NSData *responseData = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    NSString *error_number = [dic objectForKey:ERROR];
    if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_SHOW_TASK_COMMENT]){
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            NSDictionary *evaluation = [dic objectForKey:@"valuation"];
            [self.titleLabel setText:self.titleStr];
            NSString *bountySelf = self.bountyStr;
            NSString *bountyStr = [NSString stringWithFormat:@"%@元",bountySelf];
            NSMutableAttributedString *attrStr = [NSMutableAttributedString attributedStringWithString:bountyStr];
            [attrStr setFont:[UIFont systemFontOfSize:12.0] range:NSMakeRange([bountySelf length], 1)];
            [attrStr setFont:[UIFont systemFontOfSize:24.0] range:NSMakeRange(0, [bountySelf length])];
            [attrStr setTextColor:[UIColor colorWithRed:234/255.0 green:85/234.0 blue:20/255.0 alpha:1.0]];
            [self.bounty setAttributedText:attrStr];
            [self.dateline setText:[ghunterRequester getTimeDescripton:self.datelineStr]];
            CGFloat space = self.point.frame.origin.x - self.owner_back.frame.origin.x;
            CGFloat base_width = 70.0;
            self.owner_icon.clipsToBounds = YES;
            self.owner_icon.layer.cornerRadius = self.owner_icon.frame.size.height/2.0;
            [self.owner_icon sd_setImageWithURL:[evaluation objectForKey:@"owner_middle_avatar"] placeholderImage:[UIImage imageNamed:@"avatar"]];
            CGFloat top = 20; // 顶端盖高度
            CGFloat bottom = self.owner_back.frame.size.height - top - 1; // 底端盖高度
            CGFloat right = 20; // 左端盖宽度
            CGFloat left = self.owner_back.frame.size.width - right - 1; // 右端盖宽度
            UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
            // 指定为拉伸模式，伸缩后重新赋值
            UIImage *image = [UIImage imageNamed:@"comment_conversation_top_bg"];
            image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
            [self.owner_back setImage:image];
            TQStarRatingView *owner_star = [[TQStarRatingView alloc] initWithFrame:CGRectMake(self.owner_back.frame.origin.x + 10, self.owner_back.frame.origin.y + 5, 50,10) numberOfStar:5];
            [owner_star setuserInteractionEnabled:NO];
            [owner_star setScore:[[evaluation objectForKey:@"owner_valuation"] floatValue]];
            [self.bg addSubview:owner_star];
            NSString *owner_description = [evaluation objectForKey:@"owner_description"];
            CGSize owner_contentSize = [owner_description sizeWithFont:self.owner_content.font constrainedToSize:CGSizeMake(space - 20, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
            CGRect owner_contentFrame = self.owner_content.frame;
            owner_contentFrame.size.width = owner_contentSize.width;
            self.owner_content.frame = owner_contentFrame;
            [self.owner_content setText:owner_description];
            CGRect owner_backFrame = self.owner_back.frame;
            if (owner_contentSize.width <= 50) {
                owner_backFrame.size.width = base_width;
            } else {
                owner_backFrame.size.width = owner_contentSize.width + 20;
            }
            self.owner_back.frame = owner_backFrame;
            
            self.hunter_icon.clipsToBounds = YES;
            self.hunter_icon.layer.cornerRadius = self.hunter_icon.frame.size.height/2.0;
            [self.hunter_icon sd_setImageWithURL:[evaluation objectForKey:@"hunter_middle_avatar"] placeholderImage:[UIImage imageNamed:@"avatar"]];
            UIImage *imageBottom = [UIImage imageNamed:@"comment_conversation_bottom_bg"];
            imageBottom = [imageBottom resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
            [self.hunter_back setImage:imageBottom];
            TQStarRatingView *hunter_star = [[TQStarRatingView alloc] initWithFrame:CGRectMake(self.point.frame.origin.x - 50 - 10, self.hunter_back.frame.origin.y + 5, 50,10) numberOfStar:5];
            [hunter_star setuserInteractionEnabled:NO];
            [hunter_star setScore:[[evaluation objectForKey:@"hunter_valuation"] floatValue]];
            [self.bg addSubview:hunter_star];
            NSString *hunter_description = [evaluation objectForKey:@"hunter_description"];
            CGSize hunter_contentSize = [hunter_description sizeWithFont:self.hunter_content.font constrainedToSize:CGSizeMake(space - 20, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
            CGRect hunter_contentFrame = self.hunter_content.frame;
            hunter_contentFrame.origin.x = self.point.frame.origin.x - 10 - hunter_contentSize.width;
            hunter_contentFrame.size.width = hunter_contentSize.width;
            self.hunter_content.frame = hunter_contentFrame;
            
            [self.hunter_content setText:hunter_description];
            CGRect hunter_backFrame = self.hunter_back.frame;
            if (hunter_contentSize.width <= 50) {
                hunter_backFrame.origin.x = self.point.frame.origin.x - base_width;
                hunter_backFrame.size.width = base_width;
            } else {
                hunter_backFrame.size.width = hunter_contentSize.width + 20;
                hunter_backFrame.origin.x = self.point.frame.origin.x - hunter_backFrame.size.width;
            }
            self.hunter_back.frame = hunter_backFrame;
        }else if([dic objectForKey:@"msg"]){
            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
        }else{
            [ghunterRequester noMsg];
        }
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    [ghunterRequester performSelectorOnMainThread:@selector(showTip:) withObject:@"网络连接异常" waitUntilDone:false];
//    NSError *error = [request error];
//    NSLog(@"%@",error);
}


- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
