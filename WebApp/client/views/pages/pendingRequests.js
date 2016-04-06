Pending = new Mongo.Collection('pending');

// Execute client-side
if (Meteor.isClient) {
  Template.pendingRequests.helpers({
    pending: function() {
      return Pending.find({});
    }
  });

}

// Execute server-side
if (Meteor.isServer) {
  Meteor.startup(function() {

    // Seed db if empty
    if (Pending.find().count() == 0) {
      Pending.insert({
        name: "John Doe",
        phone: "555-555-5555",
        uoid: 951111111,
        pickup: "[Pickup Address]",
        dropoff: "[Dropoff Address]",
        riders: 3
      });
    }

  });
}
