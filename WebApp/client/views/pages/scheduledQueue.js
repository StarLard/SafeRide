Scheduled = new Mongo.Collection('scheduled');

// Execute client-side
if (Meteor.isClient) {
  Template.scheduledQueue.helpers({
    scheduled: function() {
      return Scheduled.find({});
    }
  });

}

// Execute server-side
if (Meteor.isServer) {
  Meteor.startup(function() {

  });
}
