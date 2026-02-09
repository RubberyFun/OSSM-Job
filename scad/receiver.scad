include <BOSL2/std.scad>
$fn=256;
wall = 5;  //how thick the walls are
receiver_id = 50;  //this is the minimum inner diameter
receiver_base_flare = 0; //shape is 0 for Venus 2000, 10 for AutoBlow
receiver_len = 150; //Small = 150, Medium = 180, Large = 210
valve_od = 10; // 3/8 for many pneumatic toy hose id
valve_offset = 50; //how far from the bottom is the valve
valve_len = 25;  //how far out the valve sticks
receiver_id_at_valve_base = receiver_id + receiver_base_flare * ((receiver_len - valve_offset + valve_od*2) / receiver_len);
receiver_id_at_valve_top = receiver_id + receiver_base_flare * ((receiver_len - valve_offset - valve_od*2) / receiver_len);
cap_h = 25; //how tall the cap is
stem_id = 8;  //corresponds to one-way-valve inner diameter
//original valve: https://autoblow.com/product/vacuglide-nipples-2-set/ 
//valve option (might need to set stem_id to 5 or 6): https://www.amazon.com/Compatible-Replacement-Accessories-Signature-Smartpump/dp/B0CP16F4VF
//valve option(sticks out a bit): https://www.amazon.com/Bwintech-Straight-Pneumatic-Connect-Compressor/dp/B0CFTZZ8B2 

stem_h = 5;  //length of the one-way-valve attachment
stem_wall = 1;
stem_recess_od = receiver_id- wall; //26;
stem_fillet = 4;
cap_allowance=.1;
show_receiver=true;
show_cap=true;

echo(str("Receiver ID at valve: ", receiver_id_at_valve_base));

if (show_cap) {
    if (show_receiver)
        #translate([0,0,receiver_len]) rotate([180,0,0]) cap();
    else
        cap();
}
if (show_receiver) {
    receiver();
}

module receiver()
//fillet(r = wall, l = wall*2) {
difference() {
    union() {

        //outer shell
        cylinder(d=receiver_id+wall*2+receiver_base_flare,d2=receiver_id+wall*2,h=receiver_len);
        //rounded end at base
        torus(od=receiver_id+receiver_base_flare+wall*2, id=receiver_id+receiver_base_flare);
        //rounded end at top
        translate([0,0,receiver_len])torus(od=receiver_id+wall*2, id=receiver_id);

        difference() {
            //platform for valve
            hull() {
                translate([0,0,valve_offset- valve_od*2])
                    cylinder(d1=receiver_id_at_valve_base+wall*2,d2=receiver_id_at_valve_top+wall*2,h=valve_od*4);
                translate([receiver_id_at_valve_base/2+wall,0,valve_offset]) {
                    rotate([0,90,0])
                        cylinder(d=valve_od, h=wall);
                }
            }

            translate([receiver_id_at_valve_base/2+wall*2,0,valve_offset]) 
                rotate([0,90,0]) {
                    //fillet around valve hole
                    torus(od=valve_od+wall*4, id=valve_od);

                    //flattening of platform
                    translate([0,0,-wall])
                        difference() {
                            cylinder(d=valve_od+wall*8,h=5);
                            cylinder(d=valve_od+wall*2,h=5);
                        }
                }
        }

        //valve wall
        translate([receiver_id_at_valve_base/2,0,valve_offset]) 
            rotate([0,90,0])
                cylinder(d=valve_od, h=valve_len);
    }

    //main shaft hollow
    translate([0,0,-.5]) cylinder(d1=receiver_id+receiver_base_flare,d2=receiver_id,h=receiver_len+1);

    //valve hollow
    translate([receiver_id/2 - 1,0,valve_offset]) {
        rotate([0,90,0])
            cylinder(d=valve_od-wall, h=valve_len*2);
    }
}


module cap() {
    translate([0,0,- stem_h*2]) {
        difference() {
            union() {
                difference() {
                    //recessed lid for one-way stem attachment
                    cylinder(d=receiver_id+wall*4,h=cap_h+stem_h);
                    translate([0,0,-1]) cylinder(d1=stem_recess_od+stem_h*2,d2=stem_recess_od - 2,h=stem_h+1);  //+1 & -2 for visual sanity
                    //torus(od=stem_recess_od+stem_fillet, id=stem_recess_od - stem_fillet);  //fillet around recess WIP
                    
                }
                //stem shell for one-way valve attachment and fillet
                cylinder(d=stem_id+stem_wall*2,h=wall+stem_h);
                translate([0,0,stem_h - stem_fillet/2])  round_fillet(d=stem_id+stem_wall*2, size=stem_fillet, half=false);

                //rounded end for cap
                translate([0,0,cap_h+ stem_h])torus(od=receiver_id+wall*4, id=receiver_id+wall*2);

            }

            //inner hollow of cap
            translate([0,0,stem_h*2]) cylinder(d=receiver_id+wall*2+cap_allowance,h=receiver_len);

            //inner hollow of stem
            translate([0,0,-1]) translate([0,0,0]) cylinder(d=stem_id,h=wall+stem_h+1);
        }
    }
}

module round_fillet(d, size, half=false) {
    difference() {
        cylinder(d2=d + size, d1=d, h=size/2);
        torus(od=d + size*2, id=d);
        if (half) {
            translate([-(d+size)/2,0,0]) cube([d+size,d+size,size], center=true);
        }
    }
}

