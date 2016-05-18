Template.login.events({
  'submit form': function(e){
    e.preventDefault();
    var username = $('[name=username]').val();
    var password = $('[name=password]').val();
    Meteor.loginWithPassword(username, password, function(error) {
      if(error) {
        toastr.error("Login Failed: " + error.reason);
        document.getElementById("loginForm").reset();
      } else {
        Router.go('home');
      }
    });
  }
});
