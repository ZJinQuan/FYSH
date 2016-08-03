//
//  FyshModel.m
//
//
//  Created by star on 15/3/30.
//  Copyright (c) 2015年 tentinet. All rights reserved.
//

#import "FyshModel.h"

@implementation FyshModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if(self) {
//        self.fIndex = [[dict objectForKey:@"fIndex"] integerValue];
//        self.fColor = [dict objectForKey:@"fColor"];
//        self.imageName = [dict objectForKey:@"imageName"];
//        self.imgPath = [dict objectForKey:@"imgPath"];
//        self.distance = [dict objectForKey:@"distance"];
//        self.state = [dict objectForKey:@"state"];
//        self.isdisturb= [dict objectForKey:@"isdisturb"];
//        self.address= [dict objectForKey:@"address"];
//        self.uuid= [dict objectForKey:@"uuid"];
        
        self.fId = [dict objectForKey:@"fId"];
        self.fName = [dict objectForKey:@"fName"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[NSNumber numberWithInteger:self.fIndex] forKey:@"fIndex"];
    [aCoder encodeObject:self.fColor forKey:@"fColor"];
    [aCoder encodeObject:self.imageName forKey:@"imageName"];
    [aCoder encodeObject:self.imgPath forKey:@"imgPath"];
    [aCoder encodeObject:self.distance forKey:@"distance"];
    [aCoder encodeObject:self.state forKey:@"state"];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.fIndex  = [[aDecoder decodeObjectForKey:@"fIndex"] integerValue];
        self.fColor = [aDecoder decodeObjectForKey:@"fColor"];
        self.imageName = [aDecoder decodeObjectForKey:@"imageName"];
        self.imgPath = [aDecoder decodeObjectForKey:@"imgPath"];
        self.distance = [aDecoder decodeObjectForKey:@"distance"];
        self.state = [aDecoder decodeObjectForKey:@"state"];
    }
    return self;
}

@end
