Template.schedulePending.rendered = function(){
    // Move modal to body
    // Fix Bootstrap backdrop issue with animation.css
    $('.modal').appendTo("body");
    $("[data-toggle=tooltip]").tooltip();
};

Template.schedulePending.helpers({
  pending: function() {
    return Pending.find({});
  },
  scheduled: function() {
    return Scheduled.find({});
  },
  denied: function() {
    return Denied.find({});
  }
});

Template.schedulePending.events({
  'click .btn-primary': function() {
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
    toastr.success("Successfully scheduled " + this.name + " for " + this.pickupTime);
  },
  'click .btn-danger': function() {
    Denied.insert({
      name: this.name,
      phone: this.phone,
      uoid: this.uoid,
      pickup: this.pickup,
      dropoff: this.dropoff,
      riders: this.riders,
      pickupTime: this.pickupTime
    });
    Pending.remove(this._id);
    toastr.warning("Denied " + this.name + "'s request");
  }
});
