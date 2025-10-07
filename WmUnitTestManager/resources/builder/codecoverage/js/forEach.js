/* Copyright Super iPaaS Integration LLC, an IBM Company 2024
*/

'use strict';
(function () {
  if (!Array.prototype.forEach) {
    Array.prototype.forEach = function forEach (callback, thisArg) {
      if (typeof callback !== 'function') {
        throw new TypeError(callback + ' is not a functionQQQQQ');
      }
      var array = this;
      thisArg = thisArg || this;
      for (var i = 0, l = array.length; i !== l; ++i) {
        callback.call(thisArg, array[i], i, array);
      }
    };
  }
})();