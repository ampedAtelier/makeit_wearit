/**
 * LiPo Battery Cases
 * TODO:
 * [ ] add minimal size conditionals for bottom slot and grasp cutout
 * [ ] add customizer: 
 *      Lesson 4: https://www.thingiverse.com/thing:1201466
 * [ ] add sewing tabs: 
 *      https://i.materialise.com/blog/openscad-tutorial/
 * [ ] add to amped atelier github
 */

// Parametric Variables
// values are in mm that will be the default unit for printing
pBatteryLength = 25;
pBatteryWidth = 21;
pBatteryThickness = 5;
pCaseThickness = 1.6;

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
            cylinder(pCaseThickness+2,1,1);
            translate([-6,2,-1])
            cylinder(pCaseThickness+2,1,1);
        }
    }
}

// Main Program
union() {
    // Hollow Case Module
    difference() {
        // case
        round_rectangle(pBatteryLength+pCaseThickness,
            pBatteryWidth+pCaseThickness+pCaseThickness,
            pBatteryThickness+pCaseThickness+pCaseThickness);
        // Battery negative space
        translate([pCaseThickness,pCaseThickness,pCaseThickness])
        round_rectangle(pBatteryLength+1,pBatteryWidth,pBatteryThickness);
        // bottom slot
        translate([pCaseThickness*2,pCaseThickness*2,-pCaseThickness])
        round_rectangle(pCaseThickness*3,
            pBatteryWidth-pCaseThickness-pCaseThickness,
            pBatteryThickness-pCaseThickness-pCaseThickness);
        /* finger graps cutout
        translate([-2,
            (pBatteryWidth+pCaseThickness)/2,
            pBatteryLength+pCaseThickness])
        rotate(a=[0,90,0])
        cylinder(15,10,10);
        */
    }
    //TODO: if shouldAddTabs
    translate([0, -4, 0])
    sewTab();
    mirror([0,1,0])
    translate([0, -pBatteryWidth-pCaseThickness-pCaseThickness-4, 0])
    sewTab();
    //TODO: mirror twice more
}

// The % operator makes the object transparent for debugging
// The '#' operator highlights the object
