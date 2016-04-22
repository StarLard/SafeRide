Template.addScheduled.rendered = function(){
    // Move modal to body
    // Fix Bootstrap backdrop issue with animation.css
    $('.modal').appendTo("body");
};
Template.scheduledQueue.helpers({
  scheduled: function() {
    return Scheduled.find({});
  }
});

storeScheduled = function(name, uoid, phone, pickup, dropoff, riders, pickuptime) {
  Scheduled.insert({
    name: name,
    phone: phone,
    uoid: uoid,
    pickup: pickup,
    dropoff: dropoff,
    riders: riders,
    pickupTime: pickuptime,
  });
}
