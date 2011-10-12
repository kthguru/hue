// (c) Copyright 2011 Cloudera, Inc. All rights reserved.
//This plugin provides some simple drop-down menu functionality.
//
//It expects:
//	
//	<a class="header">...</a>
//	<ul class="menuOptions hidden">
//		<li>...</li>
//	</ul>
//
//	within a <div> or a <span>.

(function( $ ){
	var methods = {
		init: function(options) {
			if (this.hasClass("SlickMenu") || !(this.is("div") || this.is("span"))) {
				return this;
			}
			var defaults = {
				containerClasses: "SmoothnessMenu",
				expandedContainerClasses: "SmoothnessMenuExpanded",
				ulClasses: "ui-widget ui-widget-content ui-corner-all"
			};

			var opts = $.extend({}, defaults, options);
			this.data('slickMenu', opts);
			
			this.addClass("SlickMenu " + opts.containerClasses)
				.find("ul.menuOptions")
					.addClass("hidden " + opts.ulClasses);

			$("body").click(function(evt) {
				$(".SlickMenu").each(function(index, item) {
					$(item).slickMenu("collapse");
				});
			});
			this.click(methods.handleClick);
			this.find(".arrowIcon").hover(methods.handleSpanHover);
			return this;
		},
		
		destroy: function() {
			this.unbind("click");
			$(this).data.slickMenu.remove();
			this.removeData("slickMenu");
		},
		
		expand: function() {
			var opts = $(this).data('slickMenu');

			var $menuOptions = $(this).find('ul.menuOptions');
			$menuOptions.removeClass('hidden');
			$(this).slickMenu("show");
		},
		
		collapse: function() {
			var opts = $(this).data('slickMenu');
			$(this).removeClass(opts.expandedContainerClasses)
				.find('ul.menuOptions')
					.addClass('hidden');
		},

		show: function() {
			var $menuOptions = $(this).find('ul.menuOptions');
			var pos = $(this).position();
			var left = pos.left;
			var top = pos.top + $(this).outerHeight(true);
			var $parent = $(this).parent();
			while ($parent.css("position") !== "relative") {
				if ($parent.is("body")) {
					break;
				}
				$parent = $parent.parent();
			}
			var parentWidth = $parent.width();
			var menuWidth = $menuOptions.outerWidth(true);
			if (left + menuWidth > parentWidth) {
				// right align the menu with the right edge of this.
				left = left + $(this).outerWidth(true) - menuWidth;
			}
			$menuOptions.css({
				left: left,
				top: top
			});
		},

		toggleState: function() {
			var opts = $(this).data('slickMenu');
			var $menuOptions = $(this).toggleClass(opts.expandedContainerClasses).find('ul.menuOptions');

			$menuOptions.toggleClass('hidden');
			if (!$menuOptions.hasClass("hidden")) {
				$(this).slickMenu("show");
			}
		},
		
		handleClick: function(event) {
			var $target = $(event.target);
			var opts = $(this).data('slickMenu');
			$(".SlickMenu").not($target.closest(".SlickMenu")).each(function(index, item) {
				$(item).slickMenu("collapse");
			});
			if ($target.is(".SlickMenu") ||
				$target.is("ul.menuOptions")) {
				$(this).slickMenu("toggleState");
			} else {
				if (opts.afterSelect) {
					opts.afterSelect(event);
				}
			}
			event.stopPropagation();
			$target = null;
		},
		
		handleSpanHover: function(event) {
			var opts = $(this).closest('.SlickMenu').data('slickMenu');
			if (opts.ignoreHover) {
				return;
			}
			var $target = $(event.target);
			$(".SlickMenu").not($target.closest(".SlickMenu")).each(function(index, item) {
				$(item).slickMenu("collapse");
			});
			$(event.target).closest(".SlickMenu").slickMenu("expand");
			$target = null;
		}
	};
	
//	The usage of this plugin is: jQuery("selector").pluginName("methodName")
	$.fn.slickMenu = function(method) {
		if (methods[method]) {
			return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
		} else if (typeof(method) === 'object' || !method) {
			return methods.init.apply(this, arguments);
		} else {
			$.error("Method " + method + " does not exist on jQuery.slickMenu");
		}
	};
}( jQuery ));
