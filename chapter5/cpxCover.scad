/**
 * Chapter 5: Fanny Pack CPX sewable cover
 *
 * TODO:
 * [ ] create light channels 
 * [ ] create button and button holes
 */
 
 // Parametric Variables
cpxRadius = 27;       // Outer Diameter: ~50.8mm / ~2.0"
cpxHeight =  5.5;
minThinkness = 1.5;
radiusToPadHole = 23.2;   //43.3 + 3.1 /2 
padHoleRadius = 1.4;    //3.1 diameter

union() {
    // case with tabs
    difference() {
        union() {
            translate([-11.5,49,0])
            import("starShape.stl");
            // CPX case
            cylinder(cpxHeight+minThinkness, cpxRadius+minThinkness, cpxRadius);
            /*
            for (i = [30:60:330]) {
                rotate([0,0,i])
                // sewing tabs
                difference() {
                    union() {
                        translate([cpxRadius+4,0,1])
                        cube([5,10,minThinkness], true);
                        translate([cpxRadius+6,0,0])
                        cylinder(minThinkness,5,5);
                    }
                    translate([cpxRadius+6,0,-1])
                    #cylinder(5,2,2);
                }
            }
            */
        }
        // CPX negative space
        translate([0,0,-minThinkness])
        cylinder(cpxHeight+minThinkness, cpxRadius, cpxRadius-minThinkness);
        // USB slot
        translate([cpxRadius,0,2])
        cube([26,8,5.5], true);   //TODO: needs measurements
        // Battery slot
        translate([-cpxRadius,0,3])
        cube([28,8,7.2], true);   //TODO: needs measurements
        // sewing holes
        for (i = [30:60:330]) {
            rotate([0,0,i])
            translate([cpxRadius+6,0,-1])
            cylinder(5,2,2);
        }
    }
    // internal pins
    for (i = [30:60:330]) {
        if (i != 180) {
            rotate([0,0,i])
            //TODO: needs measurements
            translate([radiusToPadHole,0,0])
            cylinder(cpxHeight+1,padHoleRadius,padHoleRadius, $fn=20);
        }
    }
}

// The % operator makes the object transparent for debugging
// The '#' operator highlights the object