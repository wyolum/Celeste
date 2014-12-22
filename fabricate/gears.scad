include <Parametric_Involute__Bevel_and_Spur_Gears/parametric_involute_gear_v5.0.scad>

$fn=50;
mm = 1;
inch = 25.4 * mm;

ACRYLIC_THICKNESS = 5. * mm;
ACRYLIC_TOL = .5 * mm;
PITCH = 360 * mm;
PRESSURE_ANGLE = 28;

RIM_THICKNESS = 2 * mm;
EXTRA_RIM_R = 3 * mm;

module hex(r, h){
  rotate(a=30, v=[0, 0, 1])
  linear_extrude(height=h)
    polygon(points=[[r,0],
		    [r * cos(60),r * sin(60)],
		    [r * cos(120),r * sin(120)],
		    [r * cos(180),r * sin(180)],
		    [r * cos(240),r * sin(240)],
		    [r * cos(300),r * sin(300)],
		    ],paths=[ [0, 1, 2, 3, 4, 5] ]);
}

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
	    gear_thickness = ACRYLIC_THICKNESS + ACRYLIC_TOL + RIM_THICKNESS,
	    rim_thickness = ACRYLIC_THICKNESS + ACRYLIC_TOL + RIM_THICKNESS,
	    hub_thickness = ACRYLIC_THICKNESS + ACRYLIC_TOL + RIM_THICKNESS,
	    bore_diameter=0. * mm,
	    circles=4,
	    pressure_angle=28
	    );
      translate([0, 0, -RIM_THICKNESS])cylinder(r=OUTER_RADIUS, h=RIM_THICKNESS);
      // translate([0, 0, 6.5*mm])cylinder(r=OUTER_RADIUS, h=RIM_THICKNESS);
      translate([0, 0, -2 * RIM_THICKNESS])cylinder(r=OUTER_RADIUS + EXTRA_RIM_R, h=RIM_THICKNESS);
    }
    translate([0, 0, -1])cylinder(r=3 * mm/2, h=ACRYLIC_THICKNESS + ACRYLIC_TOL + 2 + 100);
  }
}

module outer_gear(N_TEETH=66){
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

module inner_gear(minute, N_TEETH=30){
  PITCH_R = N_TEETH * PITCH / 360.;
  PITCH_D = 2 * PITCH_R;
  PITCH_DIAMETRIAL = N_TEETH / PITCH_D;
  // Addendum: Radial distance from pitch circle to outside circle.
  ADDENDUM = 1 / PITCH_DIAMETRIAL;
  
  //Outer Circle
  OUTER_RADIUS = PITCH_R + ADDENDUM;
  OUTER_DIAMETER = 2 * OUTER_RADIUS;
  rad = 10 * mm;
  d1 = (rad + .0) * [1,0,0];
  d2 = (rad + .0) * [sin(30), cos(30), 0];
  translate([0, 36  * mm, .1])
    rotate(a=360/30/4 - 66./30 * minute/60 * 360 + minute/60.*720, v=[0, 0,1])
    difference(){
    intersection(){
      cylinder(r1=40, r2=26.5, h=ACRYLIC_THICKNESS); // taper the teeth
      scale([1, 1, 1])gear (number_of_teeth=N_TEETH,
	    circular_pitch = PITCH,
			    gear_thickness = ACRYLIC_THICKNESS/2,
	    rim_thickness = ACRYLIC_THICKNESS - ACRYLIC_TOL,
	    hub_thickness = ACRYLIC_THICKNESS - ACRYLIC_TOL,
	    bore_diameter=0. * mm,
	    circles=0,
	    pressure_angle=28
	    );
    }
    translate([0, 0, -1])cylinder(r=6 * mm/2, h=ACRYLIC_THICKNESS + ACRYLIC_TOL + 2 + 100);

    // lighten the load
    for(i=[0:4]){
      rotate(a=360/5 * i, v=[0, 0, 1])translate([0, 16, -1])cylinder(r=6 * mm, h=ACRYLIC_THICKNESS + ACRYLIC_TOL + 2 + 100);
      // scale([1, 1, .3])translate([0, 0, ])rotate(a=360/5 * i, v=[0, 0, 1])translate([0, 18, -1])sphere(r=11 * mm);
    }
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
      translate([0, 36, -RIM_THICKNESS])cylinder(r=5.5 * mm/2, h=ACRYLIC_THICKNESS + RIM_THICKNESS + .5*mm);
      // translate([0, 39, ACRYLIC_THICKNESS + .25])scale([1, .8, 1])cylinder(r1=3 * mm, r2=2.4*mm, h=1 * mm); // clip
      translate([0, 36, ACRYLIC_THICKNESS + .25*mm])scale([1, .8, 1])cylinder(r1=7/2. * mm, r2=3.2*mm, h=1.5*mm); // clip
      translate([0, 0, -RIM_THICKNESS])cylinder(r=11, h=h);
    }
    translate([0, 0, -RIM_THICKNESS - 1])cylinder(r=8.5, h=2*h);
    translate([-.5 * mm, 36 * mm-5 * mm, 2])cube([1 * mm, 10 * mm, 10 * mm]); // slot
  }
}

HOUR = 9;
MINUTE = $t * 60;
// MINUTE = HOUR * 60 + 15;
translate([0, -0, -RIM_THICKNESS])rotate(a=MINUTE/720 * 360, v=[0, 0, 1])color([.1, 1, 0])inner_gear(MINUTE);
//color([.1, .1, 1])outer_gear(); 
//translate([0, 0, -1.5*mm])rotate(a=MINUTE/720 * 360, v=[0, 0, 1])color([1, 0, 0])rotate(a=0, v=[0, 0, 1])hour_hand();
//translate([0, 0, -RIM_THICKNESS])translate([0, 0, 0])rotate(a=MINUTE/60 * 360, v=[0, 0, 1])minute_hand();

// cylinder(r=50*mm, h=100*mm); // for scale


