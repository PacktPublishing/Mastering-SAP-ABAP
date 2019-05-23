sap.ui.require([
		"sap/ui/test/Opa5",
		"sap/ui/test/actions/EnterText",
		"my/namespace/test/integration/pages/BasicArrangements"
	],
	function (Opa5, EnterText, BasicArrangements) {
		"use strict";
		Opa5.createPageObjects({
			onTheFlightsPage: {
				baseClass: BasicArrangements,
				assertions: {
					theTextShouldBeEntered: function () {
						return this.waitFor({
							id: "searchInput",
							viewName: "my.namespace.views.SearchView",
							actions: new EnterText({
								clearTextFirst: true,
								text: "New York"
							}),
							success: function () {
								Opa5.assert.ok(true, "Text is entered");
							},
							errorMessage: "Failed to enter text"
						});
					}
				}
			}
		});
	});
