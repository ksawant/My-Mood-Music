//
//  newaccountbg.m
//  My Mood Music
//
//  Created by Kartik Sawant on 10/25/14.
//  Copyright (c) 2014 Kartik Sawant. All rights reserved.
//

#import "newaccountbg.h"

@implementation newaccountbg
@synthesize username, password, confirmpassword, year;
@synthesize scrollview;
//@synthesize table_ok,databaseName,dataList,my_columns_names,tableName,db_open_status;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Wallpaper2.png"]];
    
    UITapGestureRecognizer * tap= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
/*    dataList = [[NSMutableArray alloc]init];
    databaseName = @"mysampledatabase";
    tableName = @"mypeople";
    db_open_status = NO;
    table_ok = NO;
    my_columns_names = [[NSArray alloc]initWithObjects:@"username",@"password",@"year", nil];
    if ([self openDBwithSQLName:databaseName]) {
        db_open_status = YES;
    }*/
    
    // Do any additional setup after loading the view.
}

/*-(IBAction)saveButton:(id)sender {
    if (table_ok) {
        if(!db_open_status) {
            [self openDBwithSQLName:databaseName];
        }
    }
    NSMutableDictionary *objectColsVals = [[NSMutableDictionary alloc]init];
    for(id aSubView in [self.view subviews]) {
        if ([aSubView isKindOfClass:[UITextField class]]) {
            [(UITextField *)aSubView isFirstResponder];
        }
        int this_tag = ((UITextField *)aSubView).tag;
        NSString *this_textValue = [(UITextField*)aSubView text];
        [objectColsVals setValue:this_textValue forKey:[my_columns_names objectAtIndex:this_tag]];
        ((UITextField *)aSubView).text = @"";
    }
    if ([[objectColsVals allKeys]count]>0) {
        if ([self addItemstoTable:tableName WithColumnValues:objectColsVals]) {
            [self closeDB];
        }
    }
    NSString *fetch_sql = [NSString stringWithFormat:@"SELECT * FROM %@",tableName];
    NSLog(@"%@",fetch_sql);
}*/

-(void) dismissKeyboard {
    [username resignFirstResponder];
    [password resignFirstResponder];
    [confirmpassword resignFirstResponder];
    [year resignFirstResponder];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    CGPoint scrollPoint = CGPointMake(0, textField.frame.origin.y);
    [scrollview setContentOffset:scrollPoint animated:YES];
}

-(void) textFieldDidEndEditing:(UITextField *)textField {
    [scrollview setContentOffset:CGPointZero animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)confirmpasswords:(id)sender {
    [self dismissKeyboard];
    if(![username.text isEqualToString:@""]) {
        if(![password.text isEqualToString:@""]) {
            if(![confirmpassword.text isEqualToString:@""]) {
                if(![year.text isEqualToString:@""]) {
                    if([password.text isEqualToString:confirmpassword.text]) {
                        NSLog(@"MATCH AND NOT EMPTY");
                        [self performSegueWithIdentifier:@"nextview" sender:sender];
                    }
                    else {
                        NSLog(@"DIFFERENT");
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                        message:@"Passwords do not match"
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                        [alert show];
                    }
                }
                else {
                    NSLog(@"EMPTY");
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:@"Year is four digits"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                }
            }
            else {
                NSLog(@"EMPTY");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"Passwords must have at least 1 character"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
        }
        else {
            NSLog(@"EMPTY");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Passwords must have at least 1 character"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    else {
        NSLog(@"EMPTY");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Username must have at least 1 character"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

//Made this to input the user into the database!!!
//This needs to happen on submit but not sure right now how to do that.
-(void)callInsertService{
	NSURL *url = [NSURL URLWithString:@"http://web.ics.purdue.edu/~bunge/mymood.php?todo=setU&username=" + username.text + "&password=" +password.text + "&year=" + year.text];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request setDidFinishSelector:@selector(requestCompleted:)];
    [request setDidFailSelector:@selector(requestError:)];
    
    [request setDelegate:self];
    [request startAsynchronous];
}

//This is to see if the user already exists in the database if it does then we need to have them make a new user.
- (void)requestCompleted:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    NSLog(@"API Response: %@", responseString);
    
    NSArray *valueArray = [responseString componentsSeparatedByString:@"|"];
    NSString *works = [valueArray objectAtIndex:0];
    
    if(![works isEqualToString:@"User exists"]){
	
	}else{
		//they need to pick a new user name
	}
    
}

/*-(BOOL)openDBwithSQLName:(NSString *)sqlname {
    BOOL is_Opened = NO;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *my_sqlfile = [[paths objectAtIndex:0]stringByAppendingPathComponent:sqlname];
    if(sqlite3_open([my_sqlfile UTF8String], &my_dbname) == SQLITE_OK) {
        is_Opened = YES;
    }
    return is_Opened;
}

-(BOOL)createTable:(NSString *)tablename WithColumns:(NSArray *)columnNames {
    BOOL has_beencreated = NO;
    NSString *fieldSet = @"";
    char *err;
    for(int a=0;a<[columnNames count];a++) {
        NSString *columnSet = [NSString stringWithFormat:@"'%@' TEXT",[columnNames objectAtIndex:a]];
        fieldSet = [fieldSet stringByAppendingString:columnSet];
        if(a<([columnNames count]-1)) {
            fieldSet = [fieldSet stringByAppendingString:@", "];
        }
    }
    NSString *sql = [NSString stringWithFormat:@"CREAT TABLE IF NOT EXISTS '%@' (ID INTEGER PRIMARY KEY AUTOINCREMENT,%@);",tableName,fieldSet];
    if(sqlite3_exec(my_dbname, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(my_dbname);
    }
    else {
        has_beencreated = YES;
    }
    return has_beencreated;
}

-(BOOL)addItemstoTable:(NSString *)usetable WithColumnValues:(NSDictionary *)valueObject{
    BOOL has_beenadded = NO;
    NSString *mycolumns = @"";
    NSString *myvalues = @"";
    for(int r=0; r<[[valueObject allKeys] count];r++) {
        NSString *this_keyname = [[valueObject allKeys]objectAtIndex:r];
        mycolumns = [mycolumns stringByAppendingString:this_keyname];
        NSString *thisval = [NSString stringWithFormat:@"'%@'",[valueObject objectForKey:this_keyname]];
        myvalues = [myvalues stringByAppendingString:thisval];
        if (r<(([[valueObject allKeys]count])-1)) {
            mycolumns = [mycolumns stringByAppendingString:@","];
            myvalues = [myvalues stringByAppendingString:@"."];
        }
    }
    NSString *myinsert = [NSString stringWithFormat:@"INSERT INTO %@ (%@)VALUES(%@)",usetable,mycolumns,myvalues];
    char *err;
    if(sqlite3_exec(my_dbname, [myinsert UTF8String], NULL, NULL, &err) != SQLITE_OK){
        sqlite3_close(my_dbname);
    }
    else {
        has_beenadded = YES;
    }
    return has_beenadded;
}

-(void)closeDB{
    sqlite3_close(my_dbname);
    db_open_status = NO;
}*/
    
@end
