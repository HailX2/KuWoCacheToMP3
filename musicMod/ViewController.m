//
//  ViewController.m
//  musicMod
//
//  Created by zym on 2020/3/1.
//  Copyright © 2020 zym. All rights reserved.
//

#import "ViewController.h"
#import "fmdb/FMDB.h"
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSFileManager *manager = [NSFileManager defaultManager];
         

    
    NSString *path = @"/Users/zym/Downloads/cloud.db";
    
    NSString *home = [@"/Users/zym/Downloads/Music" stringByExpandingTildeInPath];
    //枚举器
    NSDirectoryEnumerator *direnum = [manager enumeratorAtPath:home];

    FMDatabase *db = [FMDatabase databaseWithPath:path];
    
    if ([db open]) {
       
        NSString *filename;

        while (filename = [direnum nextObject]) {
     
            
        NSString *querty = [NSString stringWithFormat:@"SELECT * FROM main.musicResource WHERE file LIKE '%@'",filename];
        
        FMResultSet *s = [db executeQuery:querty];
        if ([s next]) {
            NSString* string = [s stringForColumn:@"title"];
            [manager moveItemAtPath:[NSString stringWithFormat:@"/Users/zym/Downloads/Music/%@",filename] toPath:[NSString stringWithFormat:@"/Users/zym/Downloads/Music/%@",string] error:nil];
            
        }
        
                  }

        
        return;
    }
    

}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}




-(void)runShellWithCommand:(NSString *)command completeBlock:(dispatch_block_t)completeBlock{
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^{
        NSTask *task = [[NSTask alloc] init];
        [task setLaunchPath: @"/bin/sh"];
        NSArray *arguments;
        arguments = [NSArray arrayWithObjects:@"-c",command, nil];
        [task setArguments: arguments];
        [task launch];
        [task waitUntilExit];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completeBlock) {
                completeBlock();
            }
        });
    });
}
@end
