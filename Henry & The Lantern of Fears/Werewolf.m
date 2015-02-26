//
//  Werewolf.m
//  Henry & The Lantern of Fears
//
//  Created by Adriano Alves Ribeiro Gonçalves on 2/12/15.
//  Copyright (c) 2015 ABHI. All rights reserved.
//

#import "Werewolf.h"
#import "Henry.h"

@interface Werewolf ()

@property (nonatomic) BOOL attacking;


@end

@implementation Werewolf

+(id)werewolf{
    
    Werewolf *werewolf = [Werewolf spriteNodeWithImageNamed:@"werewolf"];
    werewolf.size = CGSizeMake(191,150);
    werewolf.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:werewolf.size];
    werewolf.physicsBody.allowsRotation = NO;
    werewolf.name = @"werewolf";
    [werewolf move];
    
    return werewolf;
}
-(void)move
{
    CGFloat werewolfScale = self.xScale;
    
    SKAction *runLeft = [SKAction sequence:@[[SKAction moveByX:self.position.x - 200 y:0 duration:4],
                                                  [SKAction scaleXTo:werewolfScale * -1 duration:0]]];
    
    werewolfScale = self.xScale * -1;
    
    SKAction *runRight = [SKAction sequence:@[[SKAction moveByX:self.position.x + 200 y:0 duration:4],
                                             [SKAction scaleXTo:werewolfScale * -1 duration:0]]];
    
    [self runAction: [SKAction repeatActionForever:[SKAction sequence:@[runLeft,runRight]]]];
    
        
}
   


@end
