//
//  StageGenerator.m
//  Henry & The Lantern of Fears
//
//  Created by Ivee Mendes Marins on 3/3/15.
//  Copyright (c) 2015 ABHI. All rights reserved.
//

#import "StageGenerator.h"

@implementation StageGenerator

-(void) setSound{
    
    self.soundDefiner = [SoundDefiner createSoundDefiner];
    
    NSMutableArray *urls = [NSMutableArray array];
    
    for (int i=0 ; i< self.musicNames.count ; i++)
    {
        NSString *musicname = (NSString *) self.musicNames[i];
        NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat: musicname, [[NSBundle mainBundle] resourcePath]]];
        [urls addObject:url];
        
    }
      
    [self.soundDefiner setMusicWithNames:urls];
    
    [self.soundDefiner playMusic];
}


-(void) setBackground{
    self.backgroundGenerator = [BackgroundGenerator createBackgroundGenerator];
    
    for (int i=0; i<self.backgroundNames.count ; i++)
    {
        NSString *backgroundName = (NSString *) self.backgroundNames[i];
        int backgroundRepeat = (int) self.backgroundRepeatTimes[i];
        int backgroundZPosition = (int) self.backgroundZPositions[i];
        
        [self.backgroundGenerator generateBackgroundWithImage: backgroundName repeat:backgroundRepeat OnZPosition:backgroundZPosition WithFrameSize:self.frame.size WithStartPosition:0];
    }
    
    for (int i = 0; i < self.backgroundGenerator.layers.count; i++)
    {
        SKNode *layer = (SKNode *)self.backgroundGenerator.layers[i];
        [self addChild:layer];
    }
}

-(void) setKeysDefault
{
    NSDictionary *defaults = @{
                               @"HENRY_LIVES": @3,
                               @"ENERGY_SCORE": @0,
                               };
    [self.savedInformation registerDefaults: defaults];
}



-(void) setHUD{
    self.hud = [HUD createHudWithScore:[self.savedInformation integerForKey: @"ENERGY_SCORE"] WithLives: [self.savedInformation integerForKey:@"HENRY_LIVES"] ];
    [self addChild:self.hud];
    [self.hud setHudControls];
    
}

-(void) inserVictoryLight{
    self.victoryLight = [VictoryLight victoryLight];
    self.victoryLight.size = self.size;
    [self.victoryLight insertElements];
    self.victoryLight.position = CGPointMake(self.currenteGroundX - self.frame.size.width, 0);
    [self.world addChild:self.victoryLight];
}

-(void) creatWorld
{
    self.world = [SKNode node];
    [self addChild: self.world];
}

-(void) insertHenryAndKopp{
    
    self.henry = [Henry henry];
    self.henry.physicsBody.categoryBitMask = PLAYER_CATEGORY;
    self.henry.physicsBody.collisionBitMask = GROUND_CATEGORY;
    self.henry.physicsBody.contactTestBitMask = GROUND_CATEGORY | ENEMY_CATEGORY | VICTORY_LIGHT_CATEGORY;
    self.henry.zPosition = 1;
    self.henry.position = CGPointMake(0, 200);
    
    [self.world addChild: self.henry];
    
    Kopp *kopp = [Kopp kopp: self.henry];
    
}

-(void)centerOnNode:(SKNode *)node{
    
    CGPoint positionInScene = [self convertPoint:node.position fromNode:node.parent];
    
    
    
    positionInScene.x += 185;
    self.world.position = CGPointMake(self.world.position.x - positionInScene.x, self.world.position.y);
    
    for (int i = 0; i < self.backgroundGenerator.layers.count; i++)
    {
        SKNode *layer = (SKNode *)self.backgroundGenerator.layers[i];
        
        if (layer.zPosition == -4) {
            layer.position = CGPointMake(layer.position.x - positionInScene.x * 0.1,layer.position.y);
        }
        else if(layer.zPosition == -3){
            layer.position = CGPointMake(layer.position.x - positionInScene.x * 0.3 ,layer.position.y);
        }
        else if(layer.zPosition == -2){
            layer.position = CGPointMake(layer.position.x - positionInScene.x * 0.7 ,layer.position.y);
        }
        
    }
    
}


-(void) setGround
{
    self.groundDefiner = [GroundDefiner createGroundDefiner];
    self.currenteGroundX = 0;
    
    for (int i=0; i<self.groundImageNames.count ; i++)
    {
        NSString *groundImageName = (NSString *) self.groundImageNames[i];
        int groundRepeatTime = (int) self.groundRepeatTimes[i];
    
        self.currenteGroundX = [self.groundDefiner generateGroundWithImage:groundImageName repeat:groundRepeatTime WithFrameSize:self.frame.size WithStartPoint:self.currenteGroundX];
    }
    
    [self addChild:self.groundDefiner.ground];
    
}

-(void) centerCamera
{
    self.isDead = NO;
    
    if(!self.isDead)
    {
        [self centerOnNode: self.henry];
    }
}


@end
