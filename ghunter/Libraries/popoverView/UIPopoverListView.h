//
//  UIPopoverListView.h
//  UIPopoverListViewDemo
//
//
#import <QuartzCore/QuartzCore.h>

@class UIPopoverListView;

@protocol UIPopoverListViewDataSource <NSObject>
@required

- (UITableViewCell *)popoverListView:(UIPopoverListView *)popoverListView
                    cellForIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)popoverListView:(UIPopoverListView *)popoverListView
       numberOfRowsInSection:(NSInteger)section;

@end

@protocol UIPopoverListViewDelegate <NSObject>
@optional

- (void)popoverListView:(UIPopoverListView *)popoverListView
     didSelectIndexPath:(NSIndexPath *)indexPath;

- (void)popoverListViewCancel:(UIPopoverListView *)popoverListView;

- (CGFloat)popoverListView:(UIPopoverListView *)popoverListView
   heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface UIPopoverListView : UIView <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_listView;
    UIControl   *_overlayView;
    
    id<UIPopoverListViewDataSource> _datasource;
    id<UIPopoverListViewDelegate>   _delegate;
    
}

@property (nonatomic, retain) id<UIPopoverListViewDataSource> datasource;
@property (nonatomic, retain) id<UIPopoverListViewDelegate>   delegate;

@property (nonatomic, retain) UITableView *listView;

- (void)show;
- (void)dismiss;

@end
