Template.addrequest.rendered = function(){
    // Move modal to body
    // Fix Bootstrap backdrop issu with animation.css
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
    ticket: 3,
    pickupTime: pickuptime,
    createdTime: new Date()
  });
}



// db.pending.find({},{ticket:1, _id:0}).limit(1).sort({$natural:-1})

// db.pending.find({}).limit(1).sort({$natural:-1})
//
// db.pending.find({}).sort({_id:-1}).limit(1)
