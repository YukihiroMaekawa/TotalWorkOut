//
//  ViewControllerWorkOut.m
//  Total WorkOut
//
//  Created by 前川 幸広 on 2014/03/30.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "ViewControllerWorkOut.h"
#import "ViewControllerCommonInput.h"
#import "ViewControllerWorkOutMenu.h"
#import "EntityDTrHd.h"
//#import "EntityDWeight.h"
//#import "DBConnector.h"

@interface ViewControllerWorkOut ()

@end

@implementation ViewControllerWorkOut

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
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
/*
    [[self tableView] setBackgroundView:nil];
    [[self tableView] setBackgroundColor:[UIColor whiteColor]];
*/
    _trSettings = [[TrSettings alloc]init];

    //テーブルセクション
    _tableSection    = [[NSMutableArray alloc] init];
    _tableValDate    = [[NSMutableArray alloc] init];
    _tableKeyRoutine = [[NSMutableArray alloc] init];
    _tableValRoutine = [[NSMutableArray alloc] init];
    _tableValBody    = [[NSMutableArray alloc] init];

    _tableValMemo    = [[NSMutableArray alloc] init];
    _tableKeyData    = [[NSMutableArray alloc] init];
    _tableValData    = [[NSMutableArray alloc] init];
    
    //セクション名
    NSArray *tableSectionEg = [[NSArray alloc]initWithObjects:@"Date & Time",@"Weight & Fat" ,@"Memo" ,@"" ,@"" ,nil];
    NSArray *tableSectionJp = [[NSArray alloc]initWithObjects:@"日付と時間"   ,@"体重と体脂肪"   ,@"メモ" ,@"" ,@"" ,nil];

    NSString *tableRoutineName;

    NSArray *tableKeyEg3     = [[NSArray alloc] initWithObjects:@"This workout is deleted" ,nil];
    NSArray *tableKeyJp3     = [[NSArray alloc] initWithObjects:@"このワークアウトを削除"    ,nil];
    
    if(_trSettings.defaultLanguage == 0){
        _tableSection = (NSMutableArray *)[NSArray arrayWithArray:tableSectionEg];
        _tableKeyData = (NSMutableArray *)[NSArray arrayWithArray:tableKeyEg3];
        _tableValData = (NSMutableArray *)[NSArray arrayWithArray:tableKeyEg3];
        tableRoutineName = @"The start of a workout";
    }else{
        _tableSection    = (NSMutableArray *)[NSArray arrayWithArray:tableSectionJp];
        _tableKeyData    = (NSMutableArray *)[NSArray arrayWithArray:tableKeyJp3];
        _tableValData    = (NSMutableArray *)[NSArray arrayWithArray:tableKeyJp3];
        tableRoutineName = @"ワークアウトの開始・編集";
    }

    _db = [[DBConnector alloc]init];
    [_db dbOpen];
    
    _entityDTrHd = [[EntityDTrHd alloc]initWithSelect:_db :self.keyTrHd];
    
    //新規
    NSDate *date;
    NSDateFormatter *df  = [[NSDateFormatter alloc]init];
    [df setLocale:[NSLocale systemLocale]];
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    
    if(self.keyTrHd == 0 ){
        date = [NSDate date];
        //日付
        df.dateFormat = @"yyyy/MM/dd";
        _entityDTrHd.pTrDate   = [df stringFromDate:date];
        
        //時間
        df.dateFormat = @"HH:mm";
        _entityDTrHd.pTrTimeSt = [df stringFromDate:date];
    }
    [_db dbClose];

    _tableValDate = [NSMutableArray arrayWithObjects:_entityDTrHd.pTrDate ,_entityDTrHd.pTrTimeSt ,nil];
    _tableValBody = [NSMutableArray arrayWithObjects:_entityDTrHd.pWeight ,_entityDTrHd.pFat ,nil];
    _tableValMemo = [NSMutableArray arrayWithObjects:_entityDTrHd.pMemo ,nil];

    [_tableKeyRoutine addObject:@"0"];
    [_tableValRoutine addObject:tableRoutineName];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/**
 * テーブル全体のセクションの数を返す
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_tableSection count];
}

/**
 * 指定されたセクションのセクション名を返す
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_tableSection objectAtIndex:section];
}

/**
 * テーブルのセルの数を返す
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return [_tableValDate count];
    }else if(section == 1){
        return [_tableValBody count];
    }else if(section == 2){
        return [_tableValMemo count];
    }else if(section == 3){
        return [_tableValRoutine count];
    }else{
        return [_tableKeyData count];
    }
}

/**
 * 指定されたインデックスパスのセルを作成する
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITextField *textCell1;
    UILabel     *labelCell1;

    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    for (UIView *subview in [cell.contentView subviews]) {
        [subview removeFromSuperview];
    }

    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }
    UIFont *uiFont = [UIFont systemFontOfSize:15.0];
    
    int tag;
    NSString        *textValue;
    NSDate          *date;
    NSDateFormatter *df  = [[NSDateFormatter alloc]init];

    switch (indexPath.section) {
        //日付と時間
        case 0:
            if(indexPath.row == 0){
                df.dateFormat = @"yyyy/MM/dd";
                date = [df dateFromString:[_tableValDate objectAtIndex:indexPath.row]];
                [df setLocale:[NSLocale currentLocale]];
                [df setDateStyle:NSDateFormatterMediumStyle];
                [df setTimeStyle:NSDateFormatterNoStyle];
                textValue = [df stringFromDate:date];
            }else if (indexPath.row == 1){
                df.dateFormat = @"HH:mm";
                date = [df dateFromString:[_tableValDate objectAtIndex:indexPath.row]];
                [df setLocale:[NSLocale currentLocale]];
                [df setDateStyle:NSDateFormatterNoStyle];
                [df setTimeStyle:NSDateFormatterShortStyle];
                textValue = [df stringFromDate:date];
            }
            tag = (int)indexPath.row + 1;
            break;
        // 身体(体重と体脂肪)
        case 1:
            textValue = [_tableValBody objectAtIndex:indexPath.row];
            tag = (int)indexPath.row + 1 + 2;
            break;
        // メモ
        case 2:
            textValue = [_tableValMemo objectAtIndex:indexPath.row];
            tag = (int)indexPath.row + 1 + 4;
            break;
        // ルーチン
        case 3:
            textValue = [_tableValRoutine objectAtIndex:indexPath.row];
            break;
        // Data
        case 4:
            textValue = [_tableKeyData objectAtIndex:indexPath.row];
            break;
        default:
            break;
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    if(indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2){
        textCell1 = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, 300, 45)];
        textCell1.textAlignment = NSTextAlignmentLeft;
        textCell1.backgroundColor = [UIColor clearColor];
        textCell1.textColor = [UIColor blackColor];
        [textCell1 setFont:uiFont];
        textCell1.text = textValue;
        textCell1.tag = tag;
        textCell1.delegate = self;
        [cell.contentView addSubview:textCell1];
        
        //body
        if(indexPath.section == 1){
            //体重と体脂肪のラベル
            if(indexPath.row == 0){
                textValue = [_trSettings getUnitWeightName];
                
            }else{
                textValue = @"%";
            }
            labelCell1 = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, 240, 45)];
            labelCell1.textAlignment = NSTextAlignmentLeft;
            labelCell1.backgroundColor = [UIColor clearColor];
            labelCell1.textColor = [UIColor blackColor];
            [labelCell1 setFont:uiFont];
            labelCell1.text = textValue;
            [cell.contentView addSubview:labelCell1];
        }
    }else{
        labelCell1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 240, 45)];
        labelCell1.textAlignment = NSTextAlignmentLeft;
        labelCell1.backgroundColor = [UIColor clearColor];

        if(indexPath.section == 3){
            labelCell1.textColor = [UIColor colorWithRed:0.2 green:0.6 blue:0.8 alpha:1.000];
        }else{
            labelCell1.textColor = [UIColor redColor];
        }
        [labelCell1 setFont:uiFont];
        labelCell1.text = textValue;
        [cell.contentView addSubview:labelCell1];

        if(indexPath.section == 3){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }else if(indexPath.section == 4){
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
    }

    return cell;
}

/**
 * セルが選択されたとき
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //ルーチン
    if(indexPath.section == 3){
        [self doUpdate];
        [self navigationBarTitleCreate];
        [self performSegueWithIdentifier:@"trWorkOutMenuSegue" sender:self];
    }
    //データ
    else if(indexPath.section == 4) {
        [_db dbOpen];
        EntityDTrHd *entityDTrHd = [[EntityDTrHd alloc]
                                    initWithSelect:_db :self.keyTrHd];
        [entityDTrHd doDelete:_db];
        [_db dbClose];
 
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)navigationBarTitleCreate{
    NSDate *date;
    NSDateFormatter *df = [[NSDateFormatter alloc]init];

    //各国言語にローカライズする
    df.dateFormat = @"yyyy/MM/dd";
    date = [df dateFromString:_entityDTrHd.pTrDate];
    [df setLocale:[NSLocale currentLocale]];
    [df setDateStyle:NSDateFormatterFullStyle];
    [df setTimeStyle:NSDateFormatterNoStyle];
    _navigationBarTitle = [df stringFromDate:date];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    _lastTag           = textField.tag;
    _setUIKeyboardType = UIKeyboardTypeASCIICapable;
    _isPicker          = false;
    _isDatePicker      = false;
    
    switch (_lastTag) {
        case 1:
            _isDatePicker = true;
            _setUIDatePickerMode = UIDatePickerModeDate;
            break;
        case 2:
            _isDatePicker = true;
            _setUIDatePickerMode = UIDatePickerModeTime;
            break;
        case 3:
            _setUIKeyboardType = UIKeyboardTypeDecimalPad;
            break;
        case 4:
            _setUIKeyboardType = UIKeyboardTypeDecimalPad;
            break;
        case 5:
            _setUIKeyboardType = UIKeyboardTypeASCIICapable;
            break;
        default:
            break;
    }
    [self performSegueWithIdentifier:@"trCommonSegue" sender:self];
 
    return NO;
}

//画面遷移時に呼ばれるメソッド
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"trCommonSegue"]) {
        // タグから値を取得
        UILabel* label = (UILabel*) [self.view viewWithTag:_lastTag];
        ViewControllerCommonInput * viewInput = [[ViewControllerCommonInput alloc]init];
        viewInput = segue.destinationViewController;
        viewInput.inputValue          = label.text;
        viewInput.isPicker            = _isPicker;
        viewInput.isDatePicker        = _isDatePicker;
        viewInput.setUIKeyboardType   = _setUIKeyboardType;
        viewInput.setUIDatePickerMode = _setUIDatePickerMode;
        viewInput.arrPickerKey        = _arrPickerKey;
        viewInput.arrPickerVal        = _arrPickerVal;
        viewInput.delegate = (id<ViewControllerCommonInputDelegate>)self;
    }
    else if ([segue.identifier isEqualToString:@"trWorkOutMenuSegue"]) {
        ViewControllerWorkOutMenu * viewNext = [[ViewControllerWorkOutMenu alloc]init];
        viewNext = segue.destinationViewController;
        viewNext.keyTrHd = self.keyTrHd;
        viewNext.navigationBarTitle = _navigationBarTitle;
    }
}

- (void)updateData :(NSString *) dataKey :(NSString *) dataValue{
    // viewからtagを検索して
    UILabel* label = (UILabel*) [self.view viewWithTag:_lastTag];
    label.text = dataValue;

    NSDate *date;
    NSDateFormatter *df  = [[NSDateFormatter alloc]init];
    [df setLocale:[NSLocale currentLocale]];

    if(_lastTag == 1){
        [df setDateStyle:NSDateFormatterMediumStyle];
        [df setTimeStyle:NSDateFormatterNoStyle];
        date = [df dateFromString:dataValue];
        df.dateFormat = @"yyyy/MM/dd";
        dataValue = [df stringFromDate:date];
        [_tableValDate setObject:dataValue atIndexedSubscript:idxDate];
    }else if (_lastTag == 2){
        [df setDateStyle:NSDateFormatterNoStyle];
        [df setTimeStyle:NSDateFormatterShortStyle];
        date = [df dateFromString:dataValue];
        df.dateFormat = @"HH:mm";
        dataValue = [df stringFromDate:date];
        [_tableValDate setObject:dataValue atIndexedSubscript:idxTimeSt];
    }else if (_lastTag == 3){
        [_tableValBody setObject:dataValue atIndexedSubscript:idxWeight];
    }else if (_lastTag == 4){
        [_tableValBody setObject:dataValue atIndexedSubscript:idxFat];
    }else if (_lastTag == 5){
        [_tableValMemo setObject:dataValue atIndexedSubscript:idxMemo];
    }
}

- (void)doUpdate{
    [_db dbOpen];

    //新規
    if(self.keyTrHd == 0){
        _entityDTrHd.pKeyTrId = [_entityDTrHd getNextKey:_db];
    }else{
        _entityDTrHd.pKeyTrId = self.keyTrHd;
    }
    
    _entityDTrHd.pTrDate   = [_tableValDate    objectAtIndex :idxDate];
    _entityDTrHd.pTrTimeSt = [_tableValDate    objectAtIndex :idxTimeSt];
    _entityDTrHd.pWeight   = [_tableValBody objectAtIndex :idxWeight];
    _entityDTrHd.pFat      = [_tableValBody objectAtIndex :idxFat];
    _entityDTrHd.pMemo     = [_tableValMemo    objectAtIndex :idxMemo];
    
    if(self.keyTrHd == 0){
        self.keyTrHd = _entityDTrHd.pKeyTrId;
        [_entityDTrHd doInsert:_db];
    }
    else{
        [_entityDTrHd doUpdate:_db];
    }
    
    [_db dbClose];
}

- (void)viewWillAppear:(BOOL)animated {
    // 必ず親クラスのviewWillAppear:メソッドを呼ぶこと
    [super viewWillAppear:animated];
    // ハイライト解除
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        if(self.keyTrHd > 0){
            [self doUpdate];
        }
    }
    [super viewWillDisappear:animated];
}

- (void) addRoutine{
    [self doUpdate];
    [self performSegueWithIdentifier:@"trWorkOutMenuSegue" sender:self];
}
@end
