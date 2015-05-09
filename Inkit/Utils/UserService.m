//
//  InkitServiceV2.m
//  Inkit
//
//  Created by Cristian Pena on 2/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "UserService.h"
#import "DBBoard+Management.h"
#import "DBUser+Management.h"
#import "DBInk+Management.h"
#import "InkitServiceConstants.h"
#import "InkitConstants.h"
#import "DataManager.h"


@implementation UserService

+ (NSError *)registerUserDictionary:(NSDictionary *)userDictionary WithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    // Create returnError
    NSError* returnError = nil;
    
    // Create String URL
    NSString* stringURL = [NSString stringWithFormat:@"%@%@%@%@",kWebServiceBase,kWebServiceAuthorization,kWebServiceRegister,kWebServiceUser ];
    
    // Create URL
    NSURL *registerUserURL = [NSURL URLWithString:stringURL];
    
    // Create and configure URLRequest
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:registerUserURL
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:120.0];
    
    [request setValue:@"application/vnd.InkIt.v1+json" forHTTPHeaderField:@"Accept"];
    
    // Specify that it will be a POST request
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSError *error = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:userDictionary options:NSJSONWritingPrettyPrinted error:&error];
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
             NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                                options:NSJSONReadingMutableContainers
                                                                                  error:&error];
             // Check Response's StatusCode
             switch (httpResponse.statusCode) {
                 case kHTTPResponseCodeOK:
                 {
                     // Acá va a ir el código para el caso de éxito
                     DBUser* user = [DBUser fromJson:userDictionary];
                     [user updateWithJson:responseDictionary];
                     [DataManager sharedInstance].activeUser = user;
                     [target performSelectorOnMainThread:completeAction withObject:nil waitUntilDone:NO];
                     break;
                 }
                 case kTTPResponseCodeCreateUserFailed:
                 {
                     NSDictionary* errorsDictionary = responseDictionary[@"errors"];
                     NSString* errorsString = [NSString stringWithFormat:@"%@", errorsDictionary];
                     [target performSelectorOnMainThread:completeError withObject:errorsString  waitUntilDone:NO];
                     break;
                 }
                 default:
                 {
                     NSNumber* statusCode = [NSNumber numberWithLong:httpResponse.statusCode];
                     NSString* stringError = [NSString stringWithFormat:@"%@",statusCode];
                     [target performSelectorOnMainThread:completeError withObject:stringError waitUntilDone:NO];
                     break;
                 }
             }
         } else {
             [target performSelectorOnMainThread:completeError withObject:@"No estás conectado a Internet" waitUntilDone:NO];
         }
         
     }];
    
    return returnError;
}


+ (NSError *)logInUserDictionary:(NSDictionary *)userDictionary withTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    // Create returnError
    NSError* returnError = nil;
    
    // Create String URL
    NSString* stringURL = [NSString stringWithFormat:@"%@%@%@",kWebServiceBase,kWebServiceAuthorization,kWebServiceLogin];
    
    // Create URL
    NSURL *registerUserURL = [NSURL URLWithString:stringURL];
    
    // Create and configure URLRequest
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:registerUserURL
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:120.0];
    
    [request setValue:@"application/vnd.InkIt.v1+json" forHTTPHeaderField:@"Accept"];
    
    // Specify that it will be a POST request
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSError *error = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:userDictionary options:NSJSONWritingPrettyPrinted error:&error];

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
             NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                                options:NSJSONReadingMutableContainers
                                                                                  error:&error];
             // Check Response's StatusCode
             switch (httpResponse.statusCode) {
                 case kHTTPResponseCodeOK:
                 {
                     
                     // Acá va a ir el código para el caso de éxito
                     if ([responseDictionary objectForKey:kAccessToken]) {
                         DBUser* user = [DBUser createNewUser];
                         [user updateWithJson:userDictionary];
                         [user updateWithJson:responseDictionary];
                         [DataManager sharedInstance].activeUser = user;
                         [target performSelectorOnMainThread:completeAction withObject:nil waitUntilDone:NO];
                     } else {
                         [target performSelectorOnMainThread:completeError withObject:nil waitUntilDone:NO];
                     }
                     break;
                 }
                 default:
                 {
                     [DataManager sharedInstance].activeUser = nil;
                     if ([responseDictionary objectForKey:@"message"]) {
                         [target performSelectorOnMainThread:completeError withObject:[responseDictionary objectForKey:@"message"] waitUntilDone:NO];
                     } else {
                         NSNumber* statusCode = [NSNumber numberWithLong:httpResponse.statusCode];
                         [target performSelectorOnMainThread:completeError withObject:statusCode waitUntilDone:NO];
                     }
                     break;
                 }
             }
         } else {
             [target performSelectorOnMainThread:completeError withObject:@"No estás conectado a Internet" waitUntilDone:NO];
         }
         
     }];
    
    return returnError;
}

+ (NSError *)logInSocialDictionary:(NSDictionary *)facebookDictionary withTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError;
{
    // Create returnError
    NSError* returnError = nil;
    
    // Create String URL
    NSString* stringURL = [NSString stringWithFormat:@"%@%@%@%@",kWebServiceBase,kWebServiceAuthorization,kWebServiceLogin,kWebServiceSocialLogin];
    
    // Create URL
    NSURL *registerUserURL = [NSURL URLWithString:stringURL];
    
    // Create and configure URLRequest
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:registerUserURL
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:120.0];
    
    [request setValue:@"application/vnd.InkIt.v1+json" forHTTPHeaderField:@"Accept"];
    
    // Specify that it will be a POST request
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSError *error = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:facebookDictionary options:NSJSONWritingPrettyPrinted error:&error];
    
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
             NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                                options:NSJSONReadingMutableContainers
                                                                                  error:&error];
             // Check Response's StatusCode
             switch (httpResponse.statusCode) {
                 case kHTTPResponseCodeOK:
                 {
                     
                     // Acá va a ir el código para el caso de éxito
                     if ([responseDictionary objectForKey:kAccessToken]) {
                         DBUser* user = [DBUser createNewUser];
                         [user updateWithJson:facebookDictionary];
                         [user updateWithJson:responseDictionary];
                         [DataManager sharedInstance].activeUser = user;
                         [target performSelectorOnMainThread:completeAction withObject:nil waitUntilDone:NO];
                     } else {
                         [target performSelectorOnMainThread:completeError withObject:nil waitUntilDone:NO];
                     }
                     break;
                 }
                 default:
                 {
                     [DataManager sharedInstance].activeUser = nil;
                     if ([responseDictionary objectForKey:@"message"]) {
                         [target performSelectorOnMainThread:completeError withObject:[responseDictionary objectForKey:@"message"] waitUntilDone:NO];
                     } else {
                         NSNumber* statusCode = [NSNumber numberWithLong:httpResponse.statusCode];
                         [target performSelectorOnMainThread:completeError withObject:statusCode waitUntilDone:NO];
                     }
                     break;
                 }
             }
         } else {
             [target performSelectorOnMainThread:completeError withObject:@"No estás conectado a Internet" waitUntilDone:NO];
         }
         
     }];
    
    return returnError;
}

+ (NSError *)logOutUser:(DBUser *)user withTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    // Create returnError
    NSError* returnError = nil;
    
    // Create String URL
    NSString* stringURL = [NSString stringWithFormat:@"%@%@%@",kWebServiceBase,kWebServiceAuthorization,kwebServiceLogout];
    
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

    
    NSString *encodedDictionary = [NSString stringWithFormat:@"access_token=%@",user.token];
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
                     // Acá va a ir el código para el caso de éxito
                     [DataManager sharedInstance].activeUser = nil;
                     [target performSelectorOnMainThread:completeAction withObject:nil waitUntilDone:NO];
                     break;
                 }
                 default:
                 {
                     NSNumber* statusCode = [NSNumber numberWithLong:httpResponse.statusCode];
                     NSString* errorString = [NSString stringWithFormat:@"%@",statusCode];
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




+ (NSError *) getUserMyProfile:(DBUser *)user andPassword:(NSString *)password withTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    // Create returnError
    NSError* returnError = nil;
    
    // Create String URL
    NSString* stringURL = [NSString stringWithFormat:@"%@%@%@",kWebServiceBase,kWebServiceUsers,kWebServiceMyProfile];
    
    // Create URL
    NSURL *registerUserURL = [NSURL URLWithString:stringURL];
    
    // Create and configure URLRequest
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:registerUserURL
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:120.0];
    
    [request setValue:@"application/vnd.InkIt.v1+json" forHTTPHeaderField:@"Accept"];
    
    // Specify that it will be a POST request
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Convert your data and set your request's HTTPBody property
    NSDictionary* jsonDataDictionary = @{kAccessToken : user.token,
                                         @"*first_name": user.name ,
                                         @"*last_name" : user.lastName,
                                         @"*profile_pic" : user.userImage,
                                         @"*gender" : user.gender,
                                         @"*password" : password,
                                         @"*profile_url" : @"profile URL"
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
             //NSError *error = nil;
             
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


+ (NSError *)getInk:(DBInk *)ink withTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    // Create returnError
    NSError* returnError = nil;
    
    // Create String URL
    NSString* stringURL = [NSString stringWithFormat:@"%@%@%@",kWebServiceBase,kWebServiceInks,kWebServiceGetInk];
    
    // Create URL
    NSURL *registerUserURL = [NSURL URLWithString:stringURL];
    
    // Create and configure URLRequest
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:registerUserURL
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:120.0];
    
    [request setValue:@"application/vnd.InkIt.v1+json" forHTTPHeaderField:@"Accept"];
    
    // Specify that it will be a POST request
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Convert your data and set your request's HTTPBody property
    NSDictionary* jsonDataDictionary = @{
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
             //NSError *error = nil;
             
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
