//
//  ViewControllerSearch.m
//  Total WorkOut
//
//  Created by 前川 幸広 on 2014/04/07.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "ViewControllerSearch.h"
#import "ViewControllerCommonInput.h"
#import "ViewControllerExercises.h"
#import "ViewControllerExercisesNavi.h"
#import "ViewControllerHistory2.h"
#import "ViewControllerDataGraph.h"

@interface ViewControllerSearch ()

@end

@implementation ViewControllerSearch

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
    
    // デリゲート
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    _trSettings = [[TrSettings alloc]init];
    
    [self createTableData];
    
}

// テーブルデータ作成
- (void) createTableData{
    //テーブルセクション
    _tableSection = [[NSMutableArray alloc] init];
    _tableKey     = [[NSMutableArray alloc] init];
    _tableVal     = [[NSMutableArray alloc] init];
    _tableKey2    = [[NSMutableArray alloc] init];
    _tableVal2    = [[NSMutableArray alloc] init];
    _tableKey3    = [[NSMutableArray alloc] init];
    _tableVal3    = [[NSMutableArray alloc] init];
    
    //セクション名
    NSArray *tableSectionEg = [[NSArray alloc]initWithObjects:@"Start Date & End Date" ,@"Body Regions",@"Exercises"  ,@"" ,nil];
    NSArray *tableSectionJp = [[NSArray alloc]initWithObjects:@"開始日と終了日"  ,@"身体部位"     ,@"エクササイズ" ,@"",nil];
    
    NSArray *tableKeyEg     = [[NSArray alloc] initWithObjects:@"Start Date"  ,@"End Date" ,nil];
    NSArray *tableKeyJp     = [[NSArray alloc] initWithObjects:@"開始日" ,@"終了日",nil];
    NSArray *tableKeyEg2    = [[NSArray alloc] initWithObjects:@"Body Regions" ,nil];
    NSArray *tableKeyJp2    = [[NSArray alloc] initWithObjects:@"身体部位"      ,nil];
    NSArray *tableKeyEg3    = [[NSArray alloc] initWithObjects:@"Exercieses" ,nil];
    NSArray *tableKeyJp3    = [[NSArray alloc] initWithObjects:@"エクササイズ",nil];
    NSArray *tableKeyEg4    = [[NSArray alloc] initWithObjects:@"Search" ,@"Clear" ,nil];
    NSArray *tableKeyJp4    = [[NSArray alloc] initWithObjects:@"検索"    ,@"クリア",nil];
    
    NSDate *dateSt = [NSDate date];
    NSDate *dateEd = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    NSDate *today = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    if(self.runMode == 1){
        [comps setMonth:-3];
    }else{
        [comps setYear:-3];
    }
    dateSt = [cal dateByAddingComponents:comps toDate:today options:0];

    df.dateFormat = @"yyyy/MM/dd";
    _keyDateSt = [df stringFromDate:dateSt];
    _keyDateEd = [df stringFromDate:dateEd];
    
    [df setLocale:[NSLocale currentLocale]];
    [df setDateStyle:NSDateFormatterMediumStyle];
    [df setTimeStyle:NSDateFormatterNoStyle];
    _dateSt = [df stringFromDate:dateSt];
    _dateEd = [df stringFromDate:dateEd];

    if(_trSettings.defaultLanguage == 0){
        _tableSection = (NSMutableArray *)[NSArray arrayWithArray:tableSectionEg];
        _tableKey     = (NSMutableArray *)[NSArray arrayWithArray:tableKeyEg];
        _tableVal     = (NSMutableArray *)[NSArray arrayWithArray:tableKeyEg];
        _tableKey2    = (NSMutableArray *)[NSArray arrayWithArray:tableKeyEg2];
        [_tableVal2 addObject:@""];
        _tableKey3    = (NSMutableArray *)[NSArray arrayWithArray:tableKeyEg3];
        [_tableVal3 addObject:@""];
        _tableKey4    = (NSMutableArray *)[NSArray arrayWithArray:tableKeyEg4];
        _tableVal4    = (NSMutableArray *)[NSArray arrayWithArray:tableKeyEg4];
    }else{
        _tableSection = (NSMutableArray *)[NSArray arrayWithArray:tableSectionJp];
        _tableKey     = (NSMutableArray *)[NSArray arrayWithArray:tableKeyJp];
        _tableVal     = (NSMutableArray *)[NSArray arrayWithArray:tableKeyJp];
        _tableKey2    = (NSMutableArray *)[NSArray arrayWithArray:tableKeyJp2];
        [_tableVal2 addObject:@""];
        _tableKey3    = (NSMutableArray *)[NSArray arrayWithArray:tableKeyJp3];
        [_tableVal3 addObject:@""];
        _tableKey4    = (NSMutableArray *)[NSArray arrayWithArray:tableKeyJp4];
        _tableVal4    = (NSMutableArray *)[NSArray arrayWithArray:tableKeyJp4];
        
    }
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
    int retValue = 0;
    
    switch (section) {
        case 0:
            retValue = (int)[_tableKey count];
            break;
        case 1:
            retValue = (int)[_tableKey2 count];
            break;
        case 2:
            retValue = (int)[_tableKey3 count];
            break;
        case 3:
            retValue = (int)[_tableKey4 count];
            break;
    }
    return retValue;
}

/**
 * 指定されたインデックスパスのセルを作成する
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITextField *textCell1;
    UILabel     *labelCell1;

    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    for (UIView *subview in [cell.contentView subviews]) {
        [subview removeFromSuperview];
    }

    // セルが作成されていないか?
    if (!cell) { // yes
        // セルを作成
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    UIFont *uiFont = [UIFont systemFontOfSize:15.0];

    NSString *valueData;
    int tag;
    
    // セルにテキストを設定
    switch (indexPath.section) {
        case 0:
            valueData = [_tableVal objectAtIndex:indexPath.row];
            if(indexPath.row == 0){
                valueData = _dateSt;
            }else{
                valueData = _dateEd;
            }
            tag = (int)indexPath.row + 1;
            break;
        case 1:
            tag = (int)indexPath.row + 1 + 2;

            valueData = [_tableVal2 objectAtIndex:indexPath.row];
            break;
        case 2:
            tag = (int)indexPath.row + 1 + 3;
            valueData = [_tableVal3 objectAtIndex:indexPath.row];
            break;
        case 3:
            valueData = [_tableVal4 objectAtIndex:indexPath.row];
            break;
        default:
            break;
    }

    if(indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2){
        textCell1 = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, 300, 45)];
        textCell1.textAlignment = NSTextAlignmentLeft;
        textCell1.backgroundColor = [UIColor clearColor];
        textCell1.textColor = [UIColor blackColor];
        [textCell1 setFont:uiFont];
        textCell1.text = valueData;
        textCell1.tag = tag;
        textCell1.delegate = self;
        [cell.contentView addSubview:textCell1];
    }else{
        labelCell1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 300, 45)];
        labelCell1.textAlignment = NSTextAlignmentLeft;
        labelCell1.backgroundColor = [UIColor clearColor];
        labelCell1.textColor = [UIColor colorWithRed:0.2 green:0.6 blue:0.8 alpha:1.000];
        [labelCell1 setFont:uiFont];
        labelCell1.text = valueData;
        [cell.contentView addSubview:labelCell1];
    }

    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;

    if(indexPath.section == 1 || indexPath.section == 2){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }

    return cell;
}

/**
 * セルが選択されたとき
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            //1から
            _lastTag = indexPath.row + 1;
            break;
        case 1:
            //3から
            _lastTag = indexPath.row + 3;
            _runModeEx = 1; //部位のみ
            break;
        case 2:
            //4から
            _lastTag = indexPath.row + 4;
            _runModeEx = 2; //部位 + 種目
            break;
        case 3:
            //5から
            _lastTag = indexPath.row + 5;
            break;
    }

    if(indexPath.section == 0){
        [self performSegueWithIdentifier:@"trCommonSegue" sender:self];
    }else if(indexPath.section == 3){
        if(indexPath.row == 0){
            //検索
            if(self.runMode == 1){
                [self performSegueWithIdentifier:@"trHistory2Segue" sender:self];
            //グラフ検索
            }else{
                [self performSegueWithIdentifier:@"trDataGraphSegue" sender:self];
            }
        }else{
            [self resetCondition];
        }
    }
    else{
        [self performSegueWithIdentifier:@"trExerciseSegue" sender:self];
    }
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
            _setUIDatePickerMode = UIDatePickerModeDate;
            break;
        case 3:
            _runModeEx = 1; //部位のみ
            [self performSegueWithIdentifier:@"trExerciseSegue" sender:self];
            break;
        case 4:
            _runModeEx = 2; //部位 + 種目
            [self performSegueWithIdentifier:@"trExerciseSegue" sender:self];
            break;
        default:
            break;
    }
    
    [self performSegueWithIdentifier:@"trCommonSegue" sender:self];
    
    return NO;
}

- (void)trExerciesesData2 :(NSInteger)buiId :(NSString *)buiName
                          :(NSInteger)syumokuId :(NSString *)syumokuName2{
    if (buiId ==0 && syumokuId == 0){return;};
    
    UILabel* label = (UILabel*) [self.view viewWithTag:_lastTag];
    
    if(_lastTag == 3){
        _buiId     = buiId;
        _syumokuId = syumokuId;
        label.text = buiName;
    }else{
        _buiId     = buiId;
        _syumokuId = syumokuId;
        label.text = syumokuName2;
    }
}

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
        viewInput.delegate = (id<ViewControllerCommonInputDelegate>)self;
    }else if ([segue.identifier isEqualToString:@"trExerciseSegue"]) {
        ViewControllerExercises * viewEx = [[ViewControllerExercises alloc] init];
        viewEx = segue.destinationViewController;
        viewEx.delegate =(id<ViewControllerExercisesDelegate>)self;
        
        ViewControllerExercisesNavi * viewEx2 = [[ViewControllerExercisesNavi alloc] init];
        viewEx2 = segue.destinationViewController;
        viewEx2.runMode = _runModeEx;
    }else if ([segue.identifier isEqualToString:@"trHistory2Segue"]) {
        ViewControllerHistory2 * viewNext = [[ViewControllerHistory2 alloc] init];
        viewNext = segue.destinationViewController;
        viewNext.isEdit       = true;
        viewNext.serchMode    = 3; // 日付検索指定
        viewNext.keyDateSt    = _keyDateSt;
        viewNext.keyDateEd    = _keyDateEd;
        viewNext.keyBuiId     = _buiId;
        viewNext.keySyumokuId = _syumokuId;
    }else if ([segue.identifier isEqualToString:@"trDataGraphSegue"]) {
        ViewControllerDataGraph * viewNext = [[ViewControllerDataGraph alloc] init];
        viewNext = segue.destinationViewController;
        viewNext.keyDateSt    = _keyDateSt;
        viewNext.keyDateEd    = _keyDateEd;        
        viewNext.keyBuiId     = _buiId;
        viewNext.keySyumokuId = _syumokuId;
    }
}

- (void)updateData :(NSString *) dataKey :(NSString *) dataValue{
    // viewからtagを検索して
    UILabel* label = (UILabel*) [self.view viewWithTag:_lastTag];
    label.text = dataValue;
    
    NSDate *date;
    NSDateFormatter *df  = [[NSDateFormatter alloc]init];
    [df setLocale:[NSLocale currentLocale]];
    [df setDateStyle:NSDateFormatterMediumStyle];
    [df setTimeStyle:NSDateFormatterNoStyle];
    date = [df dateFromString:dataValue];
    df.dateFormat = @"yyyy/MM/dd";
    
    switch (_lastTag) {
        case 1:
            _dateSt    = dataValue;
            _keyDateSt = [df stringFromDate:date];
            break;
        case 2:
            _dateEd    = dataValue;
            _keyDateEd = [df stringFromDate:date];
        case 3:
            break;
        case 4:
            break;
        default:
            break;
    }
}

- (void) resetCondition{
    for (int i = 1; i<=4; i++) {
        UILabel* label = (UILabel*) [self.view viewWithTag:i];
        label.text = @"";
    }
    _buiId     = 0;
    _syumokuId = 0;
    [self createTableData];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    // 必ず親クラスのviewWillAppear:メソッドを呼ぶこと
    [super viewWillAppear:animated];
    // ハイライト解除
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
    self.navigationItem.title = self.navigationBarTitle;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
