Denied = new Mongo.Collection('denied');

// Execute client-side
if (Meteor.isClient) {
  Template.deniedQueue.helpers({
    denied: function() {
      return Denied.find({});
    }
  });

}

// Execute server-side
if (Meteor.isServer) {
  Meteor.startup(function() {

  });
}
