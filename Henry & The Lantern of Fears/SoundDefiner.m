//
//  ConfigBackgroundMusicFases.m
//  Henry & The Lantern of Fears
//
//  Created by Ivee Mendes Marins on 2/24/15.
//  Copyright (c) 2015 ABHI. All rights reserved.
//

#import "SoundDefiner.h"
#import "VictoryLight.h"

@implementation SoundDefiner


+(SoundDefiner *) createSoundDefiner
{
    SoundDefiner *definer = [SoundDefiner node];
    
    return definer;
}

///////////////Para musicas///////////////
-(void) setMusicWithNames: (NSMutableArray *) urls
{
    _soundOn = YES;
    NSError *error;
    self.musicPlayers = [NSMutableArray array];
    
    for (int i = 0 ; i < urls.count ; i++)
    {
        NSURL *soundUrl = (NSURL *) urls[i];
        
        AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:&error];
        player.numberOfLoops = -1;
        
        [self.musicPlayers addObject: player];
    }
    
//    if (!self.soundPlayer || !self.musicPlayer)
//        NSLog([error localizedDescription]);
//        else{
//    _soundOn = YES;
    
}

-(void) playMusic
{
    for (int i = 0 ; i < self.musicPlayers.count ; i++)
    {
        AVAudioPlayer *player = (AVAudioPlayer *) self.musicPlayers[i];
        [player play];
    }
}

-(void) stopMusic
{
    for (int i = 0 ; i < self.musicPlayers.count ; i++)
    {
        AVAudioPlayer *player = (AVAudioPlayer *) self.musicPlayers[i];
        [player stop];
    }
}



///////////////Para sons///////////////
-(AVAudioPlayer *) setSound: (NSString *) name
{
    NSError *error;
    
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat: name , [[NSBundle mainBundle] resourcePath]]];
    
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    player.numberOfLoops = 0;
    
    return player;
}

-(void) playSound: (AVAudioPlayer *) sound
{
    [sound play];
}

-(void) stopSound: (AVAudioPlayer *) sound
{
    [sound stop];
}



@end