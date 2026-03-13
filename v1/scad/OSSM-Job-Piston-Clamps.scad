$fn=48;
include <BOSL2/std.scad>

piston_od=54;  //
piston_h=292;
pipe_od=5;
pipe_space=5;
hex_nut_d=8.25;  //7.75 for M4, 5.75 for M3, 8.25 for 6/32
hex_nut_h=3;
shelf_h=10;
faceplate_h=3;
mount_d=3;
mount_l=20;
mount_h=piston_od + mount_d*2 + faceplate_h;
ossm_h=33.5;
ossm_bolt_d=4 + .25; //.25 for slop
ossm_bolt_offset=6;  //thought this would be 5, may be due to slop
ossm_pitclamp_offset=6; //to get out of the way of the pitclamp arm
first_ossm_screw=23.8;
side_to_print=0; //1 for top, 2 for bottom, anything else for both. 
show_piston=false;  //for reference, disable for printing
show_ossm= false;  //for reference, disable for printing
show_mount=true;  //only this should be true for printing

echo(str("Mount height: ", mount_h));
if (show_mount) {
    if (show_piston || show_ossm) {
        clamp();
        translate([50,0,0]) clamp();
    } else {
        if (side_to_print == 1 || side_to_print == 2) {
            clamp(print_side=side_to_print);
        } else {
            translate([0,0,-ossm_h/2 - ossm_pitclamp_offset + 5 ]) clamp(print_side=1);
            translate([0,0,-ossm_h/2 - ossm_pitclamp_offset - 5]) clamp(print_side=2);
        }
    }
}

module clamp(print_side=0) {
    difference() {
        translate([first_ossm_screw-mount_l/2,-mount_h-shelf_h,ossm_h/2 - mount_h/2 + faceplate_h/2]) difference() {
            //main mounting block
            translate([0,0,ossm_pitclamp_offset]) cube([mount_l,mount_h+shelf_h*2,mount_h]);
            
            //fillets
            for (x = [0:1]) {
                    for (y = [-1:2:1]) {
                        translate([mount_l/2,(mount_h+shelf_h*2)*x,mount_h/2 + y* (ossm_h + ((y+1)/2)*ossm_pitclamp_offset) - ossm_pitclamp_offset/2]) {
                            translate([0,0,(y < 0 ? 1 : -.5)*(x-1)*-ossm_h/2]) 
                                cuboid([mount_l+1,shelf_h*2,ossm_h/2+ossm_pitclamp_offset],rounding=shelf_h/2, edges="X");
                        }
                }
            }
        }

        //piston cutout
        translate([0,-mount_h/2,ossm_h/2 + faceplate_h/2 + ossm_pitclamp_offset]) piston();

        //ossm shelf cutout
        translate([first_ossm_screw,shelf_h,ossm_h/2])
            cuboid([mount_l+1,shelf_h*2,ossm_h],rounding=1);
        
            //mounting screwholes
        for (x = [0:1]) {
            translate([first_ossm_screw,-x*(mount_h+shelf_h) + shelf_h/2 +(x*-2),ossm_h/2-mount_h/2 + ossm_pitclamp_offset]) { //magic +-1 to get to ossm_bolt_offset   
                cylinder(h=mount_h,d=ossm_bolt_d);
                

                //nuts n bolts
                translate([0,0,shelf_h*x + (1-x)*1 + (x)*8]) //fudging the 1 and 8
                    cylinder(h=hex_nut_h,d=hex_nut_d,$fn=6);

                translate([0,0,mount_h-shelf_h-hex_nut_h])
                    cylinder(h=hex_nut_h,d=hex_nut_d,$fn=6);
                }
        }
        //all the way through
        translate([first_ossm_screw, -2.5, mount_h/2 - shelf_h]) { //fudging 2.25
            cylinder(h=mount_h + shelf_h,d=ossm_bolt_d, center=true);  
            translate([0,0,(mount_h/2-hex_nut_h) * (print_side == 2 ? -1 : 1) + (print_side == 2 ? -.5 : 3)]) { // fudging -.5 : 3
                cylinder(h=hex_nut_h,d=hex_nut_d,$fn=6);
            }
        }


        //erase top or bottom half for printing
        if (print_side == 1) {
            translate([first_ossm_screw-mount_l/2-1,-mount_h-shelf_h,ossm_h/2-mount_h/2])
        cube([mount_l+2,mount_h+shelf_h*2,mount_h/2 + ossm_pitclamp_offset]);
        }
        if (print_side == 2) {
            translate([first_ossm_screw-mount_l/2-1,-mount_h-shelf_h,ossm_h/2 + ossm_pitclamp_offset])
        cube([mount_l+2,mount_h+shelf_h*2,mount_h/2+faceplate_h/2]);
        }

        //ossm();
        
        //a simplified cutout for the OSSM
        translate([first_ossm_screw,shelf_h,ossm_h/2+faceplate_h]) cuboid([mount_l*2,shelf_h*2,ossm_h+faceplate_h],rounding=2);

    }

}
module ossm() {
    if (show_mount || show_piston) {
        color("cyan") translate([0,0,ossm_h]) import("../STL/ossm_cover_blank.stl");
    }
    color("blue") translate([0,-.5,0]) difference() {  //not sure why I need to goose this .5mm but it makes the screw holes line up
        import("../STL/OSSM - Actuator - Body - Bottom.stl");
        
        //through holes
        color("red") {
            translate([first_ossm_screw,ossm_bolt_offset,-3]) { //-3 i dunno
                cylinder(h=ossm_h+6,d=ossm_bolt_d);
                translate([0,0,hex_nut_h*2]) {
                    cylinder(h=hex_nut_h,d=hex_nut_d,$fn=6);
                    translate([0,-shelf_h/2,hex_nut_h/2]) rotate([0,0,180]) cube([hex_nut_d,shelf_h,hex_nut_h], center=true);
                    color("transparent") translate([0,-hex_nut_d/2,hex_nut_h/2]) cube([hex_nut_d,ossm_bolt_offset,hex_nut_h], center=true);
                }
            }
        
            translate([first_ossm_screw+50,ossm_bolt_offset,-3]) {
                cylinder(h=ossm_h+6,d=ossm_bolt_d);
                translate([0,0,hex_nut_h*2]) {
                    cylinder(h= hex_nut_h,d= hex_nut_d,$fn=6);
                    translate([0,-shelf_h/2,hex_nut_h/2]) rotate([0,0,180]) cube([hex_nut_d,shelf_h,hex_nut_h], center=true);
                    color("transparent") translate([0,-hex_nut_d/2,hex_nut_h/2]) cube([hex_nut_d,ossm_bolt_offset,hex_nut_h], center=true);
                }
            }
        }
    }
}
if (show_ossm) {
    ossm();
}

if (show_piston) translate([piston_h/2,-piston_od/2 - mount_d*1.5,ossm_h/2 + ossm_pitclamp_offset+faceplate_h/2]) piston(); //magic *1.5

module piston() {
    rotate([0,90,0]) {
        color("grey")
        //main piston body
        cylinder(d=piston_od, h=piston_h, center=true);
        for (i = [0:3]) {
            
            rotate([0,0,90*i+45])  {

                //cutouts for sliding into place
                translate([piston_od/2-((i % 2 * 2 - 1) *-2 - (i % 2 ) *-4),(i % 2 * 2 - 1) *-7,first_ossm_screw])
                    rotate([0,0,(i % 2 * 2 - 1) * -45]) 
                        color("transparent") cube([pipe_od*1.5,piston_od/3+2,mount_l+1], center=true);  //(i % 2 * 2 - 1) * 1

                //channels for support poles on side of piston
                color("yellow") {
                    translate([0,piston_od/2 + pipe_od/2 + pipe_space,0]) {
                        cylinder(d=pipe_od, h=piston_h+1, center=true);
                        translate([0,-pipe_od/2,0]) cube([pipe_od,pipe_od,piston_h], center=true);
                    }
                }
            }
        }
    }
}

    