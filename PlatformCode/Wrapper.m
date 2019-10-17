//
//  Wrapper.m
//  Brogue
//
//  Created by Raymund Vidar on 10/11/19.
//  Copyright © 2019 darthvid. All rights reserved.
//

//#import <Foundation/Foundation.h>
#include "Rogue.h"
#include "Wrapper.h"
#import "Brogue-Swift.h"
GameScene *scene;

boolean isAppActive = false;
unsigned int ctr = 0;
void (*cbSetCell)() = NULL;


cbStruct callbacks;

int foo(int i) {
    return i;
}

/*
 Platform -> Brogue
 */

void runGame() {
    printf("%s: \n", __PRETTY_FUNCTION__);
    rogueMain();
}

/*
 Brogue -> Platform
 */

boolean controlKeyIsDown() {
    // Darth: Seems only used for the main menu to change "New Game" to "New Game Custom".
    
    //printf("%s: \n", __PRETTY_FUNCTION__);
    return false;
}

short getHighScoresList(rogueHighScoresEntry returnList[HIGH_SCORES_COUNT]) {
    // returns the index number of the most recent score
    
    printf("%s: \n", __PRETTY_FUNCTION__);
    return 0;
}

void initializeBrogueSaveLocation() {
    printf("%s: \n", __PRETTY_FUNCTION__);
}

void initializeLaunchArguments(enum NGCommands *command, char *path, unsigned long *seed) {
    printf("%s: \n", __PRETTY_FUNCTION__);
}

boolean isApplicationActive() {
    // Darth: Seems only used for the main menu to change "New Game" to "New Game Custom".
    //printf("%s(%d)\n", __FUNCTION__, isAppActive);
    //printf("%s(%d) plotchar:%i\n", __FUNCTION__, isAppActive, ctr);
    
    //printf("%s(%d)\n", __FUNCTION__, callbacks.isAppActive());
    
    return callbacks.isAppActive();
    
}

fileEntry *listFiles(short *fileCount, char **dynamicMemoryBuffer){
    // Returns a malloc'ed fileEntry array, and puts the file count into *fileCount.
    // Also returns a pointer to the memory that holds the file names, so that it can also
    // be freed afterward.

    printf("%s: \n", __PRETTY_FUNCTION__);
    return NULL;
}

void nextKeyOrMouseEvent(rogueEvent *returnEvent, boolean textInput, boolean colorsDance) {
    // Darth:
    //  Returns a _relevant_ event back to Brogue.
    //  It seems the other implems only loop to flush or serve as an event accumulator. When an actual Brogue recognized event occurts, the functions returns.
    //  There is some expectation that this will sortof loop efficiently until an input occurs.
    
    printf("%s(%d, %d)\n", __FUNCTION__, textInput, colorsDance);
    
    /*
    NSEvent *theEvent = scene.aEvent;
    NSEventType theEventType = theEvent.type;
    scene.aEvent = NULL;
    
    if (theEventType == NSKeyDown && !(theEvent.modifierFlags & NSCommandKeyMask)) {
        
        char a = [[theEvent charactersIgnoringModifiers] characterAtIndex:0];
        printf("char %d\n", a);
    }
    
    if (colorsDance) {
        shuffleTerrainColors(3, true);
        commitDraws();
    }
     */
    
    //[scene setCellWithCharToPlot: charToPlot];
    callbacks.getBrogueEvent(textInput, colorsDance);
    [scene bridgeCurrInputEventWithReturnEvent:returnEvent textInput:textInput colorsDance:colorsDance];
    //returnEvent: UnsafePointer<rogueEvent>, textInput:Bool, colorsDance:
    
    //returnEvent->eventType = 0;
}

boolean pauseForMilliseconds(short milliseconds) {
    // Returns true if the player interrupted the wait with a keystroke or mouse action; otherwise false.
    
    //printf("%s(%i)\n", __FUNCTION__, milliseconds);
    //if (isAppActive) {
        //if (milliseconds >= 16) {
//        usleep(milliseconds/1000);
  //  }

    //return false;
    //return (NULL != scene.aEvent);
    //callbacks.cbVoidVoid();
    
    //return [scene isCurrEventExist];
    boolean res = callbacks.isEventWhilePaused(milliseconds);
    if (res) {
        printf("%i %s(%i)\n",res,  __FUNCTION__, milliseconds);
    }
    
    return (0 || res);
}

void plotChar(uchar inputChar,
              short xLoc, short yLoc,
              short backRed, short backGreen, short backBlue,
              short foreRed, short foreGreen, short foreBlue) {
    //  plotChar: plots inputChar at (xLoc, yLoc) with specified background and foreground colors.
    //  Color components are given in ints from 0 to 100.
    
    PlotCharStruct charToPlot;

    //printf("%s: \n", __PRETTY_FUNCTION__);
    //cbSetCell();
    //[scene setCell];
    //[scene setCellWithX:xLoc y:yLoc code:inputChar bgColor:backColor fgColor:foreColor];
    // !@($&@#(%&#$(%#(!*($%@ Objective-C!!!!
    //[scene setCellWithInputChar:inputChar xLoc:xLoc yLoc:yLoc backRed:backRed backGreen:backGreen backBlue:backBlue foreRed:foreRed foreGreen:foreGreen foreBlue:foreBlue];
    charToPlot.inputChar = inputChar;
    charToPlot.xLoc = xLoc;
    charToPlot.yLoc = yLoc;
    charToPlot.backRed = backRed;
    charToPlot.backGreen = backGreen;
    charToPlot.backBlue = backBlue;
    charToPlot.foreRed = foreRed;
    charToPlot.foreGreen = foreGreen;
    charToPlot.foreBlue = foreBlue;
    
    [scene setCellWithCharToPlot: charToPlot];
}

boolean saveHighScore(rogueHighScoresEntry theEntry) {
    // saves the high scores entry over the lowest-score entry if it qualifies.
    // returns whether the score qualified for the list.
    // This function ignores the date passed to it in theEntry and substitutes the current
    // date instead.

    printf("%s: \n", __PRETTY_FUNCTION__);
    return false;
}

#ifdef USE_CLIPBOARD
char *getClipboard() {
    // Returns a pointer to a char* containing the contents of the clipboard
    
    printf("%s: \n", __PRETTY_FUNCTION__);
    return 0;
}
#endif

/*
 Swift -> Adapter
 */

void setAdapterCallbacks(void (*cbOfSetCell)()) {
    cbSetCell = cbOfSetCell;
}

void setActive(_Bool isActive) {
    isAppActive = isActive;
}

void setScene(GameScene *gameScene) {
    scene = gameScene;
}

void setWrapperCallbacks(cbStruct fnStruct) {
    
}
