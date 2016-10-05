# cordova-plugin-zingaya
cordova plugin zingaya

## Installation

```bash
$ cordova plugin add https://github.com/Oldman13/cordova-plugin-zingaya
```

## Usage


zingaya.call = function(successCallback, errorCallback, args)
zingaya.hangup = function(successCallback, errorCallback)
zingaya.microphoneOn = function(successCallback, errorCallback)
zingaya.microphoneOff = function(successCallback, errorCallback)

example:
zingaya.call(function(status){
                    scope.lastDialUpStatus = status;
                }, function(status){
                    console.warn('Dial up error', status);
                }

zingaya.hangup(
                function(status){
                    console.warn('Hang up successful', status);
                }, function(status){
                    console.warn('Hang up error', status);
                }
            );

zingaya.microphoneOn(
                    function (status) {
                        console.warn('Turning on microphone successful', status);
                    }, function (status) {
                        console.warn('Turning on microphone error', status);
                    }
                );

zingaya.microphoneO(
                    function (status) {
                        console.warn('Turning on microphone successful', status);
                    }, function (status) {
                        console.warn('Turning on microphone error', status);
                    }
                );


## Compatibility

  * Cordova >= 3.0.0
  