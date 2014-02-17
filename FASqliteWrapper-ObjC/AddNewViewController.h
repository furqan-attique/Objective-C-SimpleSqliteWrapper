//
//  AddNewViewController.h
//  FASqliteWrapper-ObjC
//
//  Created by Furqan on 2/15/14.
//  Copyright (c) 2014 InnovativeApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"

@interface AddNewViewController : UIViewController <UITextFieldDelegate>

@property(nonatomic,weak)IBOutlet UITextField *name_text;
@property(nonatomic,weak)IBOutlet UITextField *email_text;
@property(nonatomic,weak)IBOutlet UIButton *addnew_btn;


//@property (nonatomic,strong) NSString *name;
//@property (nonatomic,strong) NSString *email;
@property (nonatomic,weak) Person *person;


@property BOOL isEditMode;

-(IBAction)addingNewRecord:(id)sender;

-(IBAction)back:(id)sender;

@end
