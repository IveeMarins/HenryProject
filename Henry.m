//
//  Henry.m
//  Henry & The Lantern of Fears
//
//  Created by Adriano Alves Ribeiro Gonçalves on 1/22/15.
//  Copyright (c) 2015 ABHI. All rights reserved.
//

#import "Henry.h"

@implementation Henry
{
    
    NSArray *_AnimationFrames;
    
}

+(id)henry
{
    
    Henry *henry = [Henry spriteNodeWithImageNamed:@"idle1"];
    henry.size = CGSizeMake(80, 100);
    henry.zPosition=1;

    SKSpriteNode *lightBlocker = [SKSpriteNode spriteNodeWithColor:[UIColor grayColor] size:CGSizeMake(1,40)];
    lightBlocker.zPosition = -10;
    lightBlocker.position = CGPointMake(henry.frame.size.width * 1.5, henry.position.y);
    lightBlocker.shadowCastBitMask = 0x1 << 30;
    [henry addChild:lightBlocker];
    
    
    henry.name = @"henry";
    
    henry.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:henry.size];
    henry.physicsBody.restitution = 0.0;
    henry.physicsBody.allowsRotation  = NO;
    henry.shadowCastBitMask = 0x1 << 31;
    
    [henry idleAnimation];
    
    return henry;
}
-(void)walkRight
{
    
    SKAction *incrementRight = [SKAction repeatActionForever:[SKAction moveByX:30 y:0 duration:0.3]];
    SKAction *walkAnimation = [SKAction repeatActionForever:[SKAction animateWithTextures:@[[SKTexture textureWithImageNamed:@"run1"],[SKTexture textureWithImageNamed:@"run2"],[SKTexture textureWithImageNamed:@"run3"],[SKTexture textureWithImageNamed:@"run4"]] timePerFrame:0.2]];
    
    [self runAction:walkAnimation withKey:@"walkAnimation"];
    [self runAction:incrementRight withKey:@"walkRight"];
}
-(void)walkLeft
{
    
    SKAction *incrementLeft = [SKAction repeatActionForever:[SKAction moveByX:-30 y:0 duration:0.3]];
    SKAction *walkAnimation = [SKAction repeatActionForever:[SKAction animateWithTextures:@[[SKTexture textureWithImageNamed:@"run1"],[SKTexture textureWithImageNamed:@"run2"],[SKTexture textureWithImageNamed:@"run3"],[SKTexture textureWithImageNamed:@"run4"]] timePerFrame:0.2]];
    
    [self runAction:walkAnimation withKey:@"walkAnimation"];
    
    [self runAction:incrementLeft withKey:@"walkLeft"];
}
-(void)jump
{
    
    [self.physicsBody applyImpulse:CGVectorMake(0, 100)];
    
    
}
-(void)pickLantern
{
    
    NSString *lanternLightEmmiterPath = [[NSBundle mainBundle] pathForResource:@"lanternLight" ofType:@"sks"];
    SKEmitterNode *lanternLightEmmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:lanternLightEmmiterPath];
    
    
    lanternLightEmmitter.position = CGPointMake(self.frame.size.width,0);
    
    lanternLightEmmitter.name = @"lanternLightParticle";
    
    SKLightNode *lanternLight = [[SKLightNode alloc] init];
    lanternLight.categoryBitMask = 0x1 << 31;
    lanternLight.falloff = 0.1;
    lanternLight.ambientColor = [UIColor whiteColor];
    lanternLight.lightColor = lanternLightEmmitter.particleColor;
    lanternLight.shadowColor = [[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
    lanternLight.name = @"lanternLight";
    
    [lanternLightEmmitter addChild:lanternLight];
    [self addChild:lanternLightEmmitter];
    
    
    SKLightNode *fakeLanternLight = [[SKLightNode alloc] init];
    fakeLanternLight.categoryBitMask = 0x1 << 30;
    fakeLanternLight.falloff = 0.1;
    fakeLanternLight.ambientColor = [UIColor whiteColor];
    fakeLanternLight.lightColor = lanternLightEmmitter.particleColor;
    fakeLanternLight.shadowColor = [[UIColor alloc] initWithRed:1.0 green:1.0 blue:1.0 alpha:0.3];
    fakeLanternLight.name = @"fakeLanternLight";
    
    
    fakeLanternLight.position = CGPointMake(-self.frame.size.width,0);
    
    
    
    [self addChild:fakeLanternLight];
    
}

-(void)idleAnimation
{
    
    SKAction *idleAnimation = [SKAction repeatActionForever:[SKAction animateWithTextures:@[[SKTexture textureWithImageNamed:@"idle1"],[SKTexture textureWithImageNamed:@"idle2"],[SKTexture textureWithImageNamed:@"idle1"]] timePerFrame:1]];
    
    [self runAction:idleAnimation withKey:@"idleAnimation"];
    
    
//    NSMutableArray *idleFrames = [NSMutableArray array];
//    SKTextureAtlas *idleHenryAtlas = [SKTextureAtlas atlasNamed:@"IdleAnimation"];
//    for (int i = 1; i < 5; i++) {
//        if (i == 3) {
//            [idleFrames addObject:[idleHenryAtlas textureNamed:@"idle1"]];
//        }
//        else{
//            [idleFrames addObject:[idleHenryAtlas textureNamed:[NSString stringWithFormat:@"idle%d",i]]];
//        }
//    }
//    
//    _AnimationFrames = idleFrames;
//    
//    [self runAction: [SKAction repeatActionForever:[SKAction animateWithTextures:_AnimationFrames
//                                                                    timePerFrame:0.2]]withKey:@"idleAnimation"];
    
}

@end
