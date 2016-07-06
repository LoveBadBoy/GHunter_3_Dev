//
//  ghunterCollectSkillCell.m
//  ghunter
//
//  Created by imgondar on 15/5/22.
//  Copyright (c) 2015年 ghunter. All rights reserved.
//

#import "ghunterCollectSkillCell.h"

@implementation ghunterCollectSkillCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backImageview = [[UIImageView alloc] init];
        self.iconImageView = [[UIImageView alloc] init];
        self.name = [[UILabel alloc] init];
        self.jienngLabel = [[UILabel alloc] init];
        self.sexImageView = [[UIImageView alloc] init];
        self.ageLabel = [[UILabel alloc] init];
        self.distanceLabel = [[UILabel alloc] init];
        self.showSkillLabel = [[UILabel alloc] init];
        self.scaleLabel = [[UILabel alloc] init];
        self.priceLabel = [[UILabel alloc] init];
        self.grayImageView = [[UIImageView alloc] init];
        self.timeLabel = [[UILabel alloc] init];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backImageview.frame = CGRectMake(0, 10, mainScreenWidth, 105);
    [self.backImageview setImage:[UIImage imageNamed:@"white"]];
    [self.contentView addSubview:self.backImageview];
    self.iconImageView.frame = CGRectMake(mainScreenWidth / 64, 5, mainScreenWidth / 7.11, mainScreenWidth / 7.11);
    [self.backImageview addSubview:self.iconImageView];
    //self.name.frame = CGRectMake(mainScreenWidth / 5.33, 8, mainScreenWidth / 5.71, 15);
    [self.backImageview addSubview:self.name];
    self.timeLabel.frame = CGRectMake(mainScreenWidth / 1.25, 8, mainScreenWidth / 6.4, 15);
    [self.backImageview addSubview:self.timeLabel];
    //self.jienngLabel.frame = CGRectMake(mainScreenWidth / 2.758, 8, mainScreenWidth / 3.5, 15);
    [self.backImageview addSubview:self.jienngLabel];
    self.sexImageView.frame = CGRectMake(mainScreenWidth / 5.33, 35, mainScreenWidth / 45.7, 8);
    [self.backImageview addSubview:self.sexImageView];
    self.ageLabel.frame =CGRectMake(mainScreenWidth / 4.32, 32, mainScreenWidth / 9.1428, 15);
    [self.backImageview addSubview:self.ageLabel];
//    self.distanceLabel.frame = CGRectMake(mainScreenWidth / 3.1, 32, mainScreenWidth / 5.714, 15);
   self.distanceLabel.frame = CGRectMake(mainScreenWidth / 4.32, 32, mainScreenWidth / 5.714, 15);
    [self.backImageview addSubview:self.distanceLabel];
    self.grayImageView.frame = CGRectMake(mainScreenWidth / 6.1538, 52, mainScreenWidth / 1.3333, 45);
    [self.grayImageView.layer setCornerRadius:5];
    self.grayImageView.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:240 / 255.0 blue:240 / 255.0 alpha:1];
    [self.backImageview addSubview:self.grayImageView];
    self.showSkillLabel.frame = CGRectMake(mainScreenWidth / 64, 5, mainScreenWidth / 1.333, 15);
    [self.grayImageView addSubview:self.showSkillLabel];
    self.scaleLabel.frame = CGRectMake(mainScreenWidth / 64, 23, mainScreenWidth / 16, 20);
    [self.scaleLabel.layer setCornerRadius:10];
    self.scaleLabel.layer.masksToBounds = YES;
    [self.scaleLabel.layer setBorderWidth:1];
    [self.scaleLabel.layer setBorderColor:[UIColor colorWithRed:244.0 / 255 green:78 / 255.0 blue:32.0 / 255 alpha:1].CGColor];
    [self.grayImageView addSubview:self.scaleLabel];
    self.priceLabel.frame = CGRectMake(mainScreenWidth / 11.4285, 17, mainScreenWidth / 3.2, 30);
    [self.grayImageView addSubview:self.priceLabel];
}

@end
