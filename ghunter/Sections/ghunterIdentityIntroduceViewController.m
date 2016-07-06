//
//  ghunterIdentityIntroduceViewController.m
//  ghunter
//
//  Created by 汪睦雄 on 15/6/11.
//  Copyright (c) 2015年 ghunter. All rights reserved.
//

#import "ghunterIdentityIntroduceViewController.h"
#import "Header.h"
@interface ghunterIdentityIntroduceViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *bg;

@end

@implementation ghunterIdentityIntroduceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _bg.backgroundColor = Nav_backgroud;
    UIImageView *guide1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, mainScreenWidth-20, 400)];
    [guide1 setImage:[UIImage imageNamed:@"identity_guide1"]];
    UIImageView *guide2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 420, mainScreenWidth-20, 400)];
    [guide2 setImage:[UIImage imageNamed:@"identity_guide2"]];
    UIImageView *guide3 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 830, mainScreenWidth-20, 400)];
    [guide3 setImage:[UIImage imageNamed:@"identity_guide3"]];
    
    [self.scrollView addSubview:guide1];
    [self.scrollView addSubview:guide2];
    [self.scrollView addSubview:guide3];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:228/255.0 green:227/255.0 blue:220/255.0 alpha:1.0f]];
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 400*3 + 45);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.alpha = 0;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

// 返回按钮
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- scrollview delege
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

@end
