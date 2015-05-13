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

@implementation InkService

+ (NSError *)createInk:(NSDictionary *)inkDictionary withTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    NSError* returnError = nil;

    DBBoard* board = inkDictionary[kInkBoard];
    
    NSString *boundary = @"14737809831466499882746641449";
    NSMutableData *body = [NSMutableData data];
    
    // Body part for "Access Token" parameter. This is a string.
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"access_token"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", [DataManager sharedInstance].activeUser.token] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Body part for "Description" parameter. This is a string.
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"description"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", inkDictionary[kInkDescription]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Body part for "board_id" parameter. This is a string.
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"board_id"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", board.boardID] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // add image data
    NSData* imageData = UIImageJPEGRepresentation(inkDictionary[kInkImage], 1.0);
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.png\"\r\n", @"image"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Setup the session
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
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
                    [target performSelectorOnMainThread:completeError withObject:statusCode waitUntilDone:NO];
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

+ (NSError *)getDashboardInksWithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    // Create returnError
    NSError* returnError = nil;
    
    // Create String URL
    NSString* stringURL = [NSString stringWithFormat:@"%@%@%@%@=%@",kWebServiceBase,kWebServiceInks,kWebServiceDashboard,kWebServiceAccessToken,[DataManager sharedInstance].activeUser.token];
    
    // Create URL
    NSURL *registerUserURL = [NSURL URLWithString:stringURL];
    
    // Create and configure URLRequest
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:registerUserURL
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:120.0];
    
    [request setValue:@"application/vnd.InkIt.v1+json" forHTTPHeaderField:@"Accept"];
    
    // Specify that it will be a GET request
    [request setHTTPMethod:@"GET"];
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

+ (NSError *)getInksForSearchString:(NSString *)searchString withTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    // Create returnError
    NSError* returnError = nil;
    
    
    // Convert your data and set your request's HTTPBody property
    NSDictionary* jsonDataDictionary = @{@"access_token" : [DataManager sharedInstance].activeUser.token,
                                         @"keywords":searchString};
    
    NSString *encodedDictionary = [jsonDataDictionary serializeParams];
    
    // Create String URL
    NSString* stringURL = [NSString stringWithFormat:@"%@%@/%@%@",kWebServiceBase,kWebServiceInks,kWebServiceSearch,encodedDictionary];
    
    // Create URL
    NSURL *registerUserURL = [NSURL URLWithString:stringURL];
    
    // Create and configure URLRequest
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:registerUserURL
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:120.0];
    
    [request setValue:@"application/vnd.InkIt.v1+json" forHTTPHeaderField:@"Accept"];
    
    // Specify that it will be a GET request
    [request setHTTPMethod:@"GET"];
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
                     NSDictionary* dataDictionary = responseDictionary[@"data"];
                     // Acá va a ir el código para el caso de éxito
                     for (NSDictionary* inkDictionary in dataDictionary) {
                         [DBInk fromJson:inkDictionary];
                     }
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
