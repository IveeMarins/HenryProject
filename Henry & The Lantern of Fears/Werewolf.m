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
    
    Werewolf *werewolf = [Werewolf spriteNodeWithColor:[UIColor purpleColor] size:CGSizeMake(20, 20)];
    
    werewolf.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:werewolf.size];
    werewolf.physicsBody.affectedByGravity = NO;
    werewolf.physicsBody.allowsRotation = NO;
    werewolf.name = @"werewolf";
    [werewolf move];
    
    return werewolf;
}
-(void)move
{
        
        SKAction *runWithLimits = [SKAction sequence:@[[SKAction moveByX:self.position.x - 200 y:0 duration:4],
                                                       [SKAction moveByX:self.position.y + 200 y:0 duration:4]]];
        
        
        [self runAction: [SKAction repeatActionForever:runWithLimits]];
    
        
}
   


@end
