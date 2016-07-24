//
//  XBAlertView.h
//  XBAlertView
//
//  Created by xxb on 16/7/24.
//  Copyright © 2016年 xxb. All rights reserved.

#import <UIKit/UIKit.h>

@interface XBAlertView : UIView

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