
cordova.define("com.abcpen.paiti.ABCMallPlugin", function(require, exports, module) { var exec = require('cordova/exec');
/**
 * Constructor
 */
               function ABCMallPlugin() {}
/*                    */

               ABCMallPlugin.prototype.sayHello = function() {
               exec(function(result){
                    // result handler
                    alert(result['body']);
                    // alert(result);
                    },
                    function(error){
                    // error handler
                    alert("Error" + error);
                    },
                    "ABCMallPlugin",
                    "sayHello",
                    []
                    );
               }
               
               // v1.4接口：获取登录有效
               ABCMallPlugin.prototype.getAuthData = function() {
                    exec(function(result) {
                         // result handler
                         UserData.user_agent = result['user_agent'];
                         UserData.token = escape(result['token']);
                         UserData.cookie = escape(result['cookie']);
                         UserData.mobile = escape(result['mobile']);
                         },
                         function(error){
                         // error handler
                         alert("Error" + error);
                         },
                         "ABCMallPlugin",
                         "getAuthData",
                         []
                         );
               }
               
               ABCMallPlugin.prototype.setTitle = function() {
               exec(function(result) {
                        alert("setTitle returned");
                    },
                    function(error) {
                        alert("setTitle error");
                    },
                    "ABCMallPlugin",
                    "setTitle",
                    [document.title]//写入title的值
                    );
               }
               
               ABCMallPlugin.prototype.inviteFriend = function() {
               exec(function(result) {
                        alert("inviteFriend returned");
                    },
                    function(error) {
                        alert("inviteFriend error");
                    },
                    "ABCMallPlugin",
                    "inviteFriend",
                    []
                    );
               }

               ABCMallPlugin.prototype.reportReqFail = function() {
               exec(function(result) {
                    
                    },
                    function(error) {
                    
                    },
                    "ABCMallPlugin",
                    "reportReqFail",
                    []
                    );
               }
               
               ABCMallPlugin.prototype.sendVerifiCode = function(tel) {
               exec(function(result) {
                    // 更改按钮状态
                    },
                    function(error) {
                        alert("inviteFriend error");
                    },
                    "ABCMallPlugin",
                    "sendVerifiCode",
                    [tel]
                    );
               }
               
               
               var mallPlugin = new ABCMallPlugin();
               module.exports = mallPlugin
               });

