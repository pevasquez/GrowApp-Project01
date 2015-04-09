//
//  InkitService.m
//  Inkit
//
//  Created by Cristian Pena on 5/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "InkitService.h"
#import "InkitDataUtil.h"
#import "AppDelegate.h"
#import "UserService.h"
#import "InkService.h"
#import "BoardService.h"
#import "DBBodyPart+Management.h"
#import "DBTattooType+Management.h"
#import "DBUser+Management.h"
#import "InkitServiceConstants.h"


@implementation InkitService

+ (NSError *)logInUser:(DBUser *)user withTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    return [UserService logInUser:user withTarget:target completeAction:completeAction completeError:completeError];
}

+ (NSError *)logInUser:(DBUser *)user WithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    NSError* returnError = nil;

    return returnError;
}


+ (NSError *)registerUser:(DBUser *)user WithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    return [UserService registerUser:user withTarget:target completeAction:completeAction completeError:completeError];
}


+ (NSError *)logInUserWithToken:(NSString *)token WithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    NSError* returnError = nil;
    
    // Get ManagedObjectContext from AppDelegate
    NSManagedObjectContext* managedObjectContext = ((AppDelegate*)([[UIApplication sharedApplication] delegate] )).managedObjectContext;
    
    DBUser* user = [DBUser createMockUserInManagedObjectContext:managedObjectContext];
    
    [InkitDataUtil sharedInstance].activeUser = user;
    
    // Call complete Action
    [target performSelectorOnMainThread:completeAction withObject:nil waitUntilDone:NO];
    
    return returnError;
}

+ (NSError *) logOutUser:(DBUser *)user WithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    return [UserService logOutUser:user withTarget:target completeAction:completeAction completeError:completeError];
}

+ (NSError *)getBodyPartsWithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    NSError* returnError = nil;
    
    // Get ManagedObjectContext from AppDelegate
    NSManagedObjectContext* managedObjectContext = ((AppDelegate*)([[UIApplication sharedApplication] delegate] )).managedObjectContext;
    
    // Creat Mock Body Parts
    [DBBodyPart createMockBodyPartsInManagedObjectContext:managedObjectContext];
    
    // Call complete Action
    [target performSelectorOnMainThread:completeAction withObject:nil waitUntilDone:NO];
    
    return returnError;
}

+ (NSError *)getTattooTypesWithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    NSError* returnError = nil;
    
    // Get ManagedObjectContext from AppDelegate
    NSManagedObjectContext* managedObjectContext = ((AppDelegate*)([[UIApplication sharedApplication] delegate] )).managedObjectContext;
    
    // Creat Mock Body Parts
    [DBTattooType createMockTattooTypesInManagedObjectContext:managedObjectContext];
    
    // Call complete Action
    [target performSelectorOnMainThread:completeAction withObject:nil waitUntilDone:NO];
    
    return returnError;
}

+ (NSError *)postInk:(DBInk *)ink WithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    NSError* returnError = nil;

    //return [InkService createInk:ink forUser:ink.user inBoard:ink.inBoard withTarget:target completeAction:completeAction completeError:completeError];

    // Call complete Action
    [target performSelectorOnMainThread:completeAction withObject:ink waitUntilDone:NO];
    
    return returnError;
}

+ (NSError *)postBoard:(DBBoard *)board WithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    NSError* returnError = nil;
    
//     Create Ink in DB
//    
//     Call complete Action
    [target performSelectorOnMainThread:completeAction withObject:board waitUntilDone:NO];
    
    return returnError;
    
    //return [BoardService createBoard:board withTarget:target completeAction:completeAction completeError:completeError];
}

+ (NSError *)getBoardsWithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    NSError* returnError = nil;

    // Call complete Action
    [target performSelectorOnMainThread:completeAction withObject:nil waitUntilDone:NO];
    
    return returnError;
}

+ (NSError *)postComment:(DBComment*)comment withTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    NSError* returnError = nil;
    
    // Call complete Action
    [target performSelectorOnMainThread:completeAction withObject:nil waitUntilDone:NO];
    
    return returnError;
}
+ (NSError *)getShopsWithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{


        // Create returnError
        NSError* returnError = nil;
        
        // Create String URL
        NSString* stringURL = [NSString stringWithFormat:@"%@%@%@",kWebServiceBase,kWebServiceUsers,kWebServiceProfileAccesToken];
        
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
        NSDictionary* jsonDataDictionary = @{@"access_token" : @"",
                                             @"user_id" : @"",
                                             @"accept" : @""
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
                 NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:NSJSONReadingMutableContainers
                                                                                      error:&error];
                 // Check Response's StatusCode
                 switch (httpResponse.statusCode) {
                     case kHTTPResponseCodeOK:
                     {
                         // Acá va a ir el código para el caso de éxito
                         if ([responseDictionary objectForKey:@"shop"]) {
                             for (NSDictionary* shopDictionary in responseDictionary[@"shop"]) {
                                 // [DBShop fromJson(shopDictionary)]
                             }
                             [target performSelectorOnMainThread:completeAction withObject:nil waitUntilDone:NO];
                         } else {
                             [target performSelectorOnMainThread:completeError withObject:nil waitUntilDone:NO];
                         }
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

+ (NSError *)getDashboardInksWithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    return [InkService getDashboardInksWithTarget:target completeAction:completeAction completeError:completeError];
}

+ (NSError *)getArtistsForSearchString:(NSString *)searchString withTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    return [InkService getArtistsForSearchString:searchString withTarget:target completeAction:completeAction completeError:completeError];
}

@end
