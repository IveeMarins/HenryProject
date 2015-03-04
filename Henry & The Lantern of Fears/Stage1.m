//
//  Stage1.m
//  Henry & The Lantern of Fears
//
//  Created by Ivee Mendes Marins on 3/3/15.
//  Copyright (c) 2015 ABHI. All rights reserved.
//

#import "Stage1.h"

@implementation Stage1

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        ///////SETBACKGROUND///////
        self.backgroundNames = [[NSMutableArray alloc] initWithObjects:@"backgroundMountain",@"backgroundTrees2",@"backgroundTrees", nil];
        self.backgroundRepeatTimes = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:10], [NSNumber numberWithInt:10],[NSNumber numberWithInt:10], nil];
        self.backgroundZPositions = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:-4], [NSNumber numberWithInt:-3],[NSNumber numberWithInt:-2], nil];
        [self setBackground];
        
        ///////SETSOUND///////
        self.musicNames = [[NSMutableArray alloc] initWithObjects:@"%@/nightForestMusic.mp3",@"%@/nightForestSound.mp3", nil];
        [self setSound];
        
        ///////SETDEFAULT///////
        [self setKeysDefault];
        
        ///////SETHUD///////
        [self setHUD];
        
        ///////SETWORLD///////
        [self creatWorld];
        
        ///////INSERT HENRY AND KOPP///////
        [self insertHenryAndKopp];
        
        ///////SETGROUND///////
        self.groundImageNames = [[NSMutableArray alloc] initWithObjects:
                                 @"ground",
                                 @"groundBig",
                                 @"ground",
                                 @"groundRamp",
                                 @"spikes",
                                 @"ground",
                                 @"groundBig",
                                 @"ground", nil];
        
        self.groundRepeatTimes = [[NSMutableArray alloc]
                                  initWithObjects:
                                  [NSNumber numberWithInt:3],
                                  [NSNumber numberWithInt:2],
                                  [NSNumber numberWithInt:1],
                                  [NSNumber numberWithInt:1],
                                  [NSNumber numberWithInt:1],
                                  [NSNumber numberWithInt:2],
                                  [NSNumber numberWithInt:2],
                                  [NSNumber numberWithInt:2], nil];
        [self setGround];
        
    }
    return self;
}

-(void) didSimulatePhysics{
    [self centerCamera];
}




@end
