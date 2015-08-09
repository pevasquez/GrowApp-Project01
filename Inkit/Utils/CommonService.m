//
//  CommonService.m
//  Inkit
//
//  Created by Cristian Pena on 4/11/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "CommonService.h"
#import "InkitServiceConstants.h"

@implementation CommonService

+ (void)getBodyPartsWithCompletion:(ServiceResponse)completion {
    
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
                     [DataManager loadBodyPartsFromJson:responseDictionary];
                     [DataManager saveContext];
                     dispatch_async(dispatch_get_main_queue(), ^{
                         completion(nil, nil);
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

+ (void)getTattooStylesWithCompletion:(ServiceResponse)completion {

}

+ (void)getTattooTypesWithCompletion:(ServiceResponse)completion {
    
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
                     [DataManager loadTattooTypesFromJson:responseDictionary];
                     [DataManager saveContext];
                     dispatch_async(dispatch_get_main_queue(), ^{
                         completion(nil, nil);
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
