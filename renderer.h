#define CANVAS_SIZE 256
char canvas[CANVAS_SIZE][CANVAS_SIZE];
void fill_Mrx(float* array, float* r);
void fill_Mry(float* array, float* r);
void fill_Mrz(float* array, float* r);
void create_rotation_matrix();

void bresenham(int x1, int y1, int x2, int y2);
//C=AxB
void matrix_multiplication_3x3(float* C, float* B, float*A);
void vector_matrix_multiolication_4x4(float *M, float*V, float R);
void vector_matrix_multiolication_3x3(float *M, float*V, float R);
void fpu_test(float* a);
