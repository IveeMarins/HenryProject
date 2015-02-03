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
    
    NSArray *_idleAnimationFrames;
    NSArray *_lanternAnimationFrames;
    NSArray *_walkAnimationFrames;
}

+(id)henry
{
    
    Henry *henry = [Henry spriteNodeWithImageNamed:@"idle1"];
    henry.size = CGSizeMake(80, 100);
    henry.zPosition = 1;
    
    SKSpriteNode *lightBlocker = [SKSpriteNode spriteNodeWithColor:[UIColor grayColor] size:CGSizeMake(1,20)];
    lightBlocker.zPosition = -10;
    lightBlocker.position = CGPointMake(henry.frame.size.width * 0.5 + 5,-20);
    lightBlocker.shadowCastBitMask = 0x1 << 30;
    [henry addChild:lightBlocker];
    
    for (int i = 0; i < 25; i++) {
        SKNode *killerLine = [SKNode node];
        killerLine.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(1, 20 + 13*i)];
        killerLine.position = CGPointMake(henry.frame.size.width * 0.5 + 5 + 5*i,-20);
        killerLine.physicsBody.dynamic = NO;
        killerLine.physicsBody.categoryBitMask = 0x1 << 3;
        killerLine.physicsBody.contactTestBitMask = 0x1 << 2;
        killerLine.name = @"killerLine";
        henry.physicsBody.collisionBitMask = 0x1 << 1;
        
        [henry addChild:killerLine];
    }
    
    
    henry.name = @"henry";
    
    henry.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:henry.size];
    henry.physicsBody.restitution = 0.0;
    henry.physicsBody.allowsRotation  = NO;
    
    
    [henry idleAnimation];
    
    return henry;
}
-(void)walkRight
{
    
    SKAction *incrementRight = [SKAction repeatActionForever:[SKAction moveByX:30 y:0 duration:0.3]];
    
    NSMutableArray *walkFrames = [NSMutableArray array];
    SKTextureAtlas *walkHenryAtlas = [SKTextureAtlas atlasNamed:@"run"];
    for (int i = 1; i <= walkHenryAtlas.textureNames.count; i++) {
        NSString *textureName = [NSString stringWithFormat:@"run%d", i];
        SKTexture *temp = [walkHenryAtlas textureNamed:textureName];
        [walkFrames addObject:temp];
    }
    
    _walkAnimationFrames = walkFrames;
    
    [self runAction: [SKAction repeatActionForever:[SKAction animateWithTextures:_walkAnimationFrames
                                                                    timePerFrame:0.2]]withKey:@"walkAnimation"];
    
    [self runAction:incrementRight withKey:@"walkRight"];
}
-(void)walkLeft
{
    
    NSMutableArray *walkFrames = [NSMutableArray array];
    SKTextureAtlas *walkHenryAtlas = [SKTextureAtlas atlasNamed:@"run"];
    for (int i = 1; i <= walkHenryAtlas.textureNames.count; i++) {
        NSString *textureName = [NSString stringWithFormat:@"run%d", i];
        SKTexture *temp = [walkHenryAtlas textureNamed:textureName];
        [walkFrames addObject:temp];
    }
    
    _walkAnimationFrames = walkFrames;
    
    [self runAction: [SKAction repeatActionForever:[SKAction animateWithTextures:_walkAnimationFrames
                                                                    timePerFrame:0.2]]withKey:@"walkAnimation"];
    
    SKAction *incrementLeft = [SKAction repeatActionForever:[SKAction moveByX:-30 y:0 duration:0.3]];
    [self runAction:incrementLeft withKey:@"walkLeft"];
}
-(void)jump
{
    
    [self.physicsBody applyImpulse:CGVectorMake(0, 150)];
    
    
}
-(void)pickLantern
{
    
<<<<<<< HEAD
    [self setTexture:[SKTexture textureWithImageNamed:@"spriteHenryLantern"]];
=======
    if(self.xScale == 1){
        [self setTexture:[SKTexture textureWithImageNamed:@"spriteHenryLantern"]];
    }
    else {
        [self setTexture:[SKTexture textureWithImageNamed:@"spriteHenryLanternLeft"]];
    }
    
>>>>>>> FETCH_HEAD
    [self setSize:CGSizeMake(80, 100)];
    
    NSString *lanternLightEmmiterPath = [[NSBundle mainBundle] pathForResource:@"lanternLight" ofType:@"sks"];
    SKEmitterNode *lanternLightEmmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:lanternLightEmmiterPath];
    
    
    lanternLightEmmitter.position = CGPointMake(self.frame.size.width * 0.5 - 3,-20);
    
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
    
    
    fakeLanternLight.position = CGPointMake(self.frame.size.width * 0.5 - 3,-20);
    
    
    
    [self addChild:fakeLanternLight];
    
}

-(void)lanternAnimation
{
    
    NSMutableArray *lanternFrames = [NSMutableArray array];
    SKTextureAtlas *lanternHenryAtlas = [SKTextureAtlas atlasNamed:@"lantern"];
    
    
    for (int i = 1; i <= lanternHenryAtlas.textureNames.count; i++) {
        NSString *textureName = [NSString stringWithFormat:@"lantern%d", i];
        SKTexture *temp = [lanternHenryAtlas textureNamed:textureName];
        [lanternFrames addObject:temp];
    }
    
    _lanternAnimationFrames = lanternFrames;
    
    [self runAction: [SKAction repeatActionForever:[SKAction animateWithTextures:_lanternAnimationFrames
                                                                    timePerFrame:3]]withKey:@"lanternAnimation"];
    
}

-(void)idleAnimation
{
    
//    SKAction *idleAnimation = [SKAction repeatActionForever:[SKAction animateWithTextures:@[[SKTexture textureWithImageNamed:@"idle1"],[SKTexture textureWithImageNamed:@"idle2"],[SKTexture textureWithImageNamed:@"idle1"]] timePerFrame:1]];
//    
//    [self runAction:idleAnimation withKey:@"idleAnimation"];
    
    NSMutableArray *idleFrames = [NSMutableArray array];
    SKTextureAtlas *idleHenryAtlas = [SKTextureAtlas atlasNamed:@"idle"];
    for (int i = 1; i <= idleHenryAtlas.textureNames.count; i++) {
        NSString *textureName = [NSString stringWithFormat:@"idle%d", i];
        SKTexture *temp = [idleHenryAtlas textureNamed:textureName];
        [idleFrames addObject:temp];
    }
    
    _idleAnimationFrames = idleFrames;
    
    [self runAction: [SKAction repeatActionForever:[SKAction animateWithTextures:_idleAnimationFrames
                                                                    timePerFrame:3]]withKey:@"idleAnimation"];
    
}

@end
