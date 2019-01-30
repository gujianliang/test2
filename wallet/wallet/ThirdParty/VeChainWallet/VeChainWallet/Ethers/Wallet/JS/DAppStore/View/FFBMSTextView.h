//
//  FFBMSTextView.h
//  FFBMS
//
//  Created by 曾新 on 16/4/19.
//  Copyright © 2016年 Eagle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFBMSTextView : UITextView

@property (strong, nonatomic) UILabel *placeholderLab;

@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;
@property (nonatomic) BOOL displayPlaceHolder;
@property (nonatomic, strong) UIImage *placeholderImg;
@property (nonatomic, strong) UILabel *placeLabel;
@property (nonatomic, assign) CGFloat placeHolderXOffset;
@property (nonatomic, assign) CGFloat placeHolderYOffset;

@property (nonatomic, assign) BOOL disablePaste;
@property (nonatomic, assign) BOOL disableSelect;
@property (nonatomic, assign) BOOL disableSelectAll;

- (void)contentSizeToFit;

@end
