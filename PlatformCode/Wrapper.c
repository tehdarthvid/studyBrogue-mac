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


/*
Complete missing C functions from BrogueCode then transfer calls to Wrapper.swift so all actual handling is via Swift.
"callbacks" struct is actually initialized in Wrapper.swift, but has to be declared here for C functions to find the global.
*/

cbStruct callbacks;



boolean controlKeyIsDown() {
    // Darth: Seems only used for the main menu to change "New Game" to "New Game Custom".
    
    //printf("%s: \n", __PRETTY_FUNCTION__);
    //return false;
    return callbacks.isControlKeyDown();
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
    
    *returnEvent = callbacks.getBrogueEvent(textInput, colorsDance);
}

boolean pauseForMilliseconds(short milliseconds) {
    // Returns true if the player interrupted the wait with a keystroke or mouse action; otherwise false.
    
    //printf("%s(%i)\n",  __FUNCTION__, milliseconds);
    boolean res = callbacks.isEventWhilePaused(milliseconds);
    if (res) {
        printf("%i %s(%i)\n",res,  __FUNCTION__, milliseconds);
    }
    
    return (0 || res);
}

void plotChar(uchar inputChar,
              short xLoc, short yLoc,
              short foreRed, short foreGreen, short foreBlue,
              short backRed, short backGreen, short backBlue) {

//void plotChar(uchar inputChar,
//              short xLoc, short yLoc,
//              short backRed, short backGreen, short backBlue,
//              short foreRed, short foreGreen, short foreBlue) {
    //  plotChar: plots inputChar at (xLoc, yLoc) with specified background and foreground colors.
    //  Color components are given in ints from 0 to 100.
    
    PlotCharStruct charToPlot;

    charToPlot.inputChar = inputChar;
    charToPlot.xLoc = xLoc;
    charToPlot.yLoc = yLoc;
    charToPlot.backRed = backRed;
    charToPlot.backGreen = backGreen;
    charToPlot.backBlue = backBlue;
    charToPlot.foreRed = foreRed;
    charToPlot.foreGreen = foreGreen;
    charToPlot.foreBlue = foreBlue;
    
    callbacks.plotChar(charToPlot);
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
