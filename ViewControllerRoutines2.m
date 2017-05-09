//
//  ViewControllerRoutines2.m
//  Total WorkOut
//
//  Created by 前川 幸広 on 2014/04/05.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "ViewControllerRoutines2.h"
#import "ViewControllerCommonInput.h"
#import "ViewControllerExercises.h"
#import "EntityMTrRoutineDt.h"

@interface ViewControllerRoutines2 ()

@end

@implementation ViewControllerRoutines2

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

// テーブルデータ作成
- (void) createTableData{
    //テーブルセクション
    _tableSection = [[NSMutableArray alloc]initWithObjects:self.trRoutineName, nil];
    _tableKey = [[NSMutableArray alloc] init];
    _tableVal = [[NSMutableArray alloc] init];
    
    NSString *strAdd;
    
    if(_trSettings.defaultLanguage == 0){
        strAdd = @"Add";
    }else{
        strAdd = @"追加";
    }

    [_db dbOpen];
    
    [_db executeQuery:[self getMTrRoutineDt] ];
    
    while ([_db.results next]) {
        [_tableKey addObject:[NSNumber numberWithInt:[_db.results intForColumn:@"tr_routine_id2"]]];
        [_tableVal addObject:[_db.results stringForColumn:@"tr_syumoku_name"]];
    }
    
    [_tableKey addObject:@"ADD"];
    [_tableVal addObject:strAdd];
    
    [_db dbClose];
}

- (NSString*)getMTrRoutineDt{
    NSString *sql;
    

    sql = [NSString stringWithFormat
           :@"SELECT tr_routine_id2"
           "        ,tr_syumoku_name"
           "  FROM m_tr_routine_dt AS rtd"
           " INNER JOIN m_tr_syumoku AS sym"
           "    ON rtd.tr_bui_id     = sym.tr_bui_id"
           "   AND rtd.tr_syumoku_id = sym.tr_syumoku_id"
           " WHERE    tr_routine_id = %d"
           " ORDER BY tr_routine_id2"
          ,(int)self.keyTrRoutineId
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([_tableKey count] == indexPath.row + 1){
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.textColor     = [UIColor colorWithRed:0.2 green:0.6 blue:0.8 alpha:1.000];;
    }else{
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.textColor     = [UIColor blackColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

/**
 * セルが選択されたとき
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_tableKey count] == indexPath.row + 1){
        [self performSegueWithIdentifier:@"trExerciseSegue" sender:self];
    }
    else{
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_tableKey count] == indexPath.row + 1){
        return;
    }else{
        if (editingStyle == UITableViewCellEditingStyleDelete)
        {   //削除
            NSInteger trRoutineId2 = [NSString stringWithFormat:@"%@"
                                      ,[_tableKey objectAtIndex:indexPath.row]].intValue;
        
            [_db dbOpen];
            EntityMTrRoutineDt *entityMTrRoutineDt = [[EntityMTrRoutineDt alloc]
                                                      initWithSelect:_db :self.keyTrRoutineId :trRoutineId2];
            [entityMTrRoutineDt doDelete:_db];
            [_db dbClose];
        
            // テーブルデータ作成
            [self createTableData];
            [self.tableView reloadData];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"trExerciseSegue"]) {
        ViewControllerExercises * viewEx = [[ViewControllerExercises alloc] init];
        viewEx = segue.destinationViewController;
        viewEx.delegate =(id<ViewControllerExercisesDelegate>)self;
    }
}

- (void)trExerciesesData :(NSInteger)buiId :(NSInteger)syumokuId{
    //
    if (buiId ==0 && syumokuId == 0){return;};
    
    [_db dbOpen];
    EntityMTrRoutineDt * entityMTrRoutineDt = [[EntityMTrRoutineDt alloc]init];
    entityMTrRoutineDt.pKeyTrRoutineId  = self.keyTrRoutineId;
    entityMTrRoutineDt.pKeyTrRoutineId2 = [entityMTrRoutineDt getNextKey:_db :self.keyTrRoutineId];
    entityMTrRoutineDt.pTrBuiId         = buiId;
    entityMTrRoutineDt.pTrSyumokuId     = syumokuId;
    [entityMTrRoutineDt doInsert:_db];
    [_db dbClose];
    
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

@end
