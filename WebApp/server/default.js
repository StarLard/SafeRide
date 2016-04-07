Pending = new Mongo.Collection('pending');
Scheduled = new Mongo.Collection('scheduled');

if (Meteor.isServer) {
  Meteor.startup(function() {
    // Seed db if empty
    if (Pending.find().count() === 0) {
      Pending.insert({
        name: "John Doe",
        phone: "555-555-5555",
        uoid: 951111111,
        pickup: "[Pickup Address]",
        dropoff: "[Dropoff Address]",
        riders: 1,
        ticket: 1,
        pickupTime: "8:00pm",
        createdTime: new Date()
      });
    }

    // Seed db if empty
    if (Scheduled.find().count() === 0) {
      Scheduled.insert({
        name: "Jane Doe",
        phone: "555-555-5555",
        uoid: 952222222,
        pickup: "[Pickup Address]",
        dropoff: "[Dropoff Address]",
        riders: 3,
        ticket: 2,
        pickupTime: "9:00pm",
        createdTime: new Date()
      });
    }
  });


  // Server permissions
  Pending.allow({
  insert: function (userId,doc) {
    /* user and doc checks ,
    return true to allow insert */
    return true;
  }
  });

  Scheduled.allow({
  insert: function (userId,doc) {
    /* user and doc checks ,
    return true to allow insert */
    return true;
  }
  });

}
