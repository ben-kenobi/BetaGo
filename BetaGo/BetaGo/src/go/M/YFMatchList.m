


//
//  YFMatchList.m
//  BetaGo
//
//  Created by yf on 2019/4/16.
//  Copyright © 2019 yf. All rights reserved.
//

#import "YFMatchList.h"
#import "YFMatch.h"


@interface YFMatchList ()
@property (nonatomic,strong)NSMutableArray<YFMatch *> *matchs;
@property (nonatomic,strong)NSString *selectedMatchID;
@end

@implementation YFMatchList
#pragma mark - exported
-(NSInteger)count{
    return self.matchs.count;
}
-(YFMatch *)getBy:(NSIndexPath *)idxpath{
    return self.matchs[idxpath.row];
}
-(YFMatch *)selectedMatch{
    for(YFMatch *match in self.matchs){
        if([match.ID isEqualToString:self.selectedMatchID])
            return match;
    }
    return [self.matchs firstObject];
}

-(void)addMatch:(YFMatch *)match{
    [self.matchs insertObject:match atIndex:0];
    [self save];
}
-(void)rmMatch:(YFMatch *)match{
    [self.matchs removeObject:match];
    [self save];
}

-(void)rmAt:(NSIndexPath *)indexpath{
    [self.matchs removeObject:[self getBy:indexpath]];
    [self save];
}

-(void)save{
    [self archive];
}
-(void)saveMatch:(YFMatch *)match{
    match.lastSavedTime = [NSDate date];
    self.selectedMatchID = match.ID;
    if([self.matchs containsObject:match]){
        [self.matchs replaceObjectAtIndex:[self.matchs indexOfObject:match] withObject:match];
        [self save];
    }else{
        [self addMatch:match];
    }
}
-(void)selectMatchAt:(NSIndexPath *)idxpath{
    self.selectedMatchID = [self getBy:idxpath].ID;
    [self save];
}


#pragma mark - init


+(instancetype)newInstance{
    YFMatchList *instance=[YFMatchList unArchive];
    return instance;
}


-(void)archive{
    //1、存在主应用沙盒文件
    runOnGlobal(^{
        [NSKeyedArchiver archiveRootObject:self toFile:[@"YFMatchList" strByAppendToDocPath]];
    });
}
+(instancetype)unArchive{
    YFMatchList *instance = nil;
    
    //1、主应用沙盒文件获取
    instance = [NSKeyedUnarchiver unarchiveObjectWithFile:[@"YFMatchList" strByAppendToDocPath]];
    if(instance){
        return instance;
    }
    instance=[[YFMatchList alloc]init];
    return instance;
}

iLazy4Ary(matchs, _matchs)

#pragma mark - codec
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.matchs forKey:@"matchs"];
    [aCoder encodeObject:self.selectedMatchID forKey:@"selectedMatchID"];
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.matchs=[coder decodeObjectForKey:@"matchs"];
        self.selectedMatchID=[coder decodeObjectForKey:@"selectedMatchID"];
    }
    return self;
}


@end
