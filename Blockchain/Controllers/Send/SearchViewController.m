//
//  SearchViewController.m
//  Blockchain
//
//  Created by Tuannq on 5/8/17.
//  Copyright © 2017 Tuannq. All rights reserved.
//

#import "SearchViewController.h"
#import "ContactTableViewCell.h"


@interface SearchViewController ()
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [CommonUtils setBorderTextfield:self.searchView];
    self.searchView.layer.cornerRadius = 10;
    self.conntentView.layer.cornerRadius = 10;
    self.displayView.layer.cornerRadius = 10;
    [CommonUtils setBorderTextfield:self.conntentView];
    [CommonUtils setBorderTextfield:self.displayView];
    [CommonUtils setBorderTextfield:self.nameView];
    [CommonUtils setBorderTextfield:self.addressView];
    self.scrollView.layer.cornerRadius = 10;
    

    contactList = [[NSMutableArray alloc] init];
    [self.tfSearch addTarget:self action:@selector(textfieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    dbManager = [[DBManager alloc] initWithDatabaseFilename:@"woecdb1.sqlite"];
    // self.dbManager=[[DBManager alloc]init];
//    [self executeQueryInsert];
    
    [self initDisplayView:YES status:SearchStateNormal];
    [self loadDataInfor];
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    if (contactList.count == 0 && self.tfSearch.text.length > 0) {
        [rightUtilityButtons sw_addUtilityButtonWithColor:
         [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                    title:@"Add"];
    }else {
    
        [rightUtilityButtons sw_addUtilityButtonWithColor:
         [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                    title:@"Edit"];
        [rightUtilityButtons sw_addUtilityButtonWithColor:
         [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Delete"];
    }
    return rightUtilityButtons;
}


-(void) loadDataInfor{
    // Form the query.
    NSString *query = @"SELECT * FROM Contact";
    [dbManager loadDataFromDB:query successBlock:^(NSArray *responseList) {
        [self setContactToList:responseList];
        [self.tableView reloadData];
    } failure:^(NSInteger failureCode) {
//        [CommonUtils showCPOMessage:MSG_ERROR_STATEMENT_QUERY];
        if (failureCode == 1) {
            [self executeQueryCreateTable];
        }
    }];
}

-(void) loadDataLike:(NSString *)value successBlock:(void(^)())successBlock failure:(void(^)(NSInteger failureCode))failure{
    
    // Form the query.
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM Contact WHERE (address LIKE '%%%@%%') OR (name LIKE '%%%@%%')", value,value];
    [dbManager loadDataFromDB:query successBlock:^(NSArray *responseList) {
        [self setContactToList:responseList];
        [self.tableView reloadData];
        if (successBlock) {
            successBlock();
        }
    } failure:^(NSInteger failureCode) {
        [CommonUtils showCPOMessage:MSG_ERROR_STATEMENT_QUERY];
        if (failure) {
            failure(failureCode);
        }
    }];
}

-(void) setContactToList:(NSArray *)arr{
    [contactList removeAllObjects];
    for (int i = 0; i < arr.count; i++) {
//        NSLog(@"%@",arr[i]);
        NSArray *arrObj = [arr[i] copy];
        Contact *contactObj = [[Contact alloc] init];
        contactObj.name = arrObj[0];
        contactObj.address = arrObj[1];
        contactObj.captcha = arrObj[2];
        [contactList addObject:contactObj];
    }
}

-(void) executeQueryInsert:(NSString *)name address:(NSString *)address{
    NSString *query= [NSString stringWithFormat:@"INSERT INTO Contact VALUES ('%@','%@','Arsenal')", name, address];
//    [dbManager executeQuery:query];
    [dbManager executeQuery:query successBlock:^(NSInteger successBlock) {
        [self loadDataLike:self.tfSearch.text successBlock:nil failure:nil];
    } failure:^(NSInteger failureCode) {
        [CommonUtils showCPOMessage:MSG_ERROR_STATEMENT_QUERY];
    }];
}


/**
 Update function

 @param contact Obj
 */
-(void) executeQueryUpdate:(Contact * ) contact{
    NSString *query= [NSString stringWithFormat:@"UPDATE Contact SET Name='%@' WHERE address='%@';", contact.name, contact.address];
//    [dbManager executeQuery:query];
    [dbManager executeQuery:query successBlock:^(NSInteger successBlock) {
        [self replace:contactModify];
        [self.tableView reloadData];
    } failure:^(NSInteger failureCode) {
        [CommonUtils showCPOMessage:MSG_ERROR_STATEMENT_QUERY];
    }];
    
}

//Replace object in array
- (void)replace:(Contact *)contact{
    for (int i = 0; i< contactList.count; i++) {
        if ([contactList containsObject:contact]) {
            [contactList replaceObjectAtIndex:i withObject:contact];
        }
    }
}

-(void) executeQueryDelete:(NSString *) name indexRow:(NSInteger)row {
//    NSString *query=@"DELETE FROM Contact WHERE Name='5';";
    NSString *query= [NSString stringWithFormat:@"DELETE FROM Contact WHERE Name='%@'", name];
//    [dbManager executeQuery:query];
    [dbManager executeQuery:query successBlock:^(NSInteger successBlock) {
        [contactList removeObjectAtIndex:row];
        [self.tableView reloadData];
    } failure:^(NSInteger failureCode) {
        [CommonUtils showCPOMessage:MSG_ERROR_STATEMENT_QUERY];
    }];
    
}
-(void) executeQueryCreateTable{
    NSString *query = @"CREATE TABLE Contact (name varchar(255) NOT NULL , address varchar(255) NOT NULL , captcha varchar(255) NOT NULL )";
    [dbManager executeQuery:query successBlock:^(NSInteger successBlock) {
        [self executeQueryInsert:@"woeccompany" address:@"CDUo7oDJ7aB7ezaT4kMWWE9P1tV3FgKzna9vgNgm91Yc4r5EzCtMDz52zFyjwodWAdUFYL2ye5UkTCA4rg9bWc6rM6PiGhR"];
        [self executeQueryInsert:@"viet anh" address:@"CFnNbvWTap9U5Uud7dW3L92xEwtT4B3GngDGhQ8SUfeiQGMk1dbFqdaSsPiAEXxobEPoV54h429Wj4jATtLi4AxbKzyUafM"];
        [self loadDataInfor];
    } failure:^(NSInteger failureCode) {
        [CommonUtils showCPOMessage:MSG_ERROR_STATEMENT_QUERY];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 Cancel action

 @param sender <#sender description#>
 */
- (IBAction)cancelAction:(id)sender {
    [self initDisplayView:YES status:SearchStateNormal];
    [self.btnClose setTitle:@"Close" forState:UIControlStateNormal];
}

- (void) initDisplayView:(BOOL) isHidden status:(NSInteger) status{
    self.tableView.hidden = !isHidden;
    self.editView.hidden = isHidden;
    statusScreen = status;
    self.btnCancel.hidden = isHidden;
    self.searchView.userInteractionEnabled = isHidden;
}

- (IBAction)closeAction:(id)sender {
    if (statusScreen == SearchStateNormal) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {
        if (![self validateFormTransfer]) {
            return;
        }
        
        if (statusScreen == SearchStateAdd) {
            [self executeQueryInsert:self.tfName.text address:self.tfAddress.text];
        }else{
            contactModify.name = self.tfName.text;
            [self executeQueryUpdate:contactModify];
        }
        self.searchView.userInteractionEnabled = YES;
        [self.btnClose setTitle:@"Close" forState:UIControlStateNormal];
        [self initDisplayView:YES status:SearchStateNormal];
    }
}
- (IBAction)scanQrCodeAction:(id)sender {
    [CommonUtils showActionSheet:self firstButton:^{
        [CommonUtils gotoQRcoode:self];
    } secondButton:^{
        [CommonUtils openLocalPhotoAlbum:self];
    }];
}

#pragma mark - QRCodeReader Delegate Methods
- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    [self dismissViewControllerAnimated:YES completion:^{
//        NSLog(@"%@", result);
        self.tfSearch.text = result;
        [self loadDataLike:result successBlock:nil failure:nil];
    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark : Asset picker controller
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    __block UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (!image){
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0)
    {
        //ios8.0之后支持
        __weak __typeof(self) weakSelf = self;
        [LBXScanNative recognizeImage:image success:^(NSArray<LBXScanResult *> *array) {
            [weakSelf scanResultWithArray:array];
        }];
    }
    else
    {
        [CommonUtils showCPOMessage:@"App not support for IOS 8 "];
    }
}

- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array
{
    if (array.count < 1)
    {
        [CommonUtils showCPOMessage:@"Not result"];
        
        return;
    }
    
    //Get value image
    for (LBXScanResult *result in array) {
        
        NSLog(@"scanResult:%@",result.strScanned);
        self.tfSearch.text = result.strScanned;
        [self loadDataLike:result.strScanned successBlock:nil failure:nil];
    }
    
    if (!array[0].strScanned || [array[0].strScanned isEqualToString:@""] ) {
        
        [CommonUtils showCPOMessage:@"Not result"];
        return;
    }
    //    LBXScanResult *scanResult = array[0];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (contactList.count == 0 && self.tfSearch.text.length > 0) {
        return 1;
    }
    return contactList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (BOOL) validateFormTransfer {
    if (![CommonUtils validateBlank:self.tfName.text]) {
        [CommonUtils showCPOMessage:[NSString stringWithFormat:MSG_ERROR_TEXTFIELD_EMPTY, @"Name"]];
        return NO;
    }
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSString *cellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld",(long)indexPath.section, (long)indexPath.row];
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:kVC_ContactTableViewCell owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.delegate = self;
    }
    [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:60];
    Contact *contactObj;
    if (contactList.count == 0 && self.tfSearch.text.length > 0) {
        contactObj = [[Contact alloc] init];
        contactObj.address = self.tfSearch.text;
    }else {
        contactObj = [self getContactInArray:contactList atIndex:indexPath.row];
    }
    
    [cell setModel:contactObj];
    return cell;
}

#pragma mark - SWTableViewDelegate
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    // Delete and restore file in Search deleted document (result search)
    switch (index) {
        case 0: {
            if (contactList.count == 0  && self.tfSearch.text.length > 0) {
                NSLog(@"Add new");
                self.searchView.userInteractionEnabled = NO;
                
                [self initDisplayView:NO status:SearchStateAdd];
                
                self.tfAddress.text = self.tfSearch.text;
                self.tfAddress.enabled = NO;
                
            }else {
                // Edit at row
                NSLog(@"Edit");
                [self initDisplayView:NO status:SearchStateEdit];
                 contactModify = [self getContactInArray:contactList atIndex:[self.tableView indexPathForCell:cell].row];
                self.tfName.text = contactModify.name;
                self.tfAddress.text = contactModify.address;
                self.tfAddress.enabled = NO;
                
            }
            [self.btnClose setTitle:@"Save" forState:UIControlStateNormal];
            break;
        }
        case 1: {
            // Delete button was pressed
            LEAlertController *alertController = [CommonUtils showAlertConfirm:MSG_CONFIRM_DELETE cancelButton:^{
                NSLog(@"cancel button pressed");
            } okButton:^{
                Contact *contactObj = [self getContactInArray:contactList atIndex:[self.tableView indexPathForCell:cell].row];
                [self executeQueryDelete:contactObj.name indexRow:[self.tableView indexPathForCell:cell].row];

            }];
            [self presentAlertController:alertController animated:YES completion:nil];
            
            break;
        }
        default:
            break;
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
    // allow just one cell's utility button to be open at once
    return YES;
}

- (void)swipeableTableViewCellDidEndScrolling:(SWTableViewCell *)cell{
    
}


- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state {
    //    disable seleted item in list view
    cell.accessoryType = UITableViewCellAccessoryNone;
    switch (state) {
        case 1:
            // set to NO to disable all left utility buttons appearing
            return NO;
            break;
        case 2:
            // set to NO to disable all right utility buttons appearing
            return YES;
            break;
        default:
            break;
    }
    return YES;
}


//dismiss flick menu
- (void)dismissFlickMenu: (UITableView *) tableview {
    for (SWTableViewCell *cell in [tableview visibleCells]) {
        [cell hideUtilityButtonsAnimated:YES];
    }
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (statusScreen == SearchStateNormal && contactList.count > 0) {
        Contact *contactObj = [self getContactInArray:contactList atIndex:indexPath.row];
        if (self.searchBlock) {
            self.searchBlock(contactObj);
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (Contact *)getContactInArray:(NSMutableArray*)contactArr atIndex:(NSInteger)index{
    if (index < contactArr.count) {
        return [contactArr objectAtIndex:index];
    }
    return nil;
}

#pragma mark UITextFieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.tfSearch resignFirstResponder];
    return YES;
}

//change the tableView contents based on string entered.
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    NSLog(@"shouldChangeCharactersInRange");
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
//    NSLog(@"textFieldDidEndEditing");
}

- (void)textfieldDidChange:(UITextField *)textField{
    NSLog(@"textfieldDidChange");
    if (textField.text.length > 0) {
        [self loadDataLike:textField.text successBlock:^{
            [self.tableView reloadData];
        } failure:nil];
    }else {
        [self loadDataInfor];
    }
}

@end
