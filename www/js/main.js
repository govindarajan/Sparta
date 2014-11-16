/**
 *REGISTRATION PART AND THE STUFFS RELATED TO THAT
 */
application = {
    'token': 'null',
    'location': '0,0',
    'acc_threshold': 0.1,
    'death_threashold': 25000,
    'bodyLoaded':false,
    'deviceLoaded':false,
    'login_url': ' http://54.254.107.59:45632/register'
};

document.addEventListener("deviceready", onDeviceReady, false);
document.addEventListener('intel.xdk.notification.confirm', receiveConfirm, false);

function onDeviceReady() {
    console.log('The device is ready ');
    if (window.Cordova && navigator.splashscreen) { // Cordova API detected
        navigator.splashscreen.hide(); // hide splash screen
    }
    //lock orientation he is not gonna play wth it and we could improve the battery usage
    intel.xdk.device.setRotateOrientation("portrait");
    intel.xdk.device.setAutoRotate(false);

    //manage power again comes the power saving , green exotel :]
    intel.xdk.device.managePower(true, false);
    navigator.geolocation.getCurrentPosition(onGeoSuccess, onGeoError);
    application.deviceLoaded = true;
    if (application.bodyLoaded) {
        checkLogin();
        watchAccel();
        shake.startWatch('shaked');
    }

}

function shaked() {
    console.log('Shaked ');
    intel.xdk.notification.confirm("Are you hungry ?", 'shake_Confirmation', 'Hungry Bird !', "Yes", "No");

}




//Process the event for the confirmed message
function receiveConfirm(e) {
    if (e.id == 'acc_confirmation') {
        if (e.success == true && e.answer == true) {
            sendAccidentData();
        } else if (e.success == true && e.answer == true) {
            cancelAccidentSending();
        }
    }
    if (e.id == 'shake_Confirmation') {
        if (e.success == true && e.answer == true) {

        }
    }
}

function cancelAccidentSending() {
    application.send_accident = false;
}

function sendAccidentData() {
    application.send_accident = true;
    var data = gatherData();

    //before real post check for send_accident value
}

function gatherData() {
    var coordinates = application.location;
    var token = application.token;
    return true;
}


function roundNumber(num) {
    var dec = 2;
    var result = 10000 * Math.round(num * Math.pow(10, dec)) / Math.pow(10, dec);
    return result;
}

function updateMinMax(_min, _max) {
    var minimum = Math.min(parseFloat(application.minimum_acceleration.textContent), _min);
    var maximum = Math.max(parseFloat(application.maximum_acceleration.textContent), _max);
    if (!isNaN(maximum) && !isNaN(minimum)) {
        application.maximum_acceleration.innerHTML = maximum;
        application.minimum_acceleration.innerHTML = minimum;
    }
}


function do_fun_with_physics(a) {

    //take the abs tilt values so we don't
    //get stupid results while doing interim
    //calculations
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
        var acc = Math.sqrt(Math.pow(roundNumber(absx), 2) + Math.pow(roundNumber(absy), 2));
        if (acc > application.death_threashold) {
            intel.xdk.notification.confirm("Are you dead ?", 'acc_confirmation', "Accident Confirmation", "Yes", "No");

        }
        if (!isNaN(acc)) {
            updateMinMax(acc, acc);
        }
    }

}

//this is the event handler for successful accelerometer readings
function suc(a) {
    do_fun_with_physics(a);
}


var watchAccel = function() {
    var opt = {
        'frequency': 5,
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
    application.pages = {};
    application.pages.registration_page = document.getElementById('registrationPage');
    application.pages.registration_form = document.getElementById('registration_form');
    application.pages.main_pages_container = document.getElementById('main_pages_container');
    application.bodyLoaded = true;
    if(application.device_loaded){
        checkLogin();
        watchAccel();
        shake.startWatch('shaked');
    }
}


function checkLogin() {
    
    application.token = window.localStorage.getItem('token');
    if (!application.token ||application.token === null || application.token == 'null') {
        update_ui('not_registered');
    } else {
        console.log('THE TOKEN IS ' + application.token);
        update_ui('registered');
        watchAccel();
    }
}


function update_ui(status) {
    console.log('Th eregistration status : ' + status);
    if (status == 'registered') {
        application.pages.main_pages_container.style.display = 'block';
        application.pages.registration_page.style.display = 'none';
    } else {
        application.pages.main_pages_container.style.display = 'none';
        application.pages.registration_page.style.display = 'block';
    }

}

function handleLogin() {
    var uname = document.getElementById("name").value;
    var number = document.getElementById("number").value;
    var location = intel.xdk.geolocation.getCurrentPosition();
    var postData = {
        "name": uname,
        "phone_number": number,
        "location": application.location

    };

    console.log('The data to be posted ' + JSON.stringify(postData));
    if (uname != '' && number != '') {
        console.log('doing the ajax with ' + JSON.stringify(postData));
        $.ajax({
            url: application.login_url,
            type: "POST",
            data: JSON.stringify(postData),
            dataType: 'json',
            cache: false,
            contentType: "application/json",
            success: function(response) {
                console.log(JSON.stringify(response));
                window.localStorage.setItem('token', response['token']);
                application.token = response['token']
                update_ui('registered');
            },
            error: function() {
                console.log('ERROR ');
            }
        });

    } else {
        navigator.notification.alert("fill the fields dude", function() {});
    }
    return false;
}




/**
 *THE GEOLOCATION STUFFS ARE HERE
 *
 */


var onGeoSuccess = function(position) {
    console.log('Latitude: ' + position.coords.latitude + '\n' +
        'Longitude: ' + position.coords.longitude + '\n' +
        'Altitude: ' + position.coords.altitude + '\n' +
        'Accuracy: ' + position.coords.accuracy + '\n' +
        'Altitude Accuracy: ' + position.coords.altitudeAccuracy + '\n' +
        'Heading: ' + position.coords.heading + '\n' +
        'Speed: ' + position.coords.speed + '\n' +
        'Timestamp: ' + position.timestamp + '\n');
    application.location = position.coords.latitude + ',' + position.coords.longitude;
};

// onError Callback receives a PositionError object
//
function onGeoError(error) {
    alert('code: ' + error.code + '\n' +
        'message: ' + error.message + '\n');
}

navigator.geolocation.getCurrentPosition(onGeoSuccess, onGeoError);