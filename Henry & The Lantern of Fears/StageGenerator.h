//
//  StageGenerator.h
//  Henry & The Lantern of Fears
//
//  Created by Ivee Mendes Marins on 3/3/15.
//  Copyright (c) 2015 ABHI. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SoundDefiner.h"
#import "HUD.h"
#import "BackgroundGenerator.h"
#import "VictoryLight.h"
#import "Henry.h"
#import "Kopp.h"
#import "Constants.h"
#import "GroundDefiner.h"

@interface StageGenerator : SKScene

@property HUD *hud;
@property SoundDefiner *soundDefiner;
@property BackgroundGenerator *backgroundGenerator;
@property Henry *henry;
@property VictoryLight *victoryLight;
@property GroundDefiner *groundDefiner;

@property BOOL isDead;

@property (nonatomic) NSMutableArray *backgroundNames;
@property (nonatomic) NSMutableArray *backgroundRepeatTimes;
@property (nonatomic) NSMutableArray *backgroundZPositions;
@property (nonatomic) NSMutableArray *musicNames;
@property (nonatomic) NSUserDefaults *savedInformation;
@property (nonatomic) SKNode *world;
@property (nonatomic) NSMutableArray *groundImageNames;
@property (nonatomic) NSMutableArray *groundRepeatTimes;
@property (nonatomic) float currenteGroundX;

-(void) setBackground;
-(void) setSound;
-(void) setKeysDefault;
-(void) setHUD;
-(void) creatWorld;
-(void) insertHenryAndKopp;
-(void) setGround;
-(void) centerCamera;


@end
