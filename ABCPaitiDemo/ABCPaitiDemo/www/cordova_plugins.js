cordova.define('cordova/plugin_list', function(require, exports, module) {
module.exports = [
               {
                  "file": "plugins/ABCQuestionPlugin.js",
                  "id": "com.abcpen.paiti.ABCQuestionPlugin",
                  "clobbers": [
                               "myPlugin"
                               ]
               },
               {
                  "file": "plugins/ABCMallPlugin.js",
                  "id": "com.abcpen.paiti.ABCMallPlugin",
                  "clobbers": [
                               "mallPlugin"
                               ]
               }
               ];
module.exports.metadata = 
// TOP OF METADATA
{
"com.abcpen.paiti.ABCQuestionPlugin": "0.1.0",
"com.abcpen.paiti.ABCMallPlugin": "0.1.0"
}
// BOTTOM OF METADATA
});
