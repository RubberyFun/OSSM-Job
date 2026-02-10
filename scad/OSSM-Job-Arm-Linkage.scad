include <BOSL2/std.scad>
include <BOSL2/screws.scad> 
$fn=128;
top_d = 30;
bottom_d = 27;
hull_cutoff = 10;
wall = 1;
ossm_height = 25;
arm_height = 10;
arm_space = 60;
fillet = 20;

module round_fillet(d, size, half=false) {
    difference() {
        cylinder(d2=d + size/2, d1=d, h=size/4);
        torus(od=d + size, id=d);
        if (half) {
            translate([-(d+size/2)/2,0,0]) cube([d+size/2,d+size/2,size/2], center=true);
        }
    }
}


difference() {
    union() {
        cylinder(h=ossm_height+arm_height,d=top_d);    
            translate([0,0,ossm_height - fillet/4]) 
                round_fillet(d=top_d, size=fillet, half=false);
        
                translate([0,0,ossm_height])  cylinder(h=arm_height,d=top_d+ fillet/2);    

    }
    translate([0,0,ossm_height]) screw_hole("M24x3", length=ossm_height,anchor=TOP,thread=true, bevel1=0, $slop=0);
}

//arm
translate([arm_space/2,0,ossm_height + arm_height/2]) {
    points = [
        [-arm_space/2,top_d/2 + fillet/4],
        [arm_space/2,top_d/2 - (top_d - bottom_d)/2 + fillet/4],
        [arm_space/2,-top_d/2 + (top_d - bottom_d)/2 - fillet/4],
        [-arm_space/2,-top_d/2 - fillet/4],
    ];
    linear_extrude(height=arm_height,center=true)
    polygon(points);
}

translate([arm_space,0,0])
difference() {
    union() {
        cylinder(h=ossm_height+arm_height,d=bottom_d);    
        //scale([1,bottom_d/(bottom_d + fillet/4),1])
            translate([0,0,ossm_height - fillet/4]) 
                rotate([0,0,180])
                    round_fillet(d=bottom_d, size=fillet, half=false);
        
        translate([0,0,ossm_height]) cylinder(h=arm_height,d=bottom_d+fillet/2);    

    }
    translate([0,0,ossm_height]) screw_hole("M16x1.5", length=ossm_height,anchor=TOP,thread=true, bevel1=0, $slop=0.1);
}


