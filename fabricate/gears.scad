include <Parametric_Involute__Bevel_and_Spur_Gears/parametric_involute_gear_v5.0.scad>

$fn=100;
mm = 1;
inch = 25.4 * mm;

ACRYLIC_THICKNESS = 6 * mm;
ACRYLIC_TOL = .5 * mm;
PITCH = 360 * mm;
PRESSURE_ANGLE = 28;

RIM_THICKNESS = 1 * mm;
EXTRA_RIM_R = 3 * mm;

module stepper_gear(N_TEETH=6){
  PITCH_R = N_TEETH * PITCH / 360.;
  PITCH_D = 2 * PITCH_R;
  PITCH_DIAMETRIAL = N_TEETH / PITCH_D;
  // Addendum: Radial distance from pitch circle to outside circle.
  ADDENDUM = 1 / PITCH_DIAMETRIAL;
  
  //Outer Circle
  OUTER_RADIUS = PITCH_R + ADDENDUM;
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
    translate([0, 0, -1])cylinder(r=3 * mm/2, h=ACRYLIC_THICKNESS + ACRYLIC_TOL + 2 + 100);
  }
}

module outer_gear(N_TEETH=72){
  PITCH_R = N_TEETH * PITCH / 360.;
  PITCH_D = 2 * PITCH_R;
  PITCH_DIAMETRIAL = N_TEETH / PITCH_D;
  // Addendum: Radial distance from pitch circle to outside circle.
  ADDENDUM = 1 / PITCH_DIAMETRIAL;
  
  //Outer Circle
  OUTER_RADIUS = PITCH_R + ADDENDUM;
  OUTER_DIAMETER = 2 * OUTER_RADIUS;

  MARGIN = 1 * inch;
  difference(){
    cylinder(r=OUTER_RADIUS  +  MARGIN, h=ACRYLIC_THICKNESS + ACRYLIC_TOL);
    translate([0, 0, -1])
    gear (number_of_teeth=N_TEETH,
	  circular_pitch = PITCH,
	  gear_thickness = ACRYLIC_THICKNESS + ACRYLIC_TOL + 2,
	  rim_thickness = ACRYLIC_THICKNESS + ACRYLIC_TOL + 2,
	  hub_thickness = ACRYLIC_THICKNESS + ACRYLIC_TOL + 2,
	  bore_diameter=0. * mm,
	  circles=0,
	  pressure_angle=28
	  );
  }
}

module hand(r=65*mm, w=21.5*mm, h=1*mm){
//linear_extrude(height = 2, center=true)
//polygon(points=[[-5*mm/2, 0], [0, 65*mm], [5*mm/2, 0]]);
  translate([0, 2*mm, -1*mm])
  linear_extrude(height=h)
    polygon(points=[[-w/2, 0], [0, r], [w/2, 0]]);
}

// outer_gear();
stepper_gear(N_TEETH=6);
hand();
