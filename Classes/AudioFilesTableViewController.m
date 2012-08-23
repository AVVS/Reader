//
//  AudioFilesTableViewController.m
//  Reader
//
//  Created by Aminev Vitaly on 23.08.12.
//
//

#import "AudioFilesTableViewController.h"
#import "MDAudioPlayerController.h"
#import "MDAudioFile.h"

@interface AudioFilesTableViewController ()

@end

@implementation AudioFilesTableViewController
{
    NSMutableArray *__audioFiles;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        _mp3Source = [[[NSBundle mainBundle] pathsForResourcesOfType:@"mp3" inDirectory:nil] retain];
        __audioFiles = [[NSMutableArray arrayWithCapacity:_mp3Source.count] retain];
        for (NSString *filePath in _mp3Source) {
            MDAudioFile *audioFile = [[MDAudioFile alloc] initWithPath:[NSURL fileURLWithPath:filePath]];
            [__audioFiles addObject:audioFile];
            [audioFile release];
        }        
    }
    return self;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _mp3Source.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ( cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell autorelease];
    }
    NSString *name = [[_mp3Source objectAtIndex:indexPath.row] lastPathComponent];
    [cell.textLabel setText:name];
    
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MDAudioPlayerController *audioPlayer = [[MDAudioPlayerController alloc] initWithSoundFiles:__audioFiles atPath:nil andSelectedIndex:indexPath.row];
    [self presentViewController:audioPlayer animated:YES completion:nil];
    [audioPlayer release];
}

- (void)dealloc
{
    [__audioFiles release];
    [_mp3Source release];
    [super dealloc];
}

@end
