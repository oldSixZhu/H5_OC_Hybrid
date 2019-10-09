//确认js加载成功
window.onload = function (){
//    alert(0);
}

//点击html按钮,调用js方法
function clickBtn() {
    window.location.href ="https://www.baidu.com";
}

//点击html按钮,调用oc方法
function dismiss() {
    window.webkit.messageHandlers.ocMethod.postMessage("我点击html按钮,调用oc的方法,让webView消失");
}

//点击html的div标签,要调用oc方法
function clickTime() {
    window.webkit.messageHandlers.presentMethod.postMessage("我点击div标签,调用oc的方法,弹出一个控制器");
}

//点击oc按钮,要调用的js方法
function baidu() {
    window.location.href = "https://www.baidu.com";
    
}


