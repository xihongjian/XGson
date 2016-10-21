//
//  GsonTest.m
//  Pods
//
//  Created by xpg on 16/10/21.
//
//

#import "GsonTest.h"
#import "Gson.h"
#import "DataObj.h"

@implementation GsonTest


+ (void)test{

    //对象转字符串
    DataObj *obj = [[DataObj alloc] init];
    obj.myid = [NSNumber numberWithInt:100];
    obj.name = [NSString stringWithFormat:@"test name"];
    NSMutableArray* objs = [[NSMutableArray alloc] init];
    for (int i = 0; i < 10; ++i) {
        [objs addObject:[[DataInfo alloc] initWithID:[NSNumber numberWithInt:i]]];
    }
    obj.objs = objs;
    
    NSData *jsonData = [Gson jsonFromObject:obj];
    NSString *strJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", strJson);
    
    DataObj *dobj = [Gson fromJsonWithData:jsonData ObjClass:[DataObj class]];
    
    NSLog(@"name = %@", dobj.name);

}

@end
