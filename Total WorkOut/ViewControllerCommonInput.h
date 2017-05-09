//
//  ViewControllerCommonInput.h
//  Training Notebook
//
//  Created by 前川 幸広 on 2014/03/21.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//
#import "TrSettings.h"
#import <UIKit/UIKit.h>

@protocol ViewControllerCommonInputDelegate <NSObject>

// デリゲートメソッドを宣言
// （宣言だけしておいて，実装はデリゲート先でしてもらう）
- (void)updateData : (NSString *) retKey : (NSString *) retValue;
@end

@interface ViewControllerCommonInput : UIViewController<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    TrSettings * _trSettings;
    UIPickerView*    oPicker;
    
    NSMutableArray *_picValHH;
    NSMutableArray *_picValMMSS;
    
    int _numberOfComponentsInPicker;
}
// デリゲート先で参照できるようにするためプロパティを定義しておく
@property (nonatomic, assign) id<ViewControllerCommonInputDelegate> delegate;

@property(nonatomic,strong) UITapGestureRecognizer *singleTap;

- (IBAction)btnOk:(id)sender;
- (IBAction)btnCancel:(id)sender;

@property (nonatomic) NSString *selectedKey;

@property (weak, nonatomic) IBOutlet UITextField *txtInputValue;

@property (nonatomic) NSString *inputValue;

@property (nonatomic) NSInteger setUIKeyboardType;
@property (nonatomic) BOOL isPicker;
@property (nonatomic) BOOL isDatePicker;
@property (nonatomic) BOOL isTimeHHMMSSPicker;
@property (nonatomic) NSInteger setUIDatePickerMode;
@property (nonatomic) NSInteger defPickerIndex;
@property (nonatomic) NSArray * arrPickerKey;
@property (nonatomic) NSArray * arrPickerVal;
@end
