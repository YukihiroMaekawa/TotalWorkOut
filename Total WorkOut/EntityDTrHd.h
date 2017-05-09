//
//  EntityDTrHd.h
//  Total WorkOut
//
//  Created by 前川 幸広 on 2014/03/30.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBConnector.h"

@interface EntityDTrHd : NSObject

@property (nonatomic)           NSInteger pKeyTrId;
@property (nonatomic)           NSString *pTrDate;
@property (nonatomic)           NSString *pTrTimeSt;
@property (nonatomic)           NSString *pWeight;
@property (nonatomic)           NSString *pFat;
@property (nonatomic)           NSString *pMemo;
@property (nonatomic,readwrite) NSString *pTrDateMonth;

- (id)initWithSelect :(DBConnector *)db :(NSInteger)trId;
-(NSInteger) getNextKey:(DBConnector *)db;
-(void) doInsert :(DBConnector *)db;
-(void) doUpdate :(DBConnector *)db;
-(void) doDelete :(DBConnector *)db;
@end
