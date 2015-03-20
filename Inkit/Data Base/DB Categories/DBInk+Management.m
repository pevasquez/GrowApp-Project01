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
    ink.inkImage = UIImagePNGRepresentation(image);
    ink.inkDescription = description;
    
    // Save context
    NSError* error = nil;
    [managedObjectContext save:&error];

    return ink;
}

- (UIImage *)getInkImage
{
    UIImage* inkImage = [UIImage imageWithData:self.inkImage];
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
    comment.ofUser = user;
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

+ (void)createMockInks:(NSManagedObjectContext *)managedObjectContext
{
    UIImage *image1 = [UIImage imageNamed:@"3dTattoo"];    
    [DBInk createWithImage:image1 AndDescription:@"Tattoo 3D en la pierna" InManagedObjectContext:managedObjectContext];

    UIImage *image2 = [UIImage imageNamed:@"blackSailsTattoo"];
    [DBInk createWithImage:image2 AndDescription:@"tattoo en pantorrilla" InManagedObjectContext:managedObjectContext];

    UIImage *image3 = [UIImage imageNamed:@"flowerTattoo"];
    [DBInk createWithImage:image3 AndDescription:@"tattoo en hombro, tribal" InManagedObjectContext:managedObjectContext];
    
    UIImage *image4 = [UIImage imageNamed:@"machinetatto"];
    [DBInk createWithImage:image4 AndDescription:@"tattoo gigante en la espalda" InManagedObjectContext:managedObjectContext];

    UIImage *image6 = [UIImage imageNamed:@"threeredpoppiestattoo"];
    [DBInk createWithImage:image6 AndDescription:@"Tattoo en el pie" InManagedObjectContext:managedObjectContext];
}

+ (NSArray *)getAllInksInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kDBInk];
    
    NSError *error;
    NSArray *matches = [managedObjectContext executeFetchRequest:request error:&error];
    NSMutableArray* inks = [[NSMutableArray alloc] init];
    
    if ([matches count]&&!error) {
        for (DBInk* ink in matches) {
            [inks addObject:ink];
        }
        return inks;
    } else {
        return nil;
    }
}

@end
