var application = {
    'user_name':'sarath@exotel.in',
    'password':'itsme',
    'acc_threshold':0.1,
    'death_threashold':25000
    
};

document.addEventListener("intel.xdk.device.ready", onDeviceReady, false);


function onDeviceReady() {
     console.log('The device is ready ');
    //lock orientation he is not gonna play wth it and we could improve the battery usage
    intel.xdk.device.setRotateOrientation("portrait");
    intel.xdk.device.setAutoRotate(false);

    //manage power again comes the power saving , green exotel :]
    intel.xdk.device.managePower(true, false);

    //hide splash screen
    intel.xdk.device.hideSplashScreen();

    watchAccel();
}



function roundNumber(num) {
    
    var dec = 2;
    var result = 10000 * Math.round(num * Math.pow(10, dec)) / Math.pow(10, dec);
    return result;
}


function updateMinMax(_min,_max){
    console.log('accelearation data '+_min);
    var minimum = Math.min(parseFloat(application.minimum_acceleration.textContent),_min);
    var maximum = Math.max(parseFloat(application.maximum_acceleration.textContent),_max);
    application.maximum_acceleration.innerHTML = maximum;
    application.minimum_acceleration.innerHTML = minimum;
}


function do_fun_with_physics(a) {
   
    //take the abs tilt values so we don't
    //get stupid results while doing interim
    //calculations
    console.log('doing fun with physics ' + JSON.stringify(a));
    var absx = Math.abs(a.x);
    var absy = Math.abs(a.y);

    
    if (absx < application.acc_threshold) {
        absx = 0;
    }
    if (absy < application.acc_threshold) {
        absy = 0;
    }

    //skip the calculations if there is no movement;
    application.acceleraton_text.innerHTML = JSON.stringify(a);
    if (absx == absy && absx === 0) {
        return 'Yola';
    } else {
        var acc = Math.sqrt(Math.pow(roundNumber(absx),2)+Math.pow(roundNumber(absy),2));
        if(acc > application.death_threashold ){
intel.xdk.notification.alert('You are dead','confirm','Nope!');     
        }
        updateMinMax(acc,acc);
        
    }
    
}

//this is the event handler for successful accelerometer readings
function suc(a) {
    do_fun_with_physics(a);
}



var watchAccel = function() {
    var opt = {
    'frequency':5,
    };
    var timer = intel.xdk.accelerometer.watchAcceleration(suc, opt);
    };


//do initialize evrything from the html stuff
function onBodyLoad() {
    console.log('on body load is called');
    application.metatag = document.getElementById("meta_view");
    application.acceleraton_text = document.getElementById('accdata');
    application.minimum_acceleration = document.getElementById('min_acc');
    application.maximum_acceleration = document.getElementById('max_acc');
}
