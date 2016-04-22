var system = require('system');
var webPage = require('webpage');
var page = webPage.create();

if (system.args.length === 1) {
  phantom.exit();
} else {
  page.open(system.args[1], function (status) {
    console.log('' + page.content);
    phantom.exit();
  });
}
