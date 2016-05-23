Router.configure({
    layoutTemplate: 'mainLayout',
    notFoundTemplate: 'notFound'
});

Router.route('/portal', {
    layoutTemplate: 'blankLayout'
});

Router.route('/login', {
    layoutTemplate: 'blankLayout'
});

Router.route('/home', function () {
    this.render('home');
});

Router.route('/pending', function () {
    this.render('pending');
});

Router.route('/scheduled', function () {
    this.render('scheduled');
});

Router.route('/denied', function () {
    this.render('denied');
});

Router.route('/admin', function () {
    this.render('admin');
});

Router.route('/', function () {
    Router.go('portal');
});

Router.onBeforeAction(function () {
    if (!Meteor.user() && !Meteor.loggingIn()) {
        this.redirect('/portal');
    } else {
        this.next();
    }
}, {
    except: ['login', 'portal']
});
