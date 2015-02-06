//
//  GameScene.m
//  Henry & The Lantern of Fears
//
//  Created by Adriano Alves Ribeiro Gonçalves on 1/22/15.
//  Copyright (c) 2015 ABHI. All rights reserved.
//

#import "GameScene.h"
#import "Henry.h"
#import "Bat.h"
#import "Kopp.h"
#import "Ghost.h"
#import "VictoryLight.h"

@interface GameScene ()

@property BOOL isStarted;
@property BOOL isDead;
@property BOOL isGamePaused;

@end

@implementation GameScene{
    
    BOOL _teste;
    
    SKNode *_world;
    SKNode *_backgroundTreeLayer;
    SKNode *_backgroundTreeLayer2;
    SKNode *_backgroundMountainLayer;
    SKNode *_backgroundSkyLayer;
    SKNode *_HUD;
    CGFloat _currentGroundX;
    
    int _time;
    int _timeSec;
    int _timeMin;
    
    
    SKSpriteNode *_sound;
    SKSpriteNode *_backgroundMenus;
    SKSpriteNode *_xMenu;
    SKSpriteNode *_currentLanguageImage;
    
    SKLabelNode *_labelScore;
    SKLabelNode *_labelTimer;
    SKLabelNode *_tituloLabelButton;
    
    NSMutableArray *_enemies;
    NSTimer *_timer;
    
    UIFont *_font;
    
    NSString *_currentLanguage;
    NSString *_fontName;
    
    Henry *_henry;
    VictoryLight *_victoryLight;
    Bat *_bat;
    Ghost *_ghost;
    
    
    BOOL _rightButtonPressed;
    BOOL _leftButtonPressed;
    BOOL _jumping;
    BOOL _moving;
    BOOL _lanternLit;
    BOOL _soundOn;
    BOOL _flipped; //If Henry's image is flipped to walk left
    
    
}

static const uint32_t GROUND_CATEGORY = 0x1;
static const uint32_t PLAYER_CATEGORY = 0x1 << 1;
static const uint32_t ENEMY_CATEGORY = 0x1 << 2;
static const uint32_t KILL_ENEMY_CATEGORY = 0x1 << 3;
static const uint32_t VICTORY_LIGHT_CATEGORY = 0x1 << 28;
static const uint32_t LIGHT_CATEGORY = 0x1 << 31;



-(void)didMoveToView:(SKView *)view {
    
    //Defining Inicial Values
    self.numberOfLives = 3;
    self.score = 0;
    
    _time = 0;
    _font = [UIFont fontWithName:@"KGLuckoftheIrish.ttf" size:100.0f];
    _fontName = [NSString stringWithFormat:@"KGLuckoftheIrish"];
    _currentLanguage = [NSString stringWithFormat: @"Portugues"];
    
    //Setting Delegate
    self.physicsWorld.contactDelegate = self;
    
    ///////////////////////////////////////////////////////////Creating Layers//////////////////////////////////////////////////////////////
    
    //Creating background Layers (Holds the backgrounds)
    _backgroundTreeLayer = [SKNode node];
    _backgroundTreeLayer.zPosition = -2;
    [self addChild:_backgroundTreeLayer];
    
    _backgroundTreeLayer2 = [SKNode node];
    _backgroundTreeLayer2.zPosition = -3;
    [self addChild:_backgroundTreeLayer2];
    
    _backgroundMountainLayer = [SKNode node];
    _backgroundMountainLayer.zPosition = -4;
    [self addChild:_backgroundMountainLayer];
    
    _backgroundSkyLayer = [SKNode node];
    _backgroundSkyLayer.zPosition = -5;
    [self addChild:_backgroundSkyLayer];
    
    //Creating World ( Holds the player, the ground, the enemies, etc )
    _world = [SKNode node];
    [self addChild:_world];
    
    //Creating HUD ( Holds the user interface )
    _HUD = [SKNode node];
    _HUD.zPosition = 2;
    [self addChild:_HUD];
    
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    ///////////////////////////////////////////////////////////Inserting Objects//////////////////////////////////////////////////////////////
    
    //Inserting Ground
    _currentGroundX = 0;
    [self generateWorldWithImage:@"ground" repeat:3];
    [self generateWorldWithImage:@"groundBig" repeat:2];
    [self generateWorldWithImage:@"ground" repeat:1];
    [self generateWorldWithImage:@"groundRamp" repeat:1];
    [self generateWorldWithImage:@"spikes" repeat:1];
    [self generateWorldWithImage:@"ground" repeat:2];
    //Creating Background
    [self generateBackgroundIn:_backgroundMountainLayer withImage:@"backgroundMountain" repeat:10];
    [self generateBackgroundIn:_backgroundTreeLayer2 withImage:@"backgroundTrees2" repeat:10];
    [self generateBackgroundIn:_backgroundTreeLayer withImage:@"backgroundTrees" repeat:10];
    
    SKSpriteNode *sky = [SKSpriteNode spriteNodeWithImageNamed:@"backgroundSky"];
    sky.size = self.frame.size;
    [_backgroundSkyLayer addChild:sky];
    
    //Inserting Player
    _henry = [Henry henry];
    _henry.physicsBody.categoryBitMask = PLAYER_CATEGORY;
    _henry.physicsBody.collisionBitMask = GROUND_CATEGORY;
    _henry.physicsBody.contactTestBitMask = GROUND_CATEGORY | ENEMY_CATEGORY | VICTORY_LIGHT_CATEGORY;
    
    [_world addChild:_henry];
    //Inserting Kopp
    Kopp *kopp = [Kopp kopp:_henry];
    
    //Inserting Enemy
    _bat = [Bat bat];
    _bat.position = CGPointMake(1000, 30);
    _bat.physicsBody.categoryBitMask = ENEMY_CATEGORY;
    _bat.physicsBody.collisionBitMask = 0;
    _bat.physicsBody.contactTestBitMask = PLAYER_CATEGORY | KILL_ENEMY_CATEGORY;
    _bat.shadowCastBitMask = LIGHT_CATEGORY;
    
    [_world addChild:_bat];
    
    _ghost = [Ghost ghost];
    _ghost.position = CGPointMake(700, 100);
    _ghost.physicsBody.categoryBitMask = ENEMY_CATEGORY;
    _ghost.physicsBody.collisionBitMask = 0;
    _ghost.physicsBody.contactTestBitMask = PLAYER_CATEGORY | KILL_ENEMY_CATEGORY;
    _ghost.shadowCastBitMask = LIGHT_CATEGORY;
    
    [_world addChild:_ghost];
    
    //Inserting Victory Light - Ending of stage
    
    _victoryLight = [VictoryLight victoryLight];
    _victoryLight.size = self.size;
    [_victoryLight insertElements];
    _victoryLight.position = CGPointMake(_currentGroundX - self.frame.size.width, 0);
    [_world addChild:_victoryLight];
    
    
    //Inserting Hud Controls
    
    //Buttons
    SKSpriteNode *rightButton = [SKSpriteNode spriteNodeWithImageNamed:@"rightButton"];
    rightButton.size = CGSizeMake(60, 60);
    rightButton.name = @"rightButton";
    rightButton.position = CGPointMake(-self.frame.size.width * 0.5 +rightButton.frame.size.width * 0.5 + rightButton.frame.size.width + 5,
                                       -self.frame.size.height * 0.5 + rightButton.frame.size.height * 0.5 +10);
    
    [_HUD addChild:rightButton];
    
    SKSpriteNode *leftButton = [SKSpriteNode spriteNodeWithImageNamed:@"leftButton"];
    leftButton.size = CGSizeMake(60, 60);
    leftButton.name = @"leftButton";
    leftButton.position = CGPointMake(-self.frame.size.width * 0.5 +leftButton.frame.size.width * 0.5 + 10,
                                      -self.frame.size.height * 0.5 + leftButton.frame.size.height * 0.5 + leftButton.frame.size.height);
    
    [_HUD addChild:leftButton];
    
    SKSpriteNode *jumpButton = [SKSpriteNode spriteNodeWithImageNamed:@"jumpButton"];
    jumpButton.size = CGSizeMake(60, 60);
    jumpButton.name = @"jumpButton";
    jumpButton.position = CGPointMake(self.frame.size.width * 0.5 - jumpButton.frame.size.width * 0.5 - 10 ,
                                      -self.frame.size.height * 0.5 + jumpButton.frame.size.height * 0.5 + jumpButton.frame.size.height);
    
    [_HUD addChild:jumpButton];
    
    SKSpriteNode *lanternButton = [SKSpriteNode spriteNodeWithImageNamed:@"lantern"];
    lanternButton.size = CGSizeMake(60, 60);
    lanternButton.name = @"lanternButton";
    lanternButton.position = CGPointMake(self.frame.size.width * 0.5 - 3 * lanternButton.frame.size.width * 0.5,
                                         -self.frame.size.height * 0.5 + lanternButton.frame.size.height * 0.5 + 10);
    
    [_HUD addChild:lanternButton];
    
    SKSpriteNode *configButton = [SKSpriteNode spriteNodeWithImageNamed:@"gear"];
    configButton.size = CGSizeMake(30, 30);
    configButton.name = @"configButton";
    configButton.position = CGPointMake(self.frame.size.width * 0.5 - configButton.frame.size.width * 0.5 - 15,
                                        self.frame.size.height * 0.5 - configButton.frame.size.height * 0.5 - 15);
    [_HUD addChild:configButton];
    
    
    SKSpriteNode *encyclopediaButton = [SKSpriteNode spriteNodeWithImageNamed:@"book"];
    encyclopediaButton.size = CGSizeMake(30, 30);
    encyclopediaButton.name = @"encyclopediaButton";
    encyclopediaButton.position = CGPointMake(configButton.position.x - encyclopediaButton.frame.size.width * 0.5 - 25 , self.frame.size.height * 0.5 - encyclopediaButton.frame.size.height * 0.5 - 15);
    [_HUD addChild:encyclopediaButton];
    
    SKSpriteNode *changeStoneButton = [SKSpriteNode spriteNodeWithImageNamed:@"magicStone"];
    changeStoneButton.size = CGSizeMake(30, 30);
    changeStoneButton.name = @"changeStoneButton";
    changeStoneButton.position = CGPointMake(encyclopediaButton.position.x - changeStoneButton.frame.size.width * 0.5 - 25 ,
                                             self.frame.size.height * 0.5 - changeStoneButton.frame.size.height * 0.5 - 15);
    [_HUD addChild:changeStoneButton];
    
    // Inserting Life and Score
    
    SKSpriteNode *life = [SKSpriteNode spriteNodeWithImageNamed:@"henryLife"];
    [life setScale:0.1];
    life.position = CGPointMake(-self.frame.size.width * 0.5 + life.frame.size.width * 0.5 + 10,
                                self.frame.size.height * 0.5 - life.frame.size.height * 0.5 - 10);
    
    [_HUD addChild:life];
    
    SKSpriteNode *xSeparator = [SKSpriteNode spriteNodeWithImageNamed:@"x"];
    xSeparator.size = CGSizeMake(life.frame.size.width*0.5, life.frame.size.height*0.5);
    xSeparator.position = CGPointMake(life.position.x + life.frame.size.width * 0.5 + xSeparator.frame.size.width * 0.5 - 5 , life.position.y - 5 );
    
    [xSeparator setScale:0.5];
    [_HUD addChild:xSeparator];
    
    _lifeLabel = [SKLabelNode labelNodeWithFontNamed:_fontName];
    _lifeLabel.fontColor = [UIColor whiteColor];
    _lifeLabel.fontSize = 25;
    _lifeLabel.position = CGPointMake(xSeparator.position.x + 15 , xSeparator.position.y - 5);
    _lifeLabel.text = [NSString stringWithFormat:@"%d",_numberOfLives];
    
    [_HUD addChild:_lifeLabel];
    
    _labelScore = [SKLabelNode labelNodeWithFontNamed:_fontName];
    _labelScore.position = CGPointMake(_lifeLabel.position.x - 10, _lifeLabel.position.y - 30);
    _labelScore.fontSize = 20;
    _labelScore.fontColor = [UIColor whiteColor];
    _labelScore.text = [NSString stringWithFormat:@"%d",_score];
    
    [_HUD addChild:_labelScore];
    
    [self timer];
    [self startTimer];
    
    /////////////////////////////////////////////////////////Defining Sound/////////////////////////////////////////////////////////
    
    
    NSURL *url1 = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/nightForestSound.mp3", [[NSBundle mainBundle] resourcePath]]];
    NSURL *url2 = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/nightForestMusic.mp3", [[NSBundle mainBundle] resourcePath]]];
    NSURL *url3 = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/victoryMusic.mp3", [[NSBundle mainBundle] resourcePath]]];
    
    NSError *error;
    
    self.soundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url1 error:&error];
    self.soundPlayer.numberOfLoops = -1;
    
    self.musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url2 error:&error];
    self.musicPlayer.numberOfLoops = -1;
    
    self.victoryMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url3 error:&error];
    self.victoryMusicPlayer.numberOfLoops = -1;
    
    if (!self.soundPlayer || !self.musicPlayer)
        NSLog([error localizedDescription]);
    else
    {
        _soundOn= YES;
        [self.soundPlayer play];
        [self.musicPlayer play];
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
}

- (void)timer
{
    _labelTimer = [SKLabelNode labelNodeWithText:@"00:00"];
    
    _labelTimer.fontName = _fontName;
    _labelTimer.position = CGPointMake(0, _lifeLabel.position.y);
    _labelTimer.fontSize = 30;
    _labelTimer.name = @"timer";
    _labelTimer.fontColor = [UIColor whiteColor];
    _labelTimer.zPosition = 1;
    
    [_labelTimer setScale:0.9];
    [_HUD addChild:_labelTimer];
    
}
-(void)startTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(increaseTimer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

-(void)increaseTimer
{
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


- (void)stopTimer
{
    [_timer invalidate];
}

-(void)setNumberOfLives:(int)numberOfLives
{
    
    _numberOfLives = numberOfLives;
    if (numberOfLives >= 0) {
        _lifeLabel.text = [NSString stringWithFormat:@"%d",numberOfLives];
    }
    
    
}

-(void)setScore:(int)score
{
    _score = score;
    _labelScore.text = [NSString stringWithFormat:@"%d",score];
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    if (!_isDead) {
        
        
        for (UITouch *touch in touches) {
            
            SKNode *n = [_HUD nodeAtPoint:[touch locationInNode:_HUD]];
            
            if([n.name isEqualToString:@"rightButton"]){
                
                _rightButtonPressed = YES;
                _moving = YES;
                [_henry removeActionForKey:@"idleAnimation"];
                _flipped = NO;
                
                [_henry walkRight];
            }
            else if([n.name isEqualToString:@"leftButton"]){
                
                _leftButtonPressed = YES;
                _moving = YES;
                [_henry removeActionForKey:@"idleAnimation"];
                _flipped = YES;
                
                [_henry walkLeft];
            }
            else if([n.name isEqualToString:@"jumpButton"]){
                
                if(!_jumping){
                    _jumping = YES;
                    [_henry jump];
                }
            }
            else if([n.name isEqualToString:@"lanternButton"]){
                
                if(!_isDead){
                    
                    _lanternLit = YES;
                    [_henry removeActionForKey:@"idleAnimation"];
                    [_henry removeActionForKey:@"walkAnimation"];
                    [_henry removeActionForKey:@"walkLeft"];
                    [_henry removeActionForKey:@"walkRight"];
                    if (_flipped) {
                        [_henry setTexture:[SKTexture textureWithImageNamed:@"spriteHenryLanternLeft"]];
                        _henry.size = CGSizeMake(80, 100);
                        
                        
                    }else{
                        [_henry setTexture:[SKTexture textureWithImageNamed:@"spriteHenryLantern"]];
                        _henry.size = CGSizeMake(80, 100);
                        
                    }
                    
                    [_henry pickLantern];
                    
                }
            }
            
        }
    }
}

-(void)clear{
    
    
    [_henry removeActionForKey:@"walkLeft"];
    [_henry removeActionForKey:@"walkRight"];
    [_henry removeActionForKey:@"walkAnimation"];
    [_henry removeActionForKey:@"idleAnimation"];

    _henry.position = CGPointMake(0, 0);
    [_world addChild:_henry];
    [_henry idleAnimation];
    _isDead = NO;
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_isDead) {
        
        
        for (UITouch *touch in touches) {
            
            SKNode *n = [_HUD nodeAtPoint:[touch locationInNode:_HUD]];
            
            if ([n.name isEqualToString:@"rightButton"]) {
                _rightButtonPressed = NO;
                _moving = NO;
                [_henry removeActionForKey:@"walkRight"];
                [_henry removeActionForKey:@"walkLeft"];
                [_henry idleAnimation];
            }
            else if ([n.name isEqualToString:@"leftButton"]) {
                _leftButtonPressed = NO;
                _moving = NO;
                [_henry removeActionForKey:@"walkRight"];
                [_henry removeActionForKey:@"walkLeft"];
                [_henry idleAnimationLeft];
            }
            else if([n.name isEqualToString:@"lanternButton"]){
                _lanternLit = NO;
                [_henry enumerateChildNodesWithName:@"lanternLightParticle" usingBlock:^(SKNode *node, BOOL *stop) {
                    [node removeFromParent];
                }];
                [_henry enumerateChildNodesWithName:@"lanternLight" usingBlock:^(SKNode *node, BOOL *stop) {
                    [node removeFromParent];
                }];
                [_henry enumerateChildNodesWithName:@"fakeLanternLight" usingBlock:^(SKNode *node, BOOL *stop) {
                    [node removeFromParent];
                }];
                if (_flipped) {
                    [_henry idleAnimationLeft];
                }
                else{
                    [_henry idleAnimation];
                }
            }
            else if(![n.name isEqualToString:@"jumpButton"]){
                
                _rightButtonPressed = NO;
                _leftButtonPressed = NO;
                _lanternLit = NO;
                _moving = NO;
                [_henry removeActionForKey:@"walkLeft"];
                [_henry removeActionForKey:@"walkRight"];
                [_henry removeActionForKey:@"walkAnimation"];
                [_henry enumerateChildNodesWithName:@"lanternLightParticle" usingBlock:^(SKNode *node, BOOL *stop) {
                    [node removeFromParent];
                }];
                [_henry enumerateChildNodesWithName:@"lanternLight" usingBlock:^(SKNode *node, BOOL *stop) {
                    [node removeFromParent];
                }];
                [_henry enumerateChildNodesWithName:@"fakeLanternLight" usingBlock:^(SKNode *node, BOOL *stop) {
                    [node removeFromParent];
                }];
                
            }
            
            
            if([n.name isEqualToString:@"configButton"] || [n.name isEqualToString:@"circle1"])
            {
                [self backgroundButtons];
                
                
                _tituloLabelButton.text = @"Configurações";
                
                _currentLanguageImage = [SKSpriteNode spriteNodeWithImageNamed:@""];
                _currentLanguageImage.position = CGPointMake(0,0);
                _currentLanguageImage.size = CGSizeMake(_sound.frame.size.width, _sound.frame.size.height);
                _currentLanguageImage.zPosition = 1;
                [self defineLanguage:_currentLanguage];
                
                
                if (_soundOn == YES)
                {
                    _sound = [SKSpriteNode spriteNodeWithImageNamed:@"soundOn"];
                }
                else if( _soundOn == NO)
                {
                    _sound = [SKSpriteNode spriteNodeWithImageNamed:@"soundOff"];
                }
                
                _sound.position = CGPointMake(0 + _backgroundMenus.frame.size.width * 0.25 ,_backgroundMenus.frame.size.height * 0.15);
                _sound.name = @"sound";
                _sound.zPosition = 1;
                [_sound setScale:0.2];
                
                _currentLanguageImage = [SKSpriteNode spriteNodeWithImageNamed:@""];
                _currentLanguageImage.position = CGPointMake(0 + _backgroundMenus.frame.size.width * 0.25 , 0 - _backgroundMenus.frame.size.height * 0.15);
                _currentLanguageImage.size = CGSizeMake(_sound.frame.size.width, _sound.frame.size.height);
                _currentLanguageImage.zPosition = 1;
                _currentLanguageImage.name = @"currentLanguageImage";
                [self defineLanguage:_currentLanguage];
                
                
                [_backgroundMenus addChild:_sound];
                [_backgroundMenus addChild:_currentLanguageImage];
            }
            
            else if([n.name isEqualToString:@"encyclopediaButton"] || [n.name isEqualToString:@"circle2"] )
            {
                
                [self backgroundButtons];
                _tituloLabelButton.text = @"Enciclopédia";
                
                
            }
            
            else if([n.name isEqualToString:@"changeStoneButton"] || [n.name isEqualToString:@"circle3"] )
            {
                [self backgroundButtons];
                _tituloLabelButton.text = @"Pedras";
                
            }
            
            
            if ([n.name isEqualToString:@"x"])
            {
                [_backgroundMenus removeFromParent];
                [self unpauseGame];
            }
            
            else if ([n.name isEqualToString:@"sound"])
            {
                if (_soundOn == YES)
                {
                    _soundOn = NO;
                    [_sound setTexture:[SKTexture textureWithImageNamed:@"soundOff"]];
                    [self.musicPlayer stop];
                    [self.soundPlayer stop];
                }
                else if( _soundOn == NO)
                {
                    _soundOn =YES;
                    [_sound setTexture:[SKTexture textureWithImageNamed:@"soundOn"]];
                    [self.musicPlayer play];
                    [self.soundPlayer play];
                }
            }
            
            else if ( [n.name isEqualToString:@"currentLanguageImage"])
            {
                if ([_currentLanguage isEqualToString:@"Portugues"])
                {
                    _currentLanguage = @"Ingles";
                    [self defineLanguage: _currentLanguage];
                }
                else if ([_currentLanguage isEqualToString:@"Ingles"])
                {
                    _currentLanguage = @"Portugues";
                    [self defineLanguage: _currentLanguage];
                }
                
            }
            
        }
    }
}

//Define Language
-(void)defineLanguage:(NSString *) currentLanguage
{
    if ([currentLanguage isEqualToString:@"Portugues"])
    {
        [_currentLanguageImage setTexture: [SKTexture textureWithImageNamed:@"brasilImage"]];
    }
    else if ( [ currentLanguage isEqualToString:@"Ingles"])
    {
        [_currentLanguageImage setTexture: [SKTexture textureWithImageNamed:@"estadosunidosImage"]];
    }
}

//Define BackgroundButtons
-(void)backgroundButtons
{
    _backgroundMenus = [SKSpriteNode spriteNodeWithImageNamed:@"backgroundConfigButton"];
    _backgroundMenus.position = CGPointMake(0, 0);
    _backgroundMenus.size = CGSizeMake(300, 250);
    _backgroundMenus.zPosition = 1;
    
    _xMenu =[SKSpriteNode spriteNodeWithImageNamed:@"xButton"];
    _xMenu.position = CGPointMake(_backgroundMenus.frame.size.width * 0.5, _backgroundMenus.frame.size.height * 0.5);
    _xMenu.size = CGSizeMake(25,25);
    _xMenu.name = @"x";
    _xMenu.zPosition = 1;
    
    _tituloLabelButton = [SKLabelNode labelNodeWithFontNamed:_fontName];
    _tituloLabelButton.position = CGPointMake(0, 90);
    _tituloLabelButton.fontSize = 25;
    _tituloLabelButton.name = @"tituloLabel";
    _tituloLabelButton.fontColor = [UIColor colorWithRed:36.0f/255.0f green:64.0f/255.0f blue:96.0f/255.0f alpha:1];
    
    
    [self pauseGame];
    [_HUD addChild:_backgroundMenus];
    [_backgroundMenus addChild:_xMenu];
    [_backgroundMenus addChild:_tituloLabelButton];
}

//Função para pausar o game
-(void)pauseGame
{
    _isGamePaused = YES; //Set pause flag to true
    self.paused = YES; //Pause scene and physics simulation
}

//função para despausar o game
-(void)unpauseGame
{
    _isGamePaused = NO; //Set pause flag to false
    self.paused = NO; //Resume scene and physics simulation
}

-(void)henryDead
{
    _isDead = YES;

    self.numberOfLives--;
    
    
    if(_lanternLit){
        _lanternLit = NO;
        [_henry enumerateChildNodesWithName:@"lanternLightParticle" usingBlock:^(SKNode *node, BOOL *stop) {
            [node removeFromParent];
        }];
        [_henry enumerateChildNodesWithName:@"lanternLight" usingBlock:^(SKNode *node, BOOL *stop) {
            [node removeFromParent];
        }];
        [_henry enumerateChildNodesWithName:@"fakeLanternLight" usingBlock:^(SKNode *node, BOOL *stop) {
            [node removeFromParent];
        }];
    }
    
    [_henry removeActionForKey:@"walkLeft"];
    [_henry removeActionForKey:@"walkRight"];
    [_henry removeActionForKey:@"walkAnimation"];
    [_henry removeActionForKey:@"idleAnimation"];
    
    
    if (self.numberOfLives >= 0){
        
        [self performSelector:@selector(clear) withObject:self afterDelay:5];
        
    }else{
        
        
        SKLabelNode *gameOverLabel = [SKLabelNode labelNodeWithFontNamed:@"DIN Alternate"];
        gameOverLabel.position = CGPointMake(0, 0);
        gameOverLabel.fontColor = [UIColor redColor];
        gameOverLabel.fontSize = 40;
        gameOverLabel.text = @"Game Over";
        [_HUD addChild:gameOverLabel];
        [_henry removeActionForKey:@"walkLeft"];
        [_henry removeActionForKey:@"walkRight"];
        [_henry removeActionForKey:@"walkAnimation"];
        [_henry removeActionForKey:@"idleAnimation"];
        
    }
}


-(void)didBeginContact:(SKPhysicsContact *)contact{
    
    SKPhysicsBody *firstBody;
    SKPhysicsBody *secondBody;
    
    if(contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask )
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
        
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if(firstBody.categoryBitMask == GROUND_CATEGORY && secondBody.categoryBitMask == PLAYER_CATEGORY){
        _jumping = NO;
    }
    else if(firstBody.categoryBitMask == PLAYER_CATEGORY && secondBody.categoryBitMask == ENEMY_CATEGORY){
        
        if (_flipped) {
            [_henry deathAnimationLeft];
        }
        else{
            [_henry deathAnimation];
        }
        [self henryDead];
        
    }else if(firstBody.categoryBitMask == ENEMY_CATEGORY && secondBody.categoryBitMask == KILL_ENEMY_CATEGORY){

        if(_lanternLit){
            
            
            if ([firstBody.node.name isEqualToString:@"bat"])
            {
                [_bat death];
                
            }
            else if([firstBody.node.name isEqualToString:@"ghost"]){
                [firstBody.node removeFromParent];
            }
        }
        
        
    }else if(firstBody.categoryBitMask == PLAYER_CATEGORY && secondBody.categoryBitMask == VICTORY_LIGHT_CATEGORY){
        [self.musicPlayer stop];
        [self.soundPlayer stop];
        [self.victoryMusicPlayer play];
    }
    
}


-(void)didSimulatePhysics
{
    if(!_isDead){
        [self centerOnNode:_henry];
    }
    
    [_world enumerateChildNodesWithName:@"henry" usingBlock:^(SKNode *node, BOOL *stop) {
        if(node.position.y + node.frame.size.height < (-self.frame.size.height * 0.5))
        {
            if (_flipped) {
                [_henry deathAnimationLeft];
            }
            else{
                [_henry deathAnimation];
            }
            [self henryDead];
        }
    }];
    
    if (_bat.position.x - _henry.position.x < 400 ) {
        [_bat attackPlayer:_henry];
    }
    if (_ghost.position.x - _henry.position.x < 300) {
        [_ghost attackPlayer:_henry];
    }
    
    [_henry enumerateChildNodesWithName:@"killerLine" usingBlock:^(SKNode *node, BOOL *stop) {
        node.position = CGPointMake(node.position.x,-20);
    }];
    
    
}
-(void)centerOnNode:(SKNode *)node
{
    
    CGPoint positionInScene = [self convertPoint:node.position fromNode:node.parent];
    
    
    
    positionInScene.x += 200;
    _world.position = CGPointMake(_world.position.x - positionInScene.x, _world.position.y);
    
    
    
    _backgroundTreeLayer.position = CGPointMake(_backgroundTreeLayer.position.x - positionInScene.x * 0.7 ,
                                                _backgroundTreeLayer.position.y);
    
    
    _backgroundTreeLayer2.position = CGPointMake(_backgroundTreeLayer2.position.x - positionInScene.x * 0.3 ,
                                                 _backgroundTreeLayer2.position.y);
    
    
    _backgroundMountainLayer.position = CGPointMake(_backgroundMountainLayer.position.x - positionInScene.x * 0.1,
                                                    _backgroundMountainLayer.position.y);
    
    
}

-(void)generateWorldWithImage:(NSString *)groundImageName repeat:(int)times
{
    
    
    if([groundImageName isEqualToString:@"ground"]){
        
        for (int i = 0; i < times; i++) {
            SKSpriteNode *ground = [SKSpriteNode spriteNodeWithImageNamed:@"ground"];
            ground.size = CGSizeMake(self.frame.size.width , 100);
            ground.position = CGPointMake(_currentGroundX, -self.frame.size.height * 0.5 + ground.frame.size.height * 0.5);
            ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.frame.size.width , 50)];
            ground.physicsBody.dynamic = NO;
            ground.physicsBody.categoryBitMask = GROUND_CATEGORY;
            [_world addChild:ground];
            _currentGroundX += ground.frame.size.width;
        }
        
        
    }
    else if([groundImageName isEqualToString:@"groundBig"]){
        
        for (int i = 0; i < times; i++) {
            SKSpriteNode *ground = [SKSpriteNode spriteNodeWithImageNamed:@"groundBig"];
            ground.size = CGSizeMake(self.frame.size.width , 160);
            ground.position = CGPointMake(_currentGroundX, -self.frame.size.height * 0.5 + ground.frame.size.height * 0.5);
            ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.frame.size.width, 80)];
            ground.physicsBody.dynamic = NO;
            ground.physicsBody.categoryBitMask = GROUND_CATEGORY;
            [_world addChild:ground];
            _currentGroundX += ground.frame.size.width;
        }
        
        
    }
    else if([groundImageName isEqualToString:@"groundRamp"]){
        
        for (int i = 0; i < times; i++) {
            SKSpriteNode *ground = [SKSpriteNode spriteNodeWithImageNamed:@"groundRamp"];
            ground.size = CGSizeMake(self.frame.size.width , 160);
            ground.position = CGPointMake(_currentGroundX, -self.frame.size.height * 0.5 + ground.frame.size.height * 0.5);
            ground.physicsBody = [SKPhysicsBody bodyWithTexture:[SKTexture textureWithImageNamed:@"groundRamp"] size:CGSizeMake(ground.frame.size.width, ground.frame.size.height - 78)];
            ground.physicsBody.dynamic = NO;
            ground.physicsBody.categoryBitMask = GROUND_CATEGORY;
            [_world addChild:ground];
            _currentGroundX += ground.frame.size.width;
            
        }
        
        
    }
    else if([groundImageName isEqualToString:@"spikes"]){
        
        for (int i = 0; i < times; i++) {
            SKSpriteNode *ground = [SKSpriteNode spriteNodeWithImageNamed:@"spikes"];
            ground.size = CGSizeMake(self.frame.size.width * 0.25 , 80);
            ground.position = CGPointMake(_currentGroundX - self.frame.size.width * 0.5 + ground.frame.size.width * 0.5, -self.frame.size.height * 0.5 + ground.frame.size.height * 0.5);
            ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:ground.size];
            ground.physicsBody.dynamic = NO;
            ground.physicsBody.categoryBitMask = ENEMY_CATEGORY;
            [_world addChild:ground];
            _currentGroundX += ground.frame.size.width;
            
        }
        
        
    }
}


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

-(void)generateBackgroundIn:(SKNode *)backgroundLayer withImage:(NSString *)backgroundImageName repeat:(int)times
{
    
    CGFloat currentBackgroundX = 0;
    
    for (int i = 0; i < times; i++) {
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:backgroundImageName normalMapped:NO];
        //background.lightingBitMask = 0x1 << 31;
        background.size = self.frame.size;
        background.position = CGPointMake(currentBackgroundX,70);
        background.name = @"background";
        [backgroundLayer addChild:background];
        currentBackgroundX += background.frame.size.width;
    }
    
}


@end
