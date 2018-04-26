$(document).ready(function() {

        // JQuery code to be added in here.

        // alert('foo')
    $("#test-btn").click( function(event) {
        alert("JQuery Working!");
    });


    $('.package-card').mousedown(function(){
    	var isDragging = false;
    	$(this).mousemove(function(){
    		isDragging = true;    		
    	});
    	$(this).unbind().mouseup(function(){
    		if (!isDragging){
				$(this).toggleClass('package-selected')
				$(this).toggleClass('package-unselected')
    			var colors = ['red', 'green', 'blue'] //'orange', 'yellow']; //, 'green', 'blue', 'violet'];

				var package_num = $(this).attr('id');

// <<<<<<< HEAD
				var pre_count = 0;

				$('.package-table-header').each(function() {
			    	if ($(this).css('display') != 'none') {
			    		pre_count++;
			    	}
			    	// if ($(this).find('td:empty')) { alert('one empty')}
			    });

			    $('.'+package_num+'-table').each(function() {
			    	$(this).toggle();
			    });


				var post_count = 0;
				$('.package-table-header').each(function() {
			    	if ($(this).css('display') != 'none') {
			    		post_count++;
			    	}
			    	// if ($(this).find('td:empty')) { alert('one empty')}
			    });

			    // alert(pre_count + ' ' + post_count);

			    if ((pre_count == colors.length && post_count == colors.length+1)){
    				$(this).toggleClass('package-selected')
					$(this).toggleClass('package-unselected')

					$('.'+package_num+'-table').each(function() {
						$(this).toggle();
					});
			    }

			    if ((pre_count == 0 && post_count == 1) || (pre_count == 1 && post_count == 0) ){
			    	$('.package-table').toggle();
			    }
// =======
				/**
				 *  Expected behavior:
				 *    1. only set a color that has not been set before
				 *    2. If there are no more available colors, cancel the package selection
				 *    3. If deselecting a package, remove all classnames for borders
				 */
				if ($(this).hasClass('package-selected')){
					color_set = false
					for (i in colors) {
						color = colors[i]
						border_class = 'border-'+color
						if 	($('.'+border_class).length == 0) {
							$(this).addClass(border_class);
							$('.'+package_num+'-information-card').addClass(border_class);
							color_set = true
							break
						}
					}
					if (!color_set){
						$('.'+package_num+'-information-card').toggle();
						// $(this).toggleClass('package-selected')
						// $(this).toggleClass('package-unselected')
						$('.'+package_num+'-information-card').toggle();
					}

				} else {
					$('.'+package_num+'-information-card').removeClass(function(idx, className) {
						return (className.match(/(^|\s)border-\S+/g) || []).join(' ');
					})
					$(this).removeClass(function(idx, className) {
						return (className.match(/(^|\s)border-\S+/g) || []).join(' ');
					})
				}
				$('.'+package_num+'-information-card').toggle();
// >>>>>>> b7bba3d14ae98e13015fcbcea0ecedf56197da08

    		}

    	});
    });

	$('.option-checkbox').change(function(){
		// alert('checked');
		// alert(JSON.stringify(this));
		// $.ajax({

		// })
	});


	/*/
	 *  Get the dropdowns for the options to behave the way I want
	 *  That means: Don't close dropdown after click, but close on outside click
	 */
	$('.dropdown-toggle').mousedown(function(){
		$(this).dropdown();
	});
	$(document).mouseup(function(e){
		$('.dropdown-menu').each(function(){
			if ($(this).hasClass('show')){
				$(this).removeClass('show');
			}
		});
	
	});
	$('.dropdown-menu').mouseup(function(e){
		e.stopPropagation();
	});


	$('.package-carousel').slick({
		arrows:true,
		infinite: false,
		slidesToShow: 5,
		variableWidth: true,
		// swipe: false,
		swipeToSlide: true,
		touchThreshold: 10,
		slidesToScroll: 1
  	});	
});