if (Meteor.isClient) {

  Template.pending.helpers({
    pendingCount: function() {
      var count = Pending.find().count();
      var result = "";
      if (count === 0) {
        result = "There are currently NO pending requests";
      } else if (count === 1) {
        result = "There is currently 1 pending request";
      } else if (count > 1) {
        result = "There are currently " + count + " pending requests";
      }
      return result;
    },
    scheduledCount: function() {
      var count = Scheduled.find().count();
      var result = "";
      if (count === 0) {
        result = "There are currently NO scheduled rides";
      } else if (count === 1) {
        result = "There is currently 1 scheduled ride";
      } else if (count > 1) {
        result = "There are currently " + count + " scheduled rides";
      }
      return result;
    },
    deniedCount: function() {
      var count = Denied.find().count();
      var result = "";
      if (count === 0) {
        result = "There are currently NO denied requests";
      } else if (count === 1) {
        result = "There is currently 1 denied requests";
      } else if (count > 1) {
        result = "There are currently " + count + " denied requests";
      }
      return result;
    }
  });

}
