//
//  InkService.m
//  Inkit
//
//  Created by Cristian Pena on 10/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "InkService.h"
#import "DBArtist+Management.h"
#import "DBShop+Management.h"
#import "DBTattooType+Management.h"
#import "DBBodyPart+Management.h"
#import "DBReportReason+Management.h"

#import "IKInk.h"

@implementation InkService

+ (NSError *)createInk:(NSDictionary *)inkDictionary withTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError {
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

    if (inkDictionary[kInkID]) {
        dataDictionary[@"parent_id"] = inkDictionary[kInkID];
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
//                    [DataManager saveContext];
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

+ (NSError *)updateInk:(DBInk *)ink withDictionary:(NSDictionary *)inkDictionary withTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError {
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

+ (void)getDashboardInksForPage:(NSUInteger)page withCompletion:(ServiceResponse)completion {
    NSDictionary* urlParams = @{@"access_token":[DataManager sharedInstance].activeUser.token,
                                @"page":[NSString stringWithFormat:@"%lu",(unsigned long)page]};
    NSString* urlParamsString = [urlParams serializeParams];
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@",kWebServiceBase,kWebServiceInks,kWebServiceDashboard,urlParamsString]];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120.0];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/vnd.InkIt.v1+json" forHTTPHeaderField:@"Accept"];
    
    NSURLSession* session = [NSURLSession sharedSession];
    NSURLSessionTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!error) {
            // Cast Response
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            // Check Response's StatusCode
            switch (httpResponse.statusCode) {
                case kHTTPResponseCodeOK: {
                    NSMutableArray* inksArray = [[NSMutableArray alloc] init];
                    NSDictionary* dataDictionary = responseDictionary[@"data"];
                    
                    for (NSDictionary* inkDictionary in dataDictionary) {
                        [inksArray addObject:[IKInk fromJson:inkDictionary]];
                    }
//                    [DataManager saveContext];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(inksArray, nil);
                    });
                    break;
                }
                case 400: {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(responseDictionary[@"message"],[[NSError alloc] init]);
                    });
                    break;
                }
                case 401: {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(responseDictionary[@"message"],[[NSError alloc] init]);
                    });
                    break;
                }
                default: {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(NSLocalizedString(@"There was a problem", nil),[[NSError alloc] init]);
                    });
                    break;
                }
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(NSLocalizedString(@"There was a problem", nil),[[NSError alloc] init]);
            });
        }
    }];
    
    [task resume];
}

+ (void)getInksForSearchString:(NSString *)searchString andPage:(NSUInteger)page withCompletion:(ServiceResponse)completion {
    NSDictionary* urlParams = @{@"access_token":[DataManager sharedInstance].activeUser.token,
                                @"page":[NSString stringWithFormat:@"%lu",(unsigned long)page],
                                @"keywords":searchString};
    
    NSString* urlParamsString = [urlParams serializeParams];
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://inkit.digbang.com/api/inks/search?%@",urlParamsString]];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120.0];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/vnd.InkIt.v1+json" forHTTPHeaderField:@"Accept"];
    
    NSURLSession* session = [NSURLSession sharedSession];
    NSURLSessionTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!error) {
            // Cast Response
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            // Check Response's StatusCode
            switch (httpResponse.statusCode) {
                case kHTTPResponseCodeOK: {
                    NSMutableArray* inksArray = [[NSMutableArray alloc] init];
                    NSDictionary* dataDictionary = responseDictionary[@"data"];
                    
                    for (NSDictionary* inkDictionary in dataDictionary) {
                        [inksArray addObject:[DBInk fromJson:inkDictionary]];
                    }
//                    [DataManager saveContext];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(inksArray, nil);
                    });
                    break;
                }
                case 400: {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(responseDictionary[@"message"],[[NSError alloc] init]);
                    });
                    break;
                }
                case 401: {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(responseDictionary[@"message"],[[NSError alloc] init]);
                    });
                    break;
                }
                default: {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(NSLocalizedString(@"There was a problem", nil),[[NSError alloc] init]);
                    });
                    break;
                }
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(NSLocalizedString(@"There was a problem", nil),[[NSError alloc] init]);
            });
        }
    }];
    
    [task resume];
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

+ (void)likeInk:(DBInk *)ink completion:(ServiceResponse)completion {
    NSURL* url = [NSURL URLWithString:@"http://inkit.digbang.com/api/inks/like"];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120.0];
    [request setValue:@"application/vnd.InkIt.v1+json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

    NSString *encodedDictionary = [NSString stringWithFormat:@"access_token=%@&ink_id=%@",[DataManager sharedInstance].activeUser.token,ink.inkID];
    [request setHTTPBody:[encodedDictionary dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession* session = [NSURLSession sharedSession];
    NSURLSessionTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!error) {
            // Cast Response
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            // Check Response's StatusCode
            switch (httpResponse.statusCode) {
                case 204: {
                    ink.loggedUserLikes = [NSNumber numberWithBool:true];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(nil, nil);
                    });
                    break;
                }
                case 400: {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(responseDictionary[@"message"],[[NSError alloc] init]);
                    });
                    break;
                }
                case 401: {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(responseDictionary[@"message"],[[NSError alloc] init]);
                    });
                    break;
                }
                default: {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(NSLocalizedString(@"There was a problem", nil),[[NSError alloc] init]);
                    });                    break;
                }
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(NSLocalizedString(@"There was a problem", nil),[[NSError alloc] init]);
            });
        }
    }];
    
    [task resume];
}

+ (void)unlikeInk:(DBInk *)ink completion:(ServiceResponse)completion {
    NSURL* url = [NSURL URLWithString:@"http://inkit.digbang.com/api/inks/unlike"];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120.0];
    [request setValue:@"application/vnd.InkIt.v1+json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSString *encodedDictionary = [NSString stringWithFormat:@"access_token=%@&ink_id=%@",[DataManager sharedInstance].activeUser.token,ink.inkID];
    [request setHTTPBody:[encodedDictionary dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession* session = [NSURLSession sharedSession];
    NSURLSessionTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!error) {
            // Cast Response
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            // Check Response's StatusCode
            switch (httpResponse.statusCode) {
                case 204: {
                    ink.loggedUserLikes = [NSNumber numberWithBool:false];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(nil, nil);
                    });
                    break;
                }
                case 400: {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(responseDictionary[@"message"],[[NSError alloc] init]);
                    });
                    break;
                }
                case 401: {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(responseDictionary[@"message"],[[NSError alloc] init]);
                    });
                    break;
                }
                default: {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(NSLocalizedString(@"There was a problem", nil),[[NSError alloc] init]);
                    });
                    break;
                }
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(NSLocalizedString(@"There was a problem", nil),[[NSError alloc] init]);
            });
        }
    }];
    
    [task resume];

}

+ (void)deleteInk:(DBInk *)ink completion:(ServiceResponse)completion {

    NSURL* url = [NSURL URLWithString:@"http://inkit.digbang.com/api/inks/delete"];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120.0];
    [request setValue:@"application/vnd.InkIt.v1+json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"DELETE"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSString *encodedDictionary = [NSString stringWithFormat:@"access_token=%@&ink_id=%@",[DataManager sharedInstance].activeUser.token,ink.inkID];
    [request setHTTPBody:[encodedDictionary dataUsingEncoding:NSUTF8StringEncoding]];

    NSURLSession* session = [NSURLSession sharedSession];
    NSURLSessionTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!error) {
            // Cast Response
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            
            // Check Response's StatusCode
            switch (httpResponse.statusCode) {
                case kHTTPResponseCodeOK: {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(nil, nil);
                    });
                    break;
                }
                case kHTTPResponseCodeOKNoResponse: {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(nil, nil);
                    });
                }
                case kTTPResponseCodeBadCredentials: {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(responseDictionary[@"message"],[[NSError alloc] init]);
                    });
                    break;
                }
                case kTTPResponseCodeUnauthorized: {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(responseDictionary[@"message"],[[NSError alloc] init]);
                    });
                    break;                }
                case 422: {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(responseDictionary[@"message"],[[NSError alloc] init]);
                    });
                    break;                }
                default: {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(NSLocalizedString(@"There was a problem", nil),[[NSError alloc] init]);
                    });
                    break;
                }
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(NSLocalizedString(@"There was a problem", nil),[[NSError alloc] init]);
            });
        }
    }];
    
    [task resume];
}

+ (void)postComment:(NSString *)comment toInk:(DBInk*)ink completion:(ServiceResponse)completion {
    NSURL* url = [NSURL URLWithString:@"http://inkit.digbang.com/api/inks/ink/comments/create"];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120.0];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/vnd.InkIt.v1+json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary* commentData = @{@"access_token":[DataManager sharedInstance].activeUser.token,
                                  @"ink_id":ink.inkID,
                                  @"comment":comment};
    NSString* encodedDictionary = [commentData serializeParams];
    [request setHTTPBody:[encodedDictionary dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession* session = [NSURLSession sharedSession];
    NSURLSessionTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!error) {
            // Cast Response
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            // Check Response's StatusCode
            switch (httpResponse.statusCode) {
                case 200: {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(nil, nil);
                    });
                    break;
                }
                case 400: {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(responseDictionary[@"message"],[[NSError alloc] init]);
                    });
                    break;
                }
                case 401: {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(responseDictionary[@"message"],[[NSError alloc] init]);
                    });
                    break;
                }
                default: {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(NSLocalizedString(@"There was a problem", nil),[[NSError alloc] init]);
                    });
                    break;
                }
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(NSLocalizedString(@"There was a problem", nil),[[NSError alloc] init]);
            });
        }
    }];
    
    [task resume];
}

+ (void)getCommentsForInk:(DBInk*)ink completion:(ServiceResponse)completion {
    
    NSDictionary* urlParams = @{@"access_token":[DataManager sharedInstance].activeUser.token,
                                  @"ink_id":ink.inkID};
    NSString* urlParamsString = [urlParams serializeParams];
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://inkit.digbang.com/api/inks/ink/comments?%@",urlParamsString]];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120.0];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/vnd.InkIt.v1+json" forHTTPHeaderField:@"Accept"];
    
    NSURLSession* session = [NSURLSession sharedSession];
    NSURLSessionTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!error) {
            // Cast Response
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            // Check Response's StatusCode
            switch (httpResponse.statusCode) {
                case kHTTPResponseCodeOK: {
                    [ink updateCommentsWithJson:responseDictionary[@"data"]];
//                    [DataManager saveContext];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(nil, nil);
                    });
                    break;
                }
                case 400: {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(responseDictionary[@"message"],[[NSError alloc] init]);
                    });
                    break;
                }
                case 401: {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(responseDictionary[@"message"],[[NSError alloc] init]);
                    });
                    break;
                }
                default: {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(NSLocalizedString(@"There was a problem", nil),[[NSError alloc] init]);
                    });
                    break;
                }
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(NSLocalizedString(@"There was a problem", nil),[[NSError alloc] init]);
            });
        }
    }];
    [task resume];
}

+ (void)getRelatedInksForInk:(DBInk*)ink andPage:(NSUInteger)page withCompletion:(ServiceResponse)completion {
    
}

+ (void)reportInk:(DBInk *)ink withReason:(DBReportReason *)reportReason completion:(ServiceResponse)completion {
    NSURL* url = [NSURL URLWithString:@"http://inkit.digbang.com/api/inks/report"];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120.0];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/vnd.InkIt.v1+json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary* reportData = @{@"access_token":[DataManager sharedInstance].activeUser.token,
                                  @"ink_id":ink.inkID,
                                  @"reason_id":reportReason.reportReasonId};
    
    NSString* encodedDictionary = [reportData serializeParams];
    [request setHTTPBody:[encodedDictionary dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession* session = [NSURLSession sharedSession];
    NSURLSessionTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!error) {
            // Cast Response
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            // Check Response's StatusCode
            switch (httpResponse.statusCode) {
                case 204: {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (completion) {
                            completion(nil, nil);
                        }
                    });
                    break;
                }
                case 400: {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (completion) {
                            completion(responseDictionary[@"message"],[[NSError alloc] init]);
                        }
                    });
                    break;
                }
                case 401: {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (completion) {
                            completion(responseDictionary[@"message"],[[NSError alloc] init]);
                        }
                    });
                    break;
                }
                default: {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (completion) {
                            completion(NSLocalizedString(@"There was a problem", nil),[[NSError alloc] init]);
                        }
                    });
                    break;
                }
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(NSLocalizedString(@"There was a problem", nil),[[NSError alloc] init]);
                }
            });
        }
    }];
    
    [task resume];
}

@end
