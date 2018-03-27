/**
 * file: ledBatteryHolder.scad 
 * Make It, Wear It
 * Chapter 4: Fiber Optic Scarf
 * 
 * Print Settings:
 * Infill: 10%
 * Supports: No
 * Build Plate Adhession: Brim
 */
 
 // module for circumscribed holes
 module cylinder_outer(height,radius,fn){
   fudge = 1/cos(180/fn);
   cylinder(h=height,r=radius*fudge,$fn=fn);
}

module sewing_tab() {
    difference() {
        union() {
            cylinder(2.0, 4.0, 4.0, $fn=20);
            translate([-3.1255, -14.5, 0])
            rotate([0,0,45])
            cube([2,7.5,2]);
        }
        translate([0, 0, -1])
        cylinder(4.0, 2.0, 2.0, $fn=20);
    }
}
 
translate([0, 0, 12.75])
difference() {
    // solids
    union() {
        // battery holder
        rotate([0,90,0]) {
            cylinder(7.4, 12.75, 12.75, true);
            // sewing tabs
            translate([-13, 6, -3.7])
            sewing_tab();
            // Another option might to use mirror()
            translate([-13, -6, -1.7])
            rotate([180,0,0])
            sewing_tab();
        }
        // LED tube
        translate([0, 0, 10])
        // LED = 8.2 mm tall, fiber optic bundle = 12.5
        cylinder(21, 5, 5, false);
        translate([0, 0, -2])
        cylinder(12, 3.7, 5, false);
    }
    // battery holder negative space
    rotate([0,90,0]) {
        cylinder(3.3, 10, 10, true);
        translate([0, -12.75, -1.7])
        cube([12.75,25.5,3.3]);
        translate([10, 0, 0])
        cylinder(7.5, 7.5, 7.5, true);
    }
    // LED tube negative space
    translate([0, 0, 9])
    // LED width = 6mm, bundle width = 5.75 mm
    //#cylinder(23, 3, 3, false, $fn=20);
    #cylinder_outer(23, 3.5, 20);
    // LED leads negative space: 0.5mm diameter
    translate([1.65, 0, -4])
    cylinder(14, .5, .5, false, $fn=20);
    translate([-1.65, 0, -4])
    cylinder(14, .5, .5, false, $fn=20);
    // plus symbol negative space
    translate([3, -9.8, 0])
    cube([1, 6.2,2.5]);
    translate([3, -8, -1.8])
    cube([1,2.5,6.2]);
}
