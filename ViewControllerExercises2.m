//
//  ViewControllerExercises2.m
//  Total WorkOut
//
//  Created by 前川 幸広 on 2014/03/29.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "ViewControllerExercises2.h"
#import "ViewControllerCommonInput.h"
#import "EntityMTrSyumoku.h"
#import "TrExercisesData.h"

@interface ViewControllerExercises2 ()

@end

@implementation ViewControllerExercises2

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
    _trExercisesData = [TrExercisesData sharedManager];

    // テーブルデータ作成
    [self createTableData];
}

// テーブルデータ作成
- (void) createTableData{
    _db = [[DBConnector alloc]init];
    
    _tableSection = [[NSMutableArray alloc]initWithObjects:self.buiName, nil];
    _tableKey = [[NSMutableArray alloc] init];
    _tableVal = [[NSMutableArray alloc] init];

    NSString *addStr;
    
    if(_trSettings.defaultLanguage == 0){
        addStr = @"Add";
    }else{
        addStr = @"追加";
    }
    
    [_db dbOpen];
    
    [_db executeQuery:[self getMTrSyumoku] ];
    
    while ([_db.results next]) {
        [_tableKey addObject:[NSNumber numberWithInt:[_db.results intForColumn:@"tr_syumoku_id"]]];
        [_tableVal addObject:[_db.results stringForColumn:@"tr_syumoku_name"]];
    }
    if (self.isEdit){
        [_tableKey addObject:@"ADD"];
        [_tableVal addObject:addStr];
    }

    [_db dbClose];
}

- (NSString*)getMTrSyumoku{
    NSString *sql;
    
    sql = [NSString stringWithFormat
           :@"SELECT tr_syumoku_id"
           "        ,tr_syumoku_name"
           "  FROM m_tr_syumoku"
           " WHERE tr_bui_id = %d"
           " ORDER BY tr_bui_id,tr_syumoku_id"
          ,(int)self.buiID
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
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (self.isEdit){
        if ([_tableKey count] == indexPath.row + 1){
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            cell.textLabel.textColor     = [UIColor colorWithRed:0.2 green:0.6 blue:0.8 alpha:1.000];
        }else{
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            cell.textLabel.textColor     = [UIColor blackColor];            
        }
    }else{
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.textColor     = [UIColor blackColor];
    }

    // セルにテキストを設定
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    cell.textLabel.text = [_tableVal objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    return cell;
}

/**
 * セルが選択されたとき
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isEdit){
        if ([_tableKey count] == indexPath.row + 1){
                _runMode    = 1;
                _inputValue = @"";
                [self performSegueWithIdentifier:@"trCommonSegue" sender:self];
        }else{
            _runMode = 2;
            _syumokuID  = [NSString stringWithFormat:@"%@",[_tableKey objectAtIndex:indexPath.row]].intValue;
            _inputValue = [_tableVal objectAtIndex:indexPath.row];
            [self performSegueWithIdentifier:@"trCommonSegue" sender:self];
        }
    }else{
        //選択モード
        /* シングルトンに設定して閉じる viewControllerのdelegateで通知*/
        _trExercisesData.buiId     = self.buiID;
        _trExercisesData.buiName   = self.buiName;
        _trExercisesData.syumokuId = [NSString stringWithFormat:@"%@"
                                      ,[_tableKey objectAtIndex:indexPath.row]].intValue;
        _trExercisesData.syumokuName = [NSString stringWithFormat:@"%@"
                                      ,[_tableVal objectAtIndex:indexPath.row]];
        
        //view閉じる
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {   //削除
        _runMode = 3;

        NSInteger syumokuID = [NSString stringWithFormat:@"%@",[_tableKey objectAtIndex:indexPath.row]].intValue;
        
        [_db dbOpen];
        EntityMTrSyumoku *entityMTrSyumoku = [[EntityMTrSyumoku alloc]
                                              initWithSelect:_db :self.buiID :syumokuID];
        [entityMTrSyumoku doDelete:_db];
        [_db dbClose];
        
        // テーブルデータ作成
        [self createTableData];
        [self.tableView reloadData];
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
    }
}

- (void)updateData :(NSString *) dataKey :(NSString *) dataValue{
    // viewからtagを検索して
    //登録
    [_db dbOpen];
    if(_runMode == 1){
        EntityMTrSyumoku *entityMTrSyumoku = [[EntityMTrSyumoku alloc]init];
        entityMTrSyumoku.pKeyTrBuiId     = self.buiID;
        entityMTrSyumoku.pKeyTrSyumokuId = [entityMTrSyumoku getKeyMTrSyumoku:_db :self.buiID];
        entityMTrSyumoku.pTrSyumokuName  = dataValue;
        [entityMTrSyumoku doInsert:_db];
    }
    //更新時
    else if(_runMode == 2){
        EntityMTrSyumoku *entityMTrSyumoku = [[EntityMTrSyumoku alloc]
                                              initWithSelect:_db :self.buiID :_syumokuID];
        entityMTrSyumoku.pTrSyumokuName = dataValue;
        [entityMTrSyumoku doUpdate:_db];
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

@end
