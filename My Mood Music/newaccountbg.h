//
//  newaccountbg.h
//  My Mood Music
//
//  Created by Kartik Sawant on 10/25/14.
//  Copyright (c) 2014 Kartik Sawant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface newaccountbg : UIViewController {
//    sqlite3 *my_dbname;
}
/*@property (retain,nonatomic) NSString *databaseName, *tableName;
@property (readwrite,nonatomic) NSMutableArray *dataList;
@property (readwrite,nonatomic) BOOL table_ok, db_open_status;
@property (retain,nonatomic) NSArray *my_columns_names;

- (IBAction)saveButton:(id)sender;
- (BOOL)openDBwithSQLName:(NSString *)sqlname;
- (BOOL)createTable:(NSString *)tablename WithColumns:(NSArray *)columnNames;
- (BOOL)addItemstoTable:(NSString *)usetable WithColumnValues:(NSDictionary *) valueObject;
- (void)closeDB;*/
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *confirmpassword;
@property (weak, nonatomic) IBOutlet UITextField *year;
@property (nonatomic) int recordIDToEdit;


- (IBAction)confirmpasswords:(id)sender;
@end
