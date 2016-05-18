//   DEPLOY_HOSTNAME=galaxy.meteor.com meteor deploy saferide.meteorapp.com --settings settings.json


Pending = new Mongo.Collection('pending');
Scheduled = new Mongo.Collection('scheduled');
Denied = new Mongo.Collection('denied');


if (Meteor.isServer) {

  Meteor.startup(function() {
  }); // end .startup()


  // Server permissions
  Pending.allow({
    insert: function(userId,doc) {
      return true;
    },
    remove: function(userId, doc) {
      return true;
    }
  });
  Scheduled.allow({
    insert: function(userId, doc) {
      return true;
    },
    remove: function(userId, doc) {
      return true;
    }
  });
  Denied.allow({
    insert: function(userId, doc) {
      return true;
    },
    remove: function(userId, doc) {
      return true;
    }
  });


  // Server Methods
  return Meteor.methods({
    purgePending: function() {
        Pending.remove({});
    },
    purgeScheduled: function() {
        Scheduled.remove({});
    },
    purgeDenied: function() {
        Denied.remove({});
    },
    purgeAll: function() {
        Pending.remove({});
        Scheduled.remove({});
        Denied.remove({});
    },
    removePending: function(id) {
        Pending.remove(id);
    },
    removeScheduled: function(id) {
        Scheduled.remove(id);
    },
    removeDenied: function(id) {
        Denied.remove(id);
    },
    insertPending: function(name, uoid, phone, pickup, dropoff, riders, pickuptime) {
        Pending.insert({
          name: name,
          phone: phone,
          uoid: uoid,
          pickup: pickup,
          dropoff: dropoff,
          riders: riders,
          pickupTime: pickuptime,
          createdTime: moment().format('h:mm a')
        });
    },
    insertScheduled: function(name, uoid, phone, pickup, dropoff, riders, pickuptime) {
        Scheduled.insert({
          name: name,
          phone: phone,
          uoid: uoid,
          pickup: pickup,
          dropoff: dropoff,
          riders: riders,
          pickupTime: pickuptime,
        });
    },
    insertDenied: function(name, uoid, phone, pickup, dropoff, riders, pickuptime) {
        Denied.insert({
          name: name,
          phone: phone,
          uoid: uoid,
          pickup: pickup,
          dropoff: dropoff,
          riders: riders,
          pickupTime: pickuptime,
        });
    },
    getPending: function() {
        return Pending.find().fetch();
    },
    getScheduled: function() {
        return Scheduled.find().fetch();
    },
    getDenied: function() {
        return Denied.find().fetch();
    },
    createAccount: function(usr, pw) {
      Accounts.createUser({
        username: usr,
        password: pw
      });
    }


  }); // end server methods


} // end .isServer()
