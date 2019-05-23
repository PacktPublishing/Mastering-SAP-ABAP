sap.ui.define([
	"my/namespace/test/unit/testModules"
], function () {
	"use strict";
});

sap.ui.require([
		"my/namespace/controllers/SearchView.controller"
	],
	function (file1) {
		"use strict";
		QUnit.module("Simple module");

		function testCase(assert, argument, expected) {
			var result = (new file1()).testMe(argument);
			assert.strictEqual(result, expected, "Correct result");
		}

		QUnit.test("Name of the test case", function (assert) {
			testCase.call(this, assert, 1, 2);
			testCase.call(this, assert, -3, -6);
		});

	});
