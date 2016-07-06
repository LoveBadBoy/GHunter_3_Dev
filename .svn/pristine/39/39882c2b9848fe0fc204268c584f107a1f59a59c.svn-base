//
//  ghunterUserInfoViewController.h
//  ghunter
//
//  Created by chensonglu on 14-3-11.
//  Copyright (c) 2014年 ghunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ghunterRequester.h"
#import "UIImageView+WebCache.h"
#import "ghunterModifyUserInfoViewController.h"
#import "ghunterModifyPhoneViewController.h"
#import "ghunterRegisterThreeViewController.h"
#import "SJAvatarBrowser.h"
#import "ghunterLevelViewController.h"
#import "SIAlertView.h"
#import "ghunterschoolViewController.h"
#import "ProvinceModel.h"
#import "GWLCustomPikerView.h"
#import "ghunterOccupationViewController.h"
#import "ghunterIdentityViewController.h"
@interface ghunterUserInfoViewController : UIViewController<UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,GWLCustomPikerViewDataSource, GWLCustomPikerViewDelegate> {
    SIAlertView *ageAlert;
    SIAlertView *pictureAlert;
    GWLCustomPikerView *customPikerView;
    UILabel *resultLabel;
    UIButton *reloadButton;
}
@property (strong, nonatomic) IBOutlet UILabel *addressssss;

@property(nonatomic,retain)NSDictionary *user;
//pick属性
@property (nonatomic,weak   ) UILabel            *resultLabel;
@property (nonatomic,weak   ) GWLCustomPikerView *customPikerView;

@property (strong, nonatomic) NSArray            *citiesData;

@property (nonatomic,assign ) NSInteger          selectedProvince;
@property (nonatomic,assign ) NSInteger          selectedCity;
@end
