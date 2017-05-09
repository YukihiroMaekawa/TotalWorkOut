//
//  ViewControllerWorkOutMenu.m
//  Total WorkOut
//
//  Created by 前川 幸広 on 2014/03/30.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "ViewControllerWorkOutMenu.h"
#import "ViewControllerExercises.h"
#import "EntityDTrDt.h"
#import "ViewControllerWorkOutSet.h"
#import "ViewControllerHistory2.h"
@interface ViewControllerWorkOutMenu ()

@end

@implementation ViewControllerWorkOutMenu

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
    
    _trSettings = [[TrSettings alloc]init];
    
    _db = [[DBConnector alloc]init];
    
    [self createTableData];

}

- (void) createRoutine{
    [_db dbOpen];
    
    [_db executeQuery:[self getMTrRoutineDt] ];
    
    NSMutableArray *arrBuiId     = [[NSMutableArray alloc]init];
    NSMutableArray *arrSyumokuId = [[NSMutableArray alloc]init];
    
    while ([_db.results next]) {
        [arrBuiId     addObject:[NSNumber numberWithInt:[_db.results intForColumn:@"tr_bui_id"]]];
        [arrSyumokuId addObject:[NSNumber numberWithInt:[_db.results intForColumn:@"tr_syumoku_id"]]];
    }
    [_db dbClose];
    
    [_db dbOpen];
    int i;
    for (i=0; i < [arrBuiId count];i++) {
        [self insTrDt:[[arrBuiId     objectAtIndex:i] intValue]
                     :[[arrSyumokuId objectAtIndex:i] intValue]
         ];
    }
    
    [_db dbClose];
}

- (NSString*)getMTrRoutineDt{
    NSString *sql;
    
    sql = [NSString stringWithFormat
           :@"SELECT tr_routine_id2"
           "        ,tr_bui_id"
           "        ,tr_syumoku_id"
           "  FROM m_tr_routine_dt AS rtd"
           " WHERE    tr_routine_id = %d"
           " ORDER BY tr_routine_id2"
           ,(int)_keyTrRoutineId
           ];
    return sql;
}

// テーブルデータ作成
- (void) createTableData{
    //テーブルセクション
    _tableSection   = [[NSMutableArray alloc] init];
    _tableKey       = [[NSMutableArray alloc] init];
    _tableVal       = [[NSMutableArray alloc] init];
    _tableVal2      = [[NSMutableArray alloc] init];
    _tableRoutineKey = [[NSMutableArray alloc] init];
    _tableRoutineVal = [[NSMutableArray alloc] init];
    _tableResultKey = [[NSMutableArray alloc] init];
    _tableResultVal = [[NSMutableArray alloc] init];
    _tableBackKey = [[NSMutableArray alloc] init];
    _tableBackVal = [[NSMutableArray alloc] init];
    
    //セクション名
    NSArray *tableSectionEg = [[NSArray alloc]initWithObjects:@"Exercises",@"It chooses from a routine and adds" ,@" " ,@"" ,nil];
    NSArray *tableSectionJp = [[NSArray alloc]initWithObjects:@"エクササイズ",@"ルーチンから選択して追加",@" " ,@"",nil];
    NSString *tableStr;
    NSString *tableResultStr;
    NSString *tableBackStr;
    
    if(_trSettings.defaultLanguage == 0){
        _tableSection = (NSMutableArray *)[NSArray arrayWithArray:tableSectionEg];
        tableStr       = @"The addition of exercise";
        tableResultStr = @"The result of exercise";
        tableBackStr   = @"The end of a workout";
    }else{
        _tableSection = (NSMutableArray *)[NSArray arrayWithArray:tableSectionJp];
        tableStr       = @"エクササイズの追加";
        tableResultStr = @"エクササイズの結果";
        tableBackStr   = @"ワークアウトの終了";
    }
    
    [_db dbOpen];
    
    [_db executeQuery:[self getDTrDt] ];
    
    NSString *addStr;
    
    while ([_db.results next]) {
        [_tableKey addObject:[NSNumber numberWithInt:[_db.results intForColumn:@"tr_id2"]]];
        [_tableVal addObject:[_db.results stringForColumn:@"tr_syumoku_name"]];

        addStr = [NSString stringWithFormat:@"%@   %d Set"
                  ,[_db.results stringForColumn:@"tr_syumoku_name"]
                  ,[_db.results intForColumn:@"set_total"]
                  ];
        [_tableVal2 addObject:addStr];
    }
    [_tableKey addObject:@"ADD"];
    [_tableVal addObject:tableStr];
    [_tableVal2 addObject:tableStr];
    [_db dbClose];
    
    //ルーチン
    [_db dbOpen];
    [_db executeQuery:[self getMTrRoutineHd] ];
    
    while ([_db.results next]) {
        [_tableRoutineKey addObject:[NSNumber numberWithInt:[_db.results intForColumn:@"tr_routine_id"]]];
        [_tableRoutineVal addObject:[_db.results stringForColumn:@"tr_routine_name"]];
    }
    [_db dbClose];
    
    //結果確認
    [_tableResultKey addObject:@"RESULT"];
    [_tableResultVal addObject:tableResultStr];
    
    //ボタン類
    [_tableBackKey addObject:@"BACK"];
    [_tableBackVal addObject:tableBackStr];
}

- (NSString*)getDTrDt{
    NSString *sql;
    
    sql = [NSString stringWithFormat
           :@"SELECT tdt.tr_id2"
           "        ,tdt.set_total"
           "        ,tsm.tr_bui_id"
           "        ,tsm.tr_syumoku_name"
           "    FROM d_tr_dt AS tdt"
           " INNER JOIN m_tr_syumoku AS tsm"
           "      ON tdt.tr_bui_id     = tsm.tr_bui_id"
           "     AND tdt.tr_syumoku_id = tsm.tr_syumoku_id"
           "   WHERE tdt.tr_id = %d"
           " ORDER BY tdt.tr_id"
           "         ,tdt.tr_id2"
           ,(int)self.keyTrHd
           ];
    return sql;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    }else if (section == 1){
        return [_tableRoutineKey count];
    }else if (section ==2){
        return [_tableResultKey count];
    }else{
        return [_tableBackKey count];
    }
}

// セルの高さを返す. セルが生成される前に実行されるので独自に計算する必要がある
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
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
    
    
    
    if(indexPath.section == 0){
        // セルにテキストを設定
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.textLabel.text = [_tableVal2 objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;

        if ([_tableKey count] == indexPath.row + 1){
            cell.textLabel.textColor = [UIColor colorWithRed:0.2 green:0.6 blue:0.8 alpha:1.000];
        }else{
            cell.textLabel.textColor = [UIColor blackColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }else if(indexPath.section == 1){
        // セルにテキストを設定
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.textLabel.textColor = [UIColor colorWithRed:0.2 green:0.6 blue:0.8 alpha:1.000];
        cell.textLabel.text = [_tableRoutineVal objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }else if(indexPath.section == 2){
        // セルにテキストを設定
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.textLabel.textColor = [UIColor colorWithRed:0.2 green:0.6 blue:0.8 alpha:1.000];
        cell.textLabel.text = [_tableResultVal objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }else{
        // セルにテキストを設定
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.textLabel.textColor = [UIColor colorWithRed:0.2 green:0.6 blue:0.8 alpha:1.000];
        cell.textLabel.text = [_tableBackVal objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    return cell;
}

/**
 * セルが選択されたとき
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        if ([_tableKey count] == indexPath.row + 1){
            [self addNew];
        }else{
            _keyTrDt  = [NSString stringWithFormat:@"%@",[_tableKey     objectAtIndex:indexPath.row]].intValue;
            _syumokuName = [_tableVal objectAtIndex:indexPath.row];
            [self performSegueWithIdentifier:@"trExerciseSetSegue" sender:self];
        }
    }else if(indexPath.section == 1){
        //ルーチン追加
        _keyTrRoutineId = [NSString stringWithFormat:@"%@"
                           ,[_tableRoutineKey objectAtIndex:indexPath.row]].intValue;
        [self createRoutine];
        [self createTableData];
        [self.tableView reloadData];
    }else if(indexPath.section == 2){
        [self performSegueWithIdentifier:@"trHistory2Segue" sender:self];
    }else{
        // 一番初めのViewへ戻る
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {   //削除
        NSInteger trId2 = [NSString stringWithFormat:@"%@",[_tableKey objectAtIndex:indexPath.row]].intValue;
        
        [_db dbOpen];
        EntityDTrDt * entityDTrDt = [[EntityDTrDt alloc]initWithSelect:_db :self.keyTrHd :trId2];
        [entityDTrDt doDelete:_db];
        [_db dbClose];
        
        // テーブルデータ作成
        [self createTableData];
        [self.tableView reloadData];
    }
}

- (void)trExerciesesData :(NSInteger)buiId :(NSInteger)syumokuId{
    //
    if (buiId ==0 && syumokuId == 0){return;};

    [_db dbOpen];
    [self insTrDt:buiId :syumokuId];
    [_db dbClose];

    [self createTableData];
    [self.tableView reloadData];
}

- (void)insTrDt:(NSInteger)buiId :(NSInteger)syumokuId{
    EntityDTrDt * entityDTrDt = [[EntityDTrDt alloc]init];
    entityDTrDt.pKeyTrId     = self.keyTrHd;
    entityDTrDt.pKeyTrId2    = [entityDTrDt getNextKey:_db:self.keyTrHd];
    entityDTrDt.pTrBuiId     = buiId;
    entityDTrDt.pTrSyumokuId = syumokuId;
    [entityDTrDt doInsert:_db];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"trExerciseSegue"]) {
        ViewControllerExercises * viewEx = [[ViewControllerExercises alloc] init];
        viewEx = segue.destinationViewController;
        viewEx.delegate =(id<ViewControllerExercisesDelegate>)self;
    }else if ([segue.identifier isEqualToString:@"trExerciseSetSegue"]) {
        ViewControllerWorkOutSet * viewEx = [[ViewControllerWorkOutSet alloc] init];
        viewEx = segue.destinationViewController;
        viewEx.keyTrHd            = self.keyTrHd;
        viewEx.keyTrHd2           = _keyTrDt;
        viewEx.syumokuName        = _syumokuName;
        viewEx.navigationBarTitle = self.navigationBarTitle;
    }else if ([segue.identifier isEqualToString:@"trHistory2Segue"]) {
        ViewControllerHistory2 * viewEx = [[ViewControllerHistory2 alloc] init];
        viewEx = segue.destinationViewController;
        viewEx.isEdit    = false;
        viewEx.serchMode = 2; // TrHd指定検索
        viewEx.keyTrHd     = self.keyTrHd;
        viewEx.titleString = @"";
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = self.navigationBarTitle;
    
    // 必ず親クラスのviewWillAppear:メソッドを呼ぶこと
    [super viewWillAppear:animated];
    // ハイライト解除
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];

    [self createTableData];
    [self.tableView reloadData];
}

- (void) addNew{
    _runMode = 1;
    [self performSegueWithIdentifier:@"trExerciseSegue" sender:self];
}

-(BOOL)textViewShouldBeginEditing:(UITextView*)textView{
    return NO;
}

@end
