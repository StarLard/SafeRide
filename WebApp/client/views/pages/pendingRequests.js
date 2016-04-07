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

  });
}
