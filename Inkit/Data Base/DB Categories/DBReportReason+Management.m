//
//  DBReportReason+Management.m
//  Inkit
//
//  Created by Cristian Pena on 10/8/15.
//  Copyright © 2015 Digbang. All rights reserved.
//

#import "DBReportReason+Management.h"

@implementation DBReportReason (Management)

#define KDBReportReason @"DBReportReason"
#define kDBReportReasonId @"reportReasonId"

+ (DBReportReason *)newReportReason {
    DBReportReason* reportReason = (DBReportReason *)[[DataManager sharedInstance] insert:KDBReportReason];
    return reportReason;
}

+ (DBReportReason *)withID:(NSString *)reportReasonId {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"reportReasonId = %@",reportReasonId];
    return (DBReportReason *)[[DataManager sharedInstance] first:KDBReportReason predicate:predicate sort:nil limit:1];
}

+ (DBReportReason *)fromJson:(NSDictionary *)reportReasonData {
    NSString* reportReasonID = [NSString stringWithFormat:@"%@",reportReasonData[@"id"]] ;
    DBReportReason* obj = [DBReportReason withID:reportReasonID];
    DBReportReason* reportReason = nil;
    if (!obj) {
        reportReason = [DBReportReason newReportReason];
        reportReason.reportReasonId = reportReasonID;
    } else {
        reportReason = obj;
    }
    [reportReason updateWithJson:reportReasonData];
    return reportReason;
}

- (void)updateWithJson:(NSDictionary *)reportReasonDictionary {
    
    if ([reportReasonDictionary objectForKey:@"name"]) {
        self.name = [reportReasonDictionary objectForKey:@"name"];
    }
}

+ (NSArray *)getReportReasonsSorted {
    
    return [[DataManager sharedInstance] fetch:KDBReportReason predicate:nil sort:@[[NSSortDescriptor sortDescriptorWithKey:kDBReportReasonId ascending:YES]] limit:0];
}

@end
