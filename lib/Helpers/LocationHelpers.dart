import 'dart:math' as math;

double meterDistanceBetweenPoints(double lat_a, double lng_a, double lat_b, double lng_b) {
  double pk = (180.0/math.pi);

  double a1 = lat_a / pk;
  double a2 = lng_a / pk;
  double b1 = lat_b / pk;
  double b2 = lng_b / pk;

  double t1 = math.cos(a1) * math.cos(a2) * math.cos(b1) * math.cos(b2);
  double t2 = math.cos(a1) * math.sin(a2) * math.cos(b1) * math.sin(b2);
  double t3 = math.sin(a1) * math.sin(b1);
  double tt = math.acos(t1 + t2 + t3);

  return 6366000 * tt;
}