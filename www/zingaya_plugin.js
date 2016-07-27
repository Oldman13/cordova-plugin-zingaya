var exec = require('cordova/exec');

function zingaya() {
    this.name = "zingaya_plugin";
}

Zingaya.prototype.call = function(successCallback, errorCallback, args) {
    exec(successCallback, errorCallback, "zingaya", "call", [args]);
};

Zingaya.prototype.hangup = function(successCallback, errorCallback) {
    exec(successCallback, errorCallback, "zingaya", "hangup", []);
};

Zingaya.prototype.microphoneOn = function(successCallback, errorCallback) {
    exec(successCallback, errorCallback, "zingaya", "microphoneOn", []);
};

Zingaya.prototype.microphoneOff = function(successCallback, errorCallback) {
    exec(successCallback, errorCallback, "zingaya", "microphoneOff", []);
};

module.exports = new zingaya();
