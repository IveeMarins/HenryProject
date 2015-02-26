//
//  HUD.h
//  Henry & The Lantern of Fears
//
//  Created by Ivee Mendes Marins on 2/12/15.
//  Copyright (c) 2015 ABHI. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface HUD : SKNode
@property (nonatomic) int numberOfLives;
@property (nonatomic) int score;
@property (nonatomic) int time;
@property (nonatomic) int timeSec;
@property (nonatomic) int timeMin;
@property (nonatomic) SKLabelNode *labelTimer;
@property (nonatomic) SKLabelNode *lifeLabel;
@property (nonatomic) SKLabelNode *labelScore;
@property NSString *fontName;
+(HUD *) createHudWithScore:(int)score WithLives:(int)numberOfLives;
-(void) setHudControls;
-(void)setNumberOfLives:(int)numberOfLives;
-(void)setScore:(int)score;
- (void)timer;
- (void)stopTimer;
-(void)increaseTimer;
-(void)startTimer;


@end
