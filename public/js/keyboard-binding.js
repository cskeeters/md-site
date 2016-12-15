/*
 * This script binds keys:
 * a to anchor #alpha
 * m to anchor #mtime
 * / to input #search
 */

var ignoreKeys = false;
$(document).keypress(function(e) {
    //alert(e.which);
    if (ignoreKeys) {
        //alert("IK");
        return true;
    }

    if (e.which == 'a'.charCodeAt(0)) {
        $("#alpha")[0].click();
    } else if (e.which == 'm'.charCodeAt(0)) {
        $("#mtime")[0].click();
    } else if (e.which == '/'.charCodeAt(0)) {
        e.preventDefault();
        $("#search").focus();
        $("#search").select();
    }
});
$(document).ready(function() {
    $("#search").focus(function() {
        ignoreKeys = true;
    });
    $("#search").blur(function() {
        ignoreKeys = false;
    });
});
