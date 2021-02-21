const pkgA = require("@myexample/a");

module.exports = function () {
  console.log("module b");
  console.log("About to call package A...");
  pkgA();
};
