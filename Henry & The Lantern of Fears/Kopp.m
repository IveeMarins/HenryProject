//
//  Kopp.m
//  Henry & The Lantern of Fears
//
//  Created by Adriano Alves Ribeiro Gonçalves on 1/25/15.
//  Copyright (c) 2015 ABHI. All rights reserved.
//

#import "Kopp.h"
#import "Henry.h"

@implementation Kopp

+(id)kopp:(Henry *)henry
{
    Kopp *kopp = [Kopp spriteNodeWithImageNamed: @"kopp"];
    kopp.size = CGSizeMake(50, 50);
    kopp.name = @"kopp";
    [henry addChild:kopp];
    kopp.position = CGPointMake(-henry.frame.size.width * 0.5 -kopp.frame.size.width + 15, 30);
    return kopp;
}



@end
