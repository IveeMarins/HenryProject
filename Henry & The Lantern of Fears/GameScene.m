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

@end

@implementation GameScene{
    
    SKNode *_world;
    SKNode *_backgroundTreeLayer;
    SKNode *_backgroundTreeLayer2;
    SKNode *_backgroundMountainLayer;
    SKNode *_backgroundSkyLayer;
    SKNode *_HUD;
    
    SKAction *_backgroundMusic;
    SKAction *_backgroundSound;
    
    Henry *_henry;
    
    NSMutableArray *_enemies;
    Bat *_bat;
    Ghost *_ghost;
    
    BOOL _rightButtonPressed;
    BOOL _leftButtonPressed;
    BOOL _jumping;
    BOOL _moving;
    BOOL _lanternLit;
    BOOL _flipped; //If Henry's image is flipped to walk left
    
    
}

static const uint32_t GROUND_CATEGORY = 0x1;
static const uint32_t PLAYER_CATEGORY = 0x1 << 1;
static const uint32_t ENEMY_CATEGORY = 0x1 << 2;
static const uint32_t LIGHT_CATEGORY = 0x1 << 31;

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    
    self.backgroundColor = [UIColor redColor];
    
    
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
    [self generateWorldWithImage:@"ground" repeat:4];
    
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
    _bat.physicsBody.contactTestBitMask = PLAYER_CATEGORY;
    _bat.shadowCastBitMask = LIGHT_CATEGORY;
    
    [_world addChild:_bat];
    
    _ghost = [Ghost ghost];
    _ghost.position = CGPointMake(700, 100);
    _ghost.physicsBody.categoryBitMask = ENEMY_CATEGORY;
    _ghost.physicsBody.collisionBitMask = PLAYER_CATEGORY;
    _ghost.physicsBody.contactTestBitMask = PLAYER_CATEGORY;
    _ghost.shadowCastBitMask = LIGHT_CATEGORY;
    
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
    
    SKSpriteNode *configButton = [SKSpriteNode spriteNodeWithImageNamed:@"gear"];
    configButton.size = CGSizeMake(20, 20);
    configButton.name = @"configButton";
    configButton.position = CGPointMake(self.frame.size.width * 0.5 - configButton.frame.size.width * 0.5 - 5,
                                         self.frame.size.height * 0.5 - configButton.frame.size.height * 0.5 - 5);
    
    [_HUD addChild:configButton];
    
    SKSpriteNode *encyclopediaButton = [SKSpriteNode spriteNodeWithImageNamed:@"book"];
    encyclopediaButton.size = CGSizeMake(20, 20);
    encyclopediaButton.name = @"encyclopediaButton";
    encyclopediaButton.position = CGPointMake(self.frame.size.width * 0.5 - encyclopediaButton.frame.size.width * 2.0 - 10,
                                        self.frame.size.height * 0.5 - encyclopediaButton.frame.size.height * 0.5 - 5);
    
    [_HUD addChild:encyclopediaButton];
    
    SKSpriteNode *changeStoneButton = [SKSpriteNode spriteNodeWithImageNamed:@"magicStone"];
    changeStoneButton.size = CGSizeMake(20, 20);
    changeStoneButton.name = @"changeStoneButton";
    changeStoneButton.position = CGPointMake(self.frame.size.width * 0.5 - changeStoneButton.frame.size.width * 4.0 - 10,
                                              self.frame.size.height * 0.5 - changeStoneButton.frame.size.height * 0.5 - 5);
    
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
    _lifeLabel.fontColor = [UIColor blackColor];
    _lifeLabel.fontSize = 25;
    
    _lifeLabel.position = CGPointMake(xSeparator.position.x + 15 , xSeparator.position.y - 5);
    
    [_HUD addChild:_lifeLabel];
    
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
//Defining Inicial Values
    self.numberOfLives = 3;
    
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
/////////////////////////////////////////////////////////Defining Sound/////////////////////////////////////////////////////////
    
    _backgroundSound = [SKAction repeatActionForever:[SKAction playSoundFileNamed:@"nightForestSound.mp3" waitForCompletion:YES]];
    [self runAction:_backgroundSound];
    
    _backgroundMusic = [SKAction repeatActionForever:[SKAction playSoundFileNamed:@"nightForestMusic.mp3" waitForCompletion:YES]];
    [self runAction:_backgroundMusic];
    
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
}

-(void)setNumberOfLives:(int)numberOfLives
{
    
    _numberOfLives = numberOfLives;
    if (numberOfLives >= 0) {
        _lifeLabel.text = [NSString stringWithFormat:@"%d",numberOfLives];
    }
    
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        
        SKNode *n = [_HUD nodeAtPoint:[touch locationInNode:_HUD]];
        
        if([n.name isEqualToString:@"rightButton"]){
            
            _rightButtonPressed = YES;
            _moving = YES;
            [_henry removeActionForKey:@"idleAnimation"];
            if(_henry.xScale == -1){
                _henry.xScale = 1;
                _flipped = NO;
            }
            [_henry walkRight];
        }
        else if([n.name isEqualToString:@"leftButton"]){
            
            _leftButtonPressed = YES;
            _moving = YES;
            [_henry removeActionForKey:@"idleAnimation"];
            if(_henry.xScale == 1){
                _henry.xScale = -1;
                _flipped = YES;
            }
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
            [_henry idleAnimation];
        }
        if ([n.name isEqualToString:@"leftButton"]) {
            _leftButtonPressed = NO;
            _moving = NO;
            [_henry idleAnimation];
            [_henry removeActionForKey:@"walkLeft"];
        }
        if([n.name isEqualToString:@"lanternButton"]){
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
        
    };
    
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
    
    if (_bat.position.x - _henry.position.x < 200 ) {
        [_bat attackPlayer:_henry];
    }
    if (_ghost.position.x - _henry.position.x < 300) {
        [_ghost attackPlayer:_henry];
    }
    
    
    [_henry enumerateChildNodesWithName:@"lanternLightParticle" usingBlock:^(SKNode *node, BOOL *stop) {
        if(!_flipped){
        
            CGPoint nodePosition = [_world convertPoint:node.position fromNode:node.parent];
            
            if(_bat.position.x - nodePosition.x < 100 && _bat.position.x - nodePosition.x > 0){
                [_bat removeFromParent];
            }
            
            if (_ghost.position.x - nodePosition.x < 150 && _ghost.position.x - nodePosition.x>0) {
                [_ghost removeFromParent];
            }
            
        }
        else{
            CGPoint nodePosition = [_world convertPoint:node.position fromNode:node.parent];
        
            if(nodePosition.x - _bat.position.x < 100 && nodePosition.x - _bat.position.x > 0){
                [_bat removeFromParent];
            }
            
        }
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
    
    CGFloat currentGroundX = 0;
    if([groundImageName isEqualToString:@"ground"]){
        
        for (int i = 0; i < times; i++) {
            SKSpriteNode *ground = [SKSpriteNode spriteNodeWithImageNamed:@"ground"];
            ground.size = CGSizeMake(self.frame.size.width , 100);
            ground.position = CGPointMake(currentGroundX, -self.frame.size.height * 0.5 + ground.frame.size.height * 0.5);
            ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.frame.size.width , 50)];
            ground.physicsBody.dynamic = NO;
            ground.physicsBody.categoryBitMask = GROUND_CATEGORY;
            [_world addChild:ground];
            currentGroundX += ground.frame.size.width;
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
