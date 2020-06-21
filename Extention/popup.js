
var val;

	document.addEventListener('DOMContentLoaded', function()
	{
    var link = document.getElementById('button');
    // onClick's logic below:
    link.addEventListener('click', function() {
        getURL();
    });
});

function getURL() 
{
	//category=document.getElementById('select');
	//var ex = document.getElementById('select')[0];
    //var str= ex.options[ex.selectedIndex].value;
	
	//var par=document.getElementById('select')[0];
   var e = document.getElementById("select");
   var strUser = e.options[e.selectedIndex].value;
 
	val=window.location.href;
	fetch(`http://takemeto.us-east-1.elasticbeanstalk.com//submit?url=${val}&category=${strUser}`, {method:'POST'});
	alert("success");
}
