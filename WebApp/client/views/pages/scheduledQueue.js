Scheduled = new Mongo.Collection('scheduled');

// Execute client-side
if (Meteor.isClient) {
  Template.scheduledQueue.helpers({
    scheduled: function() {
      return Scheduled.find({});
    }
  });

  Template.scheduledQueue.events({
    'click .btn-danger': function() {
      Denied.insert({
        name: this.name,
        phone: this.phone,
        uoid: this.uoid,
        pickup: this.pickup,
        dropoff: this.dropoff,
        riders: this.riders,
        pickupTime: this.pickupTime
      });
      Scheduled.remove(this._id);
      toastr.warning("Removed " + this.name + "'s scheduled ride");
    }
  });

}

// Execute server-side
if (Meteor.isServer) {
  Meteor.startup(function() {

  });
}
