

#import "AppDelegate.h"
#include <string>
#include <iostream>
#include <map>
#include <vector>
#include <iterator>

using namespace std;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  printf("Test");
  
  [self chosenDirectory:@"/Users/jonathanmccaffrey/Desktop/TestFolder/hd" doneDirectory:@"/Users/jonathanmccaffrey/Desktop/TestFolder/hdDone"];
  
  return YES;
}

- (void) chosenDirectory:(NSString*) chosenDirectory doneDirectory:(NSString*) doneDirectory {
  //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  
  mChosenDirectory = chosenDirectory;
  mDoneDirectory = doneDirectory;
  mContentOfDirectory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:mChosenDirectory error:NULL];
  
  [self suffix:@"-hd.png" toRemove:@"-hd"];
  [self suffix:@"-hd" toRemove:@"-hd"];
  [self suffix:@"-hd.fnt" toRemove:@"-hd"];
}

-(void)suffix:(NSString*) suffix toRemove:(NSString*) toRemove {
  vector<string> fileNames;
  
  for(int i = 0; i < [mContentOfDirectory count]; i++) {
    NSString *fileName = mContentOfDirectory[i];
    if([fileName hasSuffix: suffix]) {
      NSRange range = [fileName rangeOfString:toRemove];
      
      if(range.length != 0) {
        string stringFront = [fileName UTF8String];
        stringFront[range.location] = '\0';
        stringFront = stringFront.c_str();
        
        string stringEnd = &[fileName UTF8String][range.location + range.length];
        
        string stringFull =  stringFront; stringFull.append(stringEnd.c_str());
        fileNames.push_back(stringFull);
      } else {
        fileNames.push_back("");
        
        return;
      }
      
      string fullPath = [mChosenDirectory UTF8String];
      fullPath.append("/");
      fullPath.append([fileName UTF8String]);
      
      string finalPath = [mDoneDirectory UTF8String];
      finalPath.append("/");
      finalPath.append(fileNames[i].c_str());
      
      FILE *fileChosen = fopen(fullPath.c_str(), "rb");
      FILE *fileDone = fopen(finalPath.c_str(), "wb+");
            
      int num = 0;
      int count = 0;
      char buff[512];
      
      while(!feof(fileChosen)) {
        num = fread(buff, 1, 512, fileChosen);
        count += num;
        fwrite(buff, 1, num, fileDone);
      }
      
      fclose(fileChosen);
      fclose(fileDone);
    } else {
      fileNames.push_back("");
    }
  }
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
