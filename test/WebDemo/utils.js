(function (win) {
    $.fn.hasAttr = function (attr) {
        return typeof $(this).attr(attr) != 'undefined';
    }
    var Utils = {
        alert: function (msg) {
            alert(msg);
        },
        writeText:function (text) {
            document.getElementById('#container').appendChild('<p>我是新文案</p>');
        }
    };
    win.Utils = Utils;

})
(window);
