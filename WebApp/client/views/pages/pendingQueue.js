Pending = new Mongo.Collection('pending');

// Execute client-side
if (Meteor.isClient) {

  Template.pendingQueue.helpers({
    pending: function() {
      return Pending.find({});
    },
    pendingCount: function() {
      return Pending.find().count();
    }
  });

}

// Execute server-side
if (Meteor.isServer) {
  Meteor.startup(function() {

  });
}
