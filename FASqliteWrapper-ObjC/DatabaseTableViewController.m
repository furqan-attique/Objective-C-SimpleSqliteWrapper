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
#import "Person.h"


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
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7)
    {
        self.data_tableview.contentInset = UIEdgeInsetsZero;    //UIEdgeInsetsMake(-20, 0, 0, 0);
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.data_tableview registerNib:[UINib nibWithNibName:@"DatabaseTableViewCell" bundle:nil] forCellReuseIdentifier:DATATABLEVIEWCELL_IDENTIFIER];
    
    FASQLiteDB *fasqlitedb = [FASQLiteDB sharedInstance];
    [fasqlitedb setupDatabaseWithDBFile:@"mydb33"]; //Sqlite Database File name without extension
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateDataModel];
}

-(void)updateDataModel
{
    FASQLiteDB *fasqlitedb = [FASQLiteDB sharedInstance];
    NSArray *records = [fasqlitedb executeSelectQuery:@"SELECT * FROM userdata"];
    NSLog(@"records : %@",records);
    if (records)
    {
        [self.records_arr removeAllObjects];
        
        for (NSDictionary *record in records) {
            
            Person *newPerson = [[Person alloc]initWithDictionary:record];
            [self.records_arr addObject:newPerson];
        }
        [self.data_tableview reloadData];
    }
    
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
    
    Person *person = [self.records_arr objectAtIndex:indexPath.row];
    cell.name_label.text = person.name;
    cell.email_label.text = person.email;
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.records_arr.count > 0)
    {
        AddNewViewController *addnewVC = [[AddNewViewController alloc]initWithNibName:@"AddNewViewController" bundle:nil];
        addnewVC.isEditMode = YES;
        Person *person = [self.records_arr objectAtIndex:indexPath.row];
        addnewVC.person = person;
        [self presentViewController:addnewVC animated:YES completion:nil];
    
    }

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
