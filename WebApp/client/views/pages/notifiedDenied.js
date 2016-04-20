Template.notifiedDenied.helpers({
  denied: function() {
    return Denied.find({});
  }
});

Template.notifiedDenied.events({
  'click .btn-warning': function() {
    Denied.remove(this._id);
    toastr.warning("Verified " + this.name + "'s notification of dened request");
  }
});
