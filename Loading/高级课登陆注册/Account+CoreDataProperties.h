//
//  Account+CoreDataProperties.h
//  高级课登陆注册
//
//  Created by Stephen on 15/12/14.
//  Copyright © 2015年 董强. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Account.h"

NS_ASSUME_NONNULL_BEGIN

@interface Account (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *username;
@property (nullable, nonatomic, retain) NSString *password;
@property (nullable, nonatomic, retain) NSString *telephone;

@end

NS_ASSUME_NONNULL_END
