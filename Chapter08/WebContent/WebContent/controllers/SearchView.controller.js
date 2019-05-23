sap.ui.define(["sap/ui/core/mvc/Controller"], function (Controller) {
	return Controller.extend("my.namespace.controllers.SearchView", {
		onInit: function () {
			this.getView()
				.setModel(
					new sap.ui.model.json.JSONModel({
						"FlightsSet": []
					}),
					"filteredFlights"
				);
		},

		searchButtonPressed: function (oEvent) {
			var sValue = this.getView().byId("searchInput").getValue();
			var filters = [];
			if (sValue) {
				filters.push(new sap.ui.model.Filter({
					path: "DepartureAirport",
					operator: sap.ui.model.FilterOperator.EQ,
					value1: sValue
				}));
			}
			this.getView().getModel().read("/FlightsSet", {
				filters: filters,
				success: jQuery.proxy(this.handleValuesFetched, this),
				error: jQuery.proxy(this.handleError, this)
			});
		},

		handleValuesFetched: function (data) {
			this.getView()
				.getModel("filteredFlights")
				.setData({
					"FlightsSet": data.results
				});
		},

		handleError: function (error) {
			$.sap.error(error);
		},

		testMe: function (a) {
			return a * 2;
		}
	});
});
