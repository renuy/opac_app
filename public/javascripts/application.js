// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$('.toggle_history').live('click', function() {
	var history_id = this.id.split("_");
	history_id.shift();
	history_id = '#' + history_id.join("_");

	$(history_id).toggle();

	var isShown = ($(history_id).css("display") == "none" ? false : true);

	this.innerHTML = (isShown ? "Hide History" : "Show History");

	if ( isShown ) {
		$(history_id).data('jsp').reinitialise();
	}
});

$('.toggle_stock').live('click', function() {
	var stock_id = this.id.split("_");
	stock_id.shift();
	stock_id = '#' + stock_id.join("_");

	$(stock_id).toggle();

	var isShown = ($(stock_id).css("display") == "none" ? false : true);

	this.innerHTML = (isShown ? "Hide Stock" : "Show Stock");

	if ( isShown ) {
		$(stock_id).data('jsp').reinitialise();
	}
});

var IBTapp = {};
IBTapp.Charts = {};
IBTapp.ChartData = {};
IBTapp.panels = ['div_req_','div_ass_','div_can_','div_pro_','div_alt_'];

IBTapp.showPanel = function (paneId, panelId) {
	$.each(IBTapp.panels, function(index, value) {
		var id = '#' + value + paneId;
		$(id).hide();
	});

	$('#'+panelId).show(600, function() {
			debugger;
		if (panelId.indexOf('ass') > 0) {

			if (!IBTapp.Charts["stock"+paneId]) {
				IBTapp.Charts["stock"+paneId] = new $jit.BarChart({
				  injectInto: 'chart_ibtr_' + paneId,  
				  animate: true,  
				  orientation: 'vertical',  
				  barsOffset: 1,  
				  Margin: {top:5, left: 5, right: 5,bottom:5},
				  labelOffset: 5,
				  type: 'stacked',  
				  showAggregates:true, 
				  showLabels:true, 
				  Label: {type: 'HTML', size: 10, family: 'Arial', color: 'black'}, 
				  Tips: {enable: true,  
				    onShow: function(tip, elem) {  
				      tip.innerHTML = "<span class='tooltip'><b>  " + elem.name + "</b>: " + elem.value + "  </span>";
				    }  
				  }
				});
			}

			IBTapp.Charts["stock"+paneId].loadJSON(IBTapp.ChartData["infovis"+paneId]);
		}
    
    
	});
	$('#flash_'+paneId).html('');
};

IBTapp.showAltTitle = function (paneId, panelId, titleId, ibtrId) {
  IBTapp.showPanel(paneId, panelId);
  debugger;
  $.get('/titles/qryAltTitle?' + 'queryTitleId=' + titleId+ '&ibtrId=' + ibtrId,
  function(data) {
    $('#'+panelId+' #div_srch').html(data);
  });
}

var IBTStatApp = {};
IBTStatApp.Charts = {};
IBTStatApp.ChartData = {};

IBTStatApp.showChart = function(panelId, bartype, show_aggregate){

  $('#'+panelId).show(600, function() {
			debugger;

  if (!IBTStatApp.Charts["ibtr"+panelId]) {
    IBTStatApp.Charts["ibtr"+panelId] = new $jit.BarChart({
      injectInto: panelId+'_chart_stat',  
      animate: true,  
      orientation: 'vertical',  
      barsOffset: 1,  
      Margin: {top:5, left: 5, right: 5,bottom:5},
      labelOffset: 5,
      type: bartype,  
      showAggregates:show_aggregate, 
      showLabels:true, 
      Label: {type: 'HTML', size: 10, family: 'Arial', color: 'black'}, 
      Tips: {enable: true,  
        onShow: function(tip, elem) {  
          tip.innerHTML = "<span class='tooltip'><b>  " + elem.name + "</b>: " + elem.value + "  </span>";
        }  
      }
    });
  }
  
  IBTStatApp.Charts["ibtr"+panelId].loadJSON(IBTStatApp.ChartData["infovis"+panelId]);
	});	
}

var IBThist ={}
IBThist.hide = function (paneId, panelId) {
		var id = '#' + paneId;
		$(id).hide(600);

}
IBThist.show = function (paneId, panelId) {
		var id = '#' +  paneId;
		$(id).show(600);
}
IBThist.showhide = function (showId, hideId) {

		var hideid = '#' +  hideId;
		$(hideid).hide(600);
    var showid = '#' +  showId;
		$(showid).show(600);
}
IBTapp.initSearchForm = function (option, onload) {
	if (option == 'respondent_id' || option == 'branch_id') {
		$('.ibtrSearch #branchVal').show();
		$('.ibtrSearch #searchText').hide();
	} else {
		$('.ibtrSearch #branchVal').hide();
		$('.ibtrSearch #searchText').show();
	}
};

$('.ibtrSearch #searchBy').live('change', function() {IBTapp.initSearchForm($('.ibtrSearch #searchBy').val(), false);});

IBTStatApp.initStatForm = function (option, onload) {
	if (option == 'On' || option == 'Range') {
		$('.ibtrStat #div_start_date').show();
     
    if (option == 'Range'){
      $('.ibtrStat #div_end_date').show();
		}
    else
    {
      $('.ibtrStat #div_end_date').hide();
    }
	} else {
		$('.ibtrStat #div_start_date').hide();
		$('.ibtrStat #div_end_date').hide();
	}
};

$('.ibtrStat #Created').live('change', function() {IBTStatApp.initStatForm($('.ibtrStat #Created').val(), false);});

$('#authors th a, #authors .pagination a, #authors td a').live('click', function() {
	$.getScript(this.href);
	return false;
});

$('#new_signup input[name="signup[payment_mode]"]:radio').live('change', function() {
	$('#new_signup #signup_check_div').hide();
	$('#new_signup #signup_card_div').hide();
	$('#new_signup #signup_card_no').val('');
	$('#new_signup #signup_check_no').val('');
	$('#new_signup input[name="signup[payment_mode]"]:radio:checked ~ span').show();
});

$('#new_signup #signup_coupon_id').live('change', function() {
	$.get('/signups/compute?' + 'signup_months=' + $('#signup_signup_months').val() + '&plan_id=' + $('#signup_plan_id').val() + '&coupon_id=' + $(this).val(),
		function(data) {
			$('#new_signup #payment_div').html(data);
		});

	if ( $(this).val() != '' )
		$('#new_signup #signup_coupon_no_div').show();
	else {
		$('#new_signup #signup_coupon_no_div').hide();
	};
});

var ConsignmentApp = {};
ConsignmentApp.addGood = function(goodstable) {
	alert('not implemented');
}

ConsignmentApp.removeGood = function(link) {
	$(link).prev("input[type='hidden']").val(true);
	$(link).parents("tr").hide();
};

ConsignmentApp.receiveGood = function(link) {
	$(link).prev("input[type='hidden']").val('deliver');
	$(link).parents("tr").hide();
};


//sjb
var barChart, tempBarId, signups_report_branch;

function modifyMode(mode){
    var pageSection = "<br/><p style='font-size:16px; font-weight: bolder;'>Member Details</p>";
    $.get('/report_details?' + 'branch_id=' + signups_report_branch +
        '&modifyMode=' + mode,
        function(data) {
            var isHeader = true;
            $.each(data, function() {
                $.each(this, function(k, v) {
                    pageSection += "<div class='span-40'>";
                    if(isHeader){
                            pageSection += "<div class='span-8'>";
                            $.each(v, function(key, value){
                                if(key.toString() == "membership_no")
                                    pageSection += "<p style='font-size:14px; font-weight: bolder; color:green;'>" +
                                    value + "</p>";
                            });
                            pageSection += "</div>";
                            isHeader = false;
                    }
                    var keyCount = 0;
                    $.each(v, function(key, value){
                        pageSection += "<div class='span-4'><b>" + key.toString().toUpperCase() +"</b></div>" +
                            "<div class='span-4'>" + value +"</div>";
                        keyCount += 1;
                    });

                    pageSection += "</div><hr/>"
                    isHeader = true;
                });
            });
            
            $('#signups_report_details').html(pageSection);
            
        }, "json");
}

function modifyTotal(){
    modifyMode('T');
}

function modifyProc(){
    modifyMode('P');
}

function modifyUProc(){
    modifyMode('U');
}

function modifyError(){
    modifyMode('E');
}

function generate_signups_report(branch_id, refresh_mode){
    var jsonObj = null;        
    signups_report_branch = branch_id;
    
    //flush report_details
    $('#signups_report_details').html("");

    //get data
    $.get('/report?' + 'branch_id=' + branch_id,
        function(data) {
        jsonObj = data;

        $('#id-list').show();

        if(!refresh_mode){
            //init BarChart
            barChart = new $jit.BarChart({
              injectInto: 'infovis',
              animate: true,
              orientation: 'vertical',
              barsOffset: 20,
              Margin: {top:5, left: 5, right: 5, bottom:5},
              labelOffset: 5,
              type: 'stacked',
              showAggregates:true,
              showLabels:true,
              Label: {type: 'HTML', size: 10, family: 'Arial', color: 'black'},
              Tips: {
                enable: true,
                onShow: function(tip, elem) {
                  tip.innerHTML = "<b> " + elem.name + "</b>: " + elem.value;
                }
              }
            });
        }        
        
        //load JSON data.
        if(refresh_mode){
            barChart.updateJSON(jsonObj);
        }else{
            barChart.loadJSON(jsonObj);
        }
        //end

        var list = $jit.id('id-list');

        //dynamically add legend to list
        var legend = barChart.getLegend(),
            listItems = [];
        for(var name in legend) {
          listItems.push('<div class=\'query-color\' style=\'background-color:'
              + legend[name] +'\'>&nbsp;</div>' + name);
        }
        list.innerHTML = '<li>' + listItems.join('</li><li>') + '</li>';

        //event listener ids        
        $('#infovis-label').children().each(function(){
            var infoid = $(this);
            if(infoid.attr('id').indexOf("Total") != -1){                
                tempBarId = document.getElementById(infoid.attr('id'));
                tempBarId.addEventListener('click', modifyTotal, false);
            }else if(infoid.attr('id').indexOf("Un-Processed") != -1){
                tempBarId = document.getElementById(infoid.attr('id'));
                tempBarId.addEventListener('click', modifyUProc, false);
            }else if(infoid.attr('id').indexOf("Processed") != -1){
                tempBarId = document.getElementById(infoid.attr('id'));
                tempBarId.addEventListener('click', modifyProc, false);
            }else if(infoid.attr('id').indexOf("Error") != -1){
                tempBarId = document.getElementById(infoid.attr('id'));
                tempBarId.addEventListener('click', modifyError, false);
            }
        });
    }, "json");   
    
}

$('#signups_report').live('submit', function(){       
    generate_signups_report($('#report_branch_id').val(), false);

    return false;  
});

$('#refresh_signups_report').live('click', function(){
    generate_signups_report($('#report_branch_id').val(), true);

    return false;
});
//sjb