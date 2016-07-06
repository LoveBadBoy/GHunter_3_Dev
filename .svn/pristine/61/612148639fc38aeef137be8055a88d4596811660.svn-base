//
//  RadioButton.m
//  RadioButton
//
//  Created by ohkawa on 11/03/23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RadioButton.h"

@interface RadioButton()
-(void)otherButtonSelected:(id)sender;
-(void)handleButtonTap:(id)sender;
@end

@implementation RadioButton

@synthesize groupId=_groupId;
@synthesize index=_index;

static NSMutableArray *rb_instances=nil;
static NSMutableDictionary *rb_instancesDic=nil;  // 识别不同的组
static NSMutableDictionary *rb_observers=nil;
#pragma mark - Observer

+(void)addObserverForGroupId:(NSString*)groupId observer:(id)observer{
    if(!rb_observers){
        rb_observers = [[NSMutableDictionary alloc] init];
    }
    
    if ([groupId length] > 0 && observer) {
        [rb_observers setObject:observer forKey:groupId];
        // Make it weak reference
    }
}

#pragma mark - Manage Instances

+(void)registerInstance:(RadioButton*)radioButton withGroupID:(NSString *)aGroupID{

    if(!rb_instancesDic){
        rb_instancesDic = [[NSMutableDictionary alloc] initWithCapacity:16];
    }
    
    if ([rb_instancesDic objectForKey:aGroupID]) {
        [[rb_instancesDic objectForKey:aGroupID] addObject:radioButton];
        [rb_instancesDic setObject:[rb_instancesDic objectForKey:aGroupID] forKey:aGroupID];
    }else {
        NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:16];
        [arr addObject:radioButton];
        [rb_instancesDic setObject:arr forKey:aGroupID];
    }
}

#pragma mark - Class level handler

+(void)buttonSelected:(RadioButton*)radioButton{
    
    // Notify observers
    if (rb_observers) {
        id observer= [rb_observers objectForKey:radioButton.groupId];
        
        if(observer && [observer respondsToSelector:@selector(radioButtonSelectedAtIndex:inGroup:)]){
            [observer radioButtonSelectedAtIndex:radioButton.index inGroup:radioButton.groupId];
        }
    }
    
    // Unselect the other radio buttons

    // 初始化按钮数组
    rb_instances = [rb_instancesDic objectForKey:radioButton.groupId];
    
    if (rb_instances) {
        for (int i = 0; i < [rb_instances count]; i++) {
            RadioButton *button = [rb_instances objectAtIndex:i];
            if (![button isEqual:radioButton]) {
                [button otherButtonSelected:radioButton];
            }
        }
    }
}

#pragma mark - Object Lifecycle

-(id)initWithGroupId:(NSString*)groupId index:(NSUInteger)index normalImage:(UIImage *)normalimage clickedimage:(UIImage *)clickedimage isLeft:(BOOL)isLeft size:(CGSize)size padding:(CGFloat)padding{
    self = [self init];
    if (self) {
        _groupId = groupId;
        _index = index;
        [self defaultInitWithnormalImage:normalimage withClickedImage:clickedimage isLeft:isLeft size:size padding:padding];  // 移动至此
    }
    return self;
}

- (id)init{
    self = [super init];
    if (self) {
 //       [self defaultInit];
    }
    return self;
}

#pragma mark - Set Default Checked

- (void) setChecked:(BOOL)isChecked
{
    if (isChecked) {
        [_button setSelected:YES];
        [_image setImage:_clickedImage];
    }else {
        [_button setSelected:NO];
        [_image setImage:_normalImage];
    }
}

#pragma mark - Tap handling

-(void)handleButtonTap:(id)sender{
    [_button setSelected:YES];
    [_image setImage:_clickedImage];
    [RadioButton buttonSelected:self];
}

-(void)otherButtonSelected:(id)sender{
    // Called when other radio button instance got selected
    if(_button.selected){
        [_button setSelected:NO];
        [_image setImage:_normalImage];
    }
}

#pragma mark - RadioButton init

-(void)defaultInitWithnormalImage:(UIImage *)normalImage withClickedImage:(UIImage *)clickedImage isLeft:(BOOL)isLeft size:(CGSize)size padding:(CGFloat)padding{
    // Setup container view
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height);
    _normalImage = normalImage;
    _clickedImage = clickedImage;
    
    // Customize UIButton
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame = CGRectMake(0, 0,self.frame.size.width, self.frame.size.height);
    _button.adjustsImageWhenHighlighted = NO;
    [_button addTarget:self action:@selector(handleButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_button];
    CGFloat width = size.width;
    CGFloat height = size.height;
    _image = [[UIImageView alloc] init];
    if(isLeft){
        _image.frame = CGRectMake(0, padding, height - 2*padding, height - 2*padding);
    }else{
        _image.frame = CGRectMake(width - height + 2*padding, padding, height - 2*padding, height - 2*padding);
    }
    [_image setImage:_normalImage];
    [self addSubview:_image];
    
    // update follow:
    [RadioButton registerInstance:self withGroupID:self.groupId];

}

@end
