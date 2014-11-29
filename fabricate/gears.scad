include <Parametric_Involute__Bevel_and_Spur_Gears/parametric_involute_gear_v5.0.scad>

$fn=25;
mm = 1;
inch = 25.4 * mm;

ACRYLIC_THICKNESS = 6 * mm;
ACRYLIC_TOL = .5 * mm;
PITCH = 360 * mm;
PRESSURE_ANGLE = 28;

RIM_THICKNESS = 2 * mm;
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
      rotate(a=360/6/2., v=[0, 0, 1])
      gear (number_of_teeth=6,
	    circular_pitch = PITCH,
	    gear_thickness = ACRYLIC_THICKNESS + ACRYLIC_TOL,
	    rim_thickness = ACRYLIC_THICKNESS + ACRYLIC_TOL,
	    hub_thickness = ACRYLIC_THICKNESS + ACRYLIC_TOL,
	    bore_diameter=0. * mm,
	    circles=4,
	    pressure_angle=28
	    );
      translate([0, 0, -RIM_THICKNESS])cylinder(r=OUTER_RADIUS, h=RIM_THICKNESS);
      translate([0, 0, 6.5*mm])cylinder(r=OUTER_RADIUS, h=RIM_THICKNESS);
      translate([0, 0, -2 * RIM_THICKNESS])cylinder(r=OUTER_RADIUS + EXTRA_RIM_R, h=RIM_THICKNESS);
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

module inner_gear(minute, N_TEETH=33){
  PITCH_R = N_TEETH * PITCH / 360.;
  PITCH_D = 2 * PITCH_R;
  PITCH_DIAMETRIAL = N_TEETH / PITCH_D;
  // Addendum: Radial distance from pitch circle to outside circle.
  ADDENDUM = 1 / PITCH_DIAMETRIAL;
  
  //Outer Circle
  OUTER_RADIUS = PITCH_R + ADDENDUM;
  OUTER_DIAMETER = 2 * OUTER_RADIUS;
  translate([0, 39 * mm, .1])
    rotate(a=360/33/4 - 72./33 * minute/60 * 360 + minute/60.*720, v=[0, 0,1])
    difference(){
    gear (number_of_teeth=N_TEETH,
	  circular_pitch = PITCH,
	  gear_thickness = ACRYLIC_THICKNESS + ACRYLIC_TOL,
	  rim_thickness = ACRYLIC_THICKNESS + ACRYLIC_TOL,
	  hub_thickness = ACRYLIC_THICKNESS + ACRYLIC_TOL,
	  bore_diameter=0. * mm,
	  circles=0,
	  pressure_angle=28
	  );
    translate([0, 0, -1])cylinder(r=3 * mm/2, h=ACRYLIC_THICKNESS + ACRYLIC_TOL + 2 + 100);
  }
}

module minute_hand(r=65*mm, w=21.5*mm, h=RIM_THICKNESS - 0.5*mm){
//linear_extrude(height = 2, center=true)
//polygon(points=[[-5*mm/2, 0], [0, 65*mm], [5*mm/2, 0]]);
  stepper_gear(N_TEETH=6);
  translate([0, 2*mm, -2*RIM_THICKNESS])
  linear_extrude(height=h)
    polygon(points=[[-w/2, 0], [0, r], [w/2, 0]]);
}
module hour_hand(r=50*mm, w=21.5*mm, h=1.5*mm){
  difference(){
    union(){
      translate([0, RIM_THICKNESS, -RIM_THICKNESS])
	linear_extrude(height=h)
	polygon(points=[[-w/2, 0], [0, r], [w/2, 0]]);
      translate([0, 39, 0])cylinder(r=3 * mm/2, h=ACRYLIC_THICKNESS);
      translate([0, 39, ACRYLIC_THICKNESS - 1])scale([1, .8, 1])cylinder(r=4 * mm/2, h=1); // clip
      translate([0, 0, -RIM_THICKNESS])cylinder(r=11, h=h);
    }
    translate([0, 0, -RIM_THICKNESS - 1])cylinder(r=8.5, h=2*h);
    translate([-.3, 39-5, 0])cube([.6, 10, 10]); // slot
  }
}

HOUR = 0;
MINUTE = $t * 60;
MINUTE = HOUR * 60 + 0;
translate([0, -10, 0])
rotate(a=MINUTE/720 * 360, v=[0, 0, 1])color([.1, 1, 0])inner_gear(MINUTE);
color([.1, .1, 1])outer_gear(); 
//rotate(a=MINUTE/720 * 360, v=[0, 0, 1])color([1, 0, 0])rotate(a=0, v=[0, 0, 1])hour_hand();
//translate([25, 0, +RIM_THICKNESS])
//rotate(a=MINUTE/60 * 360, v=[0, 0, 1])minute_hand();

