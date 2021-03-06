cordova.define("com.abcpen.paiti.ABCQuestionPlugin", function(require, exports, module) { var exec = require('cordova/exec');
/**
 * Constructor
 */
               function ABCQuestionPlugin() {}
               
               ABCQuestionPlugin.prototype.sayHello = function() {
               exec(function(result){
                    // result handler
                    alert(result['body']);
                    // alert(result);
                    },
                    function(error){
                    // error handler
                    alert("Error" + error);
                    },
                    "ABCQuestionPlugin",
                    "sayHello",
                    []
                    );
               }
               
               ABCQuestionPlugin.prototype.echo = function() {
               exec(function(result){
                    // result handler
                    alert(result['body']);
                    },
                    function(error){
                    // error handler
                    alert("Error" + error);
                    },
                    "ABCQuestionPlugin",
                    "echo",
                    ['dddd']
                    );
               }
               
               mills2Str=function(mills){
               if(typeof mills !='undefined' )
               {
               var date=new Date(mills);
               var time=date.getTime();
               var year=date.getFullYear();
               var month=date.getMonth()+1;if(month < 10) {month = "0"+month;}
               var day=date.getDate();if(day < 10) {day = "0"+day;}
               var hour=date.getHours();if(hour < 10) {hour = "0"+hour;}
               var minute=date.getMinutes();if(minute < 10) {minute = "0"+minute;}
               return year+'-'+month+'-'+day+' '+hour+':'+minute;
               }
               else{
               return '';
               }
               }
               
               ABCQuestionPlugin.prototype.showLoading = function() {
               exec(function(result){
                    var status=result.status;
                    var question=result.question;
                    if(status==0)
                    {
                    Results.img = '<img src="'+question.image_path+'" alt="">';
                    document.getElementById('CreateTime').innerHTML = mills2Str(question.update_time);
                    }
                    jumpWaitting(result);
                    },
                    function(error){
                    // error handler
                    alert("Error" + error);
                    },
                    "ABCQuestionPlugin",
                    "showLoading",
                    []
                    );
               }
               
               ABCQuestionPlugin.prototype.showQuestion = function() {
               exec(function(result){
                    var status=result.status;
                    if(status==0){
                         var question=result.question;
                         Results.img = '<img src="'+question.image_path+'" alt="">';
                    }else if(status==1 ||status==2){
                         var question=result.question;
                         var answers=result.machine_answers; // result handler
                         Results.img = '<img src="'+question.image_path+'" alt="">';
                         document.getElementById('CreateTime').innerHTML = mills2Str(question.update_time);
                    }else if(status==-1){
                         var question=result.question;
                         if(question!=null){
                              Results.img = '<img src="'+question.image_path+'" alt="">';
                              document.getElementById('CreateTime').innerHTML = mills2Str(question.update_time);
                         }
                    }else if(status==-2){
                    
                    }
                         jumpWaitting(result);
                    },
                    function(error){
                    // error handler
                    alert("Error" + error);
                    },
                    "ABCQuestionPlugin",
                    "showQuestion",
                    []
                    );
               }

               ABCQuestionPlugin.prototype.cacheImg = function(data) {
               exec(function(result){
                    // result handler
                    },
                    function(error){
                    // error handler
                    alert("Error" + error);
                    },
                    "ABCQuestionPlugin",
                    "cacheImg",
                    [data]
                    );
               }

               ABCQuestionPlugin.prototype.reTryLink = function() {
               exec(function(result){
                    // result handler
                    //jumpWaitting({"status":0});
                    },
                    function(error){
                    // error handler
                    alert("Error" + error);
                    },
                    "ABCQuestionPlugin",
                    "reTryLink",
                    []
                    );
               }
               
               ABCQuestionPlugin.prototype.showPhoto = function() {
               exec(function(result){
                    // result handler
                    },
                    function(error){
                    // error handler
                    alert("Error" + error);
                    },
                    "ABCQuestionPlugin",
                    "showPhoto",
                    []
                    );
               }
            
               ABCQuestionPlugin.prototype.showNewAnswer = function() {
               exec(function(result){
                    jumpNewanswer();
                    var timeoutId;
                    clearTimeout(timeoutId);
                    timeoutId = setTimeout(function () {
                         myPlugin.showQuestion();
                    }, 3000);
                    },
                    function(error){
                    // error handler
                    alert("Error" + error);
                    },
                    "ABCQuestionPlugin",
                    "showNewAnswer",
                    []
                    );
               }
               
               ABCQuestionPlugin.prototype.reTakePhoto = function() {
               exec(function(result){
                    // result handler
                    },
                    function(error){
                    // error handler
                    alert("Error" + error);
                    },
                    "ABCQuestionPlugin",
                    "reTakePhoto",
                    []
                    );
               }
               // 求助后回调求助成功的函数，暂未定义
               ABCQuestionPlugin.prototype.seekHelp = function() {
               exec(function(result){
                         pauseAudio();
                    },
                    function(error){
                    // error handler
                    alert("Error" + error);
                    },
                    "ABCQuestionPlugin",
                    "seekHelp",
                    []
                    );
               }
               // 跳转到我的求助列表
               ABCQuestionPlugin.prototype.showDiscus = function() {
               exec(function(result){
                    // result handler
                    },
                    function(error){
                    // error handler
                    alert("Error" + error);
                    },
                    "ABCQuestionPlugin",
                    "showDiscus",
                    []
                    );
               }
               // 报错
               ABCQuestionPlugin.prototype.reportError = function() {
               exec(function(result){
                   // result handler
                   },
                   function(error){
                   // error handler
                   alert("Error" + error);
                   },
                   "ABCQuestionPlugin",
                   "reportError",
                   []
                   );
               }
               // 更新所在页码，应用于有缓存进入时获取缓存页码，报错、分享、为音频付费、评价音频等情形下获取question_id
               ABCQuestionPlugin.prototype.cacheIndex = function() {
               exec(function(result){
                    // result handler
                    },
                    function(error){
                    // error handler
                    alert("Error" + error);
                    },
                    "ABCQuestionPlugin",
                    "cacheIndex",
                    [Results.index]
                    );
               }
               ABCQuestionPlugin.prototype.payAudio = function() {
               // 先判定是否登陆，未登陆则跳转到登陆界面
               // 登陆后判定是否付费，未付费跳转到付费流程
               // 付费后回调 hasPay
               exec(function(result){
                    // result handler
                    },
                    function(error){
                    // error handler
                    alert("Error" + error);
                    },
                    "ABCQuestionPlugin",
                    "payAudio",
                    []
                    );
               }
               ABCQuestionPlugin.prototype.playAudio = function() {
               // 先判定是否登陆，未登陆则跳转到登陆界面
               // 登陆后判定是否付费，未付费跳转到付费流程
               // 付费后回调 hasPay
               exec(function(result){
                    // result handler
                    },
                    function(error){
                    // error handler
                    alert("Error" + error);
                    },
                    "ABCQuestionPlugin",
                    "playAudio",
                    []
                    );
               }
               
               // 评价音频
               ABCQuestionPlugin.prototype.evaluateAudio = function() {
               exec(function(result){
                    // result handler
                    },
                    function(error){
                    // error handler
                    alert("Error" + error);
                    },
                    "ABCQuestionPlugin",
                    "evaluateAudio",
                    []
                    );
               }
               // 改变标题
               ABCQuestionPlugin.prototype.resultTitle = function(page) {
               exec(function(result){
                    // result handler
                    },
                    function(error){
                    // error handler
                    alert("Error" + error);
                    },
                    "ABCQuestionPlugin",
                    "changeTitle",
                    [page]
                    );
               }
               // requestAudio
               ABCQuestionPlugin.prototype.requestAudio = function() {
               exec(function(result){
                    // result handler
                    // AudioObj.status = data.audioStatus;
                    // Results.r[Results.index]['audio'].status = AudioObj.status;
                    // if(AudioObj.status === 1) {
                    //      doc.getElementById("request_audio").setAttribute("style","display:block;");
                    //      doc.getElementById("re_audio_status").innerHTML = "已发送请求";
                    // } else if(AudioObj.status === 2) {
                    //      updateAudio();
                    //      Results.r[Results.index].audio.url = "http://192.168.1.237/test/Time.mp3";
                    //      Results.r[Results.index].audio.duration = 250;
                    //      Results.r[Results.index].audio.haspay = true;
                    //      Results.r[Results.index].audio.gold = 20;
                    // }
                    },
                    function(error){
                    // error handler
                    alert("Error" + error);
                    },
                    "ABCQuestionPlugin",
                    "requestAudio",
                    [Results.index]
                    );
               }
               var myPlugin = new ABCQuestionPlugin();
               module.exports = myPlugin
               });
