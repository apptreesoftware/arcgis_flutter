import 'dart:math' as math;

//0	591,657,551.53
//1	295,828,775.76
//2	147,914,387.88
//3	73,957,193.94
//4	36,978,596.97
//5	18,489,298.49
//6	9,244,649.24
//7	4,622,324.62
//8	2,311,162.31
//9	1,155,581.16
//10	577,790.58
//11	288,895.29
//12	144,447.64
//13	72,223.82
//14	36,111.91
//15	18,055.96
//16	9,027.98
//17	4,513.99
//18	2,256.99
//19	1,128.50
double leafletZoomToEsriZoom(double leafletZoom) {
  return (5.92 * math.pow(10, 8)) * math.pow(math.e, -0.693 * leafletZoom);
}

double esriZoomToLeafletZoom(double esriZoom) {
  return 29.1 + -1.44*math.log(esriZoom);
}
