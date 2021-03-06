include <Parametric_Involute__Bevel_and_Spur_Gears/parametric_involute_gear_v5.0.scad>

$fn=50;
mm = 1;
inch = 25.4 * mm;

ACRYLIC_THICKNESS = 5.3 * mm;
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
  
  thickness = ACRYLIC_THICKNESS + ACRYLIC_TOL;// + RIM_THICKNESS;
  //Outer Circle
  OUTER_RADIUS = PITCH_R + ADDENDUM;
  translate([0, 0, RIM_THICKNESS])
  difference(){
    union(){
      rotate(a=360/6/2., v=[0, 0, 1])
	intersection(){
	gear(number_of_teeth=6,
	     circular_pitch = PITCH,
	     gear_thickness = thickness,
	     rim_thickness = thickness,
	     hub_thickness = thickness,
	     bore_diameter=0. * mm,
	     circles=4,
	     pressure_angle=28,
	     backlash=1
	     );
	cylinder(h=thickness, r=OUTER_RADIUS - .5*mm);
      }
      translate([0, 0, -RIM_THICKNESS])cylinder(r=OUTER_RADIUS, h=RIM_THICKNESS);
      // translate([0, 0, 6.5*mm])cylinder(r=OUTER_RADIUS, h=RIM_THICKNESS);
      translate([0, 0, -3 * RIM_THICKNESS])cylinder(r=OUTER_RADIUS + EXTRA_RIM_R, h=2 * RIM_THICKNESS);
    }
    translate([0, 0, -1])cylinder(r=3 * mm/2 + .05 * mm, h=ACRYLIC_THICKNESS + ACRYLIC_TOL + 2 + 100);
  }
}

module outer_gear(N_TEETH=66, lash=0){
  PITCH_R = N_TEETH * PITCH / 360.;
  PITCH_D = 2 * PITCH_R;
  PITCH_DIAMETRIAL = N_TEETH / PITCH_D;
  // Addendum: Radial distance from pitch circle to outside circle.
  ADDENDUM = 1 / PITCH_DIAMETRIAL;
  
  //Outer Circle
  OUTER_RADIUS = PITCH_R + ADDENDUM;
  OUTER_DIAMETER = 2 * OUTER_RADIUS;

  MARGIN = 1 * inch;
  intersection(){
    scale([.995, .995, 1])gear(number_of_teeth=72,
	   circular_pitch = PITCH,
	   gear_thickness = ACRYLIC_THICKNESS,
	   rim_thickness = ACRYLIC_THICKNESS, 
	   hub_thickness = ACRYLIC_THICKNESS, 
	   bore_diameter=0. * mm,
	   circles=0,
	   pressure_angle=28,
	   backlash=0 // play with this
	   );
difference() {
    cylinder(r=OUTER_RADIUS  +  MARGIN, h=ACRYLIC_THICKNESS + ACRYLIC_TOL);
    //cylinder(r=OUTER_RADIUS + 3, h=ACRYLIC_THICKNESS + ACRYLIC_TOL);
    translate([0, 0, -1])
      scale([1.005, 1.005, 1])gear(number_of_teeth=N_TEETH,
	   circular_pitch = PITCH,
	   gear_thickness = ACRYLIC_THICKNESS + ACRYLIC_TOL + 2,
	   rim_thickness = ACRYLIC_THICKNESS + ACRYLIC_TOL + 2,
	   hub_thickness = ACRYLIC_THICKNESS + ACRYLIC_TOL + 2,
	   bore_diameter=0. * mm,
	   circles=0,
	   pressure_angle=28,
	   backlash=0 // play with this
	   );
    cylinder(h=ACRYLIC_THICKNESS + ACRYLIC_TOL, r=OUTER_RADIUS-3); // trim teeth
  }
  }
}

module anti_lash_gear_bottom(minute, N_TEETH=30, h=ACRYLIC_THICKNESS/2, lash=0){
  ACRYLIC_THICKNESS = h;
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
  translate([0, 0, -2*ACRYLIC_THICKNESS + ACRYLIC_TOL])union(){
    translate([0, 36  * mm, 0]) 
      rotate(a=0, v=[0, 0,1])
      rotate(a=360/30/4 - 66./30 * minute/60 * 360 + minute/60.*720, v=[0, 0,1])
    intersection(){
      difference(){
      gear(number_of_teeth=N_TEETH,
	   circular_pitch = PITCH,
	   gear_thickness = ACRYLIC_THICKNESS,
	   rim_thickness = ACRYLIC_THICKNESS, //   - ACRYLIC_TOL,
	   hub_thickness = ACRYLIC_THICKNESS, //  - ACRYLIC_TOL,
	   bore_diameter=0. * mm,
	   circles=0,
	   pressure_angle=28,
	   backlash=lash // play with this
	   );
      translate([0, 0, -1])cylinder(r=6 * mm/2, h=ACRYLIC_THICKNESS + ACRYLIC_TOL + 2 + 100);

      // hollow out
      translate([0, 0, -1])cylinder(r=N_TEETH - 5, h=ACRYLIC_THICKNESS + ACRYLIC_TOL + 2 + 100);
    }
      translate([0, 0, -1])cylinder(r=OUTER_RADIUS - .5, h=100);
    }
    // add tensioners
    difference(){
      union(){
	for(i=[0:4]){
	  translate([0, 36 * mm, 0])rotate(a=360/5 * i + 3, v=[0, 0, 1])translate([0, 16, 0])
	    difference(){
	    cylinder(r=5.9 * mm, h=2 * ACRYLIC_THICKNESS);
	    translate([0, 0, -1])cylinder(r=5.9*mm - 4*.4 * mm, h=2 * ACRYLIC_THICKNESS + 2);
	  }
	  // translate([0, 36 * mm, 0])rotate(a=360/5 * i + 3, v=[0, 0, 1])translate([-1 *mm, -27 * mm, 0])cube([2 * mm, 30 * mm, ACRYLIC_THICKNESS]);  // streight spokes
	  translate([0, 36 * mm, 0])rotate(a=360/5 * i + 3, v=[0, 0, 1])translate([0 *mm, 16 * mm, 0])difference(){
	    cylinder(r=12 * mm, h = ACRYLIC_THICKNESS);
	    translate([0, 0, -1])cylinder(r=10 * mm, h = ACRYLIC_THICKNESS+2);
	    translate([0, -12, -1])cube([12, 24, 2 * ACRYLIC_THICKNESS]);
	  }
	  translate([0, 36 * mm, 0])rotate(a=360/5 * i + 3 + 180/5, v=[0, 0, 1])translate([0 *mm, -7.5 * mm, 0])
	    difference(){
	    cylinder(h=ACRYLIC_THICKNESS, r=3.0 * mm);
	    translate([0, 0, -1])cylinder(h=ACRYLIC_THICKNESS + 2, r=1.5);
	    rotate(v=[0, 0, 1], a=-45)translate([-1 * mm, -1 * mm, -1])cube([10 * mm, 10 * mm, ACRYLIC_THICKNESS + 2]);
	  }
	}
      }
      translate([0, 36*mm, -1])cylinder(r = 4*mm, h=ACRYLIC_THICKNESS+2);
    }
    difference(){ // inner hub support
      translate([0, 36*mm, 0])cylinder(r = 5*mm, h=ACRYLIC_THICKNESS);
      translate([0, 36*mm, -1])cylinder(r = 3*mm, h=ACRYLIC_THICKNESS+2);
    }
  }
}

module anti_lash_gear_top(minute, N_TEETH=30, h=ACRYLIC_THICKNESS/2, lash=0){
  ACRYLIC_THICKNESS = h;
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
  translate([0, 36  * mm, 0])
    // rotate(a=360/30/4 - 66./30 * minute/60 * 360 + minute/60.*720, v=[0, 0,1])
    rotate(-4, v=[0, 0,1])
    difference(){
    intersection(){
      cylinder(r1=40, r2=26.5, h=ACRYLIC_THICKNESS); // taper the teeth
      gear(number_of_teeth=N_TEETH,
	   circular_pitch = PITCH,
	   gear_thickness = ACRYLIC_THICKNESS,
	   rim_thickness = ACRYLIC_THICKNESS, //   - ACRYLIC_TOL,
	   hub_thickness = ACRYLIC_THICKNESS, //  - ACRYLIC_TOL,
	   bore_diameter=0. * mm,
	   circles=0,
	   pressure_angle=28,
	   backlash=lash
	   );
      translate([0, 0, -1])cylinder(r=OUTER_RADIUS - .5, h=100);
    }
    translate([0, 0, -1])cylinder(r=6 * mm/2, h=ACRYLIC_THICKNESS + ACRYLIC_TOL + 2 + 100);
    // hollow out
    translate([0, 0, -1])cylinder(r=N_TEETH - 5, h=ACRYLIC_THICKNESS + ACRYLIC_TOL + 2 + 100);

  }
  // add tensioners
  translate([0, 36*mm, 0])
  for(i=[0:4]){
    rotate(a=360/5 * i + 3, v=[0, 0, 1])translate([0, 16, 0])difference(){
      cylinder(r=6 * mm + 4 * .4*mm, h=ACRYLIC_THICKNESS);
      translate([0, 0, -1])cylinder(r=6 * mm, h=ACRYLIC_THICKNESS + 2);
    // scale([1, 1, .3])translate([0, 0, ])rotate(a=360/5 * i, v=[0, 0, 1])translate([0, 18, -1])sphere(r=11 * mm);
    }
  }
  // add in rim strip to support hour hand
  translate([0, 0, 0])
    union(){
    difference(){ // outer rim support
      translate([0, 36*mm, 0])cylinder(r = 1*inch, h=ACRYLIC_THICKNESS + 1.25);
      translate([0, 36*mm, -1])cylinder(r = 7 * inch/8, h=ACRYLIC_THICKNESS + 10);
    }
    difference(){ // inner hub support
      translate([0, 36*mm, 0])cylinder(r = 9*mm, h=ACRYLIC_THICKNESS + 1);
      translate([0, 36*mm, -2])cylinder(r = 3*mm, h=ACRYLIC_THICKNESS + 10);
     }
  }
}

module inner_gear(minute, N_TEETH=30, h=ACRYLIC_THICKNESS){
  ACRYLIC_THICKNESS = h;
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
  translate([0, 36  * mm, 0])
    rotate(a=360/30/4 - 66./30 * minute/60 * 360 + minute/60.*720, v=[0, 0,1])
    difference(){
    intersection(){
      cylinder(r1=40, r2=26.5, h=ACRYLIC_THICKNESS); // taper the teeth
      gear(number_of_teeth=N_TEETH,
	   circular_pitch = PITCH,
	   gear_thickness = ACRYLIC_THICKNESS,
	   rim_thickness = ACRYLIC_THICKNESS, //   - ACRYLIC_TOL,
	   hub_thickness = ACRYLIC_THICKNESS, //  - ACRYLIC_TOL,
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
  // add in rim strip to support hour hand
  translate([0, 0, 1])
    union(){
    difference(){ // outer rim support
      translate([0, 36*mm, 0])cylinder(r = 1*inch, h=ACRYLIC_THICKNESS);
      translate([0, 36*mm, -1])cylinder(r = 7 * inch/8, h=ACRYLIC_THICKNESS+2);
    }
    difference(){ // inner hub support
      translate([0, 36*mm, 0])cylinder(r = 8*mm, h=ACRYLIC_THICKNESS);
      translate([0, 36*mm, -1])cylinder(r = 3*mm, h=ACRYLIC_THICKNESS+2);
    }
  }
}

module minute_hand(r=65*mm, w=21.5*mm, h=RIM_THICKNESS - 0.5*mm,filagree=false){
//linear_extrude(height = 2, center=true)
//polygon(points=[[-5*mm/2, 0], [0, 65*mm], [5*mm/2, 0]]);
  difference(){
    union(){
      stepper_gear(N_TEETH=6);
      translate([0, 2*mm, -2*RIM_THICKNESS])
	linear_extrude(height=h)
        if (filagree){
	  translate([0,8.2,0])scale([1.3,1,1])import("filagreeminute.dxf");
        }
        else
            polygon(points=[[-w/2, 0], [0, r], [w/2, 0]]);
    }
    translate([0, 0, -50])cylinder(r=3 * mm/2, h=ACRYLIC_THICKNESS + ACRYLIC_TOL + 2 + 100);
    // translate([0, r - 15 * mm, -50])cylinder(h=100, r=3.00/2*mm); //hole for hall effect magnet
  }
}

module hour_hand(r=50*mm, w=21.5*mm, h=1.5*mm, filagree = false){
  difference(){
    union(){
      translate([0, RIM_THICKNESS, -RIM_THICKNESS])
	linear_extrude(height=h)
        if (filagree){
            translate([0,8.2,0])scale([1.3,1,1])import("filagreehour.dxf");
        }else
	polygon(points=[[-w/2, 0], [0, r], [w/2, 0]]);
      // translate([0, 36, -RIM_THICKNESS])cylinder(r=5.5 * mm/2, h=ACRYLIC_THICKNESS + RIM_THICKNESS + .5*mm);
      translate([0, 36, -RIM_THICKNESS])cylinder(r=5.5 * mm/2, h=ACRYLIC_THICKNESS + RIM_THICKNESS + 1);
      translate([0, 36, ACRYLIC_THICKNESS + .75*mm])scale([1, .8, 1])cylinder(r1=7/2. * mm, r2=3.2*mm, h=1.5*mm); // clip
      translate([0, 0, -RIM_THICKNESS])cylinder(r=11, h=h);
    }
    translate([0, 0, -RIM_THICKNESS - 1])cylinder(r=8.25, h=2*h);
    translate([-.5 * mm, 36 * mm-5 * mm, 2])cube([1 * mm, 10 * mm, 10 * mm]); // slot
    //translate([0, r - 10 * mm, -50])cylinder(h=100, r=3.00/2*mm); // hall effect magnet slot
  }
}

HOUR = 9;
MINUTE = $t * 60;
//MINUTE = HOUR * 60 + 15;
// translate([0,0, 2])rotate(v=[0, 1, 0], a=180)
//translate([0, -0, -RIM_THICKNESS])rotate(a=MINUTE/720 * 360, v=[0, 0, 1])color([.1, 1, 0])inner_gear(MINUTE);
// color([.1, .1, 1])outer_gear(); 
// translate([0, 0, -1.5*mm])rotate(a=MINUTE/720 * 360, v=[0, 0, 1])color([1, 0, 0])rotate(a=0, v=[0, 0, 1])hour_hand(w=11,filagree=true);
// translate([0, 0, -RIM_THICKNESS])translate([0, 0, 0])rotate(a=MINUTE/60 * 360, v=[0, 0, 1])minute_hand(w=12,filagree=true);

lash = 0;
anti_lash_gear_bottom(lash=lash);
// color([1, 0, 1])translate([0, -0, +ACRYLIC_THICKNESS/2 + ACRYLIC_TOL])anti_lash_gear_top(lash=lash);
// cylinder(r=50*mm, h=100*mm); // for scale


