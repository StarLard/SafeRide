Pending = new Mongo.Collection('pending');
Scheduled = new Mongo.Collection('scheduled');


if (Meteor.isServer) {

  Meteor.startup(function() {

    // Seed databases if empty
    // if (Pending.find().count() === 0) {
    //   Pending.insert({
    //     name: "John Doe",
    //     phone: "555-555-5555",
    //     uoid: 951111111,
    //     pickup: "[Pickup Address]",
    //     dropoff: "[Dropoff Address]",
    //     riders: 1,
    //     pickupTime: "8:21pm",
    //     createdTime: moment().format('h:mm a')
    //   });
    // }
    // if (Scheduled.find().count() === 0) {
    //   Scheduled.insert({
    //     name: "Jane Doe",
    //     phone: "555-555-5555",
    //     uoid: 952222222,
    //     pickup: "[Pickup Address]",
    //     dropoff: "[Dropoff Address]",
    //     riders: 2,
    //     pickupTime: "9:22pm",
    //   });
    // }

  }); // end .startup()


  // Server permissions
  Pending.allow({
    insert: function(userId,doc) {
      return true;
    },
    remove: function(userId, doc) {
      return true;
    }
  });

  Scheduled.allow({
    insert: function(userId, doc) {
      return true;
    },
    remove: function(userId, doc) {
      return true;
    }
  });


  // Server Methods
  return Meteor.methods({
    purgePending: function() {
        Pending.remove({});
    },
    purgeScheduled: function() {
        Scheduled.remove({});
    },
    purgeAll: function() {
        Pending.remove({});
        Scheduled.remove({});
    }




  });


} // end .isServer()
