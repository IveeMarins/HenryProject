//
//  VictoryLight.m
//  Henry & The Lantern of Fears
//
//  Created by Adriano Alves Ribeiro Gonçalves on 2/5/15.
//  Copyright (c) 2015 ABHI. All rights reserved.
//

#import "VictoryLight.h"

@implementation VictoryLight

+(id)victoryLight{
    
    VictoryLight *victoryLight = [VictoryLight node];
    
    return victoryLight;
}
-(void)insertElements
{
    SKLightNode *light = [[SKLightNode alloc] init];
    light.categoryBitMask = 0x1 << 29;
    light.falloff = 0.1;
    light.ambientColor = [UIColor whiteColor];
    light.shadowColor = [[UIColor alloc] initWithRed:1.0 green:1.0 blue:1.0 alpha:0.3];
    light.position = CGPointMake(0,self.frame.size.height * 0.5);
    [self addChild:light];
    
    SKSpriteNode *lightBlocker = [SKSpriteNode spriteNodeWithColor:[UIColor grayColor] size:CGSizeMake(10, 1)];
    lightBlocker.zPosition = -10;
    lightBlocker.name = @"lightBlocker";
    lightBlocker.position = CGPointMake(0,self.frame.size.height * 0.5 - 10);
    lightBlocker.shadowCastBitMask = 0x1 << 29;
    [self addChild:lightBlocker];
    
    NSString *victoryLightEmmiterPath = [[NSBundle mainBundle] pathForResource:@"VictoryLightParticle" ofType:@"sks"];
    SKEmitterNode *victoryLightEmmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:victoryLightEmmiterPath];
    
    [light addChild:victoryLightEmmitter];
    
    SKNode *winChekpoint = [SKNode node];
    winChekpoint.position = CGPointMake(0, 0);
    winChekpoint.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0, -self.frame.size.height * 0.5)
                                                            toPoint:CGPointMake(0, self.frame.size.height * 0.5)];
    winChekpoint.physicsBody.dynamic = NO;
    winChekpoint.physicsBody.categoryBitMask = 0x1 << 28;
    winChekpoint.physicsBody.collisionBitMask = 0;
    [self addChild:winChekpoint];
    
    
}


@end
