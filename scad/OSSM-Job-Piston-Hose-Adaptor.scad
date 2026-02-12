include <BOSL2/std.scad>
include <BOSL2/screws.scad> 
$fn=128;
top_d = 30;
bottom_d = 27;
hull_cutoff = 10;
wall = 1;
screw_height = 10;
arm_height = 10;
arm_space = 60;


 {
    difference() {
    //screw(d=13.157, pitch=1.337, length=screw_height,anchor=TOP,thread=true, bevel1=0, $slop=0); //G1/4 for SC50....M16x1.5 fit my SC63
        translate([0,0,screw_height/2]) threaded_rod(d=13.157, pitch=1.337, l=screw_height, thread_len=screw_height, internal=false);
    cylinder(d = 4, h =screw_height+1);
    }
}

barb();

module barb(hose_od = 14, hose_id = 10, swell = 2, wall_thickness = 2, barbs = 4, barb_length = 2, shell = true, bore = true, ezprint = false) {
    id = hose_id - (2 * wall_thickness);
    translate([0, 0, -((barb_length * (barbs + 3)))])
    difference() {
        union() {
            if (shell == true) {
                cylinder(d = hose_id, h = barb_length);
                for (z = [1 : 1 : barbs]) {
                    translate([0, 0, z * barb_length]) cylinder(d1 = hose_id, d2 = hose_id + swell, h = barb_length);
                }
                translate([0, 0, barb_length * (barbs + 1)]) cylinder(d = hose_id, h = barb_length*barbs/2 );
                    //bevel for strength - implemented as another barb
                    translate([0, 0, barb_length * (barbs + 2)]) cylinder(d1 = hose_id, d2 = hose_id + swell*2, h = barb_length);
            }
        }
        if (bore == true) {
            translate([0, 0, -1]) cylinder(d = id, h = (barb_length * (barbs + 1)) +  barb_length*(barbs + 4));
        }
        if (ezprint == true) {
            difference() {
                cylinder(d = hose_id + (swell * 3), h = (barb_length * (barbs + 1)));
                translate([swell, 0, 0]) cylinder(d = hose_id + (swell * 2), h = (barb_length * (barbs + 1)));
            }
        }
    }
}