#include <stdio.h>
#include <SDL2/SDL.h>

#include "renderer.h"

int main()
{
  int quit = 0;
//  double Cube[] = {0.5, 0.5, 0.5, 0.5, 0.5, -0.5, 0.5, -0.5, 0.5, 0.5, -0.5, -0.5, -0.5, 0.5, 0.5, -0.5, 0.5, -0.5, -0.5, -0.5, 0.5, -0.5, -0.5, -0.5};
//  int lines[] = {0,2, 0,1, 0,4, 7,6, 7,5, 7,3, 1,3, 1,5, 2,3, 2,6, 4,6, 4,5};

  float Mrx[] = {1,0,0, 0,0,0, 0,0,0};
  float Mry[] = {0,0,0, 0,1,0, 0,0,0};
  float Mrz[] = {0,0,0, 0,0,0, 0,0,1};
  float VPM[] = {96,0,0,128, 0,96,0,128, 0,0,127.5, 127.5, 0,0,0,1};

  float M1[] = {1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0};
  float M2[] = {1.1, 3.2, 2.2, 4.4, 5.5, 7.7, 8.8, 8.8, 9.9};
  float M3[9];
  float R[9];

  float M4[] = {1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4};
  float V[4] = {0.5, 0.5, 0.5, 0};
  float VR[4];
  int i;
  float a=0.0;
  //SDL_Event event;

  //SDL_Init(SDL_INIT_VIDEO);

  //SDL_Window * window = SDL_CreateWindow("x86-64 Cube Renderer",
  //    SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, CANVAS_SIZE, CANVAS_SIZE, 0);

  //SDL_Renderer * renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);
  //memset(canvas, 0, sizeof(canvas[0][0])*CANVAS_SIZE*CANVAS_SIZE); 

  
  //matrix_multiplication_3x3(M3, M2, M1);

  //vector_matrix_multiplication_4x4(R, M4, V);  

  //printf("MV= %f %f %f %f", R[0], R[1], R[2], R[3]); 
  
  //int i;
  //for(i=0; i<9; ++i){
  //  if(i>0 && i%3==0)
  //    printf("\n");
  //  printf("%f ",M3[i]);
  //}

  //bresenham(11, 22, 40, 101);
  //bresenham(13, 11, 111, 123);
  //bresenham(222, 22, 33, 101);

  int z;
  float cpc;
  for(z=0; z<100; ++z){
     cpc = a;
     fpu_test(&a);
     printf("%d\n%f \n",z, a);
     a= cpc + 0.1;
  }

  //x y z
  enum axis{X=0, Y, Z}; 
  float tr[3];
  float rotation[3];
  for(i=0; i<3; ++i)
  {
    tr[i]=0.f;
    rotation[i]=0.f;
  }
 /*
  while (!quit)
  {
   // SDL_UpdateTexture(texture, NULL, pixels, CANVAS_SIZE* sizeof(Uint32));
    SDL_WaitEvent(NULL);
    while( SDL_PollEvent( &event ) != 0)
    {
      if( event.type == SDL_QUIT)
      {
        quit = 1;
        break;
      }
      else if(event.type == SDL_KEYDOWN)
      {
        switch ( event.key.keysym.sym )
        {
          case SDLK_w:
            tr[0]+=0.01;
            break; 
          case SDLK_s:
            tr[0]-=0.01;
            break;
          case SDLK_a:
            tr[1]+=0.01;
            break;
          case SDLK_d:
            tr[1]-=0.01;
            break;
          case SDLK_q:
            tr[2]+=0.01;
            break;
          case SDLK_e:
            tr[2]-=0.01;
            break;

          case SDLK_u:
            rotation[X]+=0.01;
            break; 
          case SDLK_j:
            rotation[X]-=0.01;
            break;
          case SDLK_h:
            rotation[Y]+=0.01;
            break;
          case SDLK_k:
            rotation[Y]-=0.01;
            break;
          case SDLK_y:
            rotation[Z]+=0.01;
            break;
          case SDLK_i:
            rotation[Z]-=0.01;
            break;
        }
      }
      //printf("%f %f %f   %f %f %f\n", tr[0],tr[1],tr[2],rotation[0],rotation[1],rotation[2]);
    }
    */  
    rotation[X]=0.2;
    rotation[Y]=0.3;
    rotation[Z]=0.4;
  
    fill_Mrx(Mrx, &rotation[X]);
    fill_Mry(Mry, &rotation[Y]);
    fill_Mrz(Mrz, &rotation[Z]);
    int x;
     printf("\n\n");
    for(x=0; x<9; ++x)
    {
        printf("%f ", Mrx[x]);
        if(x%3==2)
        printf("\n");
    }
  
        printf("\n\n");
    for(x=0; x<9; ++x)
    {
        printf("%f ", Mry[x]);
        if(x%3==2)
        printf("\n");
    }
     printf("\n\n");
    for(x=0; x<9; ++x)
    {
        printf("%f ", Mrz[x]);
        if(x%3==2)
        printf("\n");
    }
 
    matrix_multiplication_3x3(M3, Mrx, Mrz);
    matrix_multiplication_3x3(R, M3, Mry);
    vector_matrix_multiplication_3x3(VR, R, V);

    printf(">%f %f %f<", VR[0], VR[1], VR[2]);

    //SDL_RenderClear(renderer);

    printf("\n\n");
    for(x=0; x<9; ++x)
    {
        printf("%f ", R[x]);
        if(x%3==2)
        printf("\n");
    }
  
   // for(x=0; x<CANVAS_SIZE; ++x)
   //   for(y=0; y<CANVAS_SIZE; ++y)
   //       if(canvas[x][y])
   //         SDL_RenderDrawPoint(renderer, x, y);

   // SDL_RenderPresent(renderer);
  //}


 // SDL_DestroyRenderer(renderer);
 // SDL_DestroyWindow(window);
 // SDL_Quit();

  return 0;
}
