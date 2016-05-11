Router.configure({
    layoutTemplate: 'mainLayout',
    notFoundTemplate: 'notFound'

});

Router.route('/portal', {
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
