#define CANVAS_SIZE 256
char canvas[CANVAS_SIZE][CANVAS_SIZE];
float calculate_sin_using_Taylor(float x);
float calculate_cos_using_Taylor(float x);
void fill_rx_matrix();
void fill_ry_matrix();
void fill_rz_matrix();
void create_rotation_matrix();

void bresenham(int x1, int y1, int x2, int y2);
