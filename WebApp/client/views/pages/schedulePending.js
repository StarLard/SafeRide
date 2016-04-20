Template.schedulePending.rendered = function(){
    // Move modal to body
    // Fix Bootstrap backdrop issue with animation.css
    $('.modal').appendTo("body");
};

Template.schedulePending.helpers({
  pending: function() {
    return Pending.find({});
  },
  scheduled: function() {
    return Scheduled.find({});
  }
});

Template.schedulePending.events({
  'click .btn-normal': function() {
    Scheduled.insert({
      name: this.name,
      phone: this.phone,
      uoid: this.uoid,
      pickup: this.pickup,
      dropoff: this.dropoff,
      riders: this.riders,
      pickupTime: this.pickupTime
    });
    Pending.remove(this._id);
  }
});
