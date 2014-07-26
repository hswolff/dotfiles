// SLATE CONFIG

var laptopMonitor = "1";
var externalMonitor = "0";

//
// Configs
//
slate.configAll({
  // 'windowHintsDuration': '5,
  // 'checkDefaultsOnLoad': 'true,
  'defaultToCurrentScreen': true,
  'nudgePercentOf': 'screenSize',
  'resizePercentOf': 'screenSize',
  'windowHintsShowIcons': true,
  'windowHintsIgnoreHiddenWindows': false,
  'windowHintsSpread': true
});

//
// Operations
//
var full = slate.operation('move', {
  "x" : "screenOriginX",
  "y" : "screenOriginY",
  "width" : "screenSizeX",
  "height" : "screenSizeY"
});

var tophalf = full.dup({ "height" : "screenSizeY/2" });
var bottomhalf = tophalf.dup({ "y" : "screenOriginY+screenSizeY/2" });

var lefthalf = full.dup({ "width": "screenSizeX/2" });
var righthalf = lefthalf.dup({ "x": "screenOriginX+screenSizeX/2"});

var topLeftSquare = tophalf.dup({ "width": "screenSizeX/2"});
var topRightSquare = topLeftSquare.dup({ "x": "screenOriginX+screenSizeX/2"});
var bottomLeftSquare = bottomhalf.dup({ "width": "screenSizeX/2"});
var bottomRightSquare = bottomLeftSquare.dup({ "x": "screenOriginX+screenSizeX/2"});

var grid = slate.operation("grid", {
  "grids": {
    "1440x900": {
      "width": 8,
      "height": 8
    },
    "2560x1440": {
      "width": 8,
      "height": 8
    }
  }
});


// Left Monitor Layouts
var mailPosition = slate.operation('move', {
  "screen": laptopMonitor,
  "x" : "screenOriginX",
  "y" : "screenOriginY",
  "width" : 1100,
  "height" : 740
});
var hipChatPosition = slate.operation('corner', {
  "screen": laptopMonitor,
  "direction": "bottom-left",
  "width" : 900,
  "height" : 460
});
var textualPosition = slate.operation('corner', {
  "screen": laptopMonitor,
  "direction": "top-left",
  "width" : 900,
  "height" : 410
});
var messagesPositionBuddies = slate.operation('corner', {
  "screen": laptopMonitor,
  "direction": "top-right",
  "width" : 190,
  "height" : 900
});
var messagesPositionMessages = slate.operation('corner', {
  "screen": laptopMonitor,
  "direction": "bottom-right",
  "width" : 600,
  "height" : 360
});
var iTunesPosition = slate.operation('throw', {
  "screen": laptopMonitor,
  "x": "screenOriginX+((screenSizeX-1100)/2)",
  "y": "screenOriginY",
  "width" : 1100,
  "height" : 725
});

// Center Monitor Layouts
//

// Right Monitor Layouts
var terminalPosition = slate.operation('move', {
  "x" : "screenOriginX",
  "y" : "screenOriginY",
  "width" : "screenSizeX",
  "height" : 460
});
var gitxPosition = slate.operation('corner', {
  "direction": "bottom-left",
  "width" : "screenSizeX",
  "height" : 680
});
var sourceTreePosition = slate.operation('corner', {
  "direction": "bottom-left",
  "width" : "screenSizeX",
  "height" : 720
});


//
// Layouts
//

var leftSpaceLayout = slate.layout("leftSpace", {
  "Sparrow": {
    "operations": [mailPosition]
  },
  "Airmail": {
    "operations": [mailPosition]
  },
  "HipChat": {
    "operations": [hipChatPosition]
  },
  "Textual": {
    "operations": [textualPosition]
  },
  "Messages": {
    "operations": [messagesPositionBuddies, messagesPositionMessages],
    "title-order": ["Buddies", "Messages"]
  },
  "iTunes": {
    "operations": [iTunesPosition]
  }
});

var centerSpaceLayout = slate.layout("centerSpace", {
  "Google Chrome": {
    "operations": [full],
    "repeat": true
  },
  "Sublime Text": {
    "operations": [full],
    "repeat": true
  }
});

var rightSpaceLayout = slate.layout("rightSpace", {
  "Terminal": {
    "operations": [terminalPosition]
  },
  "iTerm": {
    "operations": [terminalPosition]
  },
  "GitX": {
    "operations": [gitxPosition]
  },
  "SourceTree": {
    "operations": [sourceTreePosition]
  }
});

//
// Bindings
//
slate.bindAll({
  "esc:cmd": slate.operation("hint"),
  "esc:ctrl" : grid,

  "s:ctrl;shift": full,
  "a:ctrl;shift": lefthalf,
  "d:ctrl;shift": righthalf,

  // "w:ctrl;shift": tophalf,
  // "x:ctrl;shift": bottomhalf,

  "q:ctrl;shift": topLeftSquare,
  "e:ctrl;shift": topRightSquare,
  "z:ctrl;shift": bottomLeftSquare,
  "c:ctrl;shift": bottomRightSquare,

  "1:ctrl,shift": slate.operation("layout", {"name": leftSpaceLayout }),
  "2:ctrl,shift": slate.operation("layout", {"name": centerSpaceLayout }),
  "3:ctrl,shift": slate.operation("layout", {"name": rightSpaceLayout })
});