//
//  Gson.h
//  LoveStudy
//
//  Created by xpg on 14/11/3.
//  Copyright (c) 2014年 xpg. All rights reserved.
//

#import <Foundation/Foundation.h>

/**由于json本来就是在java scrip技术上作出来的东西。所以在java上进行转换时非常方便的。
 *在oc中可以做到对象跟json串之间的转换，但是也有很多的局限。尽管如此，该工具也会减少
 *可观的代码编写。
 */

/**
 *使用该类进行json到对象转换时必须遵循以下约定。
 *1.所有的对象中均要包含类名字段  “cname” ，值必须区分大小写
 *2.所有类中如果出现“id”的请写成mid。在解析的时候会自动转变。
 *3.除1，2特殊约定外实体类变量名已定要跟json中的字段名一一对应，区分大小写。
 *4.不可以用技术类型做为变量，（int， char， long  等等）必须用类。
 *使用该类进行对象到json转换时必须遵循以下约定。
 *1.父类的属性将不会被反射出来,所以最好不要使用父类的属性。［有点遗憾］
 *2.在init函数中对各个变量进行初始化。［也可以不初始化，但那样不是很完美。］
 *注意：该类使用了ios提供的json解析api所以只能使用在ios5.0及以上版本，
 低版本可以自行适配。
 */

//json对象中关于类名的表示字段，
#define CLASS_NAME      @"cname"

////假如字段名是“id”的话特殊处理变成“mid”
//#define ID_KEY          @"id"


@interface Gson : NSObject

////使用json字符串来解析。
//+ (id) fromJsonWithString:(NSString*)strJson;
//
////使用NSData对象来解析。
//+ (id) fromJsonWithData:(NSData *)dataJson;

//
+ (id) fromJsonWithString:(NSString*)strJson ObjClass:(Class)objclass;
//
+ (id) fromJsonWithData:(NSData *)dataJson ObjClass:(Class)objclass;


//将实体类封装成json串。
+ (NSData*) jsonFromObject:(id)obj;

//+ (NSString*) jsonStringFromObject:(id)obj;


+ (void) testGson;

@end
