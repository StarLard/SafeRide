Pending = new Mongo.Collection('pending');
Scheduled = new Mongo.Collection('scheduled');

var socket = io('http://159.203.237.54/:443');


if (Meteor.isServer) {

  Meteor.startup(function() {

    socket.on('connect', Meteor.bindEnvironment(function() {
      console.log('Connected to the websocket!');
      //Meteor.call('methodName1');

      // on data event
      socket.on('insert', Meteor.bindEnvironment(function(data) {
        console.log(data);
        //Meteor.call('methodName2');
      }, function(e) {
        throw e;
      }));

      // on disconnect
      socket.on('disconnect', Meteor.bindEnvironment(function() {
        console.log('Disconnected from the websocket!');
        //Meteor.call('methodName3');
      }, function(e) {
        throw e;
      }));

  }, function(e) {
    throw e;
  }));

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


  // Server Methods
  return Meteor.methods({
    purgePending: function() {
        Pending.remove({});
    },
    purgeScheduled: function() {
        Scheduled.remove({});
    },
    purgeAll: function() {
        Pending.remove({});
        Scheduled.remove({});
    },
    insertPending: function(name, uoid, phone, pickup, dropoff, riders, pickuptime)
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
    }

  }); // end server methods


} // end .isServer()
