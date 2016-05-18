Template.navigation.rendered = function(){
    // Initialize metisMenu
    $('#side-menu').metisMenu();
};

Template.navigation.events({
    'click .logout': function(e){
        e.preventDefault();
        Meteor.logout();
    }
});
