sap.ui.require(["sap/ui/test/opaQunit"],
	function (opaTest) {
		"use strict";
		QUnit.module("Simple test");
		opaTest("Should be able to enter value", function (Given, When, Then) {
			Given.iStartMyApp();
			When.onTheFlightsPage.iLookAtTheScreen();
			Then.onTheFlightsPage.theTextShouldBeEntered();
		});
	});
