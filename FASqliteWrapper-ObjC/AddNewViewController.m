//
//  AddNewViewController.m
//  FASqliteWrapper-ObjC
//
//  Created by Furqan on 2/15/14.
//  Copyright (c) 2014 InnovativeApps. All rights reserved.
//

#import "AddNewViewController.h"
#import "FASQLiteDB.h"

@interface AddNewViewController ()

@end

@implementation AddNewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (self.isEditMode)
    {
        if (self.person)
        {
            self.name_text.text = self.person.name;
            self.email_text.text = self.person.email;
            [self.addnew_btn setTitle:@"Update" forState:UIControlStateNormal];
        }
    }
}


-(IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(IBAction)addingNewRecord:(id)sender
{
    if (self.name_text.text.length > 0 && self.email_text.text.length > 0)
    {
        
    
        FASQLiteDB *fasqlitedb = [FASQLiteDB sharedInstance];
        NSString *querystring;
        if (self.isEditMode)
            querystring = [NSString stringWithFormat:@"UPDATE userdata SET name='%@',email='%@' WHERE name='%@' AND email='%@'",self.name_text.text,self.email_text.text,self.person.name,self.person.email];
        else
            querystring = [NSString stringWithFormat:@"INSERT INTO userdata (name,email) VALUES ('%@','%@')",self.name_text.text,self.email_text.text];
        BOOL isSuccessful = [fasqlitedb executeQuery:querystring];
        NSLog(@"record added  %i:",isSuccessful);
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Empty Field" message:@"Please Enter Values!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
