$fn=128;
include <BOSL2/std.scad>

mount_d=3; //thickness of mount pieces
mount_l=20; //width of mount pieces

piston_od=53;  //piston diameter (sc32=34, sc40=42, sc50=53, sc63=67)
pipe_space=3; //space between cylinder and support rods (sc32-50=3, sc63=5)
pipe_od=6 + .1; //diameter of support rods on side of piston, plus slop (sc32-50=6, sc63=6)

piston_h=292;
cap_h=20; //the ends of the piston
faceplate_h=3;
ossm_h=33.5;
bolt_l=15;
bolt_d=6; //.1 for slop?
bolt_h=bolt_d*.8;  //how thick a nut would be, 80% of bolt diameter seems to work, officially 7.75 for M4, 5.75 for M3, 8.25 for 6/32
motor_name = "57AIM V1.1"; //or "42AIM V1.1" or "iHSV57"
show_piston=false;  //for reference, disable for printing
show_ossm= false;  //for reference, disable for printing
show_mount=true;  //only this should be true for printing

if (show_mount) {
    if (show_piston || show_ossm) {
        clamp();
        translate([70.5,0,0]) clamp();
    } else { 
        clamp();
    }
}
if (show_ossm) {
    ossm();
}

if (show_piston)  piston(); 


module clamp() {
    
    difference() {
        color("red") 
        translate([0,-(piston_od+pipe_od+mount_d*2)/2, (piston_od+pipe_od+mount_d*2)/2])
            cube([mount_l,piston_od+pipe_od+mount_d*2,piston_od+pipe_od+mount_d*2], center=true);
        
        //cut out back half
        translate([0,-(piston_od+pipe_od+mount_d)/2, (piston_od+pipe_od+mount_d)/2])
            rotate([135,0,0]) 
                    translate([-100,piston_od/4,-100]) 
                        cube([200,200,200]);
        
        
        //screws
        color("green") 
        translate([.25,0,18.25]) 
        rotate([90,0,0]) {
            //shaft
            translate([0,0,-bolt_l+mount_d*2]) cylinder(d=bolt_d,h=bolt_l);
            //head
            translate([0,0,mount_d]) rotate([0,0,180]) cylinder(d=bolt_d*2,h=piston_od/2,$fn=6);
        }

        piston();

    }

}
module ossm() {
    translate([-.5,-3.875,0]) {
        motor_path = str("../STL/pitclamp mini/OSSM - Mounting Ring - PitClamp Mini - ", motor_name, ".stl");
        translate() {
            translate([-27.5,100,32.25]) rotate([0,180,180]) import("/home/llama/Documents/code/OSSM-Job/STL/pitclamp mini/OSSM - Base - PitClamp Mini - Lower V1.1.stl");

            translate([-24,17.125,0]) rotate([0,0,0]) import(motor_path);
        }
        translate([64.75,-7.5,0]) rotate([0,180,0]) {
            if (show_mount || show_piston) {
                color("cyan") translate([0,0,ossm_h]) import("../STL/reference/ossm_cover_blank.stl");
            }
            color("blue") translate([0,-.5,0]) difference() {  //not sure why I need to goose this .5mm but it makes the screw holes line up
                import("../STL/reference/OSSM - Actuator - Body - Bottom.stl");
                
            }
            color("darkblue") translate([0,25,8]) import("../STL/reference/OSSM - Actuator - Body - Middle.stl");

        }
    }
}

module piston() {
    translate([piston_h/2 - mount_l/2,-piston_od/2 - pipe_od/2 - mount_d, piston_od/2 + pipe_od/2 + mount_d])
    rotate([0,90,0]) {
        color("grey") {
            //main piston body
            cylinder(d=piston_od, h=piston_h, center=true);
            //rod
            translate([0,0,-cap_h*2]) cylinder(d=piston_od/4, h=piston_h+cap_h, center=true);
        }
        for (i = [0:3]) {
            
            rotate([0,0,90*i+45])  {
                //channels for support poles on side of piston
                color("yellow") {
                    translate([0,piston_od/2 + pipe_od/2 + pipe_space,0]) {
                        cylinder(d=pipe_od, h=piston_h+1, center=true);
                    }
                }
            }
        }

        color(c=[.1,.1,.1]) {
            //faceplates
            translate([0,0,piston_h/2 + cap_h/2-1]) cube([piston_od + pipe_od + mount_d*2, piston_od + pipe_od + mount_d*2, cap_h], center=true);
            translate([0,0,-piston_h/2 - cap_h/2+1]) cube([piston_od + pipe_od + mount_d*2, piston_od + pipe_od + mount_d*2, cap_h], center=true);
            
        }
    }
}

    