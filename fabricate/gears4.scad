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

module pointer(h){
  r = 1.5*mm;
  linear_extrude(height=h)
    polygon(points=[[r,0],
		    [r * cos(120),r * sin(120)],
		    [r * cos(240),r * sin(240)],
		    ],paths=[ [0, 1, 2] ]);
}

module my_gear(N_TEETH, bore_d, thickness){
  PITCH_R = N_TEETH * PITCH / 360.;
  PITCH_D = 2 * PITCH_R;
  PITCH_DIAMETRIAL = N_TEETH / PITCH_D;
  // Addendum: Radial distance from pitch circle to outside circle.
  ADDENDUM = 1 / PITCH_DIAMETRIAL;
  
  //Outer Circle
  OUTER_RADIUS = PITCH_R + ADDENDUM;
  gear(number_of_teeth=N_TEETH,
       circular_pitch = PITCH,
       gear_thickness = thickness,
       rim_thickness = thickness,
       hub_thickness = thickness,
       bore_diameter=bore_d,
       circles=0,
       pressure_angle=28,
       backlash=1 // prototype is backlash = 1.
       );
}

module stepper_gear(N_TEETH=6){
  PITCH_R = N_TEETH * PITCH / 360.;
  PITCH_D = 2 * PITCH_R;
  PITCH_DIAMETRIAL = N_TEETH / PITCH_D;
  // Addendum: Radial distance from pitch circle to outside circle.
  ADDENDUM = 1 / PITCH_DIAMETRIAL;
  
  thickness = ACRYLIC_THICKNESS + 4.7 * mm;// + RIM_THICKNESS;
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

module ring_gear(thickness){
  N_TEETH = 66;
  PITCH_R = N_TEETH * PITCH / 360.;
  PITCH_D = 2 * PITCH_R;
  PITCH_DIAMETRIAL = N_TEETH / PITCH_D;
  // Addendum: Radial distance from pitch circle to outside circle.
  ADDENDUM = 1 / PITCH_DIAMETRIAL;
  
  //Outer Circle
  OUTER_RADIUS = PITCH_R + ADDENDUM;
  OUTER_DIAMETER = 2 * OUTER_RADIUS;
  
  MARGIN = 1 * inch;
  xxx = 69.5 * mm;
  difference(){
    cylinder(r=xxx, h=thickness);
    translate([0, 0, -1])cylinder(r=xxx-.8*mm, h=thickness + 2);
  }
  difference(){
    translate([0, 0, 0])
      scale([67.5/66., 67.5/66., 1])gear(number_of_teeth=N_TEETH,
					 circular_pitch = PITCH,
					 gear_thickness = thickness,
					 rim_thickness = thickness,
					 hub_thickness = thickness,
					 bore_diameter=0. * mm,
					 circles=0,
					 pressure_angle=28,
					 backlash=0 // play with this
					 );
    translate([0, 0, -1])
      scale([1.00, 1.00, 2])gear(number_of_teeth=N_TEETH,
				 circular_pitch = PITCH,
				 gear_thickness = thickness,
				 rim_thickness = thickness,
				 hub_thickness = thickness,
				 bore_diameter=0. * mm,
				 circles=0,
				 pressure_angle=28,
				 backlash=0 // play with this
				 );
    cylinder(h=thickness, r=OUTER_RADIUS-3.5); // trim teeth
  }
  /*
  for(i=[0:12])rotate(a=i*360/12, v=[0, 0, 1])translate([69*mm,0*mm,0])
		 difference(){
      cylinder(r=3*mm, h = thickness);
      translate([-6*mm,-3*mm, -1])cube([6*mm, 6*mm, ACRYLIC_THICKNESS + 2]);
      translate([-0*mm,-0*mm, -1])cube([6*mm, 6*mm, ACRYLIC_THICKNESS + 2]);
      }*/
  n_pointer=4;
  for(i=[0:n_pointer])rotate(a=i*360/n_pointer, v=[0, 0, 1])translate([70*mm,0*mm,0])pointer(thickness);
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
    scale([.995, .995, 1])
      cylinder(h=ACRYLIC_THICKNESS, r=70*mm);
difference() {
    cylinder(r=OUTER_RADIUS  +  MARGIN, h=ACRYLIC_THICKNESS + ACRYLIC_TOL);
    //cylinder(r=OUTER_RADIUS + 3, h=ACRYLIC_THICKNESS + ACRYLIC_TOL);
    translate([0, 0, -1])
      scale([1.00, 1.00, 1])gear(number_of_teeth=N_TEETH,
	   circular_pitch = PITCH,
	   gear_thickness = ACRYLIC_THICKNESS + ACRYLIC_TOL + 2,
	   rim_thickness = ACRYLIC_THICKNESS + ACRYLIC_TOL + 2,
	   hub_thickness = ACRYLIC_THICKNESS + ACRYLIC_TOL + 2,
	   bore_diameter=0. * mm,
	   circles=0,
	   pressure_angle=28,
	   backlash=0 // play with this
	   );
    cylinder(h=ACRYLIC_THICKNESS + ACRYLIC_TOL, r=OUTER_RADIUS-3.5); // trim teeth
  }
  }
  //for(i=[0:12])rotate(a=i*360/12, v=[0, 0, 1])translate([69*mm,-.8*mm,0])cube([3*mm, 1.6*mm, ACRYLIC_THICKNESS]);
  /* // quarter circles
    for(i=[0:12])rotate(a=i*360/12, v=[0, 0, 1])translate([69*mm,0*mm,0])
		   difference(){
	cylinder(r=3*mm, h = ACRYLIC_THICKNESS);
	translate([-6*mm,-3*mm, -1])cube([6*mm, 6*mm, ACRYLIC_THICKNESS + 2]);
	translate([-0*mm,-0*mm, -1])cube([6*mm, 6*mm, ACRYLIC_THICKNESS + 2]);
      }
  }
  */
}

module anti_lash_gear(minute, N_TEETH=30, h=ACRYLIC_THICKNESS, lash=0){
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
    intersection(){
      difference(){
	intersection(){
	  cylinder(r1=40, r2=26.5, h=ACRYLIC_THICKNESS); // taper the teeth
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
	    translate([0, 0, -1])scale([.95, .95, 1.5])gear(number_of_teeth=N_TEETH,
		 circular_pitch = PITCH,
		 gear_thickness = ACRYLIC_THICKNESS,
		 rim_thickness = ACRYLIC_THICKNESS, //   - ACRYLIC_TOL,
		 hub_thickness = ACRYLIC_THICKNESS, //  - ACRYLIC_TOL,
		 bore_diameter=0. * mm,
		 circles=0,
		 pressure_angle=28,
		 backlash=lash // play with this
		 );
	  }
	}
      translate([0, 0, -1])cylinder(r=6 * mm/2, h=ACRYLIC_THICKNESS + ACRYLIC_TOL + 2 + 100);

      // hollow out
      translate([0, 0, -1])cylinder(r=N_TEETH - 5, h=ACRYLIC_THICKNESS + ACRYLIC_TOL + 2 + 100);
    }
      translate([0, 0, -1])cylinder(r=OUTER_RADIUS - .5, h=100);
    }
    // add spokes
    difference(){
      union(){
	for(i=[0:4]){
	  // translate([0, 36 * mm, 0])rotate(a=360/5 * i + 3, v=[0, 0, 1])translate([-1 *mm, -27 * mm, 0])cube([2 * mm, 30 * mm, ACRYLIC_THICKNESS]);  // streight spokes
	  translate([0, 36 * mm, 0])rotate(a=360/5 * i + 3, v=[0, 0, 1])translate([0 *mm, 15 * mm, 0])difference(){
 	    cylinder(r=11 * mm, h = ACRYLIC_THICKNESS/2);
	    translate([0, 0, -1])cylinder(r=10.2 * mm, h = ACRYLIC_THICKNESS+2);
	    // translate([0, -12, -1])cube([12, 24, 2 * ACRYLIC_THICKNESS]);
	  }
	}
      }
      translate([0, 36*mm, -1])cylinder(r = 4*mm, h=ACRYLIC_THICKNESS+2);
    }
    union(){
    difference(){ // outer rim support
      translate([0, 36*mm, 0])cylinder(r = 1*inch, h=ACRYLIC_THICKNESS + 1.25);
      translate([0, 36*mm, -1])cylinder(r = inch - 1*mm, h=ACRYLIC_THICKNESS + 10);
    }
    difference(){ // inner hub support
      translate([0, 36*mm, 0])cylinder(r = 4.5*mm, h=ACRYLIC_THICKNESS + 1);
      translate([0, 36*mm, -2])cylinder(r = 3*mm, h=ACRYLIC_THICKNESS + 10);
     }
    /*
    translate([0, 36*mm, 0])
      intersection(){
      cylinder(r1=40, r2=26.5, h=ACRYLIC_THICKNESS); // taper the teeth
      difference(){ // outer rim tooth support
	cylinder(r=27, h=ACRYLIC_THICKNESS);
	translate([0, 0, -1])cylinder(r=1*inch, h=ACRYLIC_THICKNESS+2);
      }
    }
    */
    translate([0, 36*mm, 0])
      intersection(){
      cylinder(r1=40, r2=26.5, h=ACRYLIC_THICKNESS); // taper the teeth
      for(i=[0:N_TEETH]){
	rotate(v=[0, 0, 1],a=i * 360./N_TEETH + 180./N_TEETH)translate([25*mm, -.5*mm, 0])cube([1.5*mm, 1*mm, ACRYLIC_THICKNESS]);
      }
    }
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
    // rotate(-4, v=[0, 0,1])
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

module planet_gear(minute, N_TEETH=30, h=ACRYLIC_THICKNESS){
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

module second_hand(h=1.5*mm){
    r=9*mm / sqrt(2);
    rotate(a=90, v=[0, 0, 1])difference(){
    union(){
      translate([0, -1*mm, 0])linear_extrude(height=h)
	translate([0,8.2,0])scale([1.0,1,1])import("second_hand.dxf");
      translate([0, 0 * mm, 0])cylinder(r = 9.5*mm, h=h);
    }
    translate([0, 0, -1])cylinder(r=2. * mm, h=h + 100);
    for(i=[0:2]){
      translate([r*sin(i*180), r * cos(i*180), -1])cylinder(r=1.6*mm, h=h + 2);
    }
  }
}

module minute_hand(thickness, h, key_width){
  rotate(a=-90, v=[0, 0, 1])translate([0, 0, -3*thickness])difference(){
    union(){
      translate([0, h, -h])linear_extrude(height=h)translate([0,8.2,0])scale([1.,1.025,1])import("filagreeminute.dxf"); 
      translate([0, 0, -1*h])cylinder(r=11, h=2*h);
      translate([0, 0, -h]) rotate(a=180/6, v=[-0, 0, 1])my_gear(6, bore_d*mm, 4*h + thickness);
      translate([-key_width/2,-key_width/2,3*h+thickness])cube([key_width, key_width, thickness]); // keyed interface to 54 tooth gear
    }
    translate([0, 0, -1])cylinder(h=10*mm, r=bore_d/2);
  }
}

module hour_hand_old(thickness){
  h = thickness/2;
  rotate(a=-90, v=[0, 0, 1])translate([0, 0, -3*thickness])difference(){
    union(){
      translate([0, h, -h])linear_extrude(height=h)translate([0,8.2,0])scale([1.,1.025,1])import("filagreehour.dxf"); 
      translate([0, 36, -h])cylinder(r=4.0 * mm/2, h=h+.6*thickness);
      translate([0, 36, thickness-1*mm])scale([1, .8, 1])cylinder(r1=2.7 * mm, r2=2*mm, h=1*mm); // clip (r1=2.6 was too small)
      translate([0, 0, -h])cylinder(r=11, h=h);
    }
    translate([0, 0, -2*h - 1])cylinder(r=7.85, h=3*h);
    translate([-.5 * mm, 36 * mm-5 * mm, 0])cube([1 * mm, 10 * mm, 10 * mm]); // slot
    translate([0 * mm, 36 * mm * mm, 0])cylinder(r=3.12/2 * mm, h=30.15 * mm);// hall effect magnet slot
  }
}
module hour_hand(gear_thickness, hand_thickness){
  h = hand_thickness;
  rotate(a=-90, v=[0, 0, 1])translate([0, 0, -3 * gear_thickness])difference(){
    union(){
      translate([0, h, -h])linear_extrude(height=h)translate([0,8.2,0])scale([1.,1.025,1])import("filagreehour.dxf"); 
      translate([0, 36, -h ])cylinder(r=2.0 * mm, h=gear_thickness + hand_thickness);
      translate([0, 0, -h])cylinder(r=11, h=hand_thickness);
    }
    translate([0, 0, -2*h - 1])cylinder(r=7.85, h=hand_thickness + 2);
  }
}

HOUR = 9;
MINUTE = $t * 60;

bore_d = 5.3*mm;
screw_d = 3*mm;
gear_thickness = 2.4*mm;
acr_thickness = 3.5*mm; // was set to this for some reason
acr_thickness = 2.8*mm;
h=1.5*mm;
key_width = 8*mm;
explode = $t * 40; // 15*mm
explode = .1 * mm;
explode = 0;
/*
difference(){                                     // 1 Drive gear
  color([0, 0, 0])
union(){                   
  rotate(a=180/9, v=[0, 0, 1])translate([0, 0, - acr_thickness + 1*mm]){
    my_gear(9, bore_d, 2 * acr_thickness - 1*mm);
  }
  translate([2.5*mm - .55*mm, -3*mm, -acr_thickness + 1*mm])cube([2*mm, 6*mm, 2 * acr_thickness - 1*mm]);
}
  translate([0, 0, -3.2*mm])cylinder(r1=bore_d/2 + 1*mm, r2 = 0, h=4*mm);
}
// 2.1 reducing gear (acrylic) 50,5 with 3d printed inner gear
//scale(3.54331) //scale for svg file
translate([0, 0,  3* explode]) // explode
translate([0, 0,  0]) 
color([0, 1, 1])
translate([59, 0, 0])difference(){
  my_gear(50, bore_d, acr_thickness);
  translate([0,0,-1])scale([1.025, 1.025, 1])my_gear(5, screw_d, acr_thickness + 2);
}
// 2.2 bearing gear
// new bearing gear
translate([0, 0,  1 * acr_thickness]) 
color([0, 0, 0])translate([59, 0, 0*mm])union(){
    my_gear(5, screw_d, 2 * gear_thickness - .5*mm);
    translate([0, 0, -7 * mm])cylinder(h=7*mm, r=8.1*mm / 2);
  }

// 3.1 reducing gear (acr)
// scale(3.54331) //scale for svg file
translate([0, 0, 1 * explode]) // explode
color([1, 1, 0])translate([0, 0, gear_thickness + acr_thickness])difference(){
  my_gear(54, bore_d, acr_thickness);
  translate([0,0,-1])translate([-key_width/2, -key_width/2, 0])cube([key_width, key_width,acr_thickness + 2]);
}


translate([0, 0, 3 * explode]) // explode
translate([-36*mm, 0, 3*gear_thickness])             // 4 Planet gear
//rotate(v=[1, 0, 0], a=180)  // (flip for printing)
color([1, 0, 1])difference(){                      
  my_gear(30, bore_d, gear_thickness);
  translate([0, 0, -0.9*mm])cylinder(r=4.25*mm, h=2*mm);
}


translate([0, 0, 4 * explode]) // explode // 5 Hour hand
translate([0, 0, gear_thickness])
color([0, 1, 0])                               
rotate(v=[0, 1, 0], a=180)hour_hand(gear_thickness, hand_thickness=gear_thickness/3.);

// hour hand snap
translate([0, 0, 2 * acr_thickness])
color([0,1,0])translate([-39, 0, 0]) union(){
cylinder(r=5*mm, h=.3*mm);
difference(){
  cylinder(r=2.8 * mm, h=gear_thickness);
  translate([0, 0, -1])cylinder(r=2*mm, h=gear_thickness + 2);
}
}

translate([0, 0, 6 * explode]) // explode // 7 second hand
color([1, 0, 0])translate([0, 0, 5 * acr_thickness + .5 * gear_thickness])second_hand(h=gear_thickness/3.);
*/

// translate([0, 0, 5*gear_thickness]) // explode      // 8 Minute hand
translate([0, 0, 5 * explode]) // explode
translate([0, 0, gear_thickness])
translate([0, 0, gear_thickness])color([0, 0, 1])rotate(v=[0, 1, 0], a=180)minute_hand(gear_thickness, gear_thickness/3., key_width);
/*

// Stackup
/*
module mount_bores(radius, thickness){
  union(){
    translate([-90*mm, 0, 0])cylinder(h=thickness, r=radius);
    translate([0, 90*mm, 0])cylinder(h=thickness, r=radius);
    translate([0, -90*mm, 0])cylinder(h=thickness, r=radius);
    translate([118*mm, -81, 0])cylinder(h=thickness, r=radius);
    translate([118*mm, 81, 0])cylinder(h=thickness, r=radius);
  }
}

for(i=[-8:-6]){
  color([1, 1, 0])
    translate([0, 0, i * explode])
    translate([0, 0, i * acr_thickness])
    difference(){
    rotate(a=90, v=[0, 0,1])linear_extrude(height=acr_thickness)import("GearClock4_outline.dxf"); 
    rotate(a=45, v=[0,0,1])translate([-28.25*mm/2, -28.25*mm/2, -1])cube([28.25*mm, 28.25*mm, acr_thickness + 2]);
    translate([0, 0, -1])mount_bores(3.5*mm/2, acr_thickness+2);
  }
}

for(i=[-6:-2]){
  color([1, 0, 0])
    translate([0, 0, i * explode])
    translate([0, 0, i * acr_thickness])
    difference(){
    rotate(a=90, v=[0, 0,1])linear_extrude(height=acr_thickness)import("GearClock4_outline.dxf"); 
    rotate(a=45, v=[0,0,1])translate([-28.25*mm/2, -28.25*mm/2, -1])cube([28.25*mm, 28.25*mm, acr_thickness + 2]);
    translate([0, 0, -1])mount_bores(2.5*mm, acr_thickness+2);
  }
 }


color([1, 1, 1])
translate([0, 0, -explode])
translate([0, 0, -acr_thickness])
difference(){
  rotate(a=90, v=[0, 0,1])linear_extrude(height=acr_thickness)import("GearClock4_outline.dxf"); 
  translate([0, 0, -1])cylinder(h=acr_thickness + 2, r=25*mm/2);
  for(i=[0:3]){
    rotate(a=90*i, v=[0, 0, 1])translate([25*mm*sqrt(2)/2, 0, -1])cylinder(h=acr_thickness + 2, r=2.75*mm/2);
  }
  translate([0, 0, -1])mount_bores(2.5*mm, acr_thickness+2);
}
color([0, 0, 0])
translate([0, 0,  0])
difference(){
  rotate(a=90, v=[0, 0,1])linear_extrude(height=acr_thickness)import("GearClock4_outline.dxf"); 
  translate([0, 0, -1])cylinder(h=acr_thickness + 2, r=25*mm/2);
  for(i=[0:3]){
    rotate(a=90*i, v=[0, 0, 1])translate([25*mm*sqrt(2)/2, 0, -1])cylinder(h=acr_thickness + 2, r=5*mm/2);
  }
  translate([0, 0, -1])mount_bores(2.5*mm, acr_thickness+2);
}


color([1, 1, 1])
translate([0, 0,  1*explode])
translate([0, 0,  1*acr_thickness])
difference(){
  rotate(a=90, v=[0, 0,1])linear_extrude(height=acr_thickness)import("GearClock4_outline.dxf"); 
  translate([0, 0, -1])cylinder(h=acr_thickness + 2, r=25*mm/2);
  translate([0, 0, -1])mount_bores(2.5*mm, acr_thickness+2);
  translate([59*mm, 0, -1])cylinder(r=106*mm/2, h=acr_thickness+2);
}

color([0, 0, 0])
translate([0, 0,  2 * explode])
translate([0, 0,  2 * acr_thickness])
difference(){
  rotate(a=90, v=[0, 0,1])linear_extrude(height=acr_thickness)import("GearClock4_outline.dxf"); 
  translate([0, 0, -1])cylinder(h=acr_thickness + 2, r=25*mm/2);
  translate([0, 0, -1])mount_bores(3.5*mm / 2, acr_thickness+2);
  translate([0, 0, -1])cylinder(r=114*mm / 2, h=acr_thickness+2);
  translate([59*mm, 0, -1])cylinder(r=13*mm / 2, h=acr_thickness+2);
}

color([1, 1, 1])
translate([0, 0,  3 * explode])
translate([0, 0,  3 * acr_thickness])
difference(){
  rotate(a=90, v=[0, 0,1])linear_extrude(height=acr_thickness)import("GearClock4_outline.dxf"); 
  translate([0, 0, -1])cylinder(h=acr_thickness + 2, r=25*mm/2);
  translate([0, 0, -1])mount_bores(3.5*mm / 2, acr_thickness+2);
  translate([0, 0, -1])my_gear(66, 0, acr_thickness + 2);
}

color([0, 1, 1, .3])
translate([0, 0,  4 * explode])
translate([0, 0,  4 * acr_thickness])
difference(){
  rotate(a=90, v=[0, 0,1])linear_extrude(height=acr_thickness)import("GearClock4_outline.dxf"); 
  translate([0, 0, -1])cylinder(h=acr_thickness + 2, r=25*mm/2);
  translate([0, 0, -1])mount_bores(3.5*mm / 2, acr_thickness+2);
  translate([0, 0, -1])cylinder(r=126*mm / 2, h=acr_thickness+2);
}

*/
