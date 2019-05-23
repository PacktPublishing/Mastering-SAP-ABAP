sap.ui.define(["sap/ui/test/Opa5"],
	function (Opa5) {
		"use strict";

		function getFrameUrl(sHash, sUrlParameters) {
			var hash, urlParams = sUrlParameters;
			hash = sHash || "";
			var sUrl = jQuery.sap.getResourcePath("my/namespace/test/mockServer", ".html");
			if (urlParams) {
				urlParams = "?" + urlParams;
			}
			return sUrl + urlParams + "#" + hash;
		}

		return Opa5.extend("my/namespace/test/integration/pages/BasicArrangements", {
			constructor: function (oConfig) {
				Opa5.apply(this, arguments);
				this._oConfig = oConfig;
			},

			iStartMyApp: function (oOptions) {
				var sUrlParameters;
				var options;
				options = oOptions || {
					hash: "search",
					delay: 0
				};
				sUrlParameters = "serverDelay=" + options.delay;
				this.iStartMyAppInAFrame(getFrameUrl(options.hash, sUrlParameters));
			},

			iLookAtTheScreen: function () {
				return this;
			}
		});
	});
