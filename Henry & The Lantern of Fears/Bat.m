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
    BOOL _attacking;
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
    if (!_attacking){
        _attacking = YES;
        
        float currentX = self.position.x;
        float currentY = self.position.y;
        float afterSweepX = 0;
        float afterSweepY = 0;
        
        
        //Group of actions to make the bat do a sweep going left and down at the same time
        SKAction *leftDownSweep = [SKAction group:@[[SKAction moveToX:self.position.x - 200 duration:2],
                                                    [SKAction moveToY:self.position.y - 60  duration:2]]];
        afterSweepX = self.position.x - 200;
        afterSweepY = self.position.y - 60;
        //To complete the movement we need to make him go up again and continue the movement to the left
        SKAction *leftUpSweep = [SKAction group:@[[SKAction moveToX:afterSweepX - 200 duration:2],
                                                  [SKAction moveToY:afterSweepY + 60 duration:2]]];
        
        //The same, but instead of going left he goes right, in case henry is at his right side
        SKAction *rightDownSweep = [SKAction group:@[[SKAction moveToX:self.position.x + 200 duration:3],
                                                     [SKAction moveToY:self.position.y - 60 duration:3]]];
        afterSweepX = self.position.x + 200;
        SKAction *rightUpSweep = [SKAction group:@[[SKAction moveToX:afterSweepX + 200 duration:3],
                                                   [SKAction moveToY:afterSweepY + 60 duration:3]]];
        
        
        if (henry.position.x < currentX) {
            
            [self runAction:[SKAction sequence:@[leftDownSweep,leftUpSweep]]];
        }
        else{
            [self runAction:[SKAction sequence:@[rightDownSweep,rightUpSweep]]];
            
        }
        [self performSelector:@selector(attackFinished) withObject:self afterDelay:5];
    }
    
    
    
}
-(void)attackFinished
{
    _attacking = NO;
    
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
    [self removeAllActions];
    self.physicsBody.categoryBitMask = 0;
    self.physicsBody.collisionBitMask = 0;
    [self removeActionForKey:@"flyAnimation"];
    [self setTexture:[SKTexture textureWithImageNamed:@"batDead"]];
    
    NSURL *url1 = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/MorteBat.mp3", [[NSBundle mainBundle] resourcePath]]];
    NSError *error;
    
    self.soundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url1 error:&error];
    self.soundPlayer.numberOfLoops = 0;
    [self.soundPlayer play];
    
    
    NSString *deathSmokePath = [[NSBundle mainBundle] pathForResource:@"DyingEnemy" ofType:@"sks"];
    SKEmitterNode *deathSmoke = [NSKeyedUnarchiver unarchiveObjectWithFile:deathSmokePath];
    
    [self addChild:deathSmoke];
    
    SKAction *removeSmoke = [SKAction sequence:@[[SKAction waitForDuration:2.0], [SKAction removeFromParent]]];
    
    [deathSmoke runAction:removeSmoke];
    
    SKAction *removeBat = [SKAction sequence:@[[SKAction waitForDuration:2.0], [SKAction removeFromParent]]];
    
    [self runAction:removeBat];
    
    
}

@end