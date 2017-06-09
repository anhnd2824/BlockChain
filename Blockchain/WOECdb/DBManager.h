//
//  DBManager.h
//  Blockchain
//
//  Created by Tuannq on 5/8/17.
//  Copyright © 2017 Tuannq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject

// đường dẫn đến thư mục documents
@property (nonatomic, strong) NSString *documentsDirectory;
// tên file + đuôi file
@property (nonatomic, strong) NSString *databaseFilename;

@property (nonatomic, strong) NSMutableArray *arrColumnNames;// lưu lại tổng số cột trong một bảng
@property (nonatomic) int affectedRows;// trả về số lượng hàng bị ảnh hưởng.
@property (nonatomic) long long lastInsertedRowID;// trả vê ID

@property (nonatomic, strong) NSMutableArray *arrResults;

-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename;

- (void)loadDataFromDB:(NSString *)query successBlock:(void(^)(NSArray *responseList))successBlock failure:(void(^)(NSInteger failureCode))failure;// Truy vấn có đọc dữ liệu ra
- (void)executeQuery:(NSString *)query successBlock:(void(^)(NSInteger successBlock))successBlock failure:(void(^)(NSInteger failureCode))failure;// chỉ truy vấn không đọc dữ liệu

@end
