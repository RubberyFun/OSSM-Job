include <BOSL2/std.scad>
include <BOSL2/screws.scad> 
$fn=128;
top_d = 24;  
top_pitch = 3; //M24x3 OSSM thread
bottom_d = 16;
bottom_pitch=1.5;  //sc32 = M10x1.25, sc50 = M16x1.5
wall = 1;
ossm_height = 25;
arm_height = 10;
arm_space = 60; //55 for sc32, 60 for SC50, 65 for SC63
fillet = 20;

//arm
difference() {
union() {
cylinder(h=arm_height,d=top_d+fillet);   
translate([arm_space/2,0,arm_height/2]) {
    points = [
        [-arm_space/2,top_d/2 + fillet/2],
        [arm_space/2,top_d/2 - (top_d - bottom_d)/2 + fillet/2],
        [arm_space/2,-top_d/2 + (top_d - bottom_d)/2 - fillet/2],
        [-arm_space/2,-top_d/2 - fillet/2],
    ];
    linear_extrude(height=arm_height,center=true)
    polygon(points);
}
translate([arm_space,0,0])
cylinder(h=arm_height,d=bottom_d+fillet);    
}
cylinder(h=arm_height*2+1,d=top_d,center=true);   

translate([arm_space,0,0])
cylinder(h=arm_height*2+1,d=bottom_d,center=true);    
}

//ossm nut
 translate([arm_space * -1,0,0]) {
  nut(str("M",top_d,"x",top_pitch),thickness=arm_height*1.5);
 }
 
 
//cylinder nut
 translate([arm_space * 2,0,0])

nut(str("M",bottom_d,"x",bottom_pitch),thickness=arm_height);

