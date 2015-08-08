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

@implementation UserService

+ (void)registerUserDictionary:(NSDictionary *)userDictionary withCompletion:(ServiceResponse)completion {
    // Create String URL
    NSString* stringURL = [NSString stringWithFormat:@"%@%@%@%@",kWebServiceBase,kWebServiceAuthorization,kWebServiceRegister,kWebServiceUser ];
    
    // Create URL
    NSURL *registerUserURL = [NSURL URLWithString:stringURL];
    
    // Create and configure URLRequest
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:registerUserURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120.0];
    
    [request setValue:@"application/vnd.InkIt.v1+json" forHTTPHeaderField:@"Accept"];
    
    // Specify that it will be a POST request
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSError *error = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:userDictionary options:NSJSONWritingPrettyPrinted error:&error];
    [request setHTTPBody: jsonData];

    NSURLSession* session = [NSURLSession sharedSession];
    NSURLSessionTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!error) {
            // Cast Response
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            // Check Response's StatusCode
            switch (httpResponse.statusCode) {
                case kHTTPResponseCodeOK: {
                    // Acá va a ir el código para el caso de éxito
                    DBUser* user = [DBUser fromJson:responseDictionary];
                    [user updateWithJson:userDictionary];
                    [DataManager sharedInstance].activeUser = user;
                    [DataManager saveContext];
                    completion(nil, nil);
                    break;
                }
                case kTTPResponseCodeCreateUserFailed: {
                    if (responseDictionary[@"errors"]) {
                        if (responseDictionary[@"errors"][@"email"]) {
                            completion(((NSArray *)(responseDictionary[@"errors"][@"email"])).firstObject,[[NSError alloc] init]);
                        } else {
                            completion(@"Could not create new user.",[[NSError alloc] init]);
                        }
                    } else {
                        completion(responseDictionary[@"message"],[[NSError alloc] init]);
                    }
                    break;
                }
                default: {
                    completion(@"There was a problem",[[NSError alloc] init]);
                    break;
                }
            }
        } else {
            completion(@"There was a problem",[[NSError alloc] init]);
        }
    }];
    
    [task resume];
}

+ (void)logInUserDictionary:(NSDictionary *)userDictionary withCompletion:(ServiceResponse)completion {
    
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
    
    NSURLSession* session = [NSURLSession sharedSession];
    NSURLSessionTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
         if (!error)
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
                         DBUser* user = [DBUser fromJson:responseDictionary];
                         [user updateWithJson:userDictionary];
                         [DataManager sharedInstance].activeUser = user;
                         dispatch_async(dispatch_get_main_queue(), ^{
                             completion(nil, nil);
                         });
                     } else {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             completion(nil, [[NSError alloc] init]);
                         });

                     }
                     break;
                 }
                 default:
                 {
                     [DataManager sharedInstance].activeUser = nil;
                     if ([responseDictionary objectForKey:@"message"]) {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             completion([responseDictionary objectForKey:@"message"],[[NSError alloc] init]);
                         });
                     } else {
                         NSNumber* statusCode = [NSNumber numberWithLong:httpResponse.statusCode];
                         NSString* errorString = [NSString stringWithFormat:@"%@",statusCode];
                         dispatch_async(dispatch_get_main_queue(), ^{
                             completion(errorString,[[NSError alloc] init]);
                         });
                     }
                     break;
                 }
             }
         } else {
             dispatch_async(dispatch_get_main_queue(), ^{
                 completion(NSLocalizedString(@"No connection", nil),[[NSError alloc] init]);
             });
         }
     }];
    
    [task resume];
}

+ (void)logInSocialDictionary:(NSDictionary *)facebookDictionary withCompletion:(ServiceResponse)completion {
    
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
    
    NSDictionary* loginDictionary = @{@"social_network_id":facebookDictionary[@"social_network_id"],
                                      @"external_id":facebookDictionary[@"external_id"]};
    
    NSError *error = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:loginDictionary options:NSJSONWritingPrettyPrinted error:&error];
    
    [request setHTTPBody: jsonData];
    
    NSURLSession* session = [NSURLSession sharedSession];
    NSURLSessionTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
         if (!error)
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
                         DBUser* user = [DBUser fromJson:responseDictionary];
                         [user updateWithJson:responseDictionary];
                         [DataManager sharedInstance].activeUser = user;
                         dispatch_async(dispatch_get_main_queue(), ^{
                             completion(nil,nil);
                         });
                     } else {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             completion(nil,[[NSError alloc] init]);
                         });
                     }
                     break;
                 }
                 default:
                 {
                     [DataManager sharedInstance].activeUser = nil;
                     if ([responseDictionary objectForKey:@"message"]) {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             completion([responseDictionary objectForKey:@"message"],[[NSError alloc] init]);
                         });
                     } else {
                         NSNumber* statusCode = [NSNumber numberWithLong:httpResponse.statusCode];
                         NSString* errorString = [NSString stringWithFormat:@"%@",statusCode];
                         dispatch_async(dispatch_get_main_queue(), ^{
                             completion(errorString,[[NSError alloc] init]);
                         });
                     }
                     break;
                 }
             }
         } else {
             dispatch_async(dispatch_get_main_queue(), ^{
                 completion(NSLocalizedString(@"No connection", nil),[[NSError alloc] init]);
             });
         }
     }];
    [task resume];
}

+ (void)logOutUser:(DBUser *)user withCompletion:(ServiceResponse)completion {
    
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
    
    NSURLSession* session = [NSURLSession sharedSession];
    NSURLSessionTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
         if (!error)
         {
             // Cast Response
             NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
             
             // Check Response's StatusCode
             switch (httpResponse.statusCode) {
                 case kHTTPResponseCodeOKNoResponse:
                 {
                     // Acá va a ir el código para el caso de éxito
                     [DataManager sharedInstance].activeUser = nil;
                     dispatch_async(dispatch_get_main_queue(), ^{
                         completion(nil,nil);
                     });
                     break;
                 }
                 default:
                 {
                     NSNumber* statusCode = [NSNumber numberWithLong:httpResponse.statusCode];
                     NSString* errorString = [NSString stringWithFormat:@"%@",statusCode];
                     dispatch_async(dispatch_get_main_queue(), ^{
                         completion(errorString,[[NSError alloc] init]);
                     });
                     break;
                 }
             }
         } else {
             dispatch_async(dispatch_get_main_queue(), ^{
                 completion(NSLocalizedString(@"No connection", nil),[[NSError alloc] init]);
             });
         }
     }];
    
    [task resume];
}

@end
