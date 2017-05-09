//
//  ViewControllerRoutines.m
//  Total WorkOut
//
//  Created by 前川 幸広 on 2014/04/05.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "ViewControllerRoutines.h"
#import "ViewControllerRoutines2.h"
#import "ViewControllerCommonInput.h"
#import "EntityMTrRoutineHd.h"

@interface ViewControllerRoutines ()

@end

@implementation ViewControllerRoutines

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

    self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.navigationController.navigationBar.barTintColor =
    [UIColor colorWithRed:0.2 green:0.6 blue:0.8 alpha:1.000];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};

    //デリゲート
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    _trSettings = [[TrSettings alloc]init];
    _db = [[DBConnector alloc]init];

    [self createTableData];
}

// テーブルデータ作成
- (void) createTableData{
    //テーブルセクション
    _tableSection = [[NSMutableArray alloc] init];
    _tableKey     = [[NSMutableArray alloc] init];
    _tableVal     = [[NSMutableArray alloc] init];
    
    //セクション名
    NSArray *tableSectionEg = [[NSArray alloc]initWithObjects:@"Routines" ,nil];
    NSArray *tableSectionJp = [[NSArray alloc]initWithObjects:@"ルーチン"   ,nil];
    NSString *strAdd;
    
    if(_trSettings.defaultLanguage == 0){
        _tableSection = (NSMutableArray *)[NSArray arrayWithArray:tableSectionEg];
        strAdd = @"Add";
    }else{
        _tableSection = (NSMutableArray *)[NSArray arrayWithArray:tableSectionJp];
        strAdd = @"追加";
    }

    [_db dbOpen];
    
    [_db executeQuery:[self getMTrRoutineHd] ];
    
    while ([_db.results next]) {
        [_tableKey addObject:[NSNumber numberWithInt:[_db.results intForColumn:@"tr_routine_id"]]];
        [_tableVal addObject:[_db.results stringForColumn:@"tr_routine_name"]];
    }
    
    [_tableKey addObject:@"ADD"];
    [_tableVal addObject:strAdd];
    
    [_db dbClose];
}

- (NSString*)getMTrRoutineHd{
    NSString *sql;
    
    sql = [NSString stringWithFormat
           :@"SELECT tr_routine_id"
           "      ,tr_routine_name"
           "  FROM m_tr_routine_hd"
           " ORDER BY tr_routine_id"
           ];
    return sql;
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
    return [_tableKey count];
}

/**
 * 指定されたインデックスパスのセルを作成する
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // セルが作成されていないか?
    if (!cell) { // yes
        // セルを作成
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // セルにテキストを設定
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    cell.textLabel.text = [_tableVal objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    if ([_tableKey count] == indexPath.row + 1){
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.textColor     = [UIColor colorWithRed:0.2 green:0.6 blue:0.8 alpha:1.000];
    }else{
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.textColor     = [UIColor blackColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    return cell;
}

/**
 * セルが選択されたとき
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_tableKey count] == indexPath.row + 1){
        _runMode    = 1;
        _inputValue = @"";
        [self performSegueWithIdentifier:@"trCommonSegue" sender:self];
    }
    else{
        _keyTrRoutineId = [NSString stringWithFormat:@"%@"
                           ,[_tableKey objectAtIndex:indexPath.row]].intValue;
        _trRoutineName  = [NSString stringWithFormat:@"%@"
                           ,[_tableVal objectAtIndex:indexPath.row]];
        [self performSegueWithIdentifier:@"trRoutines2Segue" sender:self];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_tableKey count] == indexPath.row + 1){
    }else{
        if (editingStyle == UITableViewCellEditingStyleDelete)
        {   //削除
            NSInteger trRoutineId = [NSString stringWithFormat:@"%@"
                                     ,[_tableKey objectAtIndex:indexPath.row]].intValue;
        
            [_db dbOpen];
            EntityMTrRoutineHd *entityMTrRoutineHd = [[EntityMTrRoutineHd alloc]
                                                      initWithSelect:_db :trRoutineId];
            [entityMTrRoutineHd doDelete:_db];

            [_db dbClose];
        
            // テーブルデータ作成
            [self createTableData];
            [self.tableView reloadData];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"trCommonSegue"]) {
        // タグから値を取得
        ViewControllerCommonInput * viewInput = [[ViewControllerCommonInput alloc]init];
        viewInput = segue.destinationViewController;
        viewInput.inputValue          = _inputValue;
        viewInput.isPicker            = false ;
        viewInput.isDatePicker        = false ;
        viewInput.setUIKeyboardType   = UIKeyboardTypeASCIICapable;
        viewInput.delegate = (id<ViewControllerCommonInputDelegate>)self;
        
    }else if ([segue.identifier isEqualToString:@"trRoutines2Segue"]) {
        ViewControllerRoutines2 * viewNext = [[ViewControllerRoutines2 alloc]init];
        viewNext = segue.destinationViewController;
        viewNext.keyTrRoutineId = _keyTrRoutineId;
        viewNext.trRoutineName  = _trRoutineName;
    }
}

- (void)updateData :(NSString *) dataKey :(NSString *) dataValue{
    // viewからtagを検索して
    //登録
    [_db dbOpen];
    if(_runMode == 1){
        EntityMTrRoutineHd *entityMTrRoutineHd = [[EntityMTrRoutineHd alloc]init];
        
        entityMTrRoutineHd.pKeyTrRoutineId = [entityMTrRoutineHd getNextKey:_db];
        entityMTrRoutineHd.pTrRoutineName  = dataValue;
        [entityMTrRoutineHd doInsert:_db];
    }
    [_db dbClose];
    
    // テーブルデータ作成
    [self createTableData];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    // 必ず親クラスのviewWillAppear:メソッドを呼ぶこと
    [super viewWillAppear:animated];
    // ハイライト解除
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
