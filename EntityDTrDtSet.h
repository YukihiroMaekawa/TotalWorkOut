//
//  EntityDTrDtSet.h
//  Total WorkOut
//
//  Created by 前川 幸広 on 2014/04/02.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBConnector.h"

@interface EntityDTrDtSet : NSObject
@property NSInteger pKeyTrId;
@property NSInteger pKeyTrId2;
@property NSInteger pKeyTrId3;
@property NSString *pWeight;
@property NSString *pReps;
@property NSString *pDistance;
@property NSString *pTime;
@property NSString *pCal;

@property NSString *pBestRecord; //0:BESTではない 1:BEST
@property NSString *pMemo;

- (id)initWithSelect :(DBConnector *)db :(NSInteger)trId :(NSInteger)trId2 :(NSInteger)trId3;
-(NSInteger) getNextKey:(DBConnector *)db :(NSInteger)trId :(NSInteger)trId2;

-(void) doInsert :(DBConnector *)db;
-(void) doUpdate :(DBConnector *)db;
-(void) doDelete :(DBConnector *)db;

@end
