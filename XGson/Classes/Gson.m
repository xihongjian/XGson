//
//  Gson.m
//  LoveStudy
//
//  Created by xpg on 14/11/3.
//  Copyright (c) 2014年 xpg. All rights reserved.
//

#import "Gson.h"
//#import "LLDefines.h"
#import <objc/runtime.h>

//动态数组对象的类名。
#define ARRAY_M         @"__NSArrayM"

//动态字典对象类名称。
#define DICTIONARY_M    @"__NSDictionaryM"

//解除PerformSelector函数调用警告
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)


@implementation Gson

+ (id) objectWithName:(NSString*)name;
{
    Class tClass = NULL;
    //NSLog(@"name:%@", name);
    id ret = nil;
    @try {
        tClass = NSClassFromString(name);
        ret = [[tClass alloc] init];
    }
    @catch (NSException *exception) {
        //Handle an exception thrown in the @try block
        NSLog(@"NSException:%@", exception);
        return nil;
    }
    @finally {
        //Code that gets executed whether or not an exception is thrown
    }
    
    return ret;
}

+ (id) objectWithClass:(Class)oclass;
{
    Class tClass = NULL;
    id ret = nil;
    @try {
        tClass = oclass;
        ret = [[tClass alloc] init];
    }
    @catch (NSException *exception) {
        //Handle an exception thrown in the @try block
        NSLog(@"NSException:%@", exception);
        return nil;
    }
    @finally {
        //Code that gets executed whether or not an exception is thrown
    }
    
    return ret;
}


//用字典对象填充一个实体类对象。
+ (void) fillObjectWithDictionary:(NSMutableDictionary*)dict Object:(id)obj
{
    if (obj == nil || dict == nil) {
        NSLog(@"obj or dict is error.");
        return;
    }
    
    NSMutableDictionary* tDict = dict, *ttDict = nil;
    NSArray* keys = [tDict allKeys];
    NSString* tstrMothed = nil;
    id tobj = nil;
    id tPropertyObj = nil;  //成员变量对象。
    for (int i = 0; i < [keys count]; ++i) {
        tstrMothed = [NSString stringWithFormat:@"set%@:", [[keys objectAtIndex:i] capitalizedString]];
//        if ([ID_KEY compare:[keys objectAtIndex:i]] == 0) {
//            tstrMothed = [NSString stringWithFormat:@"setM%@:", [keys objectAtIndex:i]];
//        }
        //NSLog(@"%@", tstrMothed);
        //数组字段的处理**************begin。
        if ([[tDict objectForKey:[keys objectAtIndex:i]] isKindOfClass:NSClassFromString(ARRAY_M)]) {
            NSMutableArray* tObjs = [tDict objectForKey:[keys objectAtIndex:i]];
            NSMutableArray* tArray = [[NSMutableArray alloc] init];
            for (int j = 0; j < [tObjs count]; ++j) {
                //NSLog(@"%@", [tObjs objectAtIndex:j]);
                //NSLog(@"%@", [[tObjs objectAtIndex:j] class]);
                //假如说是对象那么递归处理。
                if ([[tObjs objectAtIndex:j] isKindOfClass:NSClassFromString(DICTIONARY_M)]) {
                    ttDict = [tObjs objectAtIndex:j];
                    tobj = [Gson objectWithName:[ttDict objectForKey:CLASS_NAME]];
                    [Gson fillObjectWithDictionary:ttDict Object:tobj];
                    //NSLog(@"%@", tobj);
                    [tArray addObject:tobj];
                }
            }
            //NSLog(@"this is array.");
            tPropertyObj = tArray;
        }
        //数组字段的处理**************end。
        //字典字段的处理**************begin。
        else if ([[tDict objectForKey:[keys objectAtIndex:i]] isKindOfClass:NSClassFromString(DICTIONARY_M)]) {
            ttDict = [tDict objectForKey:[keys objectAtIndex:i]];
            tobj = [Gson objectWithName:[ttDict objectForKey:CLASS_NAME]];
            [Gson fillObjectWithDictionary:ttDict Object:tobj];
            tPropertyObj = tobj;
        }
        //字典字段的处理**************end。
        else{
            tPropertyObj = [tDict objectForKey:[keys objectAtIndex:i]];
        }
        
        //给类对象赋值。
        SEL tMothed = NSSelectorFromString(tstrMothed);
        if ([obj respondsToSelector:tMothed]) {
            //NSLog(@"send: %@", tstrMothed);
            SuppressPerformSelectorLeakWarning([obj performSelector:tMothed withObject:tPropertyObj]);
        }
    }
}

+ (void) fillObjectWithDictionary1:(NSMutableDictionary*)dict Object:(id)obj
{
    if (obj == nil || dict == nil) {
        NSLog(@"obj or dict is error.");
        return;
    }
    
    NSMutableDictionary* tDict = dict, *ttDict = nil;
    NSArray* keys = [tDict allKeys];
    NSString* tstrMothed = nil;
    id tobj = nil;
    id tPropertyObj = nil;  //成员变量对象。
    for (int i = 0; i < [keys count]; ++i) {
        tPropertyObj = nil;
        tobj = nil;
        tstrMothed = [NSString stringWithFormat:@"set%@:", [[keys objectAtIndex:i] capitalizedString]];
        //        if ([ID_KEY compare:[keys objectAtIndex:i]] == 0) {
        //            tstrMothed = [NSString stringWithFormat:@"setM%@:", [keys objectAtIndex:i]];
        //        }
        //NSLog(@"%@", tstrMothed);
        //NSLog(@"%@", [[tDict objectForKey:[keys objectAtIndex:i]] class]);
        //数组字段的处理**************begin。
        if ([[tDict objectForKey:[keys objectAtIndex:i]] isKindOfClass:NSClassFromString(ARRAY_M)]) {
            SEL SelGetClass = NSSelectorFromString([NSString stringWithFormat:@"get_%@_class", [[keys objectAtIndex:i] capitalizedString]]);
            
            //NSLog(@"%@", [NSString stringWithFormat:@"get_%@_class", [[keys objectAtIndex:i] capitalizedString]]);
            
            if (obj && [obj respondsToSelector:SelGetClass]) {
                _Pragma("clang diagnostic push")
                _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")
                Class objclass = [obj performSelector:SelGetClass];
                _Pragma("clang diagnostic pop")
                NSMutableArray* tObjs = [tDict objectForKey:[keys objectAtIndex:i]];
                NSMutableArray* tArray = [[NSMutableArray alloc] init];
                for (int j = 0; j < [tObjs count]; ++j) {
                    //NSLog(@"%@", [tObjs objectAtIndex:j]);
                    //NSLog(@"%@", [[tObjs objectAtIndex:j] class]);
                    //假如说是对象那么递归处理。
                    if ([[tObjs objectAtIndex:j] isKindOfClass:NSClassFromString(DICTIONARY_M)]) {
                        ttDict = [tObjs objectAtIndex:j];
//                        tobj = [Gson objectWithName:[ttDict objectForKey:CLASS_NAME]];
                        tobj = [Gson objectWithClass:objclass];
                        [Gson fillObjectWithDictionary1:ttDict Object:tobj];
                        //NSLog(@"%@", tobj);
                        [tArray addObject:tobj];
                    }else{
                        [tArray addObject:[tObjs objectAtIndex:j]];
                    }
                }
                //NSLog(@"this is array.");
                tPropertyObj = tArray;
                
            }
        }
        //数组字段的处理**************end。
        //字典字段的处理**************begin。
        else if ([[tDict objectForKey:[keys objectAtIndex:i]] isKindOfClass:NSClassFromString(DICTIONARY_M)]) {
            NSString* strType = [Gson getTypeName:obj Name:[keys objectAtIndex:i]];
            if (strType != nil) {
                ttDict = [tDict objectForKey:[keys objectAtIndex:i]];
                tobj = [Gson objectWithName:strType];
                [Gson fillObjectWithDictionary1:ttDict Object:tobj];
            }
            tPropertyObj = tobj;
            
        }
        //字典字段的处理**************end。
        else{
            tPropertyObj = [tDict objectForKey:[keys objectAtIndex:i]];
        }
        
        //给类对象赋值。
        SEL tMothed = NSSelectorFromString(tstrMothed);
        if ([obj respondsToSelector:tMothed]) {
            //NSLog(@"send: %@", tstrMothed);
            SuppressPerformSelectorLeakWarning([obj performSelector:tMothed withObject:tPropertyObj]);
        }
    }
}

+ (id) fromJsonWithString:(NSString*)strJson ObjClass:(Class)objclass
{
    NSData *tData = [strJson dataUsingEncoding:NSUTF8StringEncoding];
    
    return [Gson fromJsonWithData:tData ObjClass:objclass];
}


+ (id) fromJsonWithData:(NSData *)dataJson ObjClass:(Class)objclass
{
    NSError* err;
    NSMutableDictionary *tDict = [NSJSONSerialization JSONObjectWithData:dataJson options:NSJSONReadingMutableContainers error:&err];
    if (err) {
        NSLog(@"prosses json error... %@", err.domain);
        return nil;
    }
    
    //首先找到最外层对象的类名，然后创建类对象
    id ret = [Gson objectWithClass:objclass];
    
    //NSLog(@"%@", ret);
    
    //[Gson fillObjectWithDictionary:tDict Object:ret];
    [Gson fillObjectWithDictionary1:tDict Object:ret];
    
    //NSLog(@"######%@", tDict);
    
    return ret;
}

+ (id) fromJsonWithString:(NSString*)strJson
{
    NSData *tData = [strJson dataUsingEncoding:NSUTF8StringEncoding];
    
    return [Gson fromJsonWithData:tData];
}

+ (id) fromJsonWithData:(NSData *)dataJson
{
    NSError* err;
    NSMutableDictionary *tDict = [NSJSONSerialization JSONObjectWithData:dataJson options:NSJSONReadingMutableContainers error:&err];
    if (err) {
        NSLog(@"prosses json error... %@", err.domain);
        return nil;
    }
    
    //首先找到最外层对象的类名，然后创建类对象
    id ret = [Gson objectWithName:[tDict objectForKey:CLASS_NAME]];
    
    //NSLog(@"%@", ret);
    
    [Gson fillObjectWithDictionary:tDict Object:ret];

    //NSLog(@"######%@", tDict);
    
    return ret;
}


#pragma mark To Json
+ (BOOL) isSDKObject:(const char*)name
{
    char tName[3] = {0,};
    memcpy(tName, name, 2);
    tName[2] = '\0';
    //NSLog(@"%s", tName);
    return strcmp(tName, "NS")?FALSE:TRUE;
}

+ (BOOL) isArrayObject:(const char*)name
{
    return (!strcmp(name, "NSArray") || !strcmp(name, "NSMutableArray"))?TRUE:FALSE;
}

+ (NSMutableDictionary*) makeDictFromObject:(id)obj
{
    if (obj == nil) {
        NSLog(@"obj is nil... ...");
        return nil;
    }
    
    //NSLog(@"%s", object_getClassName(obj));
    
    NSMutableDictionary* tDict = [[NSMutableDictionary alloc] init];
    
    unsigned int outCount, i, j;
    objc_property_t *properties = class_copyPropertyList([obj class], &outCount);
    char class_name[32] = {0, };
    const char* char_f = NULL;
    objc_property_t property = NULL;
    NSString *propertyName = nil;
    id propertyValue = nil;
    NSArray *tArray = nil;
    NSMutableArray* tNewArray = nil;
    id tobj = nil;
    for (i = 0; i<outCount; i++)
    {
        property = properties[i];
        char_f =property_getName(property);
        propertyName = [NSString stringWithUTF8String:char_f];
        propertyValue = [obj valueForKey:(NSString *)propertyName];
        sscanf(property_getAttributes(property), "%*[^\"]%*[\"]%[^\"]", class_name);
        
        //NSLog(@"%@ [%s] [%s] = %@", propertyName, object_getClassName(propertyValue), class_name, propertyValue);
        //先将nil的熟悉添加进去。
        if (propertyValue == nil || propertyValue == [NSNull null]) {
            //[tDict setObject:NULL forKey:propertyName];
        }
        //处理数组类型属性*****begin.
        else if([Gson isArrayObject:class_name]){
            tArray = propertyValue;
            tNewArray = [[NSMutableArray alloc] init];
            for (j = 0; j < [tArray count]; ++j) {
                tobj = [tArray objectAtIndex:j];
                [tNewArray addObject:[Gson makeDictFromObject:tobj]];
            }
            [tDict setObject:tNewArray forKey:propertyName];
        }
        //处理数组类型属性*****end.
        //处理SDK提供的类型属性****begin.
        else if ([Gson isSDKObject:class_name]) {
//            if (![propertyName compare:[NSString stringWithFormat:@"m%@", ID_KEY]]) {
//                propertyName = ID_KEY;
//            }
            [tDict setObject:propertyValue forKey:propertyName];
        }
        //处理SDK提供的类型属性****end.
        else{
            [tDict setObject:[Gson makeDictFromObject:propertyValue] forKey:propertyName];
        }
    }
    
    if (properties) {
        free(properties);
    }
    return tDict;
}

+ (NSData*) jsonFromObject:(id)obj
{
    NSData* ret = nil;
    
    NSMutableDictionary* tDict = [Gson makeDictFromObject:obj];
    
    
    //NSLog(@"%@", tDict);
    NSError* err = nil;
    ret = [NSJSONSerialization dataWithJSONObject:tDict options:NSJSONWritingPrettyPrinted error:&err];
    
    if (err != nil) {
        NSLog(@"create error... ...");
        return nil;
    }
    
    return ret;
}

+ (NSString*) getTypeName:(id)obj Name:(NSString*)vName
{
    if (!obj) {
        return NULL;
    }
    
    unsigned int numIvars = 0;
    Ivar *vars = class_copyIvarList([obj class], &numIvars);

    NSString *tName = [NSString stringWithFormat:@"_%@", vName];
    NSString *name = nil;
    NSString *type = nil;
    NSString *retType = nil;
    for(int i = 0; i < numIvars; i++) {
        
        Ivar thisIvar = vars[i];
        name = [NSString stringWithUTF8String:ivar_getName(thisIvar)];  //获取成员变量的名字
        //NSLog(@"variable name :%@", name);
        type = [[[NSString stringWithUTF8String:ivar_getTypeEncoding(thisIvar)] stringByReplacingOccurrencesOfString:@"\"" withString:@""] stringByReplacingOccurrencesOfString:@"@" withString:@""]; //获取成员变量的数据类型
        //NSLog(@"variable type :%@", type);
        
        if (![tName compare:name]) {
            retType = type;
            break;
        }
    }
    
    free(vars);
    
    return retType;
}


+ (void) testGson
{
    //[Gson fromJsonWithString:@"{\"classes\":[{\"name\":\"驯龙记第二季\",\"id\":2,\"order\":1,\"imageurl\":\"http://192.168.1.103:8088/lovestudy/classes/test_class_01/201309301533396718.jpg\",\"descr\":\"\",\"courses\":null,\"insti\":null,\"cname\":\"XClass\"},{\"name\":\"驯龙记第二季\",\"id\":2,\"order\":2,\"imageurl\":\"http://192.168.1.103:8088/lovestudy/classes/test_class_01/201309301533396718.jpg\",\"descr\":\"\",\"courses\":null,\"insti\":null,\"cname\":\"XClass\"},{\"name\":\"驯龙记第二季\",\"id\":2,\"order\":3,\"imageurl\":\"http://192.168.1.103:8088/lovestudy/classes/test_class_01/201309301533396718.jpg\",\"descr\":\"\",\"courses\":null,\"insti\":null,\"cname\":\"XClass\"},{\"name\":\"驯龙记第二季\",\"id\":2,\"order\":4,\"imageurl\":\"http://192.168.1.103:8088/lovestudy/classes/test_class_01/201309301533396718.jpg\",\"descr\":\"\",\"courses\":null,\"insti\":null,\"cname\":\"XClass\"}],\"status\":0,\"cname\":\"ClassList\"}"];
    
}

@end
