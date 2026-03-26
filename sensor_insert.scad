/*
 * Inline adapter for Temp/Humidity/Pressure sensor.
 * Fits between the face mask and the hose.
 * Designed for a standard BME280 breakout (11.6mm x 15.3mm).
 */

// Basic parameters
inner_dia = 18;     // Inner diameter of the tube
outer_dia = 22;     // Outer diameter of the tube (standard medical 22mm ISO)
tube_length = 30;   // Overall length of the insert
wall_thickness = (outer_dia - inner_dia) / 2;

// Sensor mount parameters
sensor_length = 15.3;
sensor_width = 11.6;
sensor_boss_height = 3;
sensor_screw_dist = 11.5; // distance between mounting holes
screw_hole_dia = 2; // diameter for M2 screws

$fn = 100;

module adapter_tube() {
    difference() {
        cylinder(h=tube_length, d=outer_dia, center=true);
        cylinder(h=tube_length + 2, d=inner_dia, center=true);
    }
}

module sensor_boss() {
    // A flat surface on the outside of the tube to mount the sensor
    boss_width = sensor_width + 4;
    boss_length = sensor_length + 4;
    boss_thickness = sensor_boss_height + wall_thickness;

    translate([0, 0, 0])
    difference() {
        // Boss body
        translate([outer_dia/2 - wall_thickness/2, -boss_width/2, -boss_length/2])
            cube([boss_thickness, boss_width, boss_length]);

        // Inner bore cutout (to clear the inner tube diameter)
        cylinder(h=tube_length + 2, d=inner_dia, center=true);

        // Sensor opening to allow air sensing
        translate([outer_dia/2 - 1, 0, 0])
            rotate([0, 90, 0])
            cylinder(h=10, d=6, center=true);

        // Mounting screw holes
        translate([outer_dia/2 + boss_thickness - 2, 0, sensor_screw_dist/2])
            rotate([0, 90, 0])
            cylinder(h=10, d=screw_hole_dia, center=true);

        translate([outer_dia/2 + boss_thickness - 2, 0, -sensor_screw_dist/2])
            rotate([0, 90, 0])
            cylinder(h=10, d=screw_hole_dia, center=true);
    }
}

module main() {
    union() {
        adapter_tube();
        sensor_boss();
    }
}

main();
