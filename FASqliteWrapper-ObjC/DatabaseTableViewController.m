//
//  DatabaseTableViewController.m
//  FASqliteWrapper-ObjC
//
//  Created by Furqan on 2/14/14.
//  Copyright (c) 2014 InnovativeApps. All rights reserved.
//

#import "DatabaseTableViewController.h"
#import "DatabaseTableViewCell.h"
#import "AddNewViewController.h"
#import "FASQLiteDB.h"

NSString *const DATATABLEVIEWCELL_IDENTIFIER = @"DatabaseTableViewCell";

@interface DatabaseTableViewController ()

@property (nonatomic,strong) NSMutableArray *records_arr;

@end

@implementation DatabaseTableViewController

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
    
    self.records_arr = [[NSMutableArray alloc]init];
    [self.data_tableview registerNib:[UINib nibWithNibName:@"DatabaseTableViewCell" bundle:nil] forCellReuseIdentifier:DATATABLEVIEWCELL_IDENTIFIER];
    
    FASQLiteDB *fasqlitedb = [FASQLiteDB sharedInstance];
    [fasqlitedb setupDatabaseWithDBFile:@"mydb33"]; //Sqlite Database File name without extension
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    FASQLiteDB *fasqlitedb = [FASQLiteDB sharedInstance];
    NSArray *records = [fasqlitedb executeSelectQuery:@"SELECT * FROM userdata"];
    [self.records_arr removeAllObjects];
    [self.records_arr addObjectsFromArray:records];
    [self.data_tableview reloadData];
    NSLog(@"records : %@",records);
    
}


-(IBAction)addNewRecord:(id)sender
{
    
    AddNewViewController *addnewVC = [[AddNewViewController alloc]initWithNibName:@"AddNewViewController" bundle:nil];
    [self presentViewController:addnewVC animated:YES completion:nil];
   
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.records_arr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DatabaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DATATABLEVIEWCELL_IDENTIFIER forIndexPath:indexPath];
    
    NSArray *record = [self.records_arr objectAtIndex:indexPath.row];
    cell.name_label.text = [record objectAtIndex:0];
    cell.email_label.text = [record objectAtIndex:1];
    
    return cell;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
