//
//  Ghost.m
//  Henry & The Lantern of Fears
//
//  Created by Adriano Alves Ribeiro Gonçalves on 1/26/15.
//  Copyright (c) 2015 ABHI. All rights reserved.
//

#import "Ghost.h"
#import "Henry.h"

@implementation Ghost

+(id)ghost
{
    
    
    SKSpriteNode *ghost = [Ghost spriteNodeWithImageNamed:@"ghost"];
    
    ghost.size = CGSizeMake(61,62);
    
    ghost.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:23];
    ghost.physicsBody.affectedByGravity = NO;
    ghost.physicsBody.allowsRotation = NO;
    
    
    return ghost;
}

-(void)attackPlayer:(Henry *)henry
{
    
    SKAction *sequence = [SKAction sequence:@[[SKAction rotateByAngle:M_PI duration:1], [SKAction moveBy:CGVectorMake(-(self.position.x - henry.position.x),-(self.position.y - henry.position.y)) duration:2],[SKAction moveBy:CGVectorMake(0,0) duration:0]]];
    [self runAction:[SKAction repeatActionForever:sequence]];
    
    
    
}


@end
