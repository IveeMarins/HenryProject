//
//  MyPoint.m
//  Henry & The Lantern of Fears
//
//  Created by Haroldo Olivieri on 2/7/15.
//  Copyright (c) 2015 ABHI. All rights reserved.
//

#import "MyPoint.h"

@implementation MyPoint
- (id) init{
    self = [super init];
    _myPoint = CGPointZero;
    return self;
}

- (id) Init:(CGPoint) point{
    _myPoint.x = point.x;
    _myPoint.y = point.y;
    
    return self;
}

- (BOOL)isEqual:(id)anObject{
    
    MyPoint * point = (MyPoint*) anObject;
    return CGPointEqualToPoint(_myPoint, point->_myPoint);
}

@end