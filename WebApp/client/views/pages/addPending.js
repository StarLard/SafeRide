Template.addPending.rendered = function(){
    // Move modal to body
    // Fix Bootstrap backdrop issue with animation.css
    $('.modal').appendTo("body");
};

storeRequest = function(name, uoid, phone, pickup, dropoff, riders, pickuptime) {
  Pending.insert({
    name: name,
    phone: phone,
    uoid: uoid,
    pickup: pickup,
    dropoff: dropoff,
    riders: riders,
    pickupTime: pickuptime,
    createdTime: moment().format('h:mm a')
  });
}