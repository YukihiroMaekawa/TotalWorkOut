//
//  ViewControllerWorkOutSet.m
//  Total WorkOut
//
//  Created by 前川 幸広 on 2014/04/01.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//
#import "Utility.h"
#import "ViewControllerWorkOutSet.h"
#import "EntityDTrHd.h"
#import "EntityDTrDt.h"
#import "EntityDTrDtSet.h"
#import "EntityMTrBui.h"
#import "ViewControllerCommonInput.h"
#import "ViewControllerHistory2.h"

@interface ViewControllerWorkOutSet ()

@end

@implementation ViewControllerWorkOutSet

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
    
    [_db dbOpen];
    EntityDTrDt *entityDTrDt = [[EntityDTrDt alloc] initWithSelect
                                :_db :self.keyTrHd :self.keyTrHd2];
    _keyBuiId     = entityDTrDt.pTrBuiId;
    _keySyumokuID = entityDTrDt.pTrSyumokuId;
    
    EntityDTrHd *entityDTrHd = [[EntityDTrHd alloc] initWithSelect
                                :_db :self.keyTrHd];
    _trDate = entityDTrHd.pTrDate;
    
    
    EntityMTrBui *entityMTrBui = [[EntityMTrBui alloc] initWithSelect:_db :_keyBuiId];
    [entityMTrBui doSelect:_db];
    _trKb = entityMTrBui.pTrKb;
    
    [_db dbClose];

    //前回のトレーニング情報を取得
    NSArray * arrZenkaiTrDtKey = [Utility getZenkaiTrDtKey :self.keyTrHd :self.keyTrHd2];
    _keyTrHdZen  = [[arrZenkaiTrDtKey objectAtIndex:0] integerValue];
    _keyTrHd2Zen = [[arrZenkaiTrDtKey objectAtIndex:1] integerValue];

    [self createTableData];
}

// キーボードを隠す処理
- (void)closeKeyboard {
    [self.view endEditing: YES];
}

// テーブルデータ作成
- (void) createTableData{
    _tableSection  = [[NSMutableArray alloc] init];
    _tableKey      = [[NSMutableArray alloc] init];
    _tableVal      = [[NSMutableArray alloc] init];
    _tableVal2     = [[NSMutableArray alloc] init];
    _tableVal3     = [[NSMutableArray alloc] init];
    _tableSetDataVal = [[NSMutableArray alloc] init];
    _tablePrevKey  = [[NSMutableArray alloc] init];
    _tablePrevVal  = [[NSMutableArray alloc] init];
    _tableBackKey = [[NSMutableArray alloc] init];
    _tableBackVal = [[NSMutableArray alloc] init];

    NSString *tableHeader;
    NSString *syumokuName;
    NSString *strSetName;
    NSString *tableStr;

    [_db dbOpen];
    [_db executeQuery:[self getDTrDt] ];
    
    tableStr = @"";
    syumokuName = self.syumokuName;
    while ([_db.results next]) {
        [_tableKey  addObject:[NSNumber numberWithInt:[_db.results intForColumn:@"tr_id3"]]];
        [_tableVal  addObject:[_db.results stringForColumn:@"weight"]];
        [_tableVal2 addObject:[_db.results stringForColumn:@"reps"]];
        [_tableVal3 addObject:[_db.results stringForColumn:@"memo"]];
        
        //1RM
        NSString * rmData;
        rmData = [NSString stringWithFormat:@"%.2f" ,[Utility get1Rm
                                                      :[[_db.results stringForColumn:@"weight"] doubleValue]
                                                      :[[_db.results stringForColumn:@"reps"] intValue]
                                                      ]
                  ];
        if ([rmData isEqualToString:@"0.00"]){rmData = @"-";}
    
        if([_trKb isEqual:@"1"]){
            tableStr = [NSString stringWithFormat
                        :@"%d,%@,%@,%@,%@"
                        ,[_db.results intForColumn:@"tr_id3"]
                        ,[_db.results stringForColumn:@"weight"]
                        ,[_db.results stringForColumn:@"reps"]
                        ,rmData
                        ,[_db.results stringForColumn:@"memo"]
                        ];
        }else{
            tableStr = [NSString stringWithFormat
                        :@"%d,%@,%@,%@,%@"
                        ,[_db.results intForColumn:@"tr_id3"]
                        ,[_db.results stringForColumn:@"distance"]
                        ,[_db.results stringForColumn:@"time"]
                        ,[_db.results stringForColumn:@"cal"]
                        ,[_db.results stringForColumn:@"memo"]
                        ];
        }
        
        [_tableSetDataVal addObject:tableStr];
    }
    
    if(_trSettings.defaultLanguage == 0){
        if ([_trKb isEqual:@"1"]){
            strSetName = @"Set    Weight   Reps     1RM     Memo";
        }else{
            strSetName = @"Set  Distance   Time       Cal     Memo";
        }
        tableStr   = @"A set is added";
    }else{
        if ([_trKb isEqual:@"1"]){
            strSetName = @"セット    重さ       回数     1RM     メモ";
        }else{
            strSetName = @"セット    距離       時間     カロリー  メモ";
        }
        tableStr   = @"セットを追加";
    }
    
    tableHeader = [NSString stringWithFormat:@"%@\n%@",syumokuName ,strSetName];
    
    NSArray *tableSectionEg = [[NSArray alloc] initWithObjects:tableHeader ,@" " ,@"" ,nil];
    NSArray *tableSectionJp = [[NSArray alloc] initWithObjects:tableHeader ,@" " ,@"" ,nil];
    
    NSArray *tableKeyEg2 = [[NSArray alloc] initWithObjects:@"The last result" ,nil];
    NSArray *tableKeyJp2 = [[NSArray alloc] initWithObjects:@"前回の結果"  ,nil];

    NSArray *tableKeyEg3 = [[NSArray alloc] initWithObjects:@"The end of a workout" ,nil];
    NSArray *tableKeyJp3 = [[NSArray alloc] initWithObjects:@"ワークアウトの終了"  ,nil];

    if ([_tableKey count] < 20){
        [_tableKey  addObject:@"ADD"];
        [_tableVal  addObject:tableStr];
    }
    
    //前回情報
    if(_trSettings.defaultLanguage == 0){
        _tableSection = (NSMutableArray *)[NSArray arrayWithArray:tableSectionEg];
        _tablePrevKey = (NSMutableArray *)[NSArray arrayWithArray:tableKeyEg2];
        _tablePrevVal = (NSMutableArray *)[NSArray arrayWithArray:tableKeyEg2];
        _tableBackKey = (NSMutableArray *)[NSArray arrayWithArray:tableKeyEg3];
        _tableBackVal = (NSMutableArray *)[NSArray arrayWithArray:tableKeyEg3];
    }else{
        _tableSection = (NSMutableArray *)[NSArray arrayWithArray:tableSectionJp];
        _tablePrevKey = (NSMutableArray *)[NSArray arrayWithArray:tableKeyJp2];
        _tablePrevVal = (NSMutableArray *)[NSArray arrayWithArray:tableKeyJp2];
        _tableBackKey = (NSMutableArray *)[NSArray arrayWithArray:tableKeyJp3];
        _tableBackVal = (NSMutableArray *)[NSArray arrayWithArray:tableKeyJp3];
    }

    [_db resultsClose];

    [self setTotal];
}

- (void) setTotal{
    [_db dbOpen];
    EntityDTrDt *entityDTrDt = [[EntityDTrDt alloc]initWithSelect:_db :self.keyTrHd :self.keyTrHd2];
    entityDTrDt.pSetTotal = [_tableKey count] - 1;
    [entityDTrDt doUpdate:_db];
    [_db dbClose];
}

- (NSString*)getDTrDt{
    NSString *sql;
    sql = [NSString stringWithFormat
           :@"SELECT tse.tr_id3"
           "        ,tbu.tr_kb"
           "        ,tsm.tr_syumoku_name"
           "        ,tdt.weight_unit"
           "        ,tse.weight"
           "        ,tse.reps"
           "        ,tse.memo"
           "        ,tse.distance"
           "        ,tse.time"
           "        ,tse.cal"
           "    FROM d_tr_dt AS tdt"
           " INNER JOIN m_tr_bui tbu"
           "      ON tdt.tr_bui_id = tbu.tr_bui_id"
           " INNER JOIN m_tr_syumoku AS tsm"
           "      ON tdt.tr_bui_id     = tsm.tr_bui_id"
           "     AND tdt.tr_syumoku_id = tsm.tr_syumoku_id"
           " INNER JOIN d_tr_dt_set AS tse"
           "      ON tdt.tr_id  = tse.tr_id"
           "     AND tdt.tr_id2 = tse.tr_id2"
           "   WHERE tdt.tr_id  = %d"
           "     AND tdt.tr_id2 = %d"
           " ORDER BY tse.tr_id"
           "         ,tse.tr_id2"
           "         ,tse.tr_id3"
           ,(int)self.keyTrHd
           ,(int)self.keyTrHd2
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
    }else if(section == 1){
        return [_tablePrevKey count];
    }else{
        return [_tableBackKey count];
    }
}

/**
 * 指定されたインデックスパスのセルを作成する
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger tag=0;
    UILabel *labelCell1;
    UITextField *textCell1;
    
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    tag = indexPath.row * 3;
    for (UIView *subview in [cell.contentView subviews]) {
        [subview removeFromSuperview];
    }
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }
    
    UIFont *uiFont  = [UIFont systemFontOfSize:15.0];
    if(indexPath.section == 0){
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        if([[NSString stringWithFormat:@"%@" ,[_tableKey objectAtIndex:indexPath.row]] isEqual:@"ADD"]
           ){
            // ラベル
            labelCell1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 300, 50)];
            labelCell1.textAlignment = NSTextAlignmentLeft;
            labelCell1.backgroundColor = [UIColor clearColor];
            labelCell1.textColor = [UIColor blackColor];
            labelCell1.textColor = [UIColor colorWithRed:0.2 green:0.6 blue:0.8 alpha:1.000];
            [labelCell1 setFont:uiFont];
            labelCell1.text = [_tableVal objectAtIndex:indexPath.row];
            [cell.contentView addSubview:labelCell1];
        }else{
            NSString *rowData;
            NSString *textPlaceholder;
            rowData = [_tableSetDataVal objectAtIndex:indexPath.row];
            
            NSArray * arrValue = [rowData componentsSeparatedByString:@","];
            
            int rowCnt = 0;
            bool isLabel = false;
            bool isText  = false;
            int fontSize = 0;
            int x     = 0; int y      = 0;
            int width = 0; int height = 0;
            int alignMent = 0;
            
            NSInteger tag = 0;
            //筋トレ
            if([_trKb isEqual:@"1"]){
                tag = indexPath.row * 3;
            }else{
                tag = indexPath.row * 4;
            }

            //前回のデータを取得
            [_db dbOpen];
            EntityDTrDtSet *entityDTrDtSet = [[EntityDTrDtSet alloc]
                                              initWithSelect:_db :_keyTrHdZen :_keyTrHd2Zen :[arrValue[0] intValue]];
            
            for(NSString *row in arrValue){
                rowCnt ++;
                isLabel = false;
                isText = false;
                alignMent = NSTextAlignmentCenter;
            
                textPlaceholder = @"";
                //筋トレ
                if([_trKb isEqual:@"1"]){
                    if(rowCnt == 1){
                        //セット数
                        fontSize = 15;
                        x =  20; y =  0; width =  35; height =  50;
                        isLabel = true;
                    }else if(rowCnt == 2){
                        //重量
                        fontSize = 15;
                        x =  55; y =  0; width =  60; height =  45;
                        tag++;
                        isText = true;
                        textPlaceholder = entityDTrDtSet.pWeight;
                    }else if(rowCnt == 3){
                        //回数
                        fontSize = 15;
                        x = 120; y =  0; width =  50; height =  45;
                        tag++;
                        isText = true;
                        textPlaceholder = entityDTrDtSet.pReps;

                    }else if(rowCnt == 4){
                        //1RM
                        fontSize = 15;
                        x = 170; y =  0; width =  50; height =  45;
                        isLabel = true;
                    }else if(rowCnt == 5){
                        //Memo
                        fontSize = 14;
                        x = 225; y =  0; width =  90; height =  45;
                        tag++;
                        isText = true;
                        alignMent = NSTextAlignmentLeft;
                    }
                //有酸素
                }else{
                    if(rowCnt == 1){
                        //セット数
                        fontSize = 15;
                        x =  20; y =  0; width =  35; height =  50;
                        isLabel = true;
                    }else if(rowCnt == 2){
                        //距離
                        fontSize = 15;
                        x =  55; y =  0; width =  55; height =  45;
                        tag++;
                        isText = true;
                    }else if(rowCnt == 3){
                        //時間
                        fontSize = 15;
                        x = 115; y =  0; width =  60; height =  45;
                        tag++;
                        isText = true;
                    }else if(rowCnt == 4){
                        //カロリー
                        fontSize = 15;
                        x = 180; y =  0; width =  50; height =  45;
                        tag++;
                        isText = true;
                    }else if(rowCnt == 5){
                        //Memo
                        fontSize = 14;
                        x = 235; y =  0; width =  80; height =  45;
                        tag++;
                        isText = true;
                        alignMent = NSTextAlignmentLeft;
                    }
                }
                
                UIFont *uiFont  = [UIFont systemFontOfSize:fontSize];

                if(isLabel){
                    labelCell1 = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
                    labelCell1.textAlignment = alignMent;
                    labelCell1.textColor = [UIColor blackColor];
                    [labelCell1 setFont:uiFont];
                    labelCell1.text = row;
                    [cell.contentView addSubview:labelCell1];
                }
                if(isText){
                    textCell1 = [[UITextField alloc] initWithFrame:CGRectMake(x, y, width, height)];
                    textCell1.textAlignment = alignMent;
                    textCell1.backgroundColor = [UIColor clearColor];
                    textCell1.textColor = [UIColor blackColor];
                    [textCell1 setFont:uiFont];
                    textCell1.text = row;
                    textCell1.placeholder = textPlaceholder;
                    textCell1.tag = tag;
                    textCell1.delegate = self;
                    [cell.contentView addSubview:textCell1];
                }
            }
            [_db dbClose];
        }
    }else{
        // セルにテキストを設定
        // ラベル
        labelCell1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 300, 50)];
        labelCell1.textAlignment = NSTextAlignmentLeft;
        labelCell1.backgroundColor = [UIColor clearColor];
        labelCell1.textColor = [UIColor colorWithRed:0.2 green:0.6 blue:0.8 alpha:1.000];
        [labelCell1 setFont:uiFont];
        
        if(indexPath.section == 1){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            labelCell1.text = [_tablePrevVal objectAtIndex:indexPath.row];
            
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            labelCell1.text = [_tableBackVal objectAtIndex:indexPath.row];
        }
        

        [cell.contentView addSubview:labelCell1];
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
            [self insTrDtSet];
            [self createTableData];
            [self.tableView reloadData];
        }else{
        }
    }else if(indexPath.section == 1){
        [self performSegueWithIdentifier:@"trHistory2Segue" sender:self];
    }else{
        // 一番初めのViewへ戻る
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void) insTrDtSet{
    [_db dbOpen];
    
    EntityDTrDtSet *entityDTrDtSet = [[EntityDTrDtSet alloc]init];
    entityDTrDtSet.pKeyTrId    = self.keyTrHd;
    entityDTrDtSet.pKeyTrId2   = self.keyTrHd2;
    entityDTrDtSet.pKeyTrId3   = [entityDTrDtSet getNextKey:_db :self.keyTrHd :self.keyTrHd2];
    entityDTrDtSet.pWeight     = @"";
    entityDTrDtSet.pReps       = @"";
    [entityDTrDtSet doInsert:_db];
    
    [_db dbClose];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {   //削除
        [_db dbOpen];
        EntityDTrDtSet *entityDTrDtSet = [[EntityDTrDtSet alloc]initWithSelect:_db
                                                                              :self.keyTrHd
                                                                              :self.keyTrHd2
                                                                              :[NSString stringWithFormat:@"%@"
                                                                              ,[_tableKey objectAtIndex:indexPath.row]].intValue
                                          ];
        [entityDTrDtSet doDelete:_db];
        
        [_db dbClose];
        
        // テーブルデータ作成
        [self createTableData];
        [self.tableView reloadData];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    _lastTag            = textField.tag;
    _isPicker           = false;
    _isDatePicker       = false;
    _isTimeHHMMSSPicker = false;
    
    if([_trKb isEqual:@"1"]){
        switch (_lastTag % 3) {
            case 1:
                //重量
                _setUIKeyboardType = UIKeyboardTypeDecimalPad;
                break;
            case 2:
                //回数
                _setUIKeyboardType = UIKeyboardTypeNumberPad;
                break;
            case 0:
                //メモ
                _setUIKeyboardType = UIKeyboardTypeASCIICapable;
                break;
            default:
                break;
        }
    }else{
        switch (_lastTag % 4) {
            case 1:
                //距離
                _setUIKeyboardType = UIKeyboardTypeDecimalPad;
                break;
            case 2:
                //時間
                _isTimeHHMMSSPicker = true;
                _setUIKeyboardType = UIKeyboardTypeNumberPad;
                break;
            case 3:
                //カロリ
                _setUIKeyboardType = UIKeyboardTypeDecimalPad;
                break;
            case 0:
                //メモ
                _setUIKeyboardType = UIKeyboardTypeASCIICapable;
                break;
            default:
                break;
        }
    }

    [self performSegueWithIdentifier:@"trCommonSegue" sender:self];
    return NO;
}

//画面遷移時に呼ばれるメソッド
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"trCommonSegue"]) {
        // タグから値を取得
        UITextField* textData = (UITextField*) [self.view viewWithTag:_lastTag];
        ViewControllerCommonInput * viewInput = [[ViewControllerCommonInput alloc]init];
        viewInput = segue.destinationViewController;
        viewInput.inputValue          = textData.text;
        viewInput.isPicker            = _isPicker;
        viewInput.isDatePicker        = _isDatePicker;
        viewInput.isTimeHHMMSSPicker  = _isTimeHHMMSSPicker;
        viewInput.setUIKeyboardType   = _setUIKeyboardType;
        viewInput.setUIDatePickerMode = _setUIDatePickerMode;
        viewInput.arrPickerKey        = _arrPickerKey;
        viewInput.arrPickerVal        = _arrPickerVal;
        viewInput.delegate = (id<ViewControllerCommonInputDelegate>)self;
    }
    else if ([segue.identifier isEqualToString:@"trHistory2Segue"]) {
        NSString * dateStr = _trDate;
        NSDate   * date;
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        
        df.dateFormat = @"yyyy/MM/dd";
        date = [df dateFromString:dateStr];
        [comps setDay:-1];
        date = [cal dateByAddingComponents:comps toDate:date options:0];
        dateStr = [df stringFromDate:date];

        ViewControllerHistory2 * viewNext = [[ViewControllerHistory2 alloc] init];
        viewNext = segue.destinationViewController;
        viewNext.isEdit    = false;
        viewNext.serchMode = 3; // Serch
        viewNext.keyDateEd = dateStr;
        viewNext.keyBuiId  = _keyBuiId;
        viewNext.keySyumokuId  = _keySyumokuID;
        viewNext.titleString = @"";
    }

}

- (void)updateData :(NSString *) dataKey :(NSString *) dataValue{
    // viewからtagを検索して
    NSInteger index       = 0;
    NSInteger tagWeight   = 0;
    NSInteger tagReps     = 0;
    NSInteger tagMemo     = 0;
    NSInteger tagDistance = 0;
    NSInteger tagTime     = 0;
    NSInteger tagCal      = 0;

    if([_trKb isEqual:@"1"]){
        index = (_lastTag - 1) / 3;
        tagWeight = index * 3 + 1;
        tagReps   = index * 3 + 2;
        tagMemo   = index * 3 + 3;

        _keyTrHd3 = [NSString stringWithFormat:@"%@" ,[_tableKey objectAtIndex:index]].intValue;
        
        //一時的にテキストに反映してから１行のテキストをすべて取得する
        UITextField* textData   = (UITextField*) [self.view viewWithTag:_lastTag];
        switch (_lastTag % 3) {
            //回数のみ数値
            case 2:
                textData.text = [NSString stringWithFormat:@"%d" ,dataValue.intValue];
                break;
            default:
                textData.text = [NSString stringWithFormat:@"%@" ,dataValue];
                break;
        }
    }else{
        index = (_lastTag - 1) / 4;
        tagDistance = index * 4 + 1;
        tagTime     = index * 4 + 2;
        tagCal      = index * 4 + 3;
        tagMemo     = index * 4 + 4;
        
        _keyTrHd3 = [NSString stringWithFormat:@"%@" ,[_tableKey objectAtIndex:index]].intValue;
        
        //一時的にテキストに反映してから１行のテキストをすべて取得する
        UITextField* textData   = (UITextField*) [self.view viewWithTag:_lastTag];
        textData.text = [NSString stringWithFormat:@"%@" ,dataValue];
    }

    //筋トレ時テキストフィールド
    UITextField* textWeight   = (UITextField*) [self.view viewWithTag:tagWeight];
    UITextField* textReps     = (UITextField*) [self.view viewWithTag:tagReps];

    //有酸素時テキストフィールド
    UITextField* textDistance = (UITextField*) [self.view viewWithTag:tagDistance];
    UITextField* textTime     = (UITextField*) [self.view viewWithTag:tagTime];
    UITextField* textCal      = (UITextField*) [self.view viewWithTag:tagCal];

    //共通テキストフィールド
    UITextField* textMemo     = (UITextField*) [self.view viewWithTag:tagMemo];

    [_db dbOpen];
    EntityDTrDtSet *entityDTrDtSet = [[EntityDTrDtSet alloc]initWithSelect:
                                      _db :self.keyTrHd :self.keyTrHd2 :_keyTrHd3];
    if([_trKb isEqual:@"1"]){
        entityDTrDtSet.pWeight   = textWeight.text;
        entityDTrDtSet.pReps     = textReps.text;
    }else{
        entityDTrDtSet.pDistance = textDistance.text;
        entityDTrDtSet.pTime     = textTime.text;
        entityDTrDtSet.pCal      = textCal.text;
    }
    entityDTrDtSet.pMemo     = textMemo.text;
    
    [entityDTrDtSet doUpdate:_db];
    
    [_db dbClose];

    [self doUpdateBest :_db];
    
    [self createTableData];
    [self.tableView reloadData];
}

-(void) doUpdateBest :(DBConnector *)db{
    NSString *sql;
    
    [_db dbOpen];

    //最大weight
    sql = [NSString stringWithFormat
           :@"SELECT MAX(CAST(tse.weight AS REAL)) AS weight"
           "    FROM d_tr_dt_set AS tse"
           "   WHERE tse.tr_id  = %d"
           "     AND tse.tr_id2 = %d"
           ,(int)self.keyTrHd
           ,(int)self.keyTrHd2
           ];

    [_db executeQuery:sql];
    
    NSString *weightMax;
    while ([_db.results next]) {
        weightMax = [_db.results stringForColumn:@"weight"];
    }
    
    //最大weightのなかから最大回数
    sql = [NSString stringWithFormat
           :@"SELECT MAX(CAST(tse.reps AS INTEGER)) AS reps"
           "    FROM d_tr_dt_set AS tse"
           "   WHERE tse.tr_id  = %d"
           "     AND tse.tr_id2 = %d"
           "     AND CAST(tse.weight AS REAL) = '%@'"
           ,(int)self.keyTrHd
           ,(int)self.keyTrHd2
           ,weightMax
           ];
    
    [_db executeQuery:sql];
    
    NSString *repsMax;
    while ([_db.results next]) {
        repsMax = [_db.results stringForColumn:@"reps"];
    }

    
    if(   [weightMax isEqual:@""] || [weightMax isEqual:@"0"]
       || [repsMax   isEqual:@""] || [repsMax   isEqual:@"0"]
       )
    {
        return;
    }
    
    sql = [NSString stringWithFormat
           :@"UPDATE d_tr_dt_set"
           "     SET best_record ='0'"
           "   WHERE tr_id  = %d"
           "     AND tr_id2 = %d"
           ,(int)self.keyTrHd
           ,(int)self.keyTrHd2
           ];
    [db executeUpdate:sql];

    sql = [NSString stringWithFormat
           :@"UPDATE d_tr_dt_set"
           "     SET best_record ='1'"
           "   WHERE tr_id  = %d"
           "     AND tr_id2 = %d"
           "     AND CAST(weight AS REAL) = '%@'"
           "     AND reps   = '%@'"
           ,(int)self.keyTrHd
           ,(int)self.keyTrHd2
           ,weightMax
           ,repsMax
           ];
    [db executeUpdate:sql];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = self.navigationBarTitle;

    // 必ず親クラスのviewWillAppear:メソッドを呼ぶこと
    [super viewWillAppear:animated];
    // ハイライト解除
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

@end
