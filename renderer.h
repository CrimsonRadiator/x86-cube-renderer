#define CANVAS_SIZE 256
char canvas[CANVAS_SIZE][CANVAS_SIZE];
float MViewPort[] = {96,0,0,128, 0,96,0,128, 0,0,127.5, 127.5, 0,0,0,1};
float MProjection[] = {1,0,0,0,  0,1,0,0,  0,0,1,0,  0,0,-0.3333333,1};
float MRotation[9];

void fill_Mrx(float* array, float* r);
void fill_Mry(float* array, float* r);
void fill_Mrz(float* array, float* r);
void fill_Projection(float* array, float* r);
void create_rotation_matrix();

void bresenham(int x1, int y1, int x2, int y2);
//C=AxB
void matrix_multiplication_3x3(float* C, float* B, float*A);
void vector_matrix_multiplication_4x4(float *M, float*V, float R);
void vector_matrix_multiplication_3x3(float *M, float*V, float R);
void screen_coords(float *V, int* coords);
void fpu_test(float* a);
