//
//  EditTextViewController.m
//  Inkit
//
//  Created by Cristian Pena on 12/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "EditTextViewController.h"

@interface EditTextViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@end

@implementation EditTextViewController

#pragma mark - Lyfe cicle methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.textString) {
        self.textView.text = self.textString;
    }
    [self.textView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)doneButtonPressed:(UIBarButtonItem *)sender
{
    [self.delegate didFinishEnteringText:self.textView.text];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
