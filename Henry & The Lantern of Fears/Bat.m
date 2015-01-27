//
//  Bat.m
//  Henry & The Lantern of Fears
//
//  Created by Adriano Alves Ribeiro Gonçalves on 1/23/15.
//  Copyright (c) 2015 ABHI. All rights reserved.
//

#import "Bat.h"
#import "Henry.h"

@implementation Bat

+(id)bat
{
    
    SKSpriteNode *bat = [Bat spriteNodeWithImageNamed:@"bat"];
    
    bat.size = CGSizeMake(61, 38);
    
    bat.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:15];
    bat.physicsBody.affectedByGravity = NO;
    bat.physicsBody.allowsRotation = NO;
    
    
    return bat;
}

-(void)attackPlayer:(Henry *)henry
{
    
    SKAction *chasePlayer = [SKAction repeatActionForever:[SKAction moveTo:henry.position duration:2]];
    [self runAction:chasePlayer];
    
    
    
}


@end