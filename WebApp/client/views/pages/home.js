Template.home.rendered = function(){
  var data = [{
      label: "Pending",
      data: Pending.find().count(),
      color: "#0e83c9"
  }, {
      label: "Scheduled",
      data: Scheduled.find().count(),
      color: "#00b494"
  }, {
      label: "Denied",
      data: Denied.find().count(),
      color: "#faad50"
  }];

  var plotObj = $.plot($("#flot-pie-chart"), data, {
      series: {
          pie: {
              show: true
          }
      },
      grid: {
          hoverable: true
      },
      tooltip: true,
      tooltipOpts: {
          content: "%p.0%, %s", // show percentages, rounding to 2 decimal places
          shifts: {
              x: 20,
              y: 0
          },
          defaultTheme: true
      }
  });

};
