//
//  Wrapper.h
//  Brogue
//
//  Created by Raymund Vidar on 10/11/19.
//  Copyright © 2019 darthvid. All rights reserved.
//

#ifndef Wrapper_h
#define Wrapper_h

typedef struct {
    uchar inputChar;
    short xLoc; short yLoc;
    short backRed; short backGreen; short backBlue;
    short foreRed; short foreGreen; short foreBlue;
} PlotCharStruct;

typedef struct
{
    boolean (*isAppActive)(void);
    boolean (*isControlKeyDown)(void);
    boolean (*isEventWhilePaused)(int);
    rogueEvent (*getBrogueEvent)(boolean textInput, boolean colorsDance);
    void (*plotChar)(PlotCharStruct);
} cbStruct;

extern cbStruct callbacks;

/*
 Platform -> Brogue
 
 The Brogue APIs can actually be called directly from Swift, but we place them here so we can keep track of them all cleanly.
 */


/*
// Globals Platform needs to update
 
// Platform -> Brogue
    //void rogueMain();
    //void shuffleTerrainColors(short percentOfCells, boolean refreshCells);
    //void commitDraws();

// Brogue -> Platform
    //boolean controlKeyIsDown();
    //short getHighScoresList(rogueHighScoresEntry returnList[HIGH_SCORES_COUNT]);
    //void initializeBrogueSaveLocation();
    //void initializeLaunchArguments(enum NGCommands *command, char *path, unsigned long *seed);
    //boolean isApplicationActive();
    //fileEntry *listFiles(short *fileCount, char **dynamicMemoryBuffer);
    //void nextKeyOrMouseEvent(rogueEvent *returnEvent, boolean textInput, boolean colorsDance);
    //boolean pauseForMilliseconds(short milliseconds);
    //void plotChar(uchar inputChar,
                  short xLoc, short yLoc,
                  short backRed, short backGreen, short backBlue,
                  short foreRed, short foreGreen, short foreBlue);
    //boolean saveHighScore(rogueHighScoresEntry theEntry);
 #ifdef USE_CLIPBOARD
    //char *getClipboard();
 #endif
*/


#endif /* Wrapper_h */
