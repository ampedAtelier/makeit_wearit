/**
 * file: lipoSleeve.scad 
 * Make It, Wear It
 * Chapter 8: Programmable Sewn Circuit Cuff
 *
 * LiPo Battery Cases
 * Optional battery holder 3D model
 * Output named: lipo_sleeve.stl
 *
 * Printer Settings:
 * Rafts: No
 * Supports: No
 * Resolution: 0.06
 * Infill: 10%
 * 
 * TODO:
 * [ ] add minimal size conditionals for bottom slot
 *      [ ] slot should also have a max thickness
 * [ ] add customizer: 
 *      Lesson 4: https://www.thingiverse.com/thing:1201466
 * [ ] add sewing tabs: 
 *      https://i.materialise.com/blog/openscad-tutorial/
 */
 
// The % operator makes the object transparent for debugging
// The '#' operator highlights the object

// Parametric Variables
/* values are in mm that will be the default unit for printing
pBatteryLength = 25;
pBatteryWidth = 21;
pBatteryThickness = 5;
*/
// Cable Taped Battery
pBatteryLength = 52;
pBatteryWidth = 36;
pBatteryThickness = 9;

/* Larger Battery
pBatteryLength = 61;
pBatteryWidth = 38;
pBatteryThickness = 9;
*/
pCaseThickness = 1.6;
pCutOutRadius = 10;

pShouldAddTabs = true;

//Rounded Rectangle Module
module round_rectangle(l,w,t) {
    union() {
        radius = t/2;
        translate([radius,radius,0])
        cylinder(l, radius, radius);
        translate([0,radius,0])
        cube([t,w-t,l]);
        translate([radius,w-radius,0])
        cylinder(l, radius, radius);
    }
}

module sewTab() {
    //union() {
    // add cylinder to round corners
    // rotated 45ª to print w/o supports
    difference() {
        cube([pCaseThickness,10,9]);
        // sewing holes
        rotate(a=[0,90,0]) {
            translate([-3,2,-1])
            cylinder(pCaseThickness+2,1,1,$fn=20);
            translate([-6,2,-1])
            cylinder(pCaseThickness+2,1,1,$fn=20);
        }
    }
}

module sewRing() {
    difference() {
        cylinder(pCaseThickness, 4.0, 4.0, $fn=20);
        translate([0, 0, -1])
        cylinder(4.0, 2.0, 2.0, $fn=20);
    }
}

// Main Program
union() {
    // Hollow Case Module
    difference() {
        // battery case
        round_rectangle(pBatteryLength+pCaseThickness,
            pBatteryWidth+pCaseThickness+pCaseThickness,
            pBatteryThickness+pCaseThickness+pCaseThickness);
        // Battery negative space
        translate([pCaseThickness,pCaseThickness,pCaseThickness])
        round_rectangle(pBatteryLength+1,pBatteryWidth,pBatteryThickness);
        // bottom slot
        translate([pCaseThickness*2,pCaseThickness*2,-pCaseThickness])
        #round_rectangle(pCaseThickness*3,
            pBatteryWidth-pCaseThickness-pCaseThickness,
            pBatteryThickness-pCaseThickness-pCaseThickness);
        // finger grasp cutout parametric conditional 
        if (pCutOutRadius+pCutOutRadius+pCaseThickness < pBatteryWidth) {
            translate([-1,
                (pBatteryWidth+pCaseThickness+pCaseThickness)/2,
                pBatteryLength+pCaseThickness])
            rotate(a=[0,90,0])
            cylinder(pBatteryThickness+pCaseThickness+pCaseThickness+2,
            pCutOutRadius,
            pCutOutRadius);
        }        
    }
    if (pShouldAddTabs == true) {
        rotate([0,90,0]) {
            translate([-4, 0, 0])
            sewRing();
            translate([-4, pBatteryWidth+pCaseThickness+pCaseThickness, 0])
            sewRing();
            // add a third on at the top
        }
    }
}
