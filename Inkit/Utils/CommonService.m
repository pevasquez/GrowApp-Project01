//
//  CommonService.m
//  Inkit
//
//  Created by Cristian Pena on 4/11/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "CommonService.h"
#import "InkitServiceConstants.h"
#import "DataManager.h"

@implementation CommonService
+ (NSError *)getBodyPartsWithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{    
    // Create returnError
    NSError* returnError = nil;
    
    // Create String URL
    NSString* stringURL = [NSString stringWithFormat:@"%@%@%@",kWebServiceBase,kWebServiceStatics,kWebServiceBodyParts];
    
    // Create URL
    NSURL *registerUserURL = [NSURL URLWithString:stringURL];
    
    // Create and configure URLRequest
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:registerUserURL
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:120.0];
    
    [request setValue:@"application/vnd.InkIt.v1+json" forHTTPHeaderField:@"Accept"];
    
    // Specify that it will be a POST request
    [request setHTTPMethod:@"GET"];
    
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
                     [DataManager loadBodyPartsFromJson:responseDictionary];
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

+ (NSError *)getTattooStylesWithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    NSError* returnError = nil;

    return returnError;

}

+ (NSError *)getTattooTypesWithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    // Create returnError
    NSError* returnError = nil;
    
    // Create String URL
    NSString* stringURL = [NSString stringWithFormat:@"%@%@%@",kWebServiceBase,kWebServiceStatics,kWebServiceTattooTypes];
    
    // Create URL
    NSURL *registerUserURL = [NSURL URLWithString:stringURL];
    
    // Create and configure URLRequest
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:registerUserURL
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:120.0];
    
    [request setValue:@"application/vnd.InkIt.v1+json" forHTTPHeaderField:@"Accept"];
    
    // Specify that it will be a POST request
    [request setHTTPMethod:@"GET"];
    
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
                     [DataManager loadTattooTypesFromJson:responseDictionary];
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

@end
