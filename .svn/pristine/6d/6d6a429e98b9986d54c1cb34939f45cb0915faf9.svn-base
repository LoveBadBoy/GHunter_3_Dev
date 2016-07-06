//
//  ghunterFeedBackViewController.m
//  ghunter
//
//  Created by chensonglu on 14-3-11.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//用户反馈

#import "ghunterFeedBackViewController.h"

@interface ghunterFeedBackViewController ()
@property (weak, nonatomic) IBOutlet UIView *back;
@property (weak, nonatomic) IBOutlet UITextField *contact;
@property (weak, nonatomic) IBOutlet UITextView *content;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (strong, nonatomic) IBOutlet UIView *bg;

@end

@implementation ghunterFeedBackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     _bg.backgroundColor = Nav_backgroud;
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.back.clipsToBounds = YES;
    self.back.layer.cornerRadius = YES;
    self.content.delegate = self;
    self.contact.delegate = self;
    [self.contact becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)feedback:(id)sender {
    [self.content endEditing:YES];
    [self.contact endEditing:YES];
    if([self.content.text length] == 0){
        [ghunterRequester showTip:@"请输入反馈内容~"];
        return;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.contact.text forKey:@"contact"];
    [dic setObject:self.content.text forKey:@"content"];
    [ghunterRequester postwithDelegate:self withUrl:URL_FEEDBACK withUserInfo:REQUEST_FOR_FEEDBACK withDictionary:dic];
}

//http请求处理的代理方法
-(void)requestFinished:(ASIHTTPRequest *)request
{
    int responseCode=[request responseStatusCode];
    NSError *error;
    NSData *responseData = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    NSString *error_number = [dic objectForKey:ERROR];
    if ([[request.userInfo objectForKey:REQUEST_TYPE] isEqual: REQUEST_FOR_FEEDBACK]){
        if(responseCode==200 && [error_number integerValue] == 0)
        {
            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
            [self.navigationController popViewControllerAnimated:YES];
        } else if ([dic objectForKey:@"msg"]) {
            [ghunterRequester wrongMsg:[dic objectForKey:@"msg"]];
        } else {
            [ghunterRequester noMsg];
        }
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    [ghunterRequester performSelectorOnMainThread:@selector(showTip:) withObject:@"网络异常" waitUntilDone:false];
}

#pragma mark - UITextview delegate

-(void)textViewDidChange:(UITextView *)textView
{
    if(self.content.text.length != 0){
        self.contentLabel.hidden = YES;
    }else{
        self.contentLabel.hidden = NO;
    }
}

#pragma mark - UITextField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
