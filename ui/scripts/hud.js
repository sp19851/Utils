const Hud = {
    data() {
        return {
            hudShow:true,
            carHud:true,
            serverId:0,
            cash:-1
        }
    },

    methods: {
        UpdateVehicleInfo(data) {
            let speed = data.vehicleSpeed;
            let health = data.vehicleHealth;
            let oil = data.oil;
            let rpm = data.rpm;
            let fuel = data.fuel;
            let gear = data.gear;
            let mileage = data.mileage;
            
            $(".speed").text(String(speed).padStart(3, "0"));
            $(".mileage").text(String(mileage).padStart(10, "0")+" km");
            $(".gear-unit").text(gear);
            $(".rpm-bar").css("width", rpm + "%");
            if (rpm <= 60) {
                $(".rpm-bar").css("background-color", "green");
            } else if (rpm > 60 && rpm <= 80) {
                $(".rpm-bar").css("background-color", "orange");
            } else {
                $(".rpm-bar").css("background-color", "red");
            }
            $(".fuel-bar-progress").css("height", Math.ceil(100-fuel*100/65) + "%");   //  65 - 100%; fuel - x%

            if (fuel <= 40 && fuel >= 20) {
                $(".fuel").attr("src", "assets/img/hud/fuel40.png");
                $(".fuel-bar").css("background-color", "#FFA229");
            } else if (fuel <= 20) {
                $(".fuel").attr("src", "assets/img/hud/fuel20.png");
                $(".fuel-bar").css("background-color", "#FF2929");
            } else {
                $(".fuel").attr("src", "assets/img/hud/fuel.png");
                $(".fuel-bar").css("background-color", "#FFFFFF");
            }

            if (health <= 700 && health >= 500) {
                $(".engine").attr("src", "assets/img/hud/engine700.png");
                $(".engine").css("opacity", "0.8");
            } else if (health < 500) {
                $(".engine").attr("src", "assets/img/hud/engine500.png");
                $(".engine").css("opacity", "0.8");
            } else {
                $(".engine").attr("src", "assets/img/hud/engine.png");
                $(".engine").css("opacity", "0.3");
            }
            if (oil <= 700) {
                $(".oil").attr("src", "assets/img/hud/oilred.png");
                $(".oil").css("opacity", "0.8");
            } else {
                $(".oil").attr("src", "assets/img/hud/oil.png");
                $(".oil").css("opacity", "0.3");
            }
        },
        UpdateOtherData(data) {
            //console.log("UpdateOtherData inCar", data.inCar, "street", data.street)

            if (data.inCar) {
                $(".location .location-text").text(data.street);
                $(".location .location-text2").text(data.street2);
                $(".location").fadeIn()
                
            } else {
                $(".location ").fadeOut()
                
            }

            if (data.inCar) {
                if (this.carHud) {
                    $(".carhud").css("display", "flex");
                    $(".carhud").css("right", "35px");
                }

                $(".map-outline").fadeIn();
                //$(".stamina-wrapper").fadeOut();
                $(".stamina-wrapper").hide();
                if (!true) {
                    $(".status-wrapper").css("left", "15vw");
                    $(".location").css({
                        bottom: "19vh",
                        left: "0",
                    });
                }
            } else {
                $(".carhud").fadeOut();
                $(".carhud").css("right", "-335px");
                $(".rpm-bar").css("width", "0%");
                $(".map-outline").fadeOut();
                //$(".stamina-wrapper").fadeIn();
                if (!true) {
                    $(".status-wrapper").css("left", "0px");
                    $(".location").css({
                        bottom: "1vh",
                        left: "50px",
                    });
                }
            }
        },
        StatusUpdate(data){
            let health = data.health-100;
            let armor = data.armor;
            let stamina = data.stamina;
            let oxygen = data.oxygen;
            let inWater = data.inwater;
            let thirst = data.thirst
            let hunger = data.hunger

            let stress = 65
            let alcohol = 99
            let drug = 43
            let smoking = 87
            $(".thirst").css(
                "background-image",
                `conic-gradient(#fff ` + thirst + `%, transparent ` + (thirst - 100) + `%, transparent)`
            );
            $(".hunger").css(
                "background-image",
                `conic-gradient(#fff ` + hunger + `%, transparent ` + (hunger - 100) + `%, transparent)`
            );
            if (thirst == 100) {
                $(".thirst-wrapper").fadeOut();
            } else {
                $(".thirst-wrapper").fadeIn();
            }
            if (hunger == 100) {
                $(".hunger-wrapper").fadeOut();
            } else {
                $(".hunger-wrapper").fadeIn();
            }
          
            $(".stats .bottom").hide()
            $(".location .location-text").text(data.street);
            $(".location .location-text2").text(data.street2);
            if (armor == 0) {
                $(".armour-wrapper").fadeOut();
            } else if (armor > 0) {
                $(".armour-wrapper").fadeIn();
            }
            if (inWater) {
                $(".oxygen-wrapper").fadeIn();
            } else{
                $(".oxygen-wrapper").fadeOut();
            }
            $(".health").css(
                "background-image",
                `conic-gradient(#fff ` + health + `%, transparent ` + (health - 100) + `%, transparent)`
            );
            //console.log("health", health)
            if (health >= 100) {$(".health-wrapper").fadeOut()} else { $(".health-wrapper").fadeIn();}
            $(".armour").css(
                "background-image",
                `conic-gradient(#fff ` + armor + `%, transparent ` + (armor - 100) + `%, transparent)`
            );
            if (stamina == 100) {
                $(".stamina-wrapper").fadeOut();
            } else {
                $(".stamina-wrapper").fadeIn();
            }
            $(".stamina").css(
                "background-image",
                `conic-gradient(#fff ` + stamina + `%, transparent ` + (stamina - 100) + `%, transparent)`
            );
            $(".oxygen").css(
                "background-image",
                `conic-gradient(#fff ` + oxygen + `%, transparent ` + (oxygen - 100) + `%, transparent)`
            );

            //
            if (stress == 100) {
                $(".stress-wrapper").fadeOut();
            } else {
                $(".stress-wrapper").fadeIn();
            }
            $(".stress").css(
                "background-image",
                `conic-gradient(#fff ` + stress + `%, transparent ` + (stress - 100) + `%, transparent)`
            );
            if (alcohol == 100) {
                $(".alcohol-wrapper").fadeOut();
            } else {
                $(".alcohol-wrapper").fadeIn();
            }
            $(".alcohol").css(
                "background-image",
                `conic-gradient(#fff ` + alcohol + `%, transparent ` + (alcohol - 100) + `%, transparent)`
            );
            if (drug == 100) {
                $(".drug-wrapper").fadeOut();
            } else {
                $(".drug-wrapper").fadeIn();
            }
            $(".drug").css(
                "background-image",
                `conic-gradient(#fff ` + drug + `%, transparent ` + (drug - 100) + `%, transparent)`
            );
            if (smoking == 100) {
                $(".smoking-wrapper").fadeOut();
            } else {
                $(".smoking-wrapper").fadeIn();
            }
            $(".smoking").css(
                "background-image",
                `conic-gradient(#fff ` + smoking + `%, transparent ` + (smoking - 100) + `%, transparent)`
            );
        },
        onShow(bool){
            //console.log("onShow", bool)
            this.hudShow = bool;
        },


    },
    mounted() {
        this.listener = window.addEventListener("message", (event) => {

            if (event.data.request === "hud.show") {
                //console.log("event hud.show", JSON.stringify(event.data))
                this.onShow(event.data.visible);
            } else if (event.data.action == "VehicleInfo") {
                //console.log("event VehicleInfo", JSON.stringify(event.data))
                this.carHud = event.data.inCar
                this.UpdateVehicleInfo(event.data)
            } else if (event.data.request == "hud.other") {
                //console.log("event hud.other", JSON.stringify(event.data))
                this.UpdateOtherData(event.data)
                this.carHud = event.data.inCar
              
                //this.onShow(event.data.canHudShow)
            } else if (event.data.request == "carhud.hide"){
                this.carHud = false
                $(".location").fadeOut()
                
            } else if (event.data.request == "hud.setclock"){
                //console.log("clock", JSON.stringify(event.data));
                let clock = String(event.data.hours).padStart(2, "0") +":"+ String(event.data.minutes).padStart(2, "0")+":"+ String(event.data.seconds).padStart(2, "0")
                let date = String(event.data.day).padStart(2, "0") + "."+ String(event.data.month).padStart(2, "0") + "."+ event.data.year
                $(".date span").text(date);
                $(".clock span").text(String(clock).padStart(3, "0"));
                //this.onShow(event.data.canHudShow)
                //console.log("clock " , clock, "date ", date);
            } else if (event.data.request == "hud.setweather"){
                $(".weather span").text("Текущая погода: "+event.data.weather);
                //this.onShow(event.data.canHudShow)
            } else if (event.data.request == "hud.statusupdate") {
                //console.log("event", JSON.stringify(event.data))
                this.StatusUpdate(event.data)
                //this.onShow(event.data.canHudShow)
                
                
            } else if (event.data.request == "hud.setserverid") {
                this.serverId = event.data.value
            } else if (event.data.request == "hud.setcash") {
                //console.log("event", JSON.stringify(event.data))
                this.cash = event.data.value
            } else if (event.data.request === "loginscreen.hide") {
                this.onClose();
            }
        });
        this.listenerKey = window.addEventListener("keydown", (event) => {



        });
    }
};




let hud = Vue.createApp(Hud);
hud.mount("#hud");