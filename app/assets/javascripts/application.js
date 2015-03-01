// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_nested_form
//= require jquery_ujs
//= require jquery.remotipart
//= require bootstrap-sprockets
//= require jquery-ui
//= require_tree .
//= require turbolinks

// window.fbAsyncInit = function() {
//   FB.init({
//     appId      : '1514420408809454',
//     xfbml      : true,
//     version    : 'v2.2'
//   });

//   function onLogin(response) {
//     if (response.status == 'connected') {
//       FB.api('/me?fields=first_name', function(data) {
//         var welcomeBlock = document.getElementById('fb-welcome');
//         welcomeBlock.innerHTML = 'Hello, ' + data.first_name + '!';
//       });
//     }
//   }

//   FB.getLoginStatus(function(response) {
//     // Check login status on load, and if the user is
//     // already logged in, go directly to the welcome message.
//     if (response.status == 'connected') {
//       onLogin(response);
//     } else {
//       // Otherwise, show Login dialog first.
//       FB.login(function(response) {
//         onLogin(response);
//       }, {scope: 'user_friends, email'});
//     }
//   });
// };

// (function(d, s, id){
//    var js, fjs = d.getElementsByTagName(s)[0];
//    if (d.getElementById(id)) {return;}
//    js = d.createElement(s); js.id = id;
//    js.src = "//connect.facebook.net/en_US/sdk.js";
//    fjs.parentNode.insertBefore(js, fjs);
//  }(document, 'script', 'facebook-jssdk'));








