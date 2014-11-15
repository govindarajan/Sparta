
var application = {
    'user_name':'sarath@exotel.in',
    'password':'itsme',
};

function roundNumber(num) {
    var dec = 2;
    var result = 100 * Math.round(num * Math.pow(10, dec)) / Math.pow(10, dec);
    return result;
}

var metatag = null;
var masthead = null;
var tabletop = null;

//normally, global variables are discouraged. Here we use them for two reasons,
 //1) the accelerometer readings are coming potentially 100s of times per second
 // - allocating 15 variables 100s of times per second will be an unnecessary resource drain on slower device like gen1 iTouches
 //2) webkit transforms just make an animation happen - THEY DON'T change the actual CSS position of 
 //of an element that was animated. To keep track of the position a global variable is helpful (current_left, current_top)
 //although we could accomplish this differently with a little more work.
 //
 //NOTE - we said right above that webkit animations don't reposition the an element as reported by CSS. 
 //SO, why don't we then correct CSS's position? Because the can doesn't visually have time to repaint at it's pre-animation position
 //given that we are doing an new webkit animation every 100th of a second based on
 //accelerometer readings - so no need to 
 //invoke the extra overhead of telling the DOM that the element is being repositioned constantly by resetting the CSS
 //pixelLeft and pixelTop of the sodacan.
var label = null;
var container = null;
var current_left = 0;
var current_top = 0;
var absx = 0;
var absy = 0;
var dx = 0;
var dy = 0;

var x_ispos = 1;
var y_ispos = 1;

//the following funciton handles the "physics" of how the can moves
 //calculating roation of the can and the direction of movement etc.
 //can be ignored if you only care about how to grab accelerometer readings
 //and do animations.
 //        //the can wants to slide in the direction of the slope of the table.
 //        //and wants to rotate such that the can is perpendicular to that direction (has reciprocal slope)
 //        //the label of the can want to rotate in the direction opposite to gravity. 


function do_fun_with_physics(a) {
    x_ispos = 1;
    y_ispos = 1;

    //take the abs tilt values so we don't
    //get stupid results while doing interim
    //calculations
    absx = Math.abs(a.x);
    absy = Math.abs(a.y);


    if (absx < 0.1) {
        absx = 0;
    }
    if (absy < 0.1) {
        absy = 0;
    }

    //skip the calculations if there is no movement;
    if (absx == absy && absx === 0) {
        return;
    }
    
}

//this is the event handler for successful accelerometer readings
function suc(a) {
    $('#accdata').html = JSON.stringify(a);
}


var fail = function() {};

var watchAccel = function() {


        var opt = {};
        opt.frequency = 5;
        //opt.frequency = 1000;
        var timer = intel.xdk.accelerometer.watchAcceleration(suc, opt);

    };

function onDeviceReady() {
    //use viewport
    var landscapewidth = 1360;
    intel.xdk.display.useViewport(portrait_width, landscapewidth);

    //lock orientation
    intel.xdk.device.setRotateOrientation("portrait");
    intel.xdk.device.setAutoRotate(false);

    //manage power
    intel.xdk.device.managePower(true, false);

    //hide splash screen
    intel.xdk.device.hideSplashScreen();

    watchAccel();
}

document.addEventListener("intel.xdk.device.ready", onDeviceReady, false);

function onBodyLoad() {
    metatag = document.getElementById("meta_view");
    label = document.getElementById("img_sodalabel");
    container = document.getElementById("div_sodacan");
    masthead = document.getElementById("img_masthead");
}


//*** Prevent Default Scroll ******
var preventDefaultScroll = function(event) {
    // Prevent scrolling on this element
    event.preventDefault();
    window.scroll(0, 0);
    return false;
};

window.document.addEventListener('touchmove', preventDefaultScroll, false);
