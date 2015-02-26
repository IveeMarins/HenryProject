//
//  ConfigBackgroundMusicFases.h
//  Henry & The Lantern of Fears
//
//  Created by Ivee Mendes Marins on 2/24/15.
//  Copyright (c) 2015 ABHI. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>

@interface SoundDefiner : SKNode

@property (nonatomic) NSMutableArray* musicPlayers;

+(SoundDefiner *) createSoundDefiner;

///////////////Para músicas///////////////
-(void) setMusicWithNames: (NSMutableArray *) urls;

-(void) playMusic;

-(void) stopMusic;



///////////////Para sons///////////////
-(AVAudioPlayer *) setSound: (NSString *) name;

-(void) playSound: (AVAudioPlayer *) sound;

-(void) stopSound: (AVAudioPlayer *) sound;

@property (nonatomic) BOOL soundOn;

@end
