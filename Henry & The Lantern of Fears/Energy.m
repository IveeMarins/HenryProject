//
//  Energy.m
//  Henry & The Lantern of Fears
//
//  Created by Adriano Alves Ribeiro Gonçalves on 2/9/15.
//  Copyright (c) 2015 ABHI. All rights reserved.
//

#import "Energy.h"

@implementation Energy

+(id)energy
{
    Energy *energy = [Energy node];
    energy.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:2];
    energy.physicsBody.dynamic = NO;
    energy.name = @"energy";
    
    NSString *energyEmmiterPath = [[NSBundle mainBundle] pathForResource:@"EnergyBig" ofType:@"sks"];
    energy.energyEmmiter = [NSKeyedUnarchiver unarchiveObjectWithFile:energyEmmiterPath];

    [energy addChild:energy.energyEmmiter];
    
    return energy;
}

-(void)collectToPosition:(CGPoint)position{
    
    [self.energyEmmiter removeFromParent];
    NSString *energyEmmiterPath = [[NSBundle mainBundle] pathForResource:@"energyExplosion" ofType:@"sks"];
    self.energyEmmiter = [NSKeyedUnarchiver unarchiveObjectWithFile:energyEmmiterPath];
    [self addChild:self.energyEmmiter];
    
    [self runAction:[SKAction sequence:@[[SKAction waitForDuration:1.5],[SKAction removeFromParent]]]];
    
}
-(void)setParticleTarget{
    
    self.energyEmmiter.targetNode = self.scene;
    
}


@end
