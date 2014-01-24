var qs = (function(a) {
    if (a == "") return {};
    var b = {};
    for (var i = 0; i < a.length; ++i)
    {
        var p=a[i].split('=');
        if (p.length != 2) continue;
        b[p[0]] = decodeURIComponent(p[1].replace(/\+/g, " "));
    }
    return b;
})(window.location.search.substr(1).split('&'));

var token = qs["reset_password_token"];

if(token != undefined){
  console.log(token);
  $.ajax({
    type : 'GET',
    url : '/users/password/edit',
    data: { 'reset_password_token': token },
    dataType : 'script'
  });
}
