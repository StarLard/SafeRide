Template.blankLayout.rendered = function(){

    // Add gray color for background in blank layout
    $('body').addClass('green-bg');
    // $('body').addClass('text-white');

}

Template.blankLayout.destroyed = function(){

    // Remove special color for blank layout
    $('body').removeClass('green-bg');
    // $('body').removeClass('text-white');

};

// {{> topNavbar }}
