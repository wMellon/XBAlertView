//
//  XBAlertView.h
//  XBAlertView
//
//  Created by xxb on 16/7/24.
//  Copyright © 2016年 xxb. All rights reserved.

#import <UIKit/UIKit.h>

#define SelfWidth 270               //alertView的宽度
#define TitleMarginTop 20.0f        //title距离上边间隔
#define TitleHorizontalOffset 20    //title水平方向左/右间隔
#define ContentHorizontalOffset 20  //content水平方向左/右间隔
#define ContentMarginTop 15         //content距离上边间隔
#define BtnMarginTop 20             //按钮距离上边间隔
#define kButtonHeight 44.0f         //按钮高度

@interface XBAlertView : UIView

/**
 初始化方法，不要调用直接调用init，否则界面一些元素展示不正常

 @param title
 @param content

 @return
 */
- (id)initWithTitle:(NSString *)title
        contentText:(NSString *)content;

- (void)show;

/**
 *  添加alertView的点击按钮
 *
 *  @param actionBlock
 *  @param title       
 */
-(void)addAction:(dispatch_block_t)actionBlock withTitle:(NSString*)title;

@end
