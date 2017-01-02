//
//  XBAlertView.m
//  XBAlertView
//
//  Created by xxb on 16/7/24.
//  Copyright © 2016年 xxb. All rights reserved.

#import "XBAlertView.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
#import "XBAlertBtnCell.h"
#import "XBAlertBtnCellTwo.h"
#import "UIView+Convenience.h"

#define ScreenHeight [[UIScreen mainScreen] bounds].size.height//获取屏幕高度，兼容性测试
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width//获取屏幕宽度，兼容性测试
//带有RGBA的颜色设置
#define COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]


@interface XBAlertView ()<UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>{
    NSString *_title;
    NSString *_content;
}

@property (nonatomic, strong) UILabel *alertTitleLabel;
@property (nonatomic, strong) UILabel *alertContentLabel;
@property (nonatomic, strong) UIView *backImageView;

@property (nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSMutableArray *blockArray;
@property(nonatomic, strong) NSMutableArray *btnTitleArray;

@end

@implementation XBAlertView

static NSString * const btnCellOneID = @"XBAlertBtnCell";
static NSString * const btnCellTwoID = @"XBAlertBtnCellTwo";

#pragma mark - life cycle

- (id)initWithTitle:(NSString *)title
        contentText:(NSString *)content
{
    if (self = [super init]) {
        _title = title;
        _content = content;
        _blockArray = [[NSMutableArray alloc] init];
        _btnTitleArray = [[NSMutableArray alloc] init];
        [self setupContentView];
        _alertTitleLabel.text = _title;
        _alertContentLabel.text = _content;
    }
    return self;
}

- (void)setupContentView{
    //title
    self.alertTitleLabel = [[UILabel alloc] init];
    self.alertTitleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    self.alertTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.alertTitleLabel.frame = CGRectMake(TitleHorizontalOffset, TitleMarginTop, SelfWidth - TitleHorizontalOffset * 2, self.alertTitleLabel.font.lineHeight);
    [self addSubview:self.alertTitleLabel];
    
    //content
    CGFloat contentLabelWidth = SelfWidth - ContentHorizontalOffset * 2;
    CGFloat contentH = [self heightWithContent:_content byWidth:contentLabelWidth andFontSize:13 andLineSpacing:3];
    self.alertContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(ContentHorizontalOffset, CGRectGetMaxY(self.alertTitleLabel.frame) + ContentMarginTop, contentLabelWidth, contentH)];
    self.alertContentLabel.numberOfLines = 0;
    self.alertContentLabel.textAlignment = NSTextAlignmentCenter;
    self.alertContentLabel.font = [UIFont systemFontOfSize:13.0f];
    [self addSubview:self.alertContentLabel];
    
    //self
    CGFloat selfHeight = TitleMarginTop + self.alertTitleLabel.font.lineHeight + ContentMarginTop + contentH + BtnMarginTop + kButtonHeight;
    CGFloat selfMarginLeft = (ScreenWidth - SelfWidth) / 2;
    self.frame = CGRectMake(selfMarginLeft, (ScreenHeight - selfHeight) / 2, SelfWidth, selfHeight);
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 10.0;
    self.backgroundColor = [UIColor whiteColor];
    
    //collectionView
    [self addSubview:self.collectionView];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"XBAlertBtnCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:btnCellOneID];
    [_collectionView registerNib:[UINib nibWithNibName:@"XBAlertBtnCellTwo" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:btnCellTwoID];
    
    //X按钮
    UIButton *xButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [xButton setImage:[UIImage imageNamed:@"btn_close_normal.png"] forState:UIControlStateNormal];
    [xButton setImage:[UIImage imageNamed:@"btn_close_selected.png"] forState:UIControlStateHighlighted];
    xButton.frame = CGRectMake(self.frame.size.width - 32, 0, 32, 32);
    [self addSubview:xButton];
    [xButton addTarget:self action:@selector(dismissAlert) forControlEvents:UIControlEventTouchUpInside];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview == nil) {
        return;
    }
    UIViewController *topVC = [self appRootViewController];

    if (!self.backImageView) {
        self.backImageView = [[UIView alloc] initWithFrame:topVC.view.bounds];
        self.backImageView.backgroundColor = [UIColor blackColor];
        self.backImageView.alpha = 0.6f;
        self.backImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    [topVC.view addSubview:self.backImageView];
    CGRect afterFrame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - self.frame.size.width) * 0.5, (CGRectGetHeight(topVC.view.bounds) - self.frame.size.height) * 0.5, self.frame.size.width, self.frame.size.height);
    self.frame = afterFrame;
    [super willMoveToSuperview:newSuperview];
}


#pragma mark - delegate

#pragma mark -UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.btnTitleArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0 && self.btnTitleArray.count == 2){
        XBAlertBtnCellTwo *cell = [collectionView dequeueReusableCellWithReuseIdentifier:btnCellTwoID forIndexPath:indexPath];
        cell.btnTitle.text = self.btnTitleArray[indexPath.row];
        return cell;
    }else{
        XBAlertBtnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:btnCellOneID forIndexPath:indexPath];
        cell.btnTitle.text = self.btnTitleArray[indexPath.row];
        return cell;
    }
}

#pragma mark -UICollectionViewDelegateFlowLayout

#pragma mark -设置每个item的size

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(self.btnTitleArray.count == 2){
        return CGSizeMake(SelfWidth / 2, kButtonHeight);
    }else{
        return CGSizeMake(SelfWidth, kButtonHeight);
    }
}

#pragma mark -设置每个item水平间距

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

#pragma mark -设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

#pragma mark -UICollectionViewDelegate

#pragma mark -高亮后的处理

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = COLOR(217, 217, 217, 100);
}

#pragma mark -非高亮后的处理

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    dispatch_block_t block = self.blockArray[indexPath.row];
    block();
    [self dismissAlert];
}

#pragma mark - event

#pragma mark -点击“X”关闭alertView

- (void)dismissAlert
{
    [self removeFromSuperview];
}

#pragma mark - action

- (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}


- (void)removeFromSuperview
{
    [self.backImageView removeFromSuperview];
    self.backImageView = nil;
    UIViewController *topVC = [self appRootViewController];
    CGRect afterFrame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - self.frame.size.width) * 0.5, CGRectGetHeight(topVC.view.bounds), self.frame.size.width, self.frame.size.height);
    self.frame = afterFrame;
    [super removeFromSuperview];
}

- (void)show
{
    if(self.btnTitleArray.count == 0 || self.btnTitleArray.count > 2){
        //更新view的frame
        [self updateFrame];
    }
    [self.collectionView reloadData];
    UIViewController *topVC = [self appRootViewController];
    [topVC.view addSubview:self];
}

-(void)updateFrame{
    NSInteger count = self.btnTitleArray.count;
    if(count == 0){
        [self.collectionView removeFromSuperview];
        self.frameHeight -= kButtonHeight;
    }else{
        //大于2的情况
        self.collectionView.frameHeight = count * kButtonHeight;
        self.frameHeight += (count - 1) *kButtonHeight;
    }
    if(self.frameHeight > ScreenHeight - 64 * 2){
        //不让alerView覆盖到导航栏和状态栏
        self.frameHeight = ScreenHeight - 64 * 2;
    }
    self.frameY = (ScreenHeight - self.frameHeight) / 2;
}

-(void)addAction:(dispatch_block_t)actionBlock withTitle:(NSString*)title{
    if(actionBlock && ![self isBlankString:title]){
        [self.blockArray addObject:actionBlock];
        [self.btnTitleArray addObject:title];
    }
}

#pragma mark - getter

-(UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView.collectionViewLayout = flowLayout;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.alertContentLabel.frame) + BtnMarginTop, self.frame.size.width, kButtonHeight) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}

#pragma mark - 工具方法

#pragma mark -根据高度、字体大小获取字符串高度

- (CGFloat)heightWithContent:(NSString*)content byWidth:(CGFloat)width andFontSize:(CGFloat)fontSize andLineSpacing:(CGFloat)spacing {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:spacing];//调整行间距
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    CGFloat height = [content boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options: NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSParagraphStyleAttributeName:paragraphStyle} context:nil].size.height;
    return height;
}


#pragma mark -判断字符串是否为空

-(BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}


@end
