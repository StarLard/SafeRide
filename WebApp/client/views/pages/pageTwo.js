Template.pageTwo.helpers({
  pending: function() {
    return Pending.find({});
  },
  scheduled: function() {
    return Scheduled.find({});
  },
  denied: function() {
    return Denied.find({});
  }
});

Template.pageTwo.events({
  // Purge Pending Queue
  'click .btn-success': function() {
    swal({
        title: "Are you sure?",
        text: "You are about to delete the 'Pending Requests' database. All data will be forever lost. Are you sure you want to continue?",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: "#DD6B55",
        confirmButtonText: "Yes, purge away!",
        closeOnConfirm: false
    }, function () {
        Meteor.call('purgePending');
        swal("Database Deleted!", "The 'Pending Requests' database has been successfully purged.", "success");
    });
  },
  // Purge Schedule Queue
  'click .btn-primary': function() {
    swal({
        title: "Are you sure?",
        text: "You are about to delete the 'Scheduled Rides' database. All data will be forever lost. Are you sure you want to continue?",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: "#DD6B55",
        confirmButtonText: "Yes, purge away!",
        closeOnConfirm: false
    }, function () {
        Meteor.call('purgeScheduled');
        swal("Database Deleted!", "The 'Scheduled Rides' database has been successfully purged.", "success");
    });
  },
  // Purge Denied Queue
  'click .btn-warning': function() {
    swal({
        title: "Are you sure?",
        text: "You are about to delete the 'Denied Requests' database. All data will be forever lost. Are you sure you want to continue?",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: "#DD6B55",
        confirmButtonText: "Yes, purge away!",
        closeOnConfirm: false
    }, function () {
        Meteor.call('purgeDenied');
        swal("Database Deleted!", "The 'Denied Requests' database has been successfully purged.", "success");
    });
  },
  // Purge ALL Queues
  'click .btn-danger': function() {
    swal({
        title: "Are you sure?",
        text: "You are about to delete ALL databases. All data will be forever lost. Are you sure you want to continue?",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: "#DD6B55",
        confirmButtonText: "Yes, purge away!",
        closeOnConfirm: false
    }, function () {
        Meteor.call('purgeAll');
        swal("Databases Deleted!", "All databases have been successfully purged.", "success");
    });
  }

});