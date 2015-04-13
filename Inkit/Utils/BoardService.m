//
//  BoardService.m
//  Inkit
//
//  Created by Cristian Pena on 10/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "BoardService.h"
#import "InkitServiceConstants.h"
#import "NSDictionary+Extensions.h"

@implementation BoardService
+ (NSError *)postBoard:(DBBoard *)board WithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
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
    NSDictionary* jsonDataDictionary = @{@"access_token" : [NSString stringWithFormat:@"%@",board.user.token],
                                         @"name":board.boardTitle,
                                         @"description":board.boardDescription
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
                         [board updateWithJson:responseDictionary[@"data"]];
                     }
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

+ (NSError *)updateBoard:(DBBoard *)board WithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
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
    NSDictionary* jsonDataDictionary = @{@"access_token" : [NSString stringWithFormat:@"%@",board.user.token],
                                         @"board_id": [NSString stringWithFormat:@"%@",board.boardID],
                                         @"name":board.boardTitle,
                                         @"description":board.boardDescription
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

+ (NSError *)getBoard:(DBBoard *)board forUser:(DBUser*)user withTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    // Create returnError
    NSError* returnError = nil;
    
    // Create String URL
    NSString* stringURL = [NSString stringWithFormat:@"%@%@access_token=3&user_id=%@",kWebServiceBase,kWebServiceGetBoards,user.userID];
    
    // Create URL
    NSURL *registerUserURL = [NSURL URLWithString:stringURL];
    
    // Create and configure URLRequest
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:registerUserURL
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:120.0];
    
    [request setValue:@"application/vnd.InkIt.v1+json" forHTTPHeaderField:@"Accept"];
    
    // Specify that it will be a POST request
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Convert your data and set your request's HTTPBody property
    NSDictionary* jsonDataDictionary = @{@"access_token" : user.token
                                         };
    
    NSError *error = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:jsonDataDictionary options:NSJSONWritingPrettyPrinted error:&error];
    [request setHTTPBody: jsonData];
    
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
//             NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data
//                                                                                options:NSJSONReadingMutableContainers
//                                                                                  error:&error];
             // Check Response's StatusCode
             switch (httpResponse.statusCode) {
                 case kHTTPResponseCodeOK:
                 {
                     // Acá va a ir el código para el caso de éxito
                     
                     [target performSelectorOnMainThread:completeAction withObject:nil waitUntilDone:NO];
                     break;
                 }
                 default:
                 {
                     NSNumber* statusCode = [NSNumber numberWithLong:httpResponse.statusCode];
                     [target performSelectorOnMainThread:completeError withObject:statusCode waitUntilDone:NO];
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
