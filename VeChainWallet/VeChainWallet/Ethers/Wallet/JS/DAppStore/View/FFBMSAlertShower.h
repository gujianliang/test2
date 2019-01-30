//
//  FFBMSAlertShower.h
//  Stonebang
//  Alert,Sheet等控件的IOS系统适配
//  Created by 曾新 on 16/4/7.
//  Copyright © 2016年 stonebang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^clickBlock)(NSInteger index);
typedef void(^clickBlockF)(NSInteger index,NSString *msg);

@interface FFBMSAlertShower : UIView<UIAlertViewDelegate,UIActionSheetDelegate,UITextFieldDelegate>

@property(nonatomic,copy)clickBlock alertClickBack;
@property(nonatomic,copy)clickBlockF alertClickBackF;

//@property(nonatomic,copy)clickBlock sheetClickBack;

//SIGLEDEF(FFBMSAlertShower);

/**
 *  适配IOS系统版本的AlertView展示
 *
 *  @param title         标题
 *  @param msg           信息
 *  @param ctl           展示的控制器
 *  @param items         按钮标题
 *  @param clickCallBack 点击按钮的回调
 */
+(void)showAlert:(nullable NSString *)title
             msg:(id)msg
           inCtl:(UIViewController*)ctl
           items:(NSArray<NSString*>*)items
      clickBlock:(clickBlock)clickCallBack;

// 销毁已经存在的
+(void)showNoRepeatAlert:(NSString*)title
                     msg:(NSString*)msg
                   inCtl:(UIViewController*)ctl
                   items:(NSArray<NSString*>*)items
              clickBlock:(void(^)(NSInteger))clickCallBack;

/**
 *  适配IOS系统版本的ActionSheet展示
 *
 *  @param title         标题
 *  @param ctl           展示界面Controller
 *  @param items         所有按钮(destructiveButtonTitle和cancelButtonTitle分别放置在该数组的第一个和最后一个参数)
 *  @param clickCallBack 点击按钮回调
 */
+(void)showSheet:(NSString*)title
           inCtl:(UIViewController*)ctl
           items:(NSArray<NSString*>*)items
      clickBlock:(void(^)(NSInteger))clickCallBack;


+(void)showAlert:(NSString*)title
             msg:(id)msg
    magAlignment:(NSTextAlignment)textAlignment
           inCtl:(UIViewController*)ctl
           items:(NSArray<NSString*>*)items
      clickBlock:(void(^)(NSInteger))clickCallBack;


+(void)showInputView:(NSString*)inputText
               inCtl:(UIViewController*)ctl
               items:(NSArray<NSString*>*)items
          clickBlock:(void(^)(NSInteger tag,NSString *msg))clickCallBack;

+(void)showInputView:(NSString*)title
           inputText:(NSString *)inputText
       isPlaceholder:(BOOL)isPlaceHolder
         secureInput:(BOOL)secureInput
               inCtl:(UIViewController*)ctl
               items:(NSArray<NSString*>*)items
          clickBlock:(void(^)(NSInteger tag,NSString *msg))clickCallBack;

+(void)showAlertWithTimer:(NSInteger)sec
                      msg:(NSString*)msg
                    inCtl:(UIViewController*)ctl;

+(void)showAlertWithTimer:(NSString*)title
                      msg:(NSString*)msg
                    inCtl:(UIViewController*)ctl
                    items:(NSArray<NSString*>*)items
               clickBlock:(void(^)(NSInteger))clickCallBack;

+(void)showAlertMutil:(NSString*)title
                  msg:(NSString*)msg
                inCtl:(UIViewController*)ctl
                items:(NSArray<NSString*>*)items
           clickBlock:(void(^)(NSInteger))clickCallBack;

+(void)removeAlertShowerinCtl:(UIViewController*)ctl ;  // 移除弹窗视图

@end

NS_ASSUME_NONNULL_END
