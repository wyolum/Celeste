include <Parametric_Involute__Bevel_and_Spur_Gears/parametric_involute_gear_v5.0.scad>

$fn=100;
mm = 1;
inch = 25.4 * mm;

ACRYLIC_THICKNESS = 6 * mm;
ACRYLIC_TOL = .5 * mm;
PITCH = 360 * mm;
N_TEETH = 6;

PITCH_R = N_TEETH * PITCH / 360.;
PITCH_D = 2 * PITCH_R;
PRESSURE_ANGLE = 28;
PITCH_DIAMETRIAL = N_TEETH / PITCH_D;

// Addendum: Radial distance from pitch circle to outside circle.
ADDENDUM = 1/PITCH_DIAMETRIAL;

//Outer Circle
OUTER_RADIUS = PITCH_R+ADDENDUM;

RIM_THICKNESS = 1 * mm;
EXTRA_RIM_R = 3 * mm;

difference(){
  union(){
    gear (number_of_teeth=6,
	  circular_pitch = PITCH,
	  gear_thickness = ACRYLIC_THICKNESS + ACRYLIC_TOL,
	  rim_thickness = ACRYLIC_THICKNESS + ACRYLIC_TOL,
	  hub_thickness = ACRYLIC_THICKNESS + ACRYLIC_TOL,
	  bore_diameter=0. * mm,
	  circles=4,
	  pressure_angle=28
	  );
    translate([0, 0, -1*mm])cylinder(r=OUTER_RADIUS + EXTRA_RIM_R, h=RIM_THICKNESS);
    translate([0, 0, 6.5*mm])cylinder(r=OUTER_RADIUS, h=RIM_THICKNESS);
  }
  translate([0, 0, -1])cylinder(r=3mm, h=ACRYLIC_THICKNESS + ACRYLIC_TOL + 2);
}

