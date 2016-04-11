Template.schedulePending.rendered = function(){
    // Move modal to body
    // Fix Bootstrap backdrop issue with animation.css
    $('.modal').appendTo("body");
};

Template.schedulePending.helpers({
  pending: function() {
    return Pending.find({});
  }
});
