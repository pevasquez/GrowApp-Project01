//
//  TextFieldTableViewCell.h
//  Inkit
//
//  Created by Cristian Pena on 5/15/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TextFieldTableViewCellDelegate;

@interface TextFieldTableViewCell : UITableViewCell
@property (strong, nonatomic) NSIndexPath* indexPath;
@property (strong, nonatomic) NSString* text;
@property (strong, nonatomic) NSString* placeholder;
@property (weak, nonatomic) id <TextFieldTableViewCellDelegate> delegate;
@end

@protocol TextFieldTableViewCellDelegate <NSObject>

- (void)textFieldTableViewCell:(TextFieldTableViewCell *)cell didFinishEnteringText:(NSString *)text;

@optional
- (void)textFieldTableViewCellDidBeginEditing:(TextFieldTableViewCell *)cell;

@end
