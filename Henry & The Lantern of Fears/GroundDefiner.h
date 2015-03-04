//
//  GroundDefiner.h
//  Henry & The Lantern of Fears
//
//  Created by Ivee Mendes Marins on 3/3/15.
//  Copyright (c) 2015 ABHI. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GroundDefiner : SKNode

@property (nonatomic) SKNode *ground;

+(GroundDefiner *) createGroundDefiner;

-(float) generateGroundWithImage: (NSString *) groundImageName repeat: (int) times WithFrameSize:(CGSize)size WithStartPoint: (float) currentGroundX;

@end
