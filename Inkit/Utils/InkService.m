//
//  InkService.m
//  Inkit
//
//  Created by Cristian Pena on 10/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "InkService.h"
#import "InkitServiceConstants.h"
#import "DataManager.h"
#import "DBArtist+Management.h"
#import "DBShop+Management.h"
#import "InkitConstants.h"
#import "NSDictionary+Extensions.h"
#import "NSData+Extension.h"
#import "DBTattooType+Management.h"
#import "DBBodyPart+Management.h"

@implementation InkService

+ (NSError *)createInk:(NSDictionary *)inkDictionary withTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    NSError* returnError = nil;

    DBBoard* board = inkDictionary[kInkBoard];
    
    NSMutableDictionary* dataDictionary = [@{@"access_token":[DataManager sharedInstance].activeUser.token,
                                     @"description":inkDictionary[kInkDescription],
                                     @"board_id":board.boardID,
                                     @"image":inkDictionary[kInkImage]} mutableCopy];
    if (inkDictionary[kInkArtist]) {
        dataDictionary[@"artist_id"] = ((DBArtist *)inkDictionary[kInkArtist]).artistId;
    }
    if (inkDictionary[kInkTattooTypes]) {
        NSMutableArray* tattooTypesArray = [[NSMutableArray alloc] init];
        for (DBTattooType* tattooType in inkDictionary[kInkTattooTypes]) {
            [tattooTypesArray addObject:tattooType.tattooTypeId];
        }
        dataDictionary[@"tattoo_types"] = [tattooTypesArray copy];
    }
    if (inkDictionary[kInkBodyParts]) {
        NSMutableArray* bodyPartsArray = [[NSMutableArray alloc] init];
        for (DBBodyPart* bodyPart in inkDictionary[kInkBodyParts]) {
            [bodyPartsArray addObject:bodyPart.bodyPartId];
        }
        dataDictionary[@"body_parts"] = [bodyPartsArray copy];
    }

    NSString *boundary = @"14737809831466499882746641449";
    NSData* body = [NSData fromDictionary:dataDictionary andBoundary:boundary];

    // Setup the session
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.timeoutIntervalForRequest = 10;
    NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
    NSURL* createInkURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://inkit.digbang.com/api/inks/create"]];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:createInkURL];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/vnd.InkIt.v1+json" forHTTPHeaderField:@"Accept"];
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:body];
    
    NSURLSessionTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *connectionError) {
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
                    NSDictionary* inkDictionary = responseDictionary[@"data"];
                    // Acá va a ir el código para el caso de éxito
                    DBInk* ink = [DBInk fromJson:inkDictionary];
                    
                    [target performSelectorOnMainThread:completeAction withObject:ink waitUntilDone:NO];
                    break;
                }
                default:
                {
                    NSNumber* statusCode = [NSNumber numberWithLong:httpResponse.statusCode];
                    NSString* errorCode = [NSString stringWithFormat:@"%@", statusCode];
                    [target performSelectorOnMainThread:completeError withObject:errorCode waitUntilDone:NO];
                    break;
                }
            }
        } else {
            [target performSelectorOnMainThread:completeError withObject:@"No estás conectado a Internet" waitUntilDone:NO];
        }
        
    }];
    
    [task resume];
    return returnError;
}

+ (NSError *)updateInk:(DBInk *)ink withDictionary:(NSDictionary *)inkDictionary withTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    NSError* returnError = nil;
    
    // Create String URL
    NSString* stringURL = [NSString stringWithFormat:@"%@%@/%@",kWebServiceBase,kWebServiceInks,kWebServiceEdit];
    
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
    __block NSMutableDictionary* inkData = [[NSMutableDictionary alloc] init];
    inkData[@"access_token"] = [DataManager sharedInstance].activeUser.token;
    inkData[@"ink_id"] = ink.inkID;
    inkData[@"description"] = inkDictionary[@"description"];
    inkData[@"board_id"] = ((DBBoard *)inkDictionary[@"board"]).boardID;
    
    NSString *encodedDictionary = [inkData serializeParams];
    
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
                     [ink updateWithJson:inkData];
                     [target performSelectorOnMainThread:completeAction withObject:ink waitUntilDone:NO];
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

+ (NSError *)getDashboardInksForPage:(NSUInteger)page withTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    // Create returnError
    NSError* returnError = nil;
    
    // Create String URL
   
    NSString* stringURL = [NSString stringWithFormat:@"%@%@%@%@=%@&page=%lu",kWebServiceBase,kWebServiceInks,kWebServiceDashboard,kWebServiceAccessToken,[DataManager sharedInstance].activeUser.token,(unsigned long)page];
    
    // Create URL
    NSURL *registerUserURL = [NSURL URLWithString:stringURL];
    
    // Create and configure URLRequest
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:registerUserURL
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:120];
    NSMutableURLRequest *request2 = [NSMutableURLRequest requestWithURL:registerUserURL];
    [request setValue:@"application/vnd.InkIt.v1+json" forHTTPHeaderField:@"Accept"];
    
    // Specify that it will be a GET request
    [request2 setHTTPMethod:@"GET"];
    
    // Create Asynchronous Request URLConnection
    [NSURLConnection sendAsynchronousRequest:request2
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
                         [inksArray addObject:[DBInk fromJson:inkDictionary]];
                     }
                     [target performSelectorOnMainThread:completeAction withObject:inksArray waitUntilDone:NO];
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

+ (NSError *)getInksForSearchString:(NSString *)searchString andPage:(NSUInteger)page withTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    
    // Create returnError
    NSError* returnError = nil;
    
    // Create String URL
    NSString* stringURL = [NSString stringWithFormat:@"http://inkit.digbang.com/api/inks/search?access_token=%@&page=%lu&keywords=%@",[DataManager sharedInstance].activeUser.token, (unsigned long)page,searchString];
    
    // Create URL
    NSURL *registerUserURL = [NSURL URLWithString:stringURL];
    
    // Create and configure URLRequest
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:registerUserURL
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:120];
    NSMutableURLRequest *request2 = [NSMutableURLRequest requestWithURL:registerUserURL];
    [request setValue:@"application/vnd.InkIt.v1+json" forHTTPHeaderField:@"Accept"];
    
    // Specify that it will be a GET request
    [request2 setHTTPMethod:@"GET"];
    
    // Create Asynchronous Request URLConnection
    [NSURLConnection sendAsynchronousRequest:request2
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
                         [inksArray addObject:[DBInk fromJson:inkDictionary]];
                     }
                     [target performSelectorOnMainThread:completeAction withObject:inksArray waitUntilDone:NO];
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

+ (NSError *)getRemotesForSearchString:(NSString *)searchString type:(NSString *)type withTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError {
    
    // Create returnError
    NSError* returnError = nil;
    
    // Create String URL
    NSString* stringURL = [NSString stringWithFormat:@"%@%@%@%@",kWebServiceBase,kWebServiceUsers,kWebServiceArtist2,kWebServiceSearch2];
    
    // Create URL
    NSURL *registerUserURL = [NSURL URLWithString:stringURL];
    
    // Create and configure URLRequest
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:registerUserURL
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:120.0];
    
    [request setValue:@"application/vnd.InkIt.v1+json" forHTTPHeaderField:@"Accept"];
    
    // Specify that it will be a POST request
    [request setHTTPMethod:@"POST"];
    
    // get user
    DBUser* activeUser = [DataManager sharedInstance].activeUser;
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    
    NSString *encodedDictionary = [NSString stringWithFormat:@"access_token=%@&term=%@",activeUser.token,searchString];
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
                     NSArray* artistsArray = responseDictionary[@"data"];
                     NSMutableArray* returnArray = [[NSMutableArray alloc] init];
                     
                     // Acá va a ir el código para el caso de éxito
                     for (NSDictionary* artistDictionary in artistsArray) {
                         [returnArray addObject:[DBArtist fromJson:artistDictionary]];
                     }
                     [target performSelectorOnMainThread:completeAction withObject:returnArray waitUntilDone:NO];
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

+ (NSError *)likeInk:(DBInk *)ink withTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    // Create returnError
    NSError* returnError = nil;
    
    // Create String URL
    NSString* stringURL = [NSString stringWithFormat:@"%@%@%@",kWebServiceBase,kWebServiceInks,kWebServiceLike];
    
    // Create URL
    NSURL *registerUserURL = [NSURL URLWithString:stringURL];
    
    // Create and configure URLRequest
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:registerUserURL
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:120.0];
    
    [request setValue:@"application/vnd.InkIt.v1+json" forHTTPHeaderField:@"Accept"];
    
    // Specify that it will be a POST request
    [request setHTTPMethod:@"POST"];
    
    // get user
    DBUser* activeUser = [DataManager sharedInstance].activeUser;
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    
    NSString *encodedDictionary = [NSString stringWithFormat:@"access_token=%@&ink_id=%@",activeUser.token,ink.inkID];
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
                 case kHTTPResponseCodeOK:
                 {
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


+ (NSError *)unLikeInk:(DBInk *)ink withTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    // Create returnError
    NSError* returnError = nil;
    
    // Create String URL
    NSString* stringURL = [NSString stringWithFormat:@"%@%@%@",kWebServiceBase,kWebServiceInks,kWebServiceUnLike];
    
    // Create URL
    NSURL *registerUserURL = [NSURL URLWithString:stringURL];
    
    // Create and configure URLRequest
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:registerUserURL
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:120.0];
    
    [request setValue:@"application/vnd.InkIt.v1+json" forHTTPHeaderField:@"Accept"];
    
    // Specify that it will be a POST request
    [request setHTTPMethod:@"POST"];
    
    // get user
    DBUser* activeUser = [DataManager sharedInstance].activeUser;
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    
    NSString *encodedDictionary = [NSString stringWithFormat:@"access_token=%@&ink_id=%@",activeUser.token,ink.inkID];
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
                 case kHTTPResponseCodeOK:
                 {
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
