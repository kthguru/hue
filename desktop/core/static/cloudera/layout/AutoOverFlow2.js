// (c) Copyright 2011 Cloudera, Inc. All rights reserved.
/**
 * jQuery's implementation of cloudera.layout.AutoOverFlow, which
 * dynamically sets the height of a div so scrolling, if any, appears
 * inside the div.
 */
(function($, undefined){
$.fn.AutoOverFlow2 = function(options) {
	var opts = $.extend({}, $.fn.AutoOverFlow2.defaults, options);

	var throttle = function(fn, delay) {
		var timer = null;
		return function () {
			var context = this, args = arguments;
			clearTimeout(timer);
			timer = setTimeout(function () {
					fn.apply(context, args);
				}, delay);
		};
	};

	return this.each(function(){
		var $this = $(this);

		var resize = function() {
			var viewPortHeight = $(window).height();
			// outerHeight(true) includes margin.
			var height = viewPortHeight;
			height -= $this.outerHeight(true) - $this.innerHeight();

			// Apparently if the element is not visible,
			// $.position() does not return a correct value.
			if ($this.is(":visible")) {
				var top = $this.position().top;
				if (top > 0) {
					height -= top;
				}
			}
			var $parents = $this.parents();
			$parents.each(function(i, parent) {
				var $parent = $(parent);
				var bottomMargin = parseInt($parent.css("margin-bottom"), 10);
				var bottomPadding = parseInt($parent.css("padding-bottom"), 10);
				var bottomBorderWidth = parseInt($parent.css("border-bottom-width"), 10);
				height -= bottomMargin;
				height -= bottomPadding;
				height -= bottomBorderWidth;
			});
			if (opts.footer) {
				var $footer = $("#" + opts.footer);
				height -= $footer.outerHeight(true);
			}
			$this.height(height + "px");
		};

		// Run it once initially.
		resize();
		// content update won't keep up with real time browser resize.
		// throttle the resize callback to make the UI more responsive.
		var throttledResize = throttle(resize, 200);
		$(window).resize(throttledResize);
	});
};

$.fn.AutoOverFlow2.defaults = {};
}(jQuery));
