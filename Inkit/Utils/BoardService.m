//
//  BoardService.m
//  Inkit
//
//  Created by Cristian Pena on 10/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "BoardService.h"
#import "DataManager.h"
#import "InkitServiceConstants.h"
#import "InkitConstants.h"
#import "NSDictionary+Extensions.h"

@implementation BoardService
+ (NSError *)postBoard:(NSDictionary *)boardDictionary WithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    // Create returnError
    NSError* returnError = nil;
    
    // Create String URL
    NSString* stringURL = [NSString stringWithFormat:@"%@%@%@",kWebServiceBase,kWebServiceBoards,kWebServiceCreate];
    
    // Create URL
    NSURL *registerUserURL = [NSURL URLWithString:stringURL];
    
    // Create and configure URLRequest
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:registerUserURL
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:120.0];
    
    [request setValue:@"application/vnd.InkIt.v1+json" forHTTPHeaderField:@"Accept"];
    
    // Specify that it will be a POST request
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    // Convert your data and set your request's HTTPBody property
    NSDictionary* jsonDataDictionary = @{@"access_token" : [DataManager sharedInstance].activeUser.token,
                                         @"name":boardDictionary[@"name"],
                                         @"description":boardDictionary[@"description"]};
    
    NSString *encodedDictionary = [jsonDataDictionary serializeParams];
    
    [request setHTTPBody:[encodedDictionary dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Create Asynchronous Request URLConnection
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         if (!connectionError)
         {
             // Cast Response
             NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
             NSError *error = nil;
             
             // Parse JSON Response
             NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                                options:NSJSONReadingMutableContainers
                                                                                  error:&error];
             // Check Response's StatusCode
             switch (httpResponse.statusCode) {
                 case kHTTPResponseCodeOK:
                 {
                     // Acá va a ir el código para el caso de éxito
                     if ([responseDictionary objectForKey:@"data"]) {
                         DBBoard* board = [[DataManager sharedInstance].activeUser createBoardFromJson:responseDictionary[@"data"]];
                         [board updateWithJson:boardDictionary];
                         [target performSelectorOnMainThread:completeAction withObject:board waitUntilDone:NO];
                     }
                     break;
                 }
                 case 422:
                 {
                     NSString* errorMessage = [NSString stringWithFormat:@"Board already exists"];
                     [target performSelectorOnMainThread:completeError withObject:errorMessage waitUntilDone:NO];
                     break;
                 }
                     
                 default:
                 {
                     NSNumber* statusCode = [NSNumber numberWithLong:httpResponse.statusCode];
                     NSString* errorMessage = [NSString stringWithFormat:@"%@",statusCode];
                     [target performSelectorOnMainThread:completeError withObject:errorMessage waitUntilDone:NO];
                     break;
                 }
             }
         } else {
             [target performSelectorOnMainThread:completeError withObject:@"No estás conectado a Internet" waitUntilDone:NO];
         }
         
     }];
    
    return returnError;
}

+ (NSError *)updateBoard:(DBBoard *)board withDictionary:(NSDictionary *)boardDictionary target:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError;
{
    // Create returnError
    NSError* returnError = nil;
    
    // Create String URL
    NSString* stringURL = [NSString stringWithFormat:@"%@%@%@",kWebServiceBase,kWebServiceBoards,kWebServiceEdit];
    
    // Create URL
    NSURL *registerUserURL = [NSURL URLWithString:stringURL];
    
    // Create and configure URLRequest
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:registerUserURL
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:120.0];
    
    [request setValue:@"application/vnd.InkIt.v1+json" forHTTPHeaderField:@"Accept"];
    
    // Specify that it will be a POST request
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    // Convert your data and set your request's HTTPBody property
    NSDictionary* jsonDataDictionary = @{@"access_token" : [DataManager sharedInstance].activeUser.token,
                                         @"board_id": [NSString stringWithFormat:@"%@",board.boardID],
                                         @"name":boardDictionary[kBoardTitle],
                                         @"description":boardDictionary[kBoardDescription]
                                         };
    
    NSString *encodedDictionary = [jsonDataDictionary serializeParams];
    
    [request setHTTPBody:[encodedDictionary dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Create Asynchronous Request URLConnection
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         if (!connectionError)
         {
             // Cast Response
             NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
             
             // Check Response's StatusCode
             switch (httpResponse.statusCode) {
                 case kHTTPResponseCodeOKNoResponse:
                 {
                     [board updateWithJson:boardDictionary];
                     [target performSelectorOnMainThread:completeAction withObject:nil waitUntilDone:NO];
                     break;
                 }
                 case 422:
                 {
                     NSString* errorMessage = [NSString stringWithFormat:@"Board already exists"];
                     [target performSelectorOnMainThread:completeError withObject:errorMessage waitUntilDone:NO];
                     break;
                 }
                     
                 default:
                 {
                     NSNumber* statusCode = [NSNumber numberWithLong:httpResponse.statusCode];
                     NSString* errorMessage = [NSString stringWithFormat:@"%@",statusCode];
                     [target performSelectorOnMainThread:completeError withObject:errorMessage waitUntilDone:NO];
                     break;
                 }
             }
         } else {
             [target performSelectorOnMainThread:completeError withObject:@"No estás conectado a Internet" waitUntilDone:NO];
         }
         
     }];
    
    return returnError;
}

+ (NSError *)deleteBoard:(DBBoard *)board WithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    // Create returnError
    NSError* returnError = nil;
    
    // Create String URL
    NSString* stringURL = [NSString stringWithFormat:@"%@%@%@",kWebServiceBase,kWebServiceBoards,kWebServiceDelete];
    
    // Create URL
    NSURL *registerUserURL = [NSURL URLWithString:stringURL];
    
    // Create and configure URLRequest
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:registerUserURL
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:120.0];
    
    [request setValue:@"application/vnd.InkIt.v1+json" forHTTPHeaderField:@"Accept"];
    
    // Specify that it will be a POST request
    [request setHTTPMethod:@"DELETE"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    // Convert your data and set your request's HTTPBody property
    NSDictionary* jsonDataDictionary = @{@"access_token" : [NSString stringWithFormat:@"%@",board.user.token],
                                         @"board_id": [NSString stringWithFormat:@"%@",board.boardID],
                                         };
    NSString *encodedDictionary = [jsonDataDictionary serializeParams];
    
    [request setHTTPBody:[encodedDictionary dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Create Asynchronous Request URLConnection
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         if (!connectionError)
         {
             // Cast Response
             NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
//             NSError *error = nil;
//             
//             // Parse JSON Response
//             NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data
//                                                                                options:NSJSONReadingMutableContainers
//                                                                                  error:&error];
             // Check Response's StatusCode
             switch (httpResponse.statusCode) {
                 case kHTTPResponseCodeOKNoResponse:
                 {
                     // Acá va a ir el código para el caso de éxito
                     [board deleteBoard];
                     [target performSelectorOnMainThread:completeAction withObject:nil waitUntilDone:NO];
                     break;
                 }
                default:
                 {
                     NSNumber* statusCode = [NSNumber numberWithLong:httpResponse.statusCode];
                     NSString* errorMessage = [NSString stringWithFormat:@"%@",statusCode];
                     [target performSelectorOnMainThread:completeError withObject:errorMessage waitUntilDone:NO];
                     break;
                 }
             }
         } else {
             [target performSelectorOnMainThread:completeError withObject:@"No estás conectado a Internet" waitUntilDone:NO];
         }
         
     }];
    
    return returnError;
}

+ (NSError *)getBoardsForUser:(DBUser*)user withTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    // Create returnError
    NSError* returnError = nil;
    
    // Convert your data and set your request's HTTPBody property
    NSMutableDictionary* jsonDataDictionary = [@{@"access_token" : [DataManager sharedInstance].activeUser.token} mutableCopy ];
    if (!(user == [DataManager sharedInstance].activeUser)) {
        jsonDataDictionary[@"user_id"] = user.userID;
    }
    
    NSString *encodedDictionary = [jsonDataDictionary serializeParams];
    
    // Create String URL
    NSString* stringURL = [NSString stringWithFormat:@"%@%@?%@",kWebServiceBase,kWebServiceGetBoards,encodedDictionary];
    
    // Create URL
    NSURL *registerUserURL = [NSURL URLWithString:stringURL];
    
    // Create and configure URLRequest
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:registerUserURL
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:120.0];
    
    [request setValue:@"application/vnd.InkIt.v1+json" forHTTPHeaderField:@"Accept"];
    
    // Specify that it will be a POST request
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    
    
    // Create Asynchronous Request URLConnection
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         if (!connectionError)
         {
             // Cast Response
             NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
             NSError *error = nil;
             
             // Parse JSON Response
             NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                                options:NSJSONReadingMutableContainers
                                                                                  error:&error];
             // Check Response's StatusCode
             switch (httpResponse.statusCode) {
                 case kHTTPResponseCodeOK:
                 {
                     NSMutableArray* boardsArray = [[NSMutableArray alloc] init];
                     NSDictionary* dataDictionary = responseDictionary[@"data"];
                     
                     for (NSDictionary* boardDictionary in dataDictionary) {
                         [boardsArray addObject:[DBBoard fromJson:boardDictionary]];
                     }
                     [target performSelectorOnMainThread:completeAction withObject:boardsArray waitUntilDone:NO];
                     break;
                 }
                 default:
                 {
                     NSNumber* statusCode = [NSNumber numberWithLong:httpResponse.statusCode];
                     NSString* errorString = [NSString stringWithFormat:@"%@",statusCode];
                     NSLog(@"%@",responseDictionary);
                     [target performSelectorOnMainThread:completeError withObject:errorString waitUntilDone:NO];
                     break;
                 }
             }
         } else {
             [target performSelectorOnMainThread:completeError withObject:@"No estás conectado a Internet" waitUntilDone:NO];
         }
         
     }];
    
    return returnError;
}

+ (NSError *)getInksFromBoard:(DBBoard *)board withTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError {
    // Create returnError
    NSError* returnError = nil;
    
    // Convert your data and set your request's HTTPBody property
    NSDictionary* jsonDataDictionary = @{@"access_token" : [DataManager sharedInstance].activeUser.token,
                                          @"board_id" : board.boardID};
    
    NSString *encodedDictionary = [jsonDataDictionary serializeParams];
    
    // Create String URL
    NSString* stringURL = [NSString stringWithFormat:@"%@%@%@?%@",kWebServiceBase,kWebServiceBoards,kWebServiceInks,encodedDictionary];
    
    // Create URL
    NSURL *registerUserURL = [NSURL URLWithString:stringURL];
    
    // Create and configure URLRequest
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:registerUserURL
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:120.0];
    
    [request setValue:@"application/vnd.InkIt.v1+json" forHTTPHeaderField:@"Accept"];
    
    // Specify that it will be a POST request
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    
    
    // Create Asynchronous Request URLConnection
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         if (!connectionError)
         {
             // Cast Response
             NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
             NSError *error = nil;
             
             // Parse JSON Response
             NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                                options:NSJSONReadingMutableContainers
                                                                                  error:&error];
             // Check Response's StatusCode
             switch (httpResponse.statusCode) {
                 case kHTTPResponseCodeOK:
                 {
                     NSMutableArray* inksArray = [[NSMutableArray alloc] init];
                     NSDictionary* dataDictionary = responseDictionary[@"data"];
                     
                     for (NSDictionary* inkDictionary in dataDictionary) {
                         DBInk* ink =[DBInk fromJson:inkDictionary];
                         [inksArray addObject:ink];
//                         if (![board.inks containsObject:ink]) {
//                             [board addInksObject:ink];
//                         }
                     }
                     [target performSelectorOnMainThread:completeAction withObject:inksArray waitUntilDone:NO];
                     break;
                 }
                 default:
                 {
                     NSNumber* statusCode = [NSNumber numberWithLong:httpResponse.statusCode];
                     NSString* errorString = [NSString stringWithFormat:@"%@",statusCode];
                     NSLog(@"%@",responseDictionary);
                     [target performSelectorOnMainThread:completeError withObject:errorString waitUntilDone:NO];
                     break;
                 }
             }
         } else {
             [target performSelectorOnMainThread:completeError withObject:@"No estás conectado a Internet" waitUntilDone:NO];
         }
         
     }];
    
    return returnError;

}

@end
