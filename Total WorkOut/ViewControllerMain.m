//
//  ViewController.m
//  Total WorkOut
//
//  Created by 前川 幸広 on 2014/03/29.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "ViewControllerMain.h"
#import "TrSettings.h"
#import "TrMaster.h"
#import "ViewControllerExercises.h"
#import "ViewControllerSearch.h"

//test
#import "DBConnector.h"
#import "EntityDTrHd.h"
#import "EntityDTrDt.h"
#import "EntityDTrDtSet.h"

@interface ViewControllerMain ()

@end

@implementation ViewControllerMain

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    self.navigationController.navigationBar.barTintColor =
    [UIColor colorWithRed:0.2 green:0.6 blue:0.8 alpha:1.000];

    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};

    //デリゲート
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    _trSettings = [[TrSettings alloc]init];
    _trMaster = [[TrMaster alloc]init];
    
    //初回のみ初期設定をする
    if(!_trSettings.appVersion){
        //設定初期化
        [_trSettings resetAllData];
        //テーブル初期化
        [_trMaster resetAllData];
    }
    
    //オブジェクト名設定
//    [self setObjectName];
    [self createTableData];
    
}

- (void) createTableData{
    //テーブルセクション
    _tableSection     = [[NSMutableArray alloc] init];
    _tableKey         = [[NSMutableArray alloc] init];
    _tableVal         = [[NSMutableArray alloc] init];
    _tableDataKey     = [[NSMutableArray alloc] init];
    _tableDataVal     = [[NSMutableArray alloc] init];
    _tableSetthingKey = [[NSMutableArray alloc] init];
    _tableSetthingVal = [[NSMutableArray alloc] init];

    
    //セクション名
    NSArray *tableSectionEg = [[NSArray alloc]initWithObjects:@"WORKOUT MENU" ,@"Data" ,@"SETTING MENU" ,nil];
    NSArray *tableSectionJp = [[NSArray alloc]initWithObjects:@"ワークアウト" ,@"データ" ,@"設定",nil];
    
    //データ名(セクション１)
    NSArray *tableKeyEg = [[NSArray alloc]initWithObjects:@"New"  ,@"History" ,@"Search",nil];
    NSArray *tableKeyJp = [[NSArray alloc]initWithObjects:@"新規"  ,@"履歴"    ,@"検索",nil];

    NSArray *tableKeyEg2 = [[NSArray alloc]initWithObjects:@"Exercises" ,nil];
    NSArray *tableKeyJp2 = [[NSArray alloc]initWithObjects:@"エクササイズ" ,nil];
    
    NSArray *tableKeyEg3 = [[NSArray alloc]initWithObjects:@"Routines"  ,@"Exercises" ,@"Setthings",nil];
    NSArray *tableKeyJp3 = [[NSArray alloc]initWithObjects:@"ルーチン"  ,@"エクササイズ"    ,@"設定",nil];
    
    [_trSettings loadLanguage];

    if(_trSettings.defaultLanguage == 0){
        _tableSection = (NSMutableArray *)[NSArray arrayWithArray:tableSectionEg];
        _tableKey = (NSMutableArray *)[NSArray arrayWithArray:tableKeyEg];
        _tableVal = (NSMutableArray *)[NSArray arrayWithArray:tableKeyEg];
        _tableDataKey = (NSMutableArray *)[NSArray arrayWithArray:tableKeyEg2];
        _tableDataVal = (NSMutableArray *)[NSArray arrayWithArray:tableKeyEg2];
        _tableSetthingKey = (NSMutableArray *)[NSArray arrayWithArray:tableKeyEg3];
        _tableSetthingVal = (NSMutableArray *)[NSArray arrayWithArray:tableKeyEg3];
    }else{
        _tableSection = (NSMutableArray *)[NSArray arrayWithArray:tableSectionJp];
        _tableKey = (NSMutableArray *)[NSArray arrayWithArray:tableKeyJp];
        _tableVal = (NSMutableArray *)[NSArray arrayWithArray:tableKeyJp];
        _tableDataKey = (NSMutableArray *)[NSArray arrayWithArray:tableKeyJp2];
        _tableDataVal = (NSMutableArray *)[NSArray arrayWithArray:tableKeyJp2];
        _tableSetthingKey = (NSMutableArray *)[NSArray arrayWithArray:tableKeyJp3];
        _tableSetthingVal = (NSMutableArray *)[NSArray arrayWithArray:tableKeyJp3];
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
    if(section == 0){
        return [_tableKey count];
    }else if(section == 1){
        return [_tableDataKey count];
    }else{
        return [_tableSetthingKey count];
    }
}

/**
 * 指定されたインデックスパスのセルを作成する
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    NSString *dataValue;
    if(indexPath.section == 0){
        dataValue = [_tableVal objectAtIndex:indexPath.row];
    }
    else if(indexPath.section == 1){
        dataValue = [_tableDataVal objectAtIndex:indexPath.row];
    }else{
        dataValue = [_tableSetthingVal objectAtIndex:indexPath.row];
    }
    
    UIFont *uiFont = [UIFont systemFontOfSize:15.0];
    cell.textLabel.font = uiFont;
    cell.textLabel.text = dataValue;
    cell.textLabel.textColor= [UIColor colorWithRed:0.2 green:0.6 blue:0.8 alpha:1.000];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    return cell;
}

/**
 * セルが選択されたとき
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *segueName;
    //ワークアウトメニュー
    if(indexPath.section == 0){
        switch (indexPath.row) {
            case 0:
                segueName = @"trWorkOutSegue";
                break;
            case 1:
                segueName = @"trHistorySegue";
                break;
            case 2:
                segueName = @"trSearchSegue";
                _runModeSearch = 1; //検索
                _navigationBarTitle = @"Search";
                break;
            default:
                break;
        }
    //データメニュ
    }else if(indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
                segueName = @"trSearchSegue";
                _runModeSearch = 2; //グラフ検索
                _navigationBarTitle = @"Data";
                break;
            default:
                break;
        }
        
    //設定メニュー
    }else{
        switch (indexPath.row) {
            case 0:
                segueName = @"trRoutinesSegue";
                break;
            case 1:
                segueName = @"trExerciseSegue";
                break;
            case 2:
                segueName = @"trSettingSegue";
                break;
            default:
                break;
        }
    }
    [self performSegueWithIdentifier:segueName sender:self];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnTest:(id)sender {
    DBConnector *db = [[DBConnector alloc] init];

    int fuka = 120;
    int syumokuSu = 5;
    int setsu = 10;
    int buiId; //1-13
    int syumokuId; //1-3
    int weight;
    int reps;
    
    [db dbOpen];

    
    for (int k = 0; k<fuka; k++){
        NSString *dateStr;
        NSDate *date = [NSDate date];
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        df.dateFormat = @"yyyy/MM/dd";

        [comps setDay:k*-1];
        date = [cal dateByAddingComponents:comps toDate:date options:0];
        dateStr = [df stringFromDate:date];
        
        EntityDTrHd    *TrHd    = [[EntityDTrHd    alloc] init];
        TrHd.pKeyTrId = [TrHd getNextKey:db];
        TrHd.pTrDate = dateStr;
        TrHd.pTrTimeSt = @"12:00";
        [TrHd doInsert:db];
        
        syumokuSu = random() % 8 + 1;
        for (int i = 0; i < syumokuSu ;i++){
            buiId     = random() % 13 + 1;
            syumokuId = random() %  3 + 1;
            EntityDTrDt    *TrDt    = [[EntityDTrDt    alloc] init];
            TrDt.pKeyTrId      = TrHd.pKeyTrId;
            TrDt.pKeyTrId2     = [TrDt getNextKey:db :TrHd.pKeyTrId];
            TrDt.pTrBuiId      = buiId;
            TrDt.pTrSyumokuId  = syumokuId;
            [TrDt doInsert:db];
    
            
            setsu = random() % 15 + 1;
            for (int n=0; n<setsu; n++) {
                weight = random() % 200 + 1;
                reps   = random() % 20  + 1;

                EntityDTrDtSet *TrDtSet = [[EntityDTrDtSet alloc] init];
                TrDtSet.pKeyTrId  = TrHd.pKeyTrId;
                TrDtSet.pKeyTrId2 = TrDt.pKeyTrId2;
                TrDtSet.pWeight   = [NSString stringWithFormat:@"%d",weight];
                TrDtSet.pReps     = [NSString stringWithFormat:@"%d",reps];
                TrDtSet.pKeyTrId3 = [TrDtSet getNextKey:db :TrDt.pKeyTrId :TrDt.pKeyTrId2];
                [TrDtSet doInsert:db];
            }
        }
    }
    [db dbClose];
    
}

//画面遷移時に呼ばれるメソッド
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"trExerciseSegue"]) {
        ViewControllerExercises *nextView = segue.destinationViewController;
        nextView.isEdit = true;
    }
    else if ([segue.identifier isEqualToString:@"trSearchSegue"]) {
        ViewControllerSearch * nextView = segue.destinationViewController;
        nextView.runMode = _runModeSearch;
        nextView.navigationBarTitle = _navigationBarTitle;
    }

}

- (void)viewWillAppear:(BOOL)animated {
    // 必ず親クラスのviewWillAppear:メソッドを呼ぶこと
    [super viewWillAppear:animated];

    [self createTableData];
    [self.tableView reloadData];
    
    // ハイライト解除
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

@end
