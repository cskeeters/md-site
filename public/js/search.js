// This file is only used for searching by the statically generated search page

function qs(key) {
    key = key.replace(/[*+?^$.\[\]{}()|\\\/]/g, "\\$&"); // escape RegEx meta chars
    var match = location.search.match(new RegExp("[?&]"+key+"=([^&]+)(&|$)"));
    return match && decodeURIComponent(match[1].replace(/\+/g, " "));
}

$(function() {
    q = qs("q");
    $("#search").val(q);

    var data = JSON.parse(document.getElementById('data').innerHTML);
    for (var i in data.files) {
        console.log(data.files[i].name);
    }

    $("#results").append("<h1>File names matching <i>"+q+"</i></h1>");
    items=""
    for (var i in data.files) {
        file = data.files[i]
        if (file.name.toLowerCase().indexOf(q.toLowerCase()) != -1) {
            items+="<li><a href='"+file.name+"'>"+file.name+"</a></li>"
        }
    }
    $("#results").append("<ol>"+items+"</ol>");


    $("#results").append("<h1>File contents with <i>"+q+"</i></h1>");
    items=""
    for (var i in data.files) {
        file = data.files[i]
        if (file.keywords.includes(q.toLowerCase())) {
            items+="<li><a href='"+file.name+"'>"+file.name+"</a></li>"
        }
    }
    $("#results").append("<ol>"+items+"</ol>");
});
