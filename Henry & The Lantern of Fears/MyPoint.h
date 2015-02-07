//
//  MyPoint.h
//  Henry & The Lantern of Fears
//
//  Created by Haroldo Olivieri on 2/7/15.
//  Copyright (c) 2015 ABHI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface MyPoint:NSObject

@property CGPoint myPoint;

- (id) init;
- (id) Init:(CGPoint) point;
- (BOOL)isEqual:(id)anObject;

@end