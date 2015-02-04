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

@interface GameScene ()

@property BOOL isStarted;
@property BOOL isGameOver;
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
    
    
    SKAction *_backgroundMusic;
    SKAction *_backgroundSound;
    
    SKSpriteNode *_sound;
    SKSpriteNode *_backgroundMenus;
    SKSpriteNode *_xMenu;
    
    SKLabelNode *_labelScore;
    SKLabelNode *_labelTimer;
    
    Henry *_henry;
    
    NSMutableArray *_enemies;
    NSTimer *_timer;
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
static const uint32_t LIGHT_CATEGORY = 0x1 << 31;



-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    
    
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
    
    [self addChild:_HUD];
    
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    ///////////////////////////////////////////////////////////Inserting Objects//////////////////////////////////////////////////////////////
    
    //Inserting Ground
    _currentGroundX = 0;
    [self generateWorldWithImage:@"ground" repeat:4];
    [self generateWorldWithImage:@"groundBig" repeat:3];
    [self generateWorldWithImage:@"ground" repeat:4];
    [self generateWorldWithImage:@"groundRamp" repeat:1];
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
    _henry.physicsBody.contactTestBitMask = GROUND_CATEGORY;
    [_world addChild:_henry];
    
    //Inserting Kopp
    Kopp *kopp = [Kopp kopp:_henry];
    
    //Inserting Enemy
    _bat = [Bat bat];
    _bat.position = CGPointMake(1000, 30);
    _bat.physicsBody.categoryBitMask = ENEMY_CATEGORY;
    _bat.physicsBody.collisionBitMask = PLAYER_CATEGORY;
    _bat.physicsBody.contactTestBitMask = PLAYER_CATEGORY | KILL_ENEMY_CATEGORY;
    _bat.shadowCastBitMask = LIGHT_CATEGORY;
    _bat.zPosition = 1;
    
    [_world addChild:_bat];
    
    _ghost = [Ghost ghost];
    _ghost.position = CGPointMake(700, 100);
    _ghost.physicsBody.categoryBitMask = ENEMY_CATEGORY;
    _ghost.physicsBody.collisionBitMask = PLAYER_CATEGORY;
    _ghost.physicsBody.contactTestBitMask = PLAYER_CATEGORY | KILL_ENEMY_CATEGORY;
    _ghost.shadowCastBitMask = LIGHT_CATEGORY;
    _ghost.zPosition = 1;
    
    [_world addChild:_ghost];
    
    //Inserting Hud Controls
    
    //Buttons
    SKSpriteNode *rightButton = [SKSpriteNode spriteNodeWithImageNamed:@"rightButton"];
    rightButton.size = CGSizeMake(60, 60);
    rightButton.name = @"rightButton";
    rightButton.position = CGPointMake(-self.frame.size.width * 0.5 +rightButton.frame.size.width * 0.5 + rightButton.frame.size.width + 5,
                                       -self.frame.size.height * 0.5 + rightButton.frame.size.height * 0.5);
    
    [_HUD addChild:rightButton];
    
    SKSpriteNode *leftButton = [SKSpriteNode spriteNodeWithImageNamed:@"leftButton"];
    leftButton.size = CGSizeMake(60, 60);
    leftButton.name = @"leftButton";
    leftButton.position = CGPointMake(-self.frame.size.width * 0.5 +leftButton.frame.size.width * 0.5,
                                      -self.frame.size.height * 0.5 + leftButton.frame.size.height * 0.5);
    
    [_HUD addChild:leftButton];
    
    SKSpriteNode *jumpButton = [SKSpriteNode spriteNodeWithImageNamed:@"jumpButton"];
    jumpButton.size = CGSizeMake(60, 60);
    jumpButton.name = @"jumpButton";
    jumpButton.position = CGPointMake(self.frame.size.width * 0.5 - jumpButton.frame.size.width * 0.5,
                                      -self.frame.size.height * 0.5 + jumpButton.frame.size.height * 0.5 + jumpButton.frame.size.height);
    
    [_HUD addChild:jumpButton];
    
    SKSpriteNode *lanternButton = [SKSpriteNode spriteNodeWithImageNamed:@"lantern"];
    lanternButton.size = CGSizeMake(60, 60);
    lanternButton.name = @"lanternButton";
    lanternButton.position = CGPointMake(self.frame.size.width * 0.5 - 3 * lanternButton.frame.size.width * 0.5,
                                         -self.frame.size.height * 0.5 + lanternButton.frame.size.height * 0.5);
    
    [_HUD addChild:lanternButton];
    
    SKShapeNode *circle1 = [SKShapeNode shapeNodeWithCircleOfRadius:13.0];
    circle1.position = CGPointMake(0,0);
    circle1.name = @"circle1";
    circle1.fillColor = [UIColor whiteColor];
    
    SKSpriteNode *configButton = [SKSpriteNode spriteNodeWithImageNamed:@"gear"];
    configButton.size = CGSizeMake(20, 20);
    configButton.name = @"configButton";
    configButton.position = CGPointMake(self.frame.size.width * 0.5 - configButton.frame.size.width * 0.5 - 5,
                                        self.frame.size.height * 0.5 - configButton.frame.size.height * 0.5 - 5);
    [configButton addChild:circle1];
    [_HUD addChild:configButton];
    
    
    SKShapeNode *circle2 = [SKShapeNode shapeNodeWithCircleOfRadius:13.0];
    circle2.position = CGPointMake(0,0);
    circle2.name = @"circle2";
    circle2.fillColor = [UIColor whiteColor];
    
    SKSpriteNode *encyclopediaButton = [SKSpriteNode spriteNodeWithImageNamed:@"book"];
    encyclopediaButton.size = CGSizeMake(20, 20);
    encyclopediaButton.name = @"encyclopediaButton";
    encyclopediaButton.position = CGPointMake(self.frame.size.width * 0.5 - encyclopediaButton.frame.size.width * 2.0 - 10,
                                              self.frame.size.height * 0.5 - encyclopediaButton.frame.size.height * 0.5 - 5);
    [encyclopediaButton addChild:circle2];
    [_HUD addChild:encyclopediaButton];
    
    SKShapeNode *circle3 = [SKShapeNode shapeNodeWithCircleOfRadius:13.0];
    circle3.position = CGPointMake(0,0);
    circle3.name = @"circle3";
    circle3.fillColor = [UIColor whiteColor];
    
    SKSpriteNode *changeStoneButton = [SKSpriteNode spriteNodeWithImageNamed:@"magicStone"];
    changeStoneButton.size = CGSizeMake(20, 20);
    changeStoneButton.name = @"changeStoneButton";
    changeStoneButton.position = CGPointMake(self.frame.size.width * 0.5 - changeStoneButton.frame.size.width * 4.0 - 10,
                                             self.frame.size.height * 0.5 - changeStoneButton.frame.size.height * 0.5 - 5);
    [changeStoneButton addChild:circle3];
    [_HUD addChild:changeStoneButton];
    
    // Inserting Life and Score
    SKSpriteNode *life = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(40, 40)];
    SKSpriteNode *leftEye = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(5, 5)];
    leftEye.position = CGPointMake(-3, 8);
    [life addChild:leftEye];
    
    SKSpriteNode *rightEye = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(5, 5)];
    rightEye.position = CGPointMake(13, 8);
    [life addChild:rightEye];
    
    [life setScale:0.5];
    life.position = CGPointMake(-self.frame.size.width * 0.5 + life.frame.size.width * 0.5 + 10,
                                self.frame.size.height * 0.5 - life.frame.size.height * 0.5 - 10);
    
    [_HUD addChild:life];
    
    SKSpriteNode *xSeparator = [SKSpriteNode spriteNodeWithImageNamed:@"x"];
    xSeparator.size = life.size;
    xSeparator.position = CGPointMake(life.position.x + life.frame.size.width * 0.5 + xSeparator.frame.size.width * 0.5, life.position.y - 5 );
    
    [xSeparator setScale:0.5];
    [_HUD addChild:xSeparator];
    
    _lifeLabel = [SKLabelNode labelNodeWithFontNamed:@"DIN Alternate"];
    _lifeLabel.fontColor = [UIColor whiteColor];
    _lifeLabel.fontSize = 25;
    
    _lifeLabel.position = CGPointMake(xSeparator.position.x + 15 , xSeparator.position.y - 5);
    
    [_HUD addChild:_lifeLabel];
    
    _labelScore = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
    _labelScore.position = CGPointMake(_lifeLabel.position.x - 10, _lifeLabel.position.y - 30);
    _labelScore.fontSize = 20;
    _labelScore.fontColor = [UIColor whiteColor];
    
    [_HUD addChild:_labelScore];
    
    [self timer];
    [self startTimer];
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    //Defining Inicial Values
    self.numberOfLives = 3;
    self.score = 0;
    _time = 0;
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /////////////////////////////////////////////////////////Defining Sound/////////////////////////////////////////////////////////
    
    
    NSURL *url1 = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/nightForestSound.mp3", [[NSBundle mainBundle] resourcePath]]];
    NSURL *url2 = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/nightForestMusic.mp3", [[NSBundle mainBundle] resourcePath]]];
    
    NSError *error;
    
    self.soundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url1 error:&error];
    self.soundPlayer.numberOfLoops = -1;
    
    self.musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url2 error:&error];
    self.musicPlayer.numberOfLoops = -1;
    
    if (!self.soundPlayer || !self.musicPlayer)
        NSLog([error localizedDescription]);
    else
    {
        _soundOn= YES;
        [self.soundPlayer play];
        [self.musicPlayer play];
    }
    //    _backgroundSound = [SKAction repeatActionForever:[SKAction playSoundFileNamed:@"nightForestSound.mp3" waitForCompletion:YES]];
    //    [self runAction:_backgroundSound];
    //
    //    _backgroundMusic = [SKAction repeatActionForever:[SKAction playSoundFileNamed:@"nightForestMusic.mp3" waitForCompletion:YES]];
    //    [self runAction:_backgroundMusic];
    //
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
}

- (void)timer
{
    _labelTimer = [SKLabelNode labelNodeWithText:@"00:00"];
    
    _labelTimer.fontName = @"DKCoolCrayon";
    _labelTimer.position = CGPointMake(0, _lifeLabel.position.y);
    _labelTimer.fontSize = 20;
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
    _labelScore.text = [NSString stringWithFormat:@"Score: %d",score];
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
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
            
            if(!_isGameOver){

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

-(void)clear
{
    _isGameOver = NO;
    _henry.position = CGPointMake(0, 0);
    [_world addChild:_henry];
    
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
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
            
            SKLabelNode *tituloLabel = [SKLabelNode labelNodeWithText: @"Configurações:"];
            tituloLabel.position = CGPointMake(0, 90);
            tituloLabel.fontSize = 20;
            tituloLabel.fontColor = [UIColor blackColor];
            
            
            if (_soundOn == YES)
            {
                _sound = [SKSpriteNode spriteNodeWithImageNamed:@"soundOn"];
            }
            else if( _soundOn == NO)
            {
                _sound = [SKSpriteNode spriteNodeWithImageNamed:@"soundOff"];
            }
            
            _sound.position = CGPointMake(0,0);
            _sound.size = CGSizeMake(50,50);
            _sound.name = @"sound";
            _sound.zPosition = 1;
            
            
            
            [_backgroundMenus addChild:tituloLabel];
            [_backgroundMenus addChild:_sound];
            
        }
        
        else if([n.name isEqualToString:@"encyclopediaButton"] || [n.name isEqualToString:@"circle2"] )
        {
            
            [self backgroundButtons];
            
            
        }
        
        else if([n.name isEqualToString:@"changeStoneButton"] || [n.name isEqualToString:@"circle3"] )
        {
            [self backgroundButtons];
            
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
        
    }
    
}



-(void)backgroundButtons
{
    _backgroundMenus = [SKSpriteNode spriteNodeWithImageNamed:@"backgroundConfigButton.jpg"];
    _backgroundMenus.position = CGPointMake(0, 0);
    _backgroundMenus.size = CGSizeMake(300, 250);
    _backgroundMenus.zPosition = 1;
    
    _xMenu =[SKSpriteNode spriteNodeWithImageNamed:@"x"];
    _xMenu.position = CGPointMake(_backgroundMenus.frame.size.width * 0.5, _backgroundMenus.frame.size.height * 0.5);
    _xMenu.size = CGSizeMake(15,15);
    _xMenu.name = @"x";
    _xMenu.zPosition = 1;
    
    [self pauseGame];
    [_HUD addChild:_backgroundMenus];
    
    [_backgroundMenus addChild:_xMenu];
}

-(void)pauseGame
{
    _isGamePaused = YES; //Set pause flag to true
    self.paused = YES; //Pause scene and physics simulation
}


-(void)unpauseGame
{
    _isGamePaused = NO; //Set pause flag to false
    self.paused = NO; //Resume scene and physics simulation
}


-(void)gameOver
{
    _isGameOver = YES;
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
    
    if (self.numberOfLives >= 0) {
        [self performSelector:@selector(clear) withObject:self afterDelay:3];
    }
    else{
        
        SKLabelNode *gameOverLabel = [SKLabelNode labelNodeWithFontNamed:@"DIN Alternate"];
        gameOverLabel.position = CGPointMake(0, 0);
        gameOverLabel.fontColor = [UIColor redColor];
        gameOverLabel.fontSize = 40;
        gameOverLabel.text = @"Game Over";
        [_HUD addChild:gameOverLabel];
    }
}

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    
    
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
    
    if(firstBody.categoryBitMask == GROUND_CATEGORY && secondBody.categoryBitMask == PLAYER_CATEGORY)
    {
        _jumping = NO;
    }
    else if(firstBody.categoryBitMask == PLAYER_CATEGORY && secondBody.categoryBitMask == ENEMY_CATEGORY){
        [_henry removeFromParent];
        [self gameOver];
    }
    else if(firstBody.categoryBitMask == ENEMY_CATEGORY && secondBody.categoryBitMask == KILL_ENEMY_CATEGORY){
        if(_lanternLit)
        {
            [firstBody.node removeFromParent];
            if ([firstBody.node isMemberOfClass:(Bat.class)])
            {
                self.score += [Bat giveScore];
            }
            
        }
        
        
    }
    
}


-(void)didSimulatePhysics
{
    if(!_isGameOver){
        [self centerOnNode:_henry];
    }
    
    [_world enumerateChildNodesWithName:@"henry" usingBlock:^(SKNode *node, BOOL *stop) {
        if(node.position.y + node.frame.size.height < (-self.frame.size.height * 0.5))
        {
            
            [node removeFromParent];
            [self gameOver];
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
            ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.frame.size.width - 20, 80)];
            ground.physicsBody.dynamic = NO;
            ground.physicsBody.categoryBitMask = GROUND_CATEGORY;
            [_world addChild:ground];
            _currentGroundX += ground.frame.size.width;
        }
        
        
    }
    else if([groundImageName isEqualToString:@"groundRamp"]){
        
        for (int i = 0; i < times; i++) {
            SKSpriteNode *ground = [SKSpriteNode spriteNodeWithImageNamed:@"groundRamp"];
            ground.size = CGSizeMake(self.frame.size.width , 140);
            ground.position = CGPointMake(_currentGroundX, -self.frame.size.height * 0.5 + ground.frame.size.height * 0.5);
            ground.physicsBody = [SKPhysicsBody bodyWithTexture:[SKTexture textureWithImageNamed:@"groundRamp"] size:ground.size];
            ground.physicsBody.dynamic = NO;
            ground.physicsBody.categoryBitMask = GROUND_CATEGORY;
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
