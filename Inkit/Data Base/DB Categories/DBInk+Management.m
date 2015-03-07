//
//  DBInk+Management.m
//  Inkit
//
//  Created by Cristian Pena on 6/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "DBInk+Management.h"
#import "InkitService.h"
#import "DBBodyPart+Management.h"
#import "DBTattooType+Management.h"
#import "DBComment+Management.h"

#define kDBInk     @"DBInk"

@implementation DBInk (Management)

+ (DBInk *)createInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    DBInk* ink = [NSEntityDescription insertNewObjectForEntityForName:kDBInk inManagedObjectContext:managedObjectContext];
    ink.inkDescription = @"";
    // Save context
    NSError* error = nil;
    [managedObjectContext save:&error];
    return ink;
}

+ (DBInk *)createWithImage:(UIImage *)image AndDescription:(NSString *)description InManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    DBInk* ink = [DBInk createInManagedObjectContext:managedObjectContext];
    ink.inkImage = image;
    ink.inkDescription = description;
    
    // Save context
    NSError* error = nil;
    [managedObjectContext save:&error];

    return ink;
}

- (UIImage *)getInkImage
{
    UIImage* inkImage = self.inkImage;
    return inkImage;
}

- (NSString *)getBodyPartsAsString
{
    NSString* bodyParts = @"";
    for (DBBodyPart* bodyPart in self.ofBodyParts) {
        bodyParts = [bodyParts stringByAppendingString:[NSString stringWithFormat:@"%@, ",bodyPart.name]];
    }
    return bodyParts;
}

- (NSString *)getTattooTypesAsString
{
    NSString* tattooTypes = @"";
    for (DBTattooType* tattooType in self.ofTattooTypes) {
        tattooTypes = [tattooTypes stringByAppendingString:[NSString stringWithFormat:@"%@, ",tattooType.name]];
    }
    return tattooTypes;
}

- (void)postWithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    [InkitService postInk:self WithTarget:target completeAction:completeAction completeError:completeError];
    [self saveManagedObjectContext];
}

- (void)addCommentWithText:(NSString *)text forUser:(DBUser *)user
{
    DBComment* comment = [DBComment createCommentWithText:text inManagedObjectContext:self.managedObjectContext];
    comment.ofUser = self.user;
    [self addHasCommentsObject:comment];

    // Save context
    NSError* error = nil;
    [self.managedObjectContext save:&error];
}

- (void)saveManagedObjectContext
{
    // Save context
    NSError* error = nil;
    [self.managedObjectContext save:&error];
}
@end
