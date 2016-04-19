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


schedulePending = function(name, uoid, phone, pickup, dropoff, riders, pickupTime) {
  Scheduled.insert({
    name: name,
    phone: phone,
    uoid: uoid,
    pickup: pickup,
    dropoff: dropoff,
    riders: riders,
    pickupTime: pickupTime,
  });
}

removePending = function(id) {
  Pending.remove(id);
}
