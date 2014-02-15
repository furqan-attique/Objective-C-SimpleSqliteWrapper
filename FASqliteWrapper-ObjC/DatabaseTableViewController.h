//
//  DatabaseTableViewController.h
//  FASqliteWrapper-ObjC
//
//  Created by Furqan on 2/14/14.
//  Copyright (c) 2014 InnovativeApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatabaseTableViewController : UIViewController <UITableViewDataSource>

@property(nonatomic,weak) IBOutlet UITableView *data_tableview;

-(IBAction)addNewRecord:(id)sender;


@end
