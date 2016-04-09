if (Meteor.isClient) {

  Template.pageOne.helpers({
    pendingCount: function() {
      var count = Pending.find().count();
      var result = "";
      if (count === 0) {
        result = "There are currently NO pending requests";
      } else if (count === 1) {
        result = "There is currently 1 pending request";
      } else if (count > 1) {
        result = "There are currently " + count + " pending requests";

        // toastr.options = {
        //   "closeButton": false,
        //   "debug": false,
        //   "progressBar": false,
        //   "preventDuplicates": true,
        //   "positionClass": "toast-bottom-full-width",
        //   "onclick": null,
        //   "showDuration": "0",
        //   "hideDuration": "0",
        //   "timeOut": "0",
        //   "extendedTimeOut": "0",
        //   "showEasing": "swing",
        //   "hideEasing": "linear",
        //   "showMethod": "fadeIn",
        //   "hideMethod": "fadeOut"
        // }
        // toastr.warning("There are " + count + " pending requests that need your attention!");

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
    }
  });

}
