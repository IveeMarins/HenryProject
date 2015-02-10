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
    NSArray *_walkAnimationFrames;
    NSArray *_deathAnimationFrames;
    BOOL _flipped;
}

+(id)henry
{
    
    Henry *henry = [Henry spriteNodeWithImageNamed:@"idle1"];
    henry.size = CGSizeMake(80, 100);
    
    SKSpriteNode *lightBlocker = [SKSpriteNode spriteNodeWithColor:[UIColor grayColor] size:CGSizeMake(1,20)];
    lightBlocker.zPosition = -10;
    lightBlocker.name = @"lightBlocker";
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
    henry.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(46, 100) center:CGPointMake(-14, 0)];
    henry.physicsBody.restitution = 0.0;
    henry.physicsBody.allowsRotation  = NO;
    
    
    [henry idleAnimation];
    
    return henry;
}
-(void)walkRight
{
    
    SKAction *incrementRight = [SKAction repeatActionForever:[SKAction moveByX:40 y:0 duration:0.3]];
    
    [self walkRightAnimation];
    
    [self runAction:incrementRight withKey:@"walkRight"];
    
    if (_flipped){
        [self enumerateChildNodesWithName:@"killerLine" usingBlock:^(SKNode *node, BOOL *stop) {
            node.xScale = 1;
            node.position = CGPointMake(-node.position.x, node.position.y);
            
        }];
        [self enumerateChildNodesWithName:@"kopp" usingBlock:^(SKNode *node, BOOL *stop) {
            node.xScale = 1;
            node.position = CGPointMake(-node.position.x, node.position.y);
        }];
        [self enumerateChildNodesWithName:@"lightBlocker" usingBlock:^(SKNode *node, BOOL *stop) {
            node.xScale = 1;
            node.position = CGPointMake(-node.position.x, node.position.y);
            
        }];
        _flipped = NO;
    }
    
    
}
-(void)walkRightAnimation
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
}

-(void)walkLeft
{
    
    NSMutableArray *walkFrames = [NSMutableArray array];
    SKTextureAtlas *walkHenryAtlas = [SKTextureAtlas atlasNamed:@"runLeft"];
    for (int i = 1; i <= walkHenryAtlas.textureNames.count; i++) {
        NSString *textureName = [NSString stringWithFormat:@"run%d", i];
        SKTexture *temp = [walkHenryAtlas textureNamed:textureName];
        [walkFrames addObject:temp];
    }
    
    _walkAnimationFrames = walkFrames;
    
    [self runAction: [SKAction repeatActionForever:[SKAction animateWithTextures:_walkAnimationFrames
                                                                    timePerFrame:0.2]]withKey:@"walkAnimation"];
    
    SKAction *incrementLeft = [SKAction repeatActionForever:[SKAction moveByX:-40 y:0 duration:0.3]];
    [self runAction:incrementLeft withKey:@"walkLeft"];
        
        if (!_flipped){
            [self enumerateChildNodesWithName:@"killerLine" usingBlock:^(SKNode *node, BOOL *stop) {
                node.xScale = -1;
                node.position = CGPointMake(-node.position.x, node.position.y);
            }];
            [self enumerateChildNodesWithName:@"kopp" usingBlock:^(SKNode *node, BOOL *stop) {
                node.xScale = -1;
                node.position = CGPointMake(-node.position.x, node.position.y);
                
            }];
            [self enumerateChildNodesWithName:@"lightBlocker" usingBlock:^(SKNode *node, BOOL *stop) {
                node.xScale = -1;
                node.position = CGPointMake(-node.position.x, node.position.y);
                
            }];
            
            _flipped = YES;
        }
    
}
-(void)jump
{
    if (_flipped)
    {
        [self.physicsBody applyImpulse:CGVectorMake(-28, 100)];
        
    }
    else{
        [self.physicsBody applyImpulse:CGVectorMake(28, 100)];
        
    }
    
    
}
-(void)pickLantern
{
    
    
    
    NSString *lanternLightEmmiterPath = [[NSBundle mainBundle] pathForResource:@"lanternLight" ofType:@"sks"];
    SKEmitterNode *lanternLightEmmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:lanternLightEmmiterPath];
    
    
    lanternLightEmmitter.position = CGPointMake(self.frame.size.width * 0.5 - 7,-20);
    
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
    fakeLanternLight.shadowColor = [[UIColor alloc] initWithRed:89.0/255.0f green:161.0/255.0f  blue:87.0/255.0f  alpha:0.3];
    fakeLanternLight.name = @"fakeLanternLight";
    
    
    fakeLanternLight.position = CGPointMake(self.frame.size.width * 0.5 - 3,-20);
    
    if(_flipped){
        
        fakeLanternLight.position = CGPointMake(-fakeLanternLight.position.x, fakeLanternLight.position.y);
        lanternLightEmmitter.position = CGPointMake(-lanternLightEmmitter.position.x, lanternLightEmmitter.position.y);
    }
    
    [self addChild:fakeLanternLight];
    
}

-(void)idleAnimation
{
    
    
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
-(void)idleAnimationLeft
{
    
    NSMutableArray *idleFrames = [NSMutableArray array];
    SKTextureAtlas *idleHenryAtlas = [SKTextureAtlas atlasNamed:@"idleLeft"];
    for (int i = 1; i <= idleHenryAtlas.textureNames.count; i++) {
        NSString *textureName = [NSString stringWithFormat:@"idle%d", i];
        SKTexture *temp = [idleHenryAtlas textureNamed:textureName];
        [idleFrames addObject:temp];
    }
    
    _idleAnimationFrames = idleFrames;
    
    
    [self runAction: [SKAction repeatActionForever:[SKAction animateWithTextures:_idleAnimationFrames
                                                                    timePerFrame:3]]withKey:@"idleAnimation"];
    
}
-(void)deathAnimation{
    
    NSURL *url1 = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/morteHenry.mp3", [[NSBundle mainBundle] resourcePath]]];
    NSError *error;
    
    self.soundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url1 error:&error];
    self.soundPlayer.numberOfLoops = 0;
    
    NSMutableArray *deathFrames = [NSMutableArray array];
    SKTextureAtlas *deathHenryAtlas = [SKTextureAtlas atlasNamed:@"henryDeath"];
    for (int i = 1; i <= deathHenryAtlas.textureNames.count; i++) {
        NSString *textureName = [NSString stringWithFormat:@"morteHenry%d", i];
        SKTexture *temp = [deathHenryAtlas textureNamed:textureName];
        [deathFrames addObject:temp];
    }
    
    _deathAnimationFrames = deathFrames;
    
    [self.soundPlayer play];
    
    [self runAction:[SKAction sequence:@[ [SKAction animateWithTextures:_deathAnimationFrames timePerFrame:0.2],[SKAction waitForDuration:2.2],[SKAction removeFromParent]]]];
    
    
}
-(void)deathAnimationLeft{
    
    NSURL *url1 = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/morteHenry.mp3", [[NSBundle mainBundle] resourcePath]]];
    NSError *error;
    
    self.soundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url1 error:&error];
    self.soundPlayer.numberOfLoops = 0;
    
    NSMutableArray *deathFrames = [NSMutableArray array];
    SKTextureAtlas *deathHenryAtlas = [SKTextureAtlas atlasNamed:@"henryDeathLeft"];
    for (int i = 1; i <= deathHenryAtlas.textureNames.count; i++) {
        NSString *textureName = [NSString stringWithFormat:@"morteHenry%d", i];
        SKTexture *temp = [deathHenryAtlas textureNamed:textureName];
        [deathFrames addObject:temp];
    }
    
    _deathAnimationFrames = deathFrames;
    
    [self.soundPlayer play];
    
    [self runAction:[SKAction sequence:@[ [SKAction animateWithTextures:_deathAnimationFrames timePerFrame:0.1],[SKAction waitForDuration:4],[SKAction removeFromParent]]]];
}
@end
