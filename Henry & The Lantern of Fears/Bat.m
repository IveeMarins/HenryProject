//
//  Bat.m
//  Henry & The Lantern of Fears
//
//  Created by Adriano Alves Ribeiro Gonçalves on 1/23/15.
//  Copyright (c) 2015 ABHI. All rights reserved.
//

#import "Bat.h"
#import "Henry.h"

@implementation Bat{
    
    NSArray *_animationFrames;
}

+(id)bat
{
    
    Bat *bat = [Bat spriteNodeWithImageNamed:@"bat"];
    
    bat.size = CGSizeMake(56, 60);
    
    bat.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:15];
    bat.physicsBody.affectedByGravity = NO;
    bat.physicsBody.allowsRotation = NO;
    bat.name = @"bat";
    
    [bat animate];
    return bat;
}

-(void)attackPlayer:(Henry *)henry
{
    
    
    [self runAction:[SKAction repeatActionForever:[SKAction moveTo:henry.position duration:2]]];
    
    
    
}

-(void)animate{
    
    NSMutableArray *flyingFrames = [NSMutableArray array];
    SKTextureAtlas *flyingBatAtlas = [SKTextureAtlas atlasNamed:@"batFlying"];
    for (int i = 1; i <= flyingBatAtlas.textureNames.count; i++) {
        NSString *textureName = [NSString stringWithFormat:@"batfly%d", i];
        SKTexture *temp = [flyingBatAtlas textureNamed:textureName];
        [flyingFrames addObject:temp];
    }
    
    _animationFrames = flyingFrames;
    
    [self runAction: [SKAction repeatActionForever:[SKAction animateWithTextures:_animationFrames
                                                                    timePerFrame:0.1]]withKey:@"flyAnimation"];
}
-(void)death
{
    self.physicsBody.categoryBitMask = 0;
    self.physicsBody.collisionBitMask = 0;
    [self removeActionForKey:@"flyAnimation"];
    [self setTexture:[SKTexture textureWithImageNamed:@"batDead"]];
    
    NSString *deathSmokePath = [[NSBundle mainBundle] pathForResource:@"DyingEnemy" ofType:@"sks"];
    SKEmitterNode *deathSmoke = [NSKeyedUnarchiver unarchiveObjectWithFile:deathSmokePath];
    
    [self addChild:deathSmoke];
    
    SKAction *removeSmoke = [SKAction sequence:@[[SKAction waitForDuration:1.5], [SKAction removeFromParent]]];
    
    [deathSmoke runAction:removeSmoke];
    
    SKAction *removeBat = [SKAction sequence:@[[SKAction waitForDuration:1.5], [SKAction removeFromParent]]];
    
    [self runAction:removeBat];
    
    
}

@end