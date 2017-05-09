//
//  ViewControllerCommonInput.m
//  Training Notebook
//
//  Created by 前川 幸広 on 2014/03/21.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "ViewControllerCommonInput.h"

@interface ViewControllerCommonInput ()

@end

@implementation ViewControllerCommonInput

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //デリゲート
    self.txtInputValue.delegate = self;
    
    _trSettings = [[TrSettings alloc]init];
    
    //値取得
    self.txtInputValue.text = self.inputValue;
    self.txtInputValue.keyboardType = self.setUIKeyboardType;
    [self.txtInputValue becomeFirstResponder];

    // Do any additional setup after loading the view.
    UIColor *color = [UIColor darkGrayColor];
    UIColor *alphaColor = [color colorWithAlphaComponent:0.75]; //透過率
    self.view.backgroundColor = alphaColor;
    
    // 背景をキリックしたら、キーボードを隠す
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
 
    _picValHH = [[NSMutableArray alloc] initWithObjects:
                 @"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10"
                 ,@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20"
                 ,@"21",@"22",@"23"
                     , nil];
    _picValMMSS = [[NSMutableArray alloc] initWithObjects:
                 @"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10"
                 ,@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20"
                 ,@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30"
                 ,@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40"
                 ,@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50"
                 ,@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59"
                 , nil];
}

- (void)showPicker {
    // ピッカーの生成
    oPicker = [[UIPickerView alloc] init];
    CGSize offSize = [UIScreen mainScreen].bounds.size;
    CGPoint offScreenCenter = CGPointMake(offSize.width / 2.0,offSize.height - oPicker.frame.size.height/2);
    oPicker.center = offScreenCenter;//self.view.center;
    oPicker.showsSelectionIndicator = YES;
    oPicker.delegate = self;
    oPicker.dataSource = self;
    
    //初期選択と初期選択データを戻り値設定
    if(self.isTimeHHMMSSPicker){
        [oPicker selectRow:self.defPickerIndex inComponent:0 animated:NO];
        [oPicker selectRow:self.defPickerIndex inComponent:1 animated:NO];
        [oPicker selectRow:self.defPickerIndex inComponent:2 animated:NO];
        
        [self setData2:0 :0 :0];
        
    }else{
        [oPicker selectRow:self.defPickerIndex inComponent:0 animated:NO];
        [self setData:self.defPickerIndex];
    }
    
    //画面に追加
    [self.view addSubview:oPicker];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return _numberOfComponentsInPicker;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(self.isTimeHHMMSSPicker){
        switch (component) {
            case 0:
                return [_picValHH count];
                break;
            case 1:
                return [_picValMMSS count];
                break;
            case 2:
                return [_picValMMSS count];
                break;
            default:
                return 0;
                break;
        }
    }else{
        return [self.arrPickerVal count];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(self.isTimeHHMMSSPicker){
        switch (component) {
            case 0:
                return [_picValHH objectAtIndex:row];
                break;
            case 1:
                return [_picValMMSS objectAtIndex:row];
                break;
            case 2:
                return [_picValMMSS objectAtIndex:row];
                break;
            default:
                return 0;
                break;
        }
    }else{
        return [self.arrPickerVal objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSInteger id  = [pickerView selectedRowInComponent:0];
    NSInteger id2 = [pickerView selectedRowInComponent:1];
    NSInteger id3 = [pickerView selectedRowInComponent:2];
    
    if(self.isTimeHHMMSSPicker){
        [self setData2:id : id2 :id3];
    }else{
        [self setData:id];
    }
    //[oPicker removeFromSuperview];
}

- (void)setData:(NSInteger) idx{
    self.selectedKey        = self.arrPickerKey[idx];
    self.txtInputValue.text = [NSString stringWithFormat:@"%@",self.arrPickerVal[idx]];
}

- (void)setData2:(NSInteger) idx :(NSInteger) idx2 :(NSInteger) idx3{
    NSString *strData;
    strData = [NSString stringWithFormat:@"%@:%@:%@"
               ,[_picValHH   objectAtIndex:idx]
               ,[_picValMMSS objectAtIndex:idx2]
               ,[_picValMMSS objectAtIndex:idx3]
               ];
    self.selectedKey        = strData;
    self.txtInputValue.text = strData;
}

- (void)showDatePicker{
    // イニシャライザ
    UIDatePicker *datePicker= [[UIDatePicker alloc]init];

    CGSize offSize = [UIScreen mainScreen].bounds.size;
    CGPoint offScreenCenter = CGPointMake(offSize.width / 2.0,offSize.height - datePicker.frame.size.height/2);
    datePicker.center = offScreenCenter;//self.view.center;
    
    // 日付の表示モードを変更
    datePicker.datePickerMode = self.setUIDatePickerMode;

    // 分の刻み
    datePicker.minuteInterval = 1;

    // 日付ピッカーの値が変更されたときに呼ばれるメソッドを設定
    [datePicker addTarget:self
                   action:@selector(datePicker_ValueChanged:)
         forControlEvents:UIControlEventValueChanged];

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setLocale:[NSLocale currentLocale]];
    NSDate *date;
    if (self.setUIDatePickerMode == UIDatePickerModeDate){
        date = [NSDate date];
        datePicker.maximumDate = [NSDate date];
        [df setDateStyle:NSDateFormatterMediumStyle];
        [df setTimeStyle:NSDateFormatterNoStyle];
        date = [df dateFromString:self.inputValue];
        [datePicker setDate:date];
    }else{
        [df setDateStyle:NSDateFormatterNoStyle];
        [df setTimeStyle:NSDateFormatterShortStyle];
        date = [df dateFromString:self.inputValue];
        [datePicker setDate:date];
    }
    // UIDatePickerのインスタンスをビューに追加
    [self.view addSubview:datePicker];
}

/**
 * 日付ピッカーの値が変更されたとき
 */
- (void)datePicker_ValueChanged:(id)sender
{
    // 日付の表示形式を設定
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setLocale:[NSLocale currentLocale]];

    if (self.setUIDatePickerMode == UIDatePickerModeDate){
        [df setDateStyle:NSDateFormatterMediumStyle];
        [df setTimeStyle:NSDateFormatterNoStyle];
    }else{
        [df setDateStyle:NSDateFormatterNoStyle];
        [df setTimeStyle:NSDateFormatterShortStyle];
    }

    UIDatePicker *datePicker = sender;
    self.txtInputValue.text = [df stringFromDate:datePicker.date];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (self.isPicker){
        _numberOfComponentsInPicker = 1;
        [self showPicker];
        return NO;
    }else if (self.isDatePicker){
        _numberOfComponentsInPicker = 1;
        [self showDatePicker];
        return NO;
    }else if (self.isTimeHHMMSSPicker){
        _numberOfComponentsInPicker = 3;
        [self showPicker];
        return NO;
    }else{
        return YES;
    }
}

// ピッカーを隠す処理
- (void)closePicker{
    [oPicker removeFromSuperview];
}

// キーボードを隠す処理
- (void)closeKeyboard {
    [self.view endEditing: YES];
}

- (IBAction)btnOk:(id)sender {
    [self closePicker];
    self.inputValue = self.txtInputValue.text;
    [self doInput];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnCancel:(id)sender {
    [self closePicker];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doInput
{
    if ([self.delegate respondsToSelector:@selector(updateData::)]) {
        [self.delegate updateData : self.selectedKey
                                  : self.txtInputValue.text];
    }
}
@end
