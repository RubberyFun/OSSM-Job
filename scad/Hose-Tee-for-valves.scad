include <BOSL2/std.scad>
include <BOSL2/screws.scad> 
$fn=128;



translate([-5,0,0])
difference() {
    union() {
        cylinder(d=14,h=5);

        rotate([0,0,180]) barb(ezprint=true);
        //translate([2.5,2.5,2.5]) rotate([90,180,0]) barb(hose_id=5, wall_thickness=1, barbs=4, ezprint=true);
        translate([0,4.5,2.5]) rotate([90,180,0]) barb(ezprint=true, bevel=false);
        translate([0,0,5]) rotate([0,180,0]) barb(ezprint=true);
    }

    translate([0,0,-.5])cylinder(d=6,h=6);
    translate([0,0,2.5]) rotate([-90,0,0]) cylinder(d=6,h=17);
    translate([7.5,0,0]) cube([5,15,32],center=true);
}



module barb(hose_od = 14, hose_id = 10, swell = 2, wall_thickness = 2, barbs = 4, barb_length = 2, shell = true, bore = true, bevel=true, ezprint = false) {
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
                    if (bevel) translate([0, 0, barb_length * (barbs + 2)]) cylinder(d1 = hose_id, d2 = hose_id + swell*2, h = barb_length);
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