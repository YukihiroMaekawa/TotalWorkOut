//
//  EntityDTrDt.h
//  Total WorkOut
//
//  Created by 前川 幸広 on 2014/03/30.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBConnector.h"

@interface EntityDTrDt : NSObject

@property NSInteger pKeyTrId;
@property NSInteger pKeyTrId2;
@property NSInteger pTrBuiId;
@property NSInteger pTrSyumokuId;
@property NSInteger pWeightUnit;
@property NSInteger pSetTotal;

- (id)initWithSelect :(DBConnector *)db :(NSInteger)trId :(NSInteger)trId2;
-(NSInteger) getNextKey:(DBConnector *)db :(NSInteger)trId;

-(void) doInsert :(DBConnector *)db;
-(void) doUpdate :(DBConnector *)db;
-(void) doDelete :(DBConnector *)db;
@end
