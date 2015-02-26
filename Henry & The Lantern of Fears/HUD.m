//
//  HUD.m
//  Henry & The Lantern of Fears
//
//  Created by Ivee Mendes Marins on 2/12/15.
//  Copyright (c) 2015 ABHI. All rights reserved.
//

#import "HUD.h"


@interface HUD ()
{
    NSTimer *timer;
}
@end

@implementation HUD

+(HUD *) createHudWithScore:(int)score WithLives:(int)numberOfLives
{
    HUD *hud = [HUD node];
    hud.zPosition = 3;
    hud.score = score;
    hud.numberOfLives = numberOfLives;
    return hud;
}

-(void) setHudControls{
    //UIFont *font = [UIFont fontWithName:@"KGLuckoftheIrish.ttf" size:100.0f];
    _fontName = [NSString stringWithFormat:@"KGLuckoftheIrish"];
    
    
    //Inserting Hud Controls
    
    //Buttons
    SKSpriteNode *rightButton = [SKSpriteNode spriteNodeWithImageNamed:@"rightButton"];
    rightButton.size = CGSizeMake(60, 60);
    rightButton.name = @"rightButton";
    rightButton.position = CGPointMake(-self.scene.frame.size.width * 0.5 + rightButton.frame.size.width * 0.5 + rightButton.frame.size.width + 5 , -self.scene.frame.size.height * 0.5 + rightButton.frame.size.height * 0.5 + 10);
    rightButton.zPosition = 2;
    [self addChild:rightButton];
    
    SKSpriteNode *leftButton = [SKSpriteNode spriteNodeWithImageNamed:@"leftButton"];
    leftButton.size = CGSizeMake(60, 60);
    leftButton.name = @"leftButton";
    leftButton.position = CGPointMake(-self.scene.frame.size.width * 0.5 +leftButton.frame.size.width * 0.5 + 10,
                                      -self.scene.frame.size.height * 0.5 + leftButton.frame.size.height * 0.5 + leftButton.frame.size.height);
    leftButton.zPosition = 2;
    [self addChild:leftButton];
    
    SKSpriteNode *jumpButton = [SKSpriteNode spriteNodeWithImageNamed:@"jumpButton"];
    jumpButton.size = CGSizeMake(60, 60);
    jumpButton.name = @"jumpButton";
    jumpButton.position = CGPointMake(self.scene.frame.size.width * 0.5 - jumpButton.frame.size.width * 0.5 - 10 ,
                                      -self.scene.frame.size.height * 0.5 + jumpButton.frame.size.height * 0.5 + jumpButton.frame.size.height);
    jumpButton.zPosition = 2;
    [self addChild:jumpButton];
    
    SKSpriteNode *lanternButton = [SKSpriteNode spriteNodeWithImageNamed:@"lantern"];
    lanternButton.size = CGSizeMake(60, 60);
    lanternButton.name = @"lanternButton";
    lanternButton.position = CGPointMake(self.scene.frame.size.width * 0.5 - 3 * lanternButton.frame.size.width * 0.5,
                                         -self.scene.frame.size.height * 0.5 + lanternButton.frame.size.height * 0.5 + 10);
    lanternButton.zPosition = 2;
    [self addChild:lanternButton];
    
    SKSpriteNode *configButton = [SKSpriteNode spriteNodeWithImageNamed:@"gear"];
    configButton.size = CGSizeMake(30, 30);
    configButton.name = @"configButton";
    configButton.position = CGPointMake(self.scene.frame.size.width * 0.5 - configButton.frame.size.width * 0.5 - 15,
                                        self.scene.frame.size.height * 0.5 - configButton.frame.size.height * 0.5 - 15);
    configButton.zPosition = 2;
    [self addChild:configButton];
    
    
    SKSpriteNode *encyclopediaButton = [SKSpriteNode spriteNodeWithImageNamed:@"book"];
    encyclopediaButton.size = CGSizeMake(30, 30);
    encyclopediaButton.name = @"encyclopediaButton";
    encyclopediaButton.position = CGPointMake(configButton.position.x - encyclopediaButton.frame.size.width * 0.5 - 25 , self.scene.frame.size.height * 0.5 - encyclopediaButton.frame.size.height * 0.5 - 15);
    configButton.zPosition = 2;
    [self addChild:encyclopediaButton];
    
    SKSpriteNode *changeStoneButton = [SKSpriteNode spriteNodeWithImageNamed:@"magicStone"];
    changeStoneButton.size = CGSizeMake(30, 30);
    changeStoneButton.name = @"changeStoneButton";
    changeStoneButton.position = CGPointMake(encyclopediaButton.position.x - changeStoneButton.frame.size.width * 0.5 - 25 ,
                                             self.scene.frame.size.height * 0.5 - changeStoneButton.frame.size.height * 0.5 - 15);
    changeStoneButton.zPosition = 2;
    [self addChild:changeStoneButton];
    
    // Inserting Life and Score
    
    SKSpriteNode *life = [SKSpriteNode spriteNodeWithImageNamed:@"henryLife"];
    [life setScale:0.1];
    life.position = CGPointMake(-self.scene.frame.size.width * 0.5 + life.frame.size.width * 0.5 + 10,self.scene.frame.size.height * 0.5 - life.frame.size.height * 0.5 - 10);
    
    life.zPosition = 2;
    
    [self addChild:life];
    
    SKLabelNode *xSeparator = [SKLabelNode labelNodeWithFontNamed:_fontName];
    xSeparator.fontColor = [UIColor whiteColor];
    xSeparator.fontSize = 15;
    xSeparator.position = CGPointMake(life.position.x + 25 , life.position.y - 15);
    xSeparator.text = @"x";
    xSeparator.zPosition = 2;
    
    [self addChild:xSeparator];
    
    _lifeLabel = [SKLabelNode labelNodeWithFontNamed:_fontName];
    _lifeLabel.fontColor = [UIColor whiteColor];
    _lifeLabel.fontSize = 25;
    _lifeLabel.position = CGPointMake(xSeparator.position.x + 15 , xSeparator.position.y);
    _lifeLabel.text = [NSString stringWithFormat:@"%d",_numberOfLives];
    _lifeLabel.zPosition = 2;
    
    [self addChild:_lifeLabel];
    
    _labelScore = [SKLabelNode labelNodeWithFontNamed: _fontName];
    _labelScore.position = CGPointMake(_lifeLabel.position.x - 10, _lifeLabel.position.y - 40);
    _labelScore.fontSize = 20;
    _labelScore.fontColor = [UIColor whiteColor];
    _labelScore.text = [NSString stringWithFormat:@"%d",_score];
    _lifeLabel.zPosition = 2;
    
    [self addChild:_labelScore];
    
    NSString *energyEmmiterPath = [[NSBundle mainBundle] pathForResource:@"Energy" ofType:@"sks"];
    SKEmitterNode *energyEmmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:energyEmmiterPath];
    energyEmmitter.position = CGPointMake(life.position.x, _labelScore.position.y + 5);
    
    [self addChild:energyEmmitter];
    
    [self timer];
    
}


-(void)setNumberOfLives:(int)numberOfLives{
    
    _numberOfLives = numberOfLives;
    if (numberOfLives >= 0) {
        _lifeLabel.text = [NSString stringWithFormat:@"%d",numberOfLives];
    }
}

-(void)setScore:(int)score{
    _score = score;
    _labelScore.text = [NSString stringWithFormat:@"%d",score];
}

- (void)timer{
    _labelTimer = [SKLabelNode labelNodeWithText:@"00:00"];
    
    _labelTimer.fontName = _fontName;
    _labelTimer.position = CGPointMake(0, _lifeLabel.position.y);
    _labelTimer.fontSize = 30;
    _labelTimer.name = @"timer";
    _labelTimer.fontColor = [UIColor whiteColor];
    _labelTimer.zPosition = 1;
    
    [_labelTimer setScale:0.9];
    [self addChild:_labelTimer];
    
    [self startTimer];
    
}

-(void)startTimer{
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(increaseTimer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

-(void)increaseTimer{
    _time++;
    _timeSec++;
    
    if (_timeSec == 60)
    {
        _timeSec = 0;
        _timeMin++;
    }
    
    
    NSString *timeNow = [NSString stringWithFormat:@"%02d:%02d", _timeMin, _timeSec];
    _labelTimer.text = timeNow;
}


- (void)stopTimer{
    [timer invalidate];
}

@end
