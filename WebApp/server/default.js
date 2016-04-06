Pending = new Mongo.Collection('pending');

if (Meteor.isServer) {
  // Server permissions
  Pending.allow({
  insert: function (userId,doc) {
    /* user and doc checks ,
    return true to allow insert */
    return true;
  }
  });
}
