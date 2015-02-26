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
#import "FasesMundo1.h"
#import "MyPoint.h"
#import "Energy.h"
<<<<<<< HEAD
#import "HUD.h"
#import "SoundDefiner.h"
#import "BackgroundGenerator.h"
#import "FaseVitoria.h"

=======
#import "Werewolf.h"
>>>>>>> FETCH_HEAD

@interface GameScene ()

@property BOOL isStarted;
@property BOOL isDead;
@property BOOL isGamePaused;
@property NSMutableArray *batPositionArray;
@property NSMutableArray *ghostPositionArray;
@property NSMutableArray *energyPositionArray;
@property SKLabelNode *somOptionConfigButton;
@property SKLabelNode *languageOptionConfigButton;
@property HUD *hud;
@property SKScene *FaseVitoria;
//@property ConfigBackgroundMusicFases *configBackgroundMusicFases;
@property SoundDefiner *soundDefiner;
@property BackgroundGenerator *backgroundGenerator;

@end

@implementation GameScene{
    
    BOOL _teste;
    
    SKNode *_world;
    SKNode *_backgroundTreeLayer;
    SKNode *_backgroundTreeLayer2;
    SKNode *_backgroundMountainLayer;
    SKNode *_backgroundSkyLayer;
    SKNode *_tutorial;
    CGFloat _currentGroundX;
    
    SKSpriteNode *_sound;
    SKSpriteNode *_backgroundMenus;
    SKSpriteNode *_xMenu;
    SKSpriteNode *_currentLanguageImage;
    SKSpriteNode *_tutorialBackground;
    SKLabelNode *_textTutorialLabel;
    
    SKLabelNode *_labelScore;
    SKLabelNode *_tituloLabelButton;
    SKLabelNode *_startLabel;
    
    NSMutableArray *_enemies;
    
    UIFont *_font;
    
    NSString *_currentLanguage;
    NSString *_fontName;
    
    Henry *_henry;
    VictoryLight *_victoryLight;
    
    BOOL _jumping; //To control how many times henry can jump
    BOOL _moving;
    BOOL _lanternLit;
    //BOOL _soundOn;
    BOOL _flipped; //If Henry's image is flipped to walk left
    BOOL _win;
    BOOL _isOpen;
    int _contador;
    BOOL _tutorialOver;
    
}

static const uint32_t GROUND_CATEGORY = 0x1;
static const uint32_t PLAYER_CATEGORY = 0x1 << 1;
static const uint32_t ENEMY_CATEGORY = 0x1 << 2;
static const uint32_t KILL_ENEMY_CATEGORY = 0x1 << 3;
static const uint32_t ENERGY_CATEGORY = 0x1 << 4;
static const uint32_t VICTORY_LIGHT_CATEGORY = 0x1 << 28;
static const uint32_t LIGHT_CATEGORY = 0x1 << 31;



-(void)didMoveToView:(SKView *)view {
    
    self.physicsWorld.contactDelegate = self;
    
    _isGamePaused = NO;
    _tutorialOver = NO;
    self.hud.time = 0;
    _font = [UIFont fontWithName:@"KGLuckoftheIrish.ttf" size:100.0f];
    _fontName = [NSString stringWithFormat:@"KGLuckoftheIrish"];
    _currentLanguage = [NSString stringWithFormat: @"Portugues"];
    
    self.hud.score = 0;
    self.hud.numberOfLives = 3;
    
    _world = [SKNode node];
    
    [self addChild:_world];
    [self setTutorial];
    [self setBackgrounds];
    [self setGroundsAndWall];
    [self setHUD];
    
    [self initializeEnergy];
    [self initializeBats];
    [self initializeGhosts];
    [self setSound];
    [self insertHenryAndKopp];
    [self inserVictoryLight];
    
}
-(void) setTutorial{
    _tutorial = [SKNode node];
    _tutorial.zPosition = 3;
    [self addChild:_tutorial];
}

-(void) tutorial{
    _tutorialOver=YES;
    
    [self pauseGame];
    
    self.hud.hidden = YES;
    
    _tutorialBackground = [SKSpriteNode spriteNodeWithImageNamed:@"backgroundConfigButton"];
    _tutorialBackground.position = CGPointMake(0,0);
    _tutorialBackground.size = CGSizeMake(300, 250);
    _tutorialBackground.zPosition = 3;
    
    _startLabel = [SKLabelNode labelNodeWithFontNamed:_fontName];
    _startLabel.position = CGPointMake(_tutorialBackground.frame.size.width * 0.12, -_tutorialBackground.frame.size.height * 0.4);
    _startLabel.fontSize = 40;
    _startLabel.fontColor = [UIColor colorWithRed:36.0f/255.0f green:64.0f/255.0f blue:96.0f/255.0f alpha:1];
    _startLabel.zPosition = 3;
    _startLabel.name = @"startTutorial";
    _startLabel.text = @"Ok";

    _textTutorialLabel = [SKLabelNode labelNodeWithFontNamed:_fontName];
    _textTutorialLabel.position = CGPointMake(_tutorialBackground.frame.size.width * 0.12, _tutorialBackground.frame.size.height * 0.38);
    _textTutorialLabel.fontSize = 22;
    _textTutorialLabel.fontColor = [UIColor colorWithRed:36.0f/255.0f green:64.0f/255.0f blue:96.0f/255.0f alpha:1];
    _textTutorialLabel.name = @"textTutorial";
    _textTutorialLabel.zPosition = 3;
    _textTutorialLabel.text = [NSString stringWithFormat:@"Olá, eu sou o Kopp!"];

    SKLabelNode *textTutorialLabel1 = [SKLabelNode labelNodeWithFontNamed:_fontName];
    textTutorialLabel1.position = CGPointMake(_tutorialBackground.frame.size.width * 0.12, _tutorialBackground.frame.size.height * 0.38 - _textTutorialLabel.frame.size.height);
    textTutorialLabel1.fontSize = 22;
    textTutorialLabel1.fontColor = [UIColor colorWithRed:36.0f/255.0f green:64.0f/255.0f blue:96.0f/255.0f alpha:1];
    textTutorialLabel1.name = @"textTutorial1";
    textTutorialLabel1.zPosition = 3;
    textTutorialLabel1.text = [NSString stringWithFormat:@"Não fique com medo."];

    SKLabelNode *textTutorialLabel2 = [SKLabelNode labelNodeWithFontNamed:_fontName];
    textTutorialLabel2.position = CGPointMake(_tutorialBackground.frame.size.width * 0.12, _tutorialBackground.frame.size.height * 0.38 - (_textTutorialLabel.frame.size.height * 2));
    textTutorialLabel2.fontSize = 22;
    textTutorialLabel2.fontColor = [UIColor colorWithRed:36.0f/255.0f green:64.0f/255.0f blue:96.0f/255.0f alpha:1];
    textTutorialLabel2.name = @"textTutorial2";
    textTutorialLabel2.zPosition = 3;
    textTutorialLabel2.text = [NSString stringWithFormat:@"A lanterna que você tem"];
    
    SKLabelNode *textTutorialLabel3 = [SKLabelNode labelNodeWithFontNamed:_fontName];
    textTutorialLabel3.position = CGPointMake(_tutorialBackground.frame.size.width * 0.12, _tutorialBackground.frame.size.height * 0.38 - (_textTutorialLabel.frame.size.height * 3));
    textTutorialLabel3.fontSize = 22;
    textTutorialLabel3.fontColor = [UIColor colorWithRed:36.0f/255.0f green:64.0f/255.0f blue:96.0f/255.0f alpha:1];
    textTutorialLabel3.name = @"textTutorial3";
    textTutorialLabel3.zPosition = 3;
    textTutorialLabel3.text = [NSString stringWithFormat:@"nas mãos gera uma"];
    
    SKLabelNode *textTutorialLabel4 = [SKLabelNode labelNodeWithFontNamed:_fontName];
    textTutorialLabel4.position = CGPointMake(_tutorialBackground.frame.size.width * 0.12, _tutorialBackground.frame.size.height * 0.38 - (_textTutorialLabel.frame.size.height * 4));
    textTutorialLabel4.fontSize = 22;
    textTutorialLabel4.fontColor = [UIColor colorWithRed:36.0f/255.0f green:64.0f/255.0f blue:96.0f/255.0f alpha:1];
    textTutorialLabel4.name = @"textTutorial4";
    textTutorialLabel4.zPosition = 3;
    textTutorialLabel4.text = [NSString stringWithFormat:@"luz muito poderosa!"];
    
    SKLabelNode *textTutorialLabel5 = [SKLabelNode labelNodeWithFontNamed:_fontName];
    textTutorialLabel5.position = CGPointMake(_tutorialBackground.frame.size.width * 0.12, _tutorialBackground.frame.size.height * 0.38 - (_textTutorialLabel.frame.size.height * 5));
    textTutorialLabel5.fontSize = 22;
    textTutorialLabel5.fontColor = [UIColor colorWithRed:36.0f/255.0f green:64.0f/255.0f blue:96.0f/255.0f alpha:1];
    textTutorialLabel5.name = @"textTutorial5";
    textTutorialLabel5.zPosition = 3;
    textTutorialLabel5.text = [NSString stringWithFormat:@"Combine-a com a sua coragem"];
    
    SKLabelNode *textTutorialLabel6 = [SKLabelNode labelNodeWithFontNamed:_fontName];
    textTutorialLabel6.position = CGPointMake(_tutorialBackground.frame.size.width * 0.12, _tutorialBackground.frame.size.height * 0.38 - (_textTutorialLabel.frame.size.height * 6));
    textTutorialLabel6.fontSize = 22;
    textTutorialLabel6.fontColor = [UIColor colorWithRed:36.0f/255.0f green:64.0f/255.0f blue:96.0f/255.0f alpha:1];
    textTutorialLabel6.name = @"textTutorial5";
    textTutorialLabel6.zPosition = 3;
    textTutorialLabel6.text = [NSString stringWithFormat:@"e supere seus medos!"];

    
    SKSpriteNode *tutorialKopp = [SKSpriteNode spriteNodeWithImageNamed:@"kopp"];
    tutorialKopp.zPosition = 3;
    tutorialKopp.position = CGPointMake(-_tutorialBackground.frame.size.width * 0.5 -_tutorialBackground.frame.size.width *0.2, -_tutorialBackground.frame.size.height * 0.5 + _tutorialBackground.frame.size.height *0.1);
    tutorialKopp.size = CGSizeMake(tutorialKopp.size.width*0.9,tutorialKopp.size.height*0.9);
    
    SKSpriteNode *tutorialLanternButton = [SKSpriteNode spriteNodeWithImageNamed:@"lantern"];
    tutorialLanternButton.size = CGSizeMake(60, 60);
    tutorialLanternButton.name = @"lanternButton";
    tutorialLanternButton.position = CGPointMake(self.frame.size.width * 0.5 - 3 * tutorialLanternButton.frame.size.width * 0.5,
                                         -self.frame.size.height * 0.5 + tutorialLanternButton.frame.size.height * 0.5 + 10);
    tutorialLanternButton.zPosition = 3;
    
    [_tutorial addChild: _tutorialBackground];
    [_tutorialBackground addChild: _startLabel];
    [_tutorial addChild: _textTutorialLabel];
    [_tutorial addChild: textTutorialLabel1];
    [_tutorial addChild: textTutorialLabel2];
    [_tutorial addChild: textTutorialLabel3];
    [_tutorial addChild: textTutorialLabel4];
    [_tutorial addChild: textTutorialLabel5];
    [_tutorial addChild: textTutorialLabel6];
    [_tutorial addChild: tutorialKopp];
    [_tutorial addChild: tutorialLanternButton];
    [self animateWithPulse: tutorialLanternButton];
    
}

-(void)animateWithPulse:(SKNode *)node
{
    SKAction *disappear = [SKAction fadeAlphaTo:0.0 duration:1];
    SKAction *appear = [SKAction fadeAlphaTo:1.0 duration:1];
    SKAction *pulse = [SKAction sequence:@[disappear,appear]];
    [node runAction:[SKAction repeatActionForever:pulse]];
}



-(void) inserVictoryLight{
    _victoryLight = [VictoryLight victoryLight];
    _victoryLight.size = self.size;
    [_victoryLight insertElements];
    _victoryLight.position = CGPointMake(_currentGroundX - self.frame.size.width, 0);
    [_world addChild:_victoryLight];
    
    
}

-(void) insertHenryAndKopp{
    
    _henry = [Henry henry];
    _henry.physicsBody.categoryBitMask = PLAYER_CATEGORY;
    _henry.physicsBody.collisionBitMask = GROUND_CATEGORY;
    _henry.physicsBody.contactTestBitMask = GROUND_CATEGORY | ENEMY_CATEGORY | VICTORY_LIGHT_CATEGORY;
    _henry.zPosition = 1;
    [_world addChild:_henry];
    
    Kopp *kopp = [Kopp kopp:_henry];
    
}



-(void) setSound{
    
    self.soundDefiner = [SoundDefiner createSoundDefiner];
    NSMutableArray *urls = [NSMutableArray array];
    
    NSURL *url1 = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/nightForestMusic.mp3", [[NSBundle mainBundle] resourcePath]]];
    NSURL *url2 = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/nightForestSound.mp3", [[NSBundle mainBundle] resourcePath]]];
    
    [urls addObject:url1];
    [urls addObject:url2];
    
    [self.soundDefiner setMusicWithNames:urls];
    
    [self.soundDefiner playMusic];

    
//    self.configBackgroundMusicFases = [ConfigBackgroundMusicFases createConfigWithSound1:@"%@/nightForestSound.mp3" WithSound2:@"%@/nightForestMusic.mp3"  WithSound3: @"%@/victoryMusic.mp3"];
//    [self addChild: self.configBackgroundMusicFases];
//    [self.configBackgroundMusicFases setSound];
    
//    self.hud = [HUD createHudWithScore:0 WithLives:3 ];
//    [self addChild:self.hud];
//    [self.hud setHudControls];
//    NSURL *url1 = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/nightForestSound.mp3", [[NSBundle mainBundle] resourcePath]]];
//    NSURL *url2 = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/nightForestMusic.mp3", [[NSBundle mainBundle] resourcePath]]];
//    NSURL *url3 = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/victoryMusic.mp3", [[NSBundle mainBundle] resourcePath]]];
//    
//    NSError *error;
//    
//    self.soundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url1 error:&error];
//    self.soundPlayer.numberOfLoops = -1;
//    
//    self.musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url2 error:&error];
//    self.musicPlayer.numberOfLoops = -1;
//    
//    self.victoryMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url3 error:&error];
//    self.victoryMusicPlayer.numberOfLoops = -1;
//    
//    if (!self.soundPlayer || !self.musicPlayer)
//        NSLog([error localizedDescription]);
//    else{
//        _soundOn= YES;
//        [self.soundPlayer play];
//        [self.musicPlayer play];
//    }
//    
}

-(void) initializeEnergy{
    
    _energyPositionArray = [self initializeArrayByType:@"energy"];
    
    int energyCount = 4;
    
    for (NSObject *object in _energyPositionArray){
        int padding = 0 ;
        
        for (int i = 0; i < energyCount; i++){
            
            MyPoint *point = (MyPoint*) object;
            Energy *energy = [Energy energy];
            
            CGPoint position = point.myPoint;
            position.x += padding;
            point = [[MyPoint alloc]Init: position];
            
            energy.position = point.myPoint;
            energy.physicsBody.categoryBitMask = ENERGY_CATEGORY;
            energy.physicsBody.collisionBitMask = 0;
            energy.physicsBody.contactTestBitMask = PLAYER_CATEGORY;
            energy.zPosition = 2;
            
            padding += 30;
            [_world addChild:energy];
            
        }
        
        if (energyCount == 4){
            energyCount = 3;
        }else{
            energyCount = 4;
        }

        
    }
    
    
}

-(void) initializeGhosts{
    
    _ghostPositionArray = [self initializeArrayByType:@"ghost"];
    
    for (NSObject *object in _ghostPositionArray) {
        
        MyPoint *point = (MyPoint*) object;
        
        Ghost *ghost = [Ghost ghost];
        ghost.position = point.myPoint;
        ghost.physicsBody.categoryBitMask = ENEMY_CATEGORY;
        ghost.physicsBody.collisionBitMask = 0;
        ghost.physicsBody.contactTestBitMask = PLAYER_CATEGORY | KILL_ENEMY_CATEGORY;
        ghost.shadowCastBitMask = LIGHT_CATEGORY;
        ghost.zPosition = 2;
        
        [_world addChild:ghost];
        
    };
    
}

-(void) initializeBats{
    
    _batPositionArray = [self initializeArrayByType:@"bat"];
    
    for (NSObject *object in _batPositionArray) {
        
        MyPoint *point = (MyPoint*) object;
        
        
        Bat *bat = [Bat bat];
        
        bat.position = point.myPoint;
        bat.physicsBody.categoryBitMask = ENEMY_CATEGORY;
        bat.physicsBody.collisionBitMask = 0;
        bat.physicsBody.contactTestBitMask = PLAYER_CATEGORY | KILL_ENEMY_CATEGORY;
        bat.shadowCastBitMask = LIGHT_CATEGORY;
        bat.zPosition = 2;
        
        [_world addChild:bat];
        
    };
    
}

-(NSMutableArray*) initializeArrayByType:(NSString*) type{
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    int numberOfElements;
    int constant_x;
    CGPoint initialPoint;
    
    if ([type isEqualToString:@"bat"]){
        initialPoint = CGPointMake(1000, 30);
        numberOfElements = 7;
        constant_x = 600;
    }else if([type isEqualToString:@"ghost"]){
        initialPoint = CGPointMake(700, 100);
        numberOfElements = 6;
        constant_x = 1000;
    }else if([type isEqualToString:@"energy"]){
        initialPoint = CGPointMake(300, 35);
        numberOfElements = 10;
        constant_x = 800;
    }
    
    MyPoint *point = [[MyPoint alloc]Init: initialPoint];
    [array addObject: point];
    
    for (int i = 0 ; i < numberOfElements; i++) {
        
        initialPoint.x += constant_x;
        point = [[MyPoint alloc]Init: initialPoint];
        
        [array addObject: point];
        
    };
    
    return array;
}

-(void) setHUD{
    self.hud = [HUD createHudWithScore:0 WithLives:3 ];
    [self addChild:self.hud];
    [self.hud setHudControls];

}


-(void) setGroundsAndWall{
    
    _currentGroundX = 0;
    SKSpriteNode *firstWall = [SKSpriteNode spriteNodeWithImageNamed:@"wall"];
    firstWall.position = CGPointMake(-self.frame.size.width * 0.5, 0);
    firstWall.size = CGSizeMake(24,self.frame.size.height);
    firstWall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:firstWall.size];
    firstWall.physicsBody.dynamic = NO;
    [_world addChild:firstWall];
    
    [self generateWorldWithImage:@"ground" repeat:3];
    [self generateWorldWithImage:@"groundBig" repeat:2];
    [self generateWorldWithImage:@"ground" repeat:1];
    [self generateWorldWithImage:@"groundRamp" repeat:1];
    [self generateWorldWithImage:@"spikes" repeat:1];
    [self generateWorldWithImage:@"ground" repeat:2];
    [self generateWorldWithImage:@"groundBig" repeat:2];
    [self generateWorldWithImage:@"ground" repeat:2];
    
    SKSpriteNode *lastWall = [SKSpriteNode spriteNodeWithImageNamed:@"wall"];
    lastWall.position = CGPointMake(_currentGroundX  - self.frame.size.width * 0.5, 0);
    lastWall.size = CGSizeMake(24,self.frame.size.height);
    lastWall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:firstWall.size];
    lastWall.physicsBody.dynamic = NO;
    [_world addChild:lastWall];
    
}


-(void) setBackgrounds{
    
    self.backgroundGenerator = [BackgroundGenerator createBackgroundGenerator];
    
//    _backgroundTreeLayer = [SKNode node];
//    _backgroundTreeLayer.zPosition = -2;
//    [self addChild:_backgroundTreeLayer];
//    
//    _backgroundTreeLayer2 = [SKNode node];
//    _backgroundTreeLayer2.zPosition = -3;
//    [self addChild:_backgroundTreeLayer2];
//    
//    _backgroundMountainLayer = [SKNode node];
//    _backgroundMountainLayer.zPosition = -4;
//    [self addChild:_backgroundMountainLayer];
//    
//    _backgroundSkyLayer = [SKNode node];
//    _backgroundSkyLayer.zPosition = -5;
//    [self addChild:_backgroundSkyLayer]2
//    
    [self.backgroundGenerator generateBackgroundWithImage:@"backgroundMountain" repeat:10 OnZPosition: -4 WithFrameSize:self.frame.size WithStartPosition:0];
    [self.backgroundGenerator generateBackgroundWithImage:@"backgroundTrees2" repeat:10 OnZPosition:-3 WithFrameSize:self.frame.size WithStartPosition:0];
    [self.backgroundGenerator generateBackgroundWithImage:@"backgroundTrees" repeat:10 OnZPosition:-2 WithFrameSize:self.frame.size WithStartPosition:0];
    
    for (int i = 0; i < self.backgroundGenerator.layers.count; i++) {
        SKNode *layer = (SKNode *)self.backgroundGenerator.layers[i];
        [self addChild:layer];
    }
    
    
    SKSpriteNode *sky = [SKSpriteNode spriteNodeWithImageNamed:@"backgroundSky"];
    sky.size = self.frame.size;
    [_backgroundSkyLayer addChild:sky];
    
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    if (!_isDead && !_win) {
        
        
        for (UITouch *touch in touches) {
            
            SKNode *n = [_hud nodeAtPoint:[touch locationInNode:_hud]];
            
            if([n.name isEqualToString:@"rightButton"]){
                
                
                _moving = YES;
                [_henry removeActionForKey:@"idleAnimation"];
                _flipped = NO;
                
                [_henry walkRight];
            }
            else if([n.name isEqualToString:@"leftButton"]){
                
                
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
    if (!_isDead && !_win) {
        
        
        for (UITouch *touch in touches) {
            
            SKNode *n = [_hud nodeAtPoint:[touch locationInNode:_hud]];
            
            SKNode *n1 = [_tutorial nodeAtPoint:[touch locationInNode:_tutorial]];
            
            if ([n.name isEqualToString:@"rightButton"]) {
                
                _moving = NO;
                [_henry removeActionForKey:@"walkRight"];
                [_henry removeActionForKey:@"walkLeft"];
                [_henry idleAnimation];
            }
            else if ([n.name isEqualToString:@"leftButton"]) {
                
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
            
            
            if([n.name isEqualToString:@"configButton"]){
                
                if (!_isOpen){
                    [self backgroundButtons];
                    
                    
                    _tituloLabelButton.text = @"Configurações";
                    
                    
                    if (self.soundDefiner.soundOn == YES)
                    {
                        _sound = [SKSpriteNode spriteNodeWithImageNamed:@"soundOn"];
                    }
                    else if( self.soundDefiner.soundOn == NO)
                    {
                        _sound = [SKSpriteNode spriteNodeWithImageNamed:@"soundOff"];
                    }
                    
                    _sound.position = CGPointMake(0,_backgroundMenus.frame.size.height * 0.10);
                    _sound.name = @"sound";
                    _sound.zPosition = 1;
                    [_sound setScale:0.2];
                    [_backgroundMenus addChild:_sound];
                    
                    _currentLanguageImage = [SKSpriteNode spriteNodeWithImageNamed:@""];
                    _currentLanguageImage.position = CGPointMake(0, 0 - _backgroundMenus.frame.size.height * 0.15 - 20);
                    _currentLanguageImage.size = CGSizeMake(_sound.frame.size.width, _sound.frame.size.height);
                    _currentLanguageImage.zPosition = 1;
                    _currentLanguageImage.name = @"currentLanguageImage";
                    [self defineLanguage:_currentLanguage];
                    
                    _somOptionConfigButton = [SKLabelNode labelNodeWithFontNamed:_fontName];
                    _somOptionConfigButton.text = @"Som";
                    _somOptionConfigButton.fontColor = [UIColor colorWithRed:36.0f/255.0f green:64.0f/255.0f blue:96.0f/255.0f alpha:1];
                    _somOptionConfigButton.fontSize = 20;
                    _somOptionConfigButton.zPosition = 2;
                    _somOptionConfigButton.name = @"somOption";
                    _somOptionConfigButton.position = CGPointMake(_sound.position.x, _sound.position.y + 15);
                    
                    [_backgroundMenus addChild:_somOptionConfigButton];
                    
                    _languageOptionConfigButton =[SKLabelNode labelNodeWithFontNamed:_fontName];
                    _languageOptionConfigButton.text = @"Língua";
                    _languageOptionConfigButton.fontColor = [UIColor colorWithRed:36.0f/255.0f green:64.0f/255.0f blue:96.0f/255.0f alpha:1];
                    _languageOptionConfigButton.fontSize = 20;
                    _languageOptionConfigButton.zPosition = 2;
                    _languageOptionConfigButton.name = @"linguaOption";
                    _languageOptionConfigButton.position = CGPointMake(_currentLanguageImage.position.x, _currentLanguageImage.position.y + 20);
                    [_backgroundMenus addChild:_languageOptionConfigButton];
                    
                    [_backgroundMenus addChild:_currentLanguageImage];
                    
                    _isOpen = YES;
                }
                
            }else if([n.name isEqualToString:@"encyclopediaButton"]){
                
                if (!_isOpen){
                    [self backgroundButtons];
                    _tituloLabelButton.text = @"Enciclopédia";
                    
                    _isOpen = YES;
                }
                
                
            }else if([n.name isEqualToString:@"changeStoneButton"] || [n.name isEqualToString:@"circle3"] ){
                
                if (!_isOpen){
                    [self backgroundButtons];
                    _tituloLabelButton.text = @"Pedras";
                    
                    _isOpen = YES;
                }
                
            }else if ([n.name isEqualToString:@"x"]){
                [_backgroundMenus removeFromParent];
                [self unpauseGame];
                
                _isOpen = NO;
                
            }else if ([n.name isEqualToString:@"sound"]){
                if (self.soundDefiner.soundOn == YES){
                    self.soundDefiner.soundOn = NO;
                    [_sound setTexture:[SKTexture textureWithImageNamed:@"soundOff"]];
                 
//                    [self.soundDefiner.musicPlayer stop];
//                    [self.soundDefiner.soundPlayer stop];
                }
                else if(self.soundDefiner.soundOn == NO){
                    
//                   self.configBackgroundMusicFases.soundOn = YES;
//                    [_sound setTexture:[SKTexture textureWithImageNamed:@"soundOn"]];
//                    [self.configBackgroundMusicFases.musicPlayer play];
//                    [self.configBackgroundMusicFases.soundPlayer play];
                }
            }else if ( [n.name isEqualToString:@"currentLanguageImage"]){
                
                if ([_currentLanguage isEqualToString:@"Portugues"]){
                    _currentLanguage = @"Ingles";
                    [self defineLanguage: _currentLanguage];
                }else if ([_currentLanguage isEqualToString:@"Ingles"]){
                    _currentLanguage = @"Portugues";
                    [self defineLanguage: _currentLanguage];
                }
            }
            else if ([n1.name isEqualToString:@"startTutorial"]) {
                
                [_tutorial removeFromParent];
                self.hud.hidden = NO;
                [self unpauseGame];
                
            }
        }
    }
}

//Define Language
-(void)defineLanguage:(NSString *) currentLanguage{

    if ([currentLanguage isEqualToString:@"Portugues"]){
        [_tituloLabelButton setText:@"Configurações"];
        [_somOptionConfigButton setText:@"Som"];
        [_languageOptionConfigButton setText:@"Língua"];
        [_currentLanguageImage setTexture: [SKTexture textureWithImageNamed:@"brasilImage"]];
    }
    else if ( [ currentLanguage isEqualToString:@"Ingles"]){
        [_tituloLabelButton setText:@"Settings"];
        [_somOptionConfigButton setText:@"Sound"];
        [_languageOptionConfigButton setText:@"Language"];
        [_currentLanguageImage setTexture: [SKTexture textureWithImageNamed:@"estadosunidosImage"]];
    }
}

//Define BackgroundButtons
-(void)backgroundButtons{
    
    _backgroundMenus = [SKSpriteNode spriteNodeWithImageNamed:@"backgroundConfigButton"];
    _backgroundMenus.position = CGPointMake(0, 0);
    _backgroundMenus.size = CGSizeMake(300, 250);
    _backgroundMenus.zPosition = 2;
    
    _xMenu =[SKSpriteNode spriteNodeWithImageNamed:@"xButton"];
    _xMenu.position = CGPointMake(_backgroundMenus.frame.size.width * 0.5, _backgroundMenus.frame.size.height * 0.5);
    _xMenu.size = CGSizeMake(50,50);
    _xMenu.name = @"x";
    _xMenu.zPosition = 2;
    
    _tituloLabelButton = [SKLabelNode labelNodeWithFontNamed:_fontName];
    _tituloLabelButton.position = CGPointMake(0, 90);
    _tituloLabelButton.fontSize = 25;
    _tituloLabelButton.name = @"tituloLabel";
    _tituloLabelButton.fontColor = [UIColor colorWithRed:36.0f/255.0f green:64.0f/255.0f blue:96.0f/255.0f alpha:1];
    
    
    [self pauseGame];
    [_hud addChild:_backgroundMenus];
    [_backgroundMenus addChild:_xMenu];
    [_backgroundMenus addChild:_tituloLabelButton];
}

//Função para pausar o game
-(void)pauseGame{
    _isGamePaused = YES; //Set pause flag to true
    [self.hud stopTimer];
    self.paused = YES;
    _hud.paused = YES;//Pause scene and physics simulation
}

//função para despausar o game
-(void)unpauseGame{
    _isGamePaused = NO; //Set pause flag to false
    
    [self.hud startTimer];
    self.paused = NO;
    _hud.paused = NO;//Resume scene and physics simulation
}

-(void)henryDead{
    _isDead = YES;
    
    self.hud.numberOfLives--;
    
    
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
    
    
    if (self.hud.numberOfLives >= 0){
        
        [self performSelector:@selector(clear) withObject:self afterDelay:5];
        
    }else{
        
        
        SKLabelNode *gameOverLabel = [SKLabelNode labelNodeWithFontNamed:@"DIN Alternate"];
        gameOverLabel.position = CGPointMake(0, 0);
        gameOverLabel.fontColor = [UIColor redColor];
        gameOverLabel.fontSize = 40;
        gameOverLabel.text = @"Game Over";
        [_hud addChild:gameOverLabel];
//        [_henry removeActionForKey:@"walkLeft"];
//        [_henry removeActionForKey:@"walkRight"];
//        [_henry removeActionForKey:@"walkAnimation"];
//        [_henry removeActionForKey:@"idleAnimation"];
        
        [self performSelector:@selector(returnToStageSelection) withObject:self afterDelay:3];
        
        
        
    }
}
-(void)returnToStageSelection
{
    [self removeAllChildren];
    [self removeAllActions];
//    [self.configBackgroundMusicFases.musicPlayer stop];
//    [self.configBackgroundMusicFases.soundPlayer stop];
    
    FasesMundo1 *scene = [[FasesMundo1 alloc] initWithSize:self.view.bounds.size];
    
    scene.anchorPoint = CGPointMake(0.5, 0.5);
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    SKTransition *reveal = [SKTransition fadeWithDuration:3];
    [self.view presentScene:scene transition: reveal];
    
    
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
        
        if (!_isDead){
            if (_flipped) {
                [_henry deathAnimationLeft];
            }
            else{
                [_henry deathAnimation];
            }
            [self henryDead];
        }
        
    }else if(firstBody.categoryBitMask == ENEMY_CATEGORY && secondBody.categoryBitMask == KILL_ENEMY_CATEGORY){
        
        if(_lanternLit){
        
            if ([firstBody.node.name isEqualToString:@"bat"]){
                Bat *bat = (Bat*) firstBody.node;
                [bat death];
            }
            else if([firstBody.node.name isEqualToString:@"ghost"]){
                [firstBody.node removeFromParent];
            }
        }
        
        
    }else if(firstBody.categoryBitMask == PLAYER_CATEGORY && secondBody.categoryBitMask == VICTORY_LIGHT_CATEGORY){
        [_henry removeActionForKey:@"walkLeft"];
        [_henry removeActionForKey:@"walkRight"];
        [_henry removeActionForKey:@"walkAnimation"];
        [_henry removeActionForKey:@"idleAnimation"];
//        [self.configBackgroundMusicFases.musicPlayer stop];
//        [self.configBackgroundMusicFases.soundPlayer stop];
//        [self.configBackgroundMusicFases.victoryMusicPlayer play];
        [self.hud stopTimer];
        _win = YES;
        
        [self performSelector:@selector(endStage) withObject:self afterDelay:5];
    }
    else if(firstBody.categoryBitMask == PLAYER_CATEGORY && secondBody.categoryBitMask == ENERGY_CATEGORY){
     
        Energy *energy = (Energy *) secondBody.node;
        [energy collectToPosition:firstBody.node.position];
        self.hud.score++;
    }
    
}


-(void)didSimulatePhysics{
    
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
        if(_henry.position.x >300 && _tutorialOver==NO ){
            
            [self tutorial];
            _tutorialOver = YES;
        }
        
    }
     
     ];
    
    [_world enumerateChildNodesWithName:@"bat" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.x - _henry.position.x < 400 ) {
            Bat *bat = (Bat*) node;
            [bat attackPlayer: _henry];
        }
    }];
    
    [_world enumerateChildNodesWithName:@"ghost" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.x - _henry.position.x < 300 ) {
            Ghost *ghost = (Ghost*) node;
            [ghost attackPlayer:_henry];
        }
    }];
    _contador = 0;
    [_henry enumerateChildNodesWithName:@"killerLine" usingBlock:^(SKNode *node, BOOL *stop) {

        if (_flipped) {
            node.position = CGPointMake((_henry.frame.size.width * 0.5 + 5 + 5*_contador) * (-1),-20);
            _contador++;
        }
        else{
        node.position = CGPointMake(_henry.frame.size.width * 0.5 + 5 + 5*_contador,-20);
        _contador++;
        }
    }];
    
    
}
-(void)centerOnNode:(SKNode *)node{
    
    CGPoint positionInScene = [self convertPoint:node.position fromNode:node.parent];
    
    
    
    positionInScene.x += 185;
    _world.position = CGPointMake(_world.position.x - positionInScene.x, _world.position.y);
    
    for (int i = 0; i < self.backgroundGenerator.layers.count; i++) {
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
            ground.physicsBody = [SKPhysicsBody bodyWithTexture:[SKTexture textureWithImageNamed:@"groundRamp"] size:CGSizeMake(ground.frame.size.width, ground.frame.size.height - 90)];
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
            ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(ground.size.width - 90, ground.size.height)];
            ground.physicsBody.dynamic = NO;
            ground.physicsBody.categoryBitMask = ENEMY_CATEGORY;
            ground.physicsBody.collisionBitMask = PLAYER_CATEGORY;
            [_world addChild:ground];
            _currentGroundX += ground.frame.size.width;
            
        }
        
        
    }
}


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}


-(void)endStage{
    
    FasesMundo1 *scene = [[FasesMundo1 alloc] initWithSize:self.view.bounds.size];
    
    scene.anchorPoint = CGPointMake(0.5, 0.5);
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    SKTransition *reveal = [SKTransition fadeWithDuration:3];
    [self.view presentScene:scene transition: reveal];
//    [self.configBackgroundMusicFases.victoryMusicPlayer stop];
    
}

@end
