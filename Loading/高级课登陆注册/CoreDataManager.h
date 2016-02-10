//
//  CoreDataManager.h
//  CoreData
//
//  Created by Stephen on 15/12/2.
//  Copyright © 2015年 Stephen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#define kCoreDataName @"_______"

@interface CoreDataManager : NSObject
/**
 *  CoreDataManager单例方法
 *
 *  @return
 */
+ (CoreDataManager *)shareCoreDataManager;

// 数据管理器（管理对象上下文） *****
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
// 数据模型器
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
// 数据连接器
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

// 保存上下文
- (void)saveContext;
// 获取沙盒路径
- (NSURL *)applicationDocumentsDirectory;

- (void)saveusername:(NSString *)username
            password:(NSString *)password
           telephone:(NSNumber *)telephone;
- (NSArray *)select:(NSString *)select;
@end
