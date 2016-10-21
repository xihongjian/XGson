//
//  DataObj.m
//  Pods
//
//  Created by xpg on 16/10/21.
//
//

#import "DataObj.h"

@implementation DataObj

//有数组必须实现该函数。函数名称一定要写对 "get_变量名首字母大写_class"。
- (Class)get_Objs_class
{
    return [DataInfo class];
}


@end




@implementation DataInfo

- (id)initWithID:(NSNumber*)nid{
    self = [super init];
    if (self) {
        self.myid = nid;
    }
    
    return self;
}

@end
