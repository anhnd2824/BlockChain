//
//  DBManager.m
//  Blockchain
//
//  Created by Tuannq on 5/8/17.
//  Copyright © 2017 Tuannq. All rights reserved.
//

#import "DBManager.h"
#import <sqlite3.h>

@implementation DBManager

-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename{
    self = [super init];
    if (self) {
        // Lấy đường dẫn đến thư mục documents, Kết quả trả về mảng có một phần tử!
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        // đường dẫn gán vào property documentsDirectory
        self.documentsDirectory = [paths objectAtIndex:0];
        
        // Tên file được gán vào property databaseFilename
        self.databaseFilename = dbFilename;
        
        // sao chép file ở source code vào trong Thư mục documents
        [self copyDatabaseIntoDocumentsDirectory];
    }
    return self;
}

-(void)copyDatabaseIntoDocumentsDirectory{
    // Lấy đường dẫn cụ thể đến file đích bao gồm đường dẫn documents+ tên file + đuôi file
    NSString *destinationPath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    // Kiểm tra nếu file chưa tồn tại thì cho phép sao chép
    if (![[NSFileManager defaultManager] fileExistsAtPath:destinationPath]) {
        NSLog(@"file chưa tồn tại! Thực hiện sao chép");
        // Đường dẫn file ở trong source code
        NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseFilename];
        NSError *error;// tạo một đối tượng error kiểm tra khi đang sao chép có sinh ra lỗi không
        // sao chép file từ sourcePath -> documents
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destinationPath error:&error];
        
        // Nếu có lỗi sao chép đưa ra thông báo!
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }else{// ngược lại file đã tồn tại và không cần sao chép gì cả!
        NSLog(@"file đã tồn tại");
    }
}

//-(NSArray *)loadDataFromDB:(NSString *)query{
//    
//    [self runQuery:[query UTF8String] isQueryExecutable:NO];
//    
//    return (NSArray *)self.arrResults;
//}

/**
 Select Query
 
 @param query :query sql
 @param successBlock success Block
 @param failure failur block
 */
- (void)loadDataFromDB:(NSString *)query successBlock:(void(^)(NSArray *responseList))successBlock failure:(void(^)(NSInteger failureCode))failure{
    [self selectQuery:[query UTF8String] successBlock:^(NSArray *responseList) {
        if (successBlock) {
            successBlock(responseList);
        }
    } failure:^(NSInteger failureCode) {
        if (failure) {
            failure(failureCode);
        }
    }];
    
}


/**
 Update , delete , Insert Query

 @param query <#query description#>
 @param successBlock <#successBlock description#>
 @param failure <#failure description#>
 */
- (void)executeQuery:(NSString *)query successBlock:(void(^)(NSInteger successBlock))successBlock failure:(void(^)(NSInteger failureCode))failure{
    
//    [self runQuery:[query UTF8String] isQueryExecutable:YES];
    [self modifyData:[query UTF8String] successBlock:^(NSInteger successCode) {
        if (successBlock) {
            successBlock(successCode);
        }
    } failure:^(NSInteger failureCode) {
        if (failure) {
            failure(failureCode);
        }
    }];
    
}


-(void)selectQuery:(const char *)query successBlock:(void(^)(NSArray *responseList))compiletion failure:(void(^)(NSInteger failureCode))failure {
    // Khởi tạo một đối tượng của class sqlite.
    sqlite3 *sqlite3Database;
    // Lấy đường dẫn đích đến file.sqlite
    NSString *databasePath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    
    // Khởi tạo mảng kết quả
    if (self.arrResults != nil) {// nếu mảng tồn tại(lưu) đối tượng
        [self.arrResults removeAllObjects];//xoá tất cả đối tượng
        self.arrResults = nil;// set về nil
    }
    
    // khởi tạo lại vùng nhớ cho mảng
    self.arrResults = [[NSMutableArray alloc] init];
    
    // Tương tự đối với mảng chứa các trường tên cột
    if (self.arrColumnNames != nil) {
        [self.arrColumnNames removeAllObjects];
        self.arrColumnNames = nil;
    }
    self.arrColumnNames = [[NSMutableArray alloc] init];
    
    
    // Mở cơ sở dữ liệu
    // truyền vào 2 tham số đường dẫn đích đến file định dạng UTF8, Đối tượng sqlite
    BOOL openDatabaseResult = sqlite3_open([databasePath UTF8String], &sqlite3Database);
    if(openDatabaseResult == SQLITE_OK) {
        // nếu mở csdl thành công
        // Đối tượng lưu trữ các truy vấn prepare statement
        sqlite3_stmt *compiledStatement;
        
        // Chuyển đổi câu truy vấn ở định dạng chuỗi sang câu truy vấn mà sqlite3 có thể nhận dạng được!
        // các tham số truyền vào đối tượng sqlite3, câu truy vấn,Lấy độ dài câu truy vấn, ở đây -1 độ dài tuỳ ý, đối tượng sqlite3_stmt lưu trữ truy vấn, Con trỏ trỏ tới phần chưa sử dụng của câu truy vấn Sql.
        // sau khi chuyển đổi câu truy vấn được lưu lại trong compiledStatement
        BOOL prepareStatementResult = sqlite3_prepare_v2(sqlite3Database, query, -1, &compiledStatement, NULL);
        // Nếu câu truy vấn được chuyển đổi thành công sang dạng sqlite nhận dạng đc.
        if(prepareStatementResult == SQLITE_OK) {
                // Tạo một mảng lưu lại thông tin truy vấn!
                NSMutableArray *arrDataRow;
                
                // Thực thi truy vấn cho phép đọc thành công!
                while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                    // Khởi tạo mảng.
                    arrDataRow = [[NSMutableArray alloc] init];
                    
                    // trả về tổng số cột
                    int totalColumns = sqlite3_column_count(compiledStatement);
                    
                    //lặp hết các cột
                    for (int i = 0; i<totalColumns; i++){
                        // Trả về nội dung một cột kiểu char
                        char *dbDataAsChars = (char *)sqlite3_column_text(compiledStatement, i);
                        
                        // If there are contents in the currenct column (field) then add them to the current row array.
                        if (dbDataAsChars != NULL) {
                            // chuyển đổi định sang kiểu string
                            [arrDataRow addObject:[NSString  stringWithUTF8String:dbDataAsChars]];
//                            NSLog(@"%s", dbDataAsChars);
                        }
                        
                        // Lưu tên của các cột !
                        if (self.arrColumnNames.count != totalColumns) {
                            dbDataAsChars = (char *)sqlite3_column_name(compiledStatement, i);
                            [self.arrColumnNames addObject:[NSString stringWithUTF8String:dbDataAsChars]];
                        }
                    }
                    
                    // Store each fetched data row in the results array, but first check if there is actually data.
                    if (arrDataRow.count > 0) {// môt đối tượng trong arrResults là một mảng!.
                        [self.arrResults addObject:arrDataRow];
                    }
                }
            if (compiletion) {
                compiletion(self.arrResults);
            }
        }
        else {
            // In the database cannot be opened then show the error message on the debugger.
            // Nếu xảy ra lỗi mô tả sqlite.
            NSLog(@"%s", sqlite3_errmsg(sqlite3Database));
            if (failure) {
                failure(sqlite3_errcode(sqlite3Database));
            }
        }
        
        // Giải phóng một truy vấn được chuẩn bị
        sqlite3_finalize(compiledStatement);
        
    }
    
    // Đóng lại CSDL
    sqlite3_close(sqlite3Database);
}

/**
 Modify data

 @param query : query sql
 @param successBlock :success code
 @param failure : failure
 */
-(void)modifyData:(const char *)query successBlock:(void(^)(NSInteger successCode))successBlock failure:(void(^)(NSInteger failureCode))failure {
    // Khởi tạo một đối tượng của class sqlite.
    sqlite3 *sqlite3Database;
    // Lấy đường dẫn đích đến file.sqlite
    NSString *databasePath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    
    // Khởi tạo mảng kết quả
    if (self.arrResults != nil) {// nếu mảng tồn tại(lưu) đối tượng
        [self.arrResults removeAllObjects];//xoá tất cả đối tượng
        self.arrResults = nil;// set về nil
    }
    
    // khởi tạo lại vùng nhớ cho mảng
    self.arrResults = [[NSMutableArray alloc] init];
    
    // Tương tự đối với mảng chứa các trường tên cột
    if (self.arrColumnNames != nil) {
        [self.arrColumnNames removeAllObjects];
        self.arrColumnNames = nil;
    }
    self.arrColumnNames = [[NSMutableArray alloc] init];
    
    
    // Mở cơ sở dữ liệu
    // truyền vào 2 tham số đường dẫn đích đến file định dạng UTF8, Đối tượng sqlite
    BOOL openDatabaseResult = sqlite3_open([databasePath UTF8String], &sqlite3Database);
    if(openDatabaseResult == SQLITE_OK) {
        sqlite3_stmt *compiledStatement;
        BOOL prepareStatementResult = sqlite3_prepare_v2(sqlite3Database, query, -1, &compiledStatement, NULL);
        // Nếu câu truy vấn được chuyển đổi thành công sang dạng sqlite nhận dạng đc.
        if(prepareStatementResult == SQLITE_OK) {
                // Execute the query.
                int executeQueryResults = sqlite3_step(compiledStatement);
                if (executeQueryResults == SQLITE_DONE) {
                    // Nếu truy vấn thành công "chỉ truy vấn không đọc dữ liệu".
                    //                    // Trả về  số lượng hàng bị ảnh hưởng.
                    //                    self.affectedRows = sqlite3_changes(sqlite3Database);
                    //
                    //                    // trả về số đối tượng được chèn vào ở dòng cuối cùng.
                    //                    self.lastInsertedRowID = sqlite3_last_insert_rowid(sqlite3Database);
                    if (successBlock) {
                        successBlock(sqlite3_errcode(sqlite3Database));
                    }
                }
                else {
                    // Lỗi mô tả sqlite.
                    NSLog(@"DB Error: %s", sqlite3_errmsg(sqlite3Database));
                    if (failure) {
                        failure(sqlite3_errcode(sqlite3Database));
                    }
                }
        }
        else {
            // Nếu xảy ra lỗi mô tả sqlite.
            NSLog(@"%s", sqlite3_errmsg(sqlite3Database));
            if (failure) {
                failure(sqlite3_errcode(sqlite3Database));
            }
        }
        
        // Giải phóng một truy vấn được chuẩn bị
        sqlite3_finalize(compiledStatement);
        
    }
    
    // Đóng lại CSDL
    sqlite3_close(sqlite3Database);
}


// Chuẩn mở file sqlite và truy vấn sqlite
// truyền vào 2 tham số : câu truy vấn và đối tượng bool để kiểm tra: update,delete, insert, create không lấy dữ liệu ra,chỉ truy vấn: Trích lọc lấy dữ liệu truy vấn và lấy ra bảng dữ liệu.
// ở đây mình truyền vào kiểu char bởi vì Sqlite không biết NSString là gì, chỉ cho phép làm việc với char
-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable{
    // Khởi tạo một đối tượng của class sqlite.
    sqlite3 *sqlite3Database;
    // Lấy đường dẫn đích đến file.sqlite
    NSString *databasePath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    
    // Khởi tạo mảng kết quả
    if (self.arrResults != nil) {// nếu mảng tồn tại(lưu) đối tượng
        [self.arrResults removeAllObjects];//xoá tất cả đối tượng
        self.arrResults = nil;// set về nil
    }
    
    // khởi tạo lại vùng nhớ cho mảng
    self.arrResults = [[NSMutableArray alloc] init];
    
    // Tương tự đối với mảng chứa các trường tên cột
    if (self.arrColumnNames != nil) {
        [self.arrColumnNames removeAllObjects];
        self.arrColumnNames = nil;
    }
    self.arrColumnNames = [[NSMutableArray alloc] init];
    
    
    // Mở cơ sở dữ liệu
    // truyền vào 2 tham số đường dẫn đích đến file định dạng UTF8, Đối tượng sqlite
    BOOL openDatabaseResult = sqlite3_open([databasePath UTF8String], &sqlite3Database);
    if(openDatabaseResult == SQLITE_OK) {
        // nếu mở csdl thành công
        // Đối tượng lưu trữ các truy vấn prepare statement
        sqlite3_stmt *compiledStatement;
        
        // Chuyển đổi câu truy vấn ở định dạng chuỗi sang câu truy vấn mà sqlite3 có thể nhận dạng được!
        // các tham số truyền vào đối tượng sqlite3, câu truy vấn,Lấy độ dài câu truy vấn, ở đây -1 độ dài tuỳ ý, đối tượng sqlite3_stmt lưu trữ truy vấn, Con trỏ trỏ tới phần chưa sử dụng của câu truy vấn Sql.
        // sau khi chuyển đổi câu truy vấn được lưu lại trong compiledStatement
        BOOL prepareStatementResult = sqlite3_prepare_v2(sqlite3Database, query, -1, &compiledStatement, NULL);
        // Nếu câu truy vấn được chuyển đổi thành công sang dạng sqlite nhận dạng đc.
        if(prepareStatementResult == SQLITE_OK) {
            // Kiểm tra nếu truyền vào QueryExecutable NO thì ta cần trích lọc dữ liệu , đọc dữ liệu ra.
            if (!queryExecutable){
                // Tạo một mảng lưu lại thông tin truy vấn!
                NSMutableArray *arrDataRow;
                
                // Thực thi truy vấn cho phép đọc thành công!
                while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                    // Khởi tạo mảng.
                    arrDataRow = [[NSMutableArray alloc] init];
                    
                    // trả về tổng số cột
                    int totalColumns = sqlite3_column_count(compiledStatement);
                    
                    //lặp hết các cột
                    for (int i=0; i<totalColumns; i++){
                        // Trả về nội dung một cột kiểu char
                        char *dbDataAsChars = (char *)sqlite3_column_text(compiledStatement, i);
                        
                        // If there are contents in the currenct column (field) then add them to the current row array.
                        if (dbDataAsChars != NULL) {
                            // chuyển đổi định sang kiểu string
                            [arrDataRow addObject:[NSString  stringWithUTF8String:dbDataAsChars]];
//                            NSLog(@"%s", dbDataAsChars);
                        }
                        
                        // Lưu tên của các cột !
                        if (self.arrColumnNames.count != totalColumns) {
                            dbDataAsChars = (char *)sqlite3_column_name(compiledStatement, i);
                            [self.arrColumnNames addObject:[NSString stringWithUTF8String:dbDataAsChars]];
                        }
                    }
                    
                    // Store each fetched data row in the results array, but first check if there is actually data.
                    if (arrDataRow.count > 0) {// môt đối tượng trong arrResults là một mảng!.
                        [self.arrResults addObject:arrDataRow];
                    }
                }
                NSLog(@"%lu", (unsigned long)self.arrResults.count);
            }
            else {
                // Nếu chỉ truy vấn Update , Delete, insert không cần đưa ra dữ liệu
                
                // Execute the query.
                int executeQueryResults = sqlite3_step(compiledStatement);
                if (executeQueryResults == SQLITE_DONE) {
                    // Nếu truy vấn thành công "chỉ truy vấn không đọc dữ liệu".
                    //                    // Trả về  số lượng hàng bị ảnh hưởng.
                    //                    self.affectedRows = sqlite3_changes(sqlite3Database);
                    //
                    //                    // trả về số đối tượng được chèn vào ở dòng cuối cùng.
                    //                    self.lastInsertedRowID = sqlite3_last_insert_rowid(sqlite3Database);
                }
                else {
                    // Lỗi mô tả sqlite.
                    NSLog(@"DB Error: %s", sqlite3_errmsg(sqlite3Database));
                }
            }
        }
        else {
            // In the database cannot be opened then show the error message on the debugger.
            // Nếu xảy ra lỗi mô tả sqlite.
            NSLog(@"%s", sqlite3_errmsg(sqlite3Database));
        }
        
        // Giải phóng một truy vấn được chuẩn bị
        sqlite3_finalize(compiledStatement);
        
    }
    
    // Đóng lại CSDL
    sqlite3_close(sqlite3Database);
}



@end
