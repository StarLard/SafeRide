Template.reservationStatus.rendered = function(){
    // Move modal to body
    // Fix Bootstrap backdrop issue with animation.css
    $('.modal').appendTo("body");
};

checkReservationStatus = function(uoid) {
  var status = '';

  // Verify valid UO ID
  if (String(uoid).charAt(0) != '9' || String(uoid).charAt(1) != '5') {
    $('#reservationStatusModal').find("input,textarea,select").val('').end();
    status = "invalid";
  }

  // Search databases for reservation
  if (Pending.findOne({uoid:uoid}) == undefined) {
    if (Scheduled.findOne({uoid:uoid}) == undefined) {
      if (Denied.findOne({uoid:uoid}) == undefined) {
        if (status != "invalid") { status = "error"; }
      } else { status = "denied"; }
    } else { status = "scheduled"; }
  } else { status = "pending"; }

  // Set alert
  if (status == "invalid") {
    var elm = document.getElementById("invalidResult");
    elm.classList.remove("hidden");
  } else if (status == "pending") {
    var elm = document.getElementById("pendingResult");
    elm.classList.remove("hidden");
  } else if (status == "scheduled") {
    var elm = document.getElementById("scheduledResult");
    elm.classList.remove("hidden");
  } else if (status == "denied") {
    var elm = document.getElementById("deniedResult");
    elm.classList.remove("hidden");
  } else {
    var elm = document.getElementById("errorResult");
    elm.classList.remove("hidden");
  }

};

resetHiddenElement = function() {
    var invalidElement = document.getElementById("invalidResult");
    var pendingElement = document.getElementById("pendingResult");
    var scheduledElement = document.getElementById("scheduledResult");
    var deniedElement = document.getElementById("deniedResult");
    var errorElement = document.getElementById("errorResult");

    if (!invalidElement.classList.contains("hidden")) {
      invalidElement.classList.add("hidden");
    } else if (!pendingElement.classList.contains("hidden")) {
      pendingElement.classList.add("hidden");
    } else if (!scheduledElement.classList.contains("hidden")) {
      scheduledElement.classList.add("hidden");
    } else if (!deniedElement.classList.contains("hidden")) {
      deniedElement.classList.add("hidden");
    } else if (!errorElement.classList.contains("hidden")) {
      errorElement.classList.add("hidden");
    }
};
