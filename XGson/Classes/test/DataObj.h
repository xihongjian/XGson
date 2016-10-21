//
//  DataObj.h
//  Pods
//
//  Created by xpg on 16/10/21.
//
//

#import <Foundation/Foundation.h>

@interface DataInfo : NSObject

- (id)initWithID:(NSNumber*)nid;

@property (strong, nonatomic) NSNumber* myid;

@end

@interface DataObj : NSObject

//数值变量必须用NSNumber
@property (strong, nonatomic) NSNumber* myid;
@property (strong, nonatomic) NSString* name;

@property (strong, nonatomic) NSArray* objs;

@end
