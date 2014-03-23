$fn=100;

mm = 1;
inch = 25.4 * mm;

MOON_R = 50 * mm;
THICKNESS = 2 * mm;

TOL = .1 * mm;

MAGNET_R = 1./8 * inch / 2 + TOL;
MAGNET_H = 1./8 * inch;
N_MAGNET = 28;

module magnet(){
  rotate(v=[0, 1, 0], a=90)cylinder(r=MAGNET_R, h=MAGNET_H + THICKNESS);
}

module magnet_ring(r, n_magnet){
  dtheta = 360. / n_magnet;
  translate([0, 0, -1])cylinder(r=r - 2 * (THICKNESS + MAGNET_R),h=2 * (THICKNESS + MAGNET_R) + 2);
  for(i=[0:n_magnet]){
    rotate(v=[0, 0, 1], a=dtheta * i)translate([-r+THICKNESS, 0, (THICKNESS + MAGNET_R)])magnet();
  }
}
module magnet_support(r, n_magnet){
  translate([0, 0, -(THICKNESS + MAGNET_R)])
    difference(){
    cylinder(r=r - THICKNESS, h=2 * (THICKNESS + MAGNET_R));
    magnet_ring(r, n_magnet);
  }
}

module bottom(){
  difference(){
    union(){
      sphere(r=MOON_R);
    }
    union(){
      sphere(r=MOON_R - THICKNESS);
      translate([-MOON_R, -MOON_R, -MAGNET_R]) cube(2 * MOON_R + 1);
    }
  }
}
module top(){
  difference(){
    union(){
      sphere(r=MOON_R);
    }
    union(){
      sphere(r=MOON_R - THICKNESS);
      translate([-MOON_R, -MOON_R, -2 * MOON_R]) cube(2 * MOON_R + 1);
      magnet_ring();
    }
  }
}

module moon(){
  difference(){
    union(){
      translate([0, 0, MOON_R/4])top();
      bottom();
      magnet_support(MOON_R, N_MAGNET);
    }
    union(){
    }
  }
}

module gear(r, n_tooth=8){
  magnet_support(r, n_tooth);
}

// moon();
gear(MOON_R, N_MAGNET);
GEAR_RATIO = 4;
GEAR_R = MOON_R / GEAR_RATIO;
translate([-MOON_R - GEAR_R, 0, 0])gear(GEAR_R, N_MAGNET / GEAR_RATIO);
