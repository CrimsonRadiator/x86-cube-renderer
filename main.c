#include <stdio.h>
#include <SDL2/SDL.h>

#include "renderer.h"

int main()
{
  int quit = 0;
//  double Cube[] = {0.5, 0.5, 0.5, 0.5, 0.5, -0.5, 0.5, -0.5, 0.5, 0.5, -0.5, -0.5, -0.5, 0.5, 0.5, -0.5, 0.5, -0.5, -0.5, -0.5, 0.5, -0.5, -0.5, -0.5};
//  int lines[] = {0,2, 0,1, 0,4, 7,6, 7,5, 7,3, 1,3, 1,5, 2,3, 2,6, 4,6, 4,5};

  float M1[] = {1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0};
  float M2[] = {1.1, 3.2, 2.2, 4.4, 5.5, 7.7, 8.8, 8.8, 9.9};
  float M3[9];

  float M4[] = {1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4};
  float R[4];
  float V[4] = {1.0, 2.0, 3.0, 4.0};
  SDL_Event event;

  SDL_Init(SDL_INIT_VIDEO);

  SDL_Window * window = SDL_CreateWindow("x86-64 Cube Renderer",
      SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, CANVAS_SIZE, CANVAS_SIZE, 0);

  SDL_Renderer * renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);
  memset(canvas, 0, sizeof(canvas[0][0])*CANVAS_SIZE*CANVAS_SIZE); 

  
  matrix_multiplication_3x3(M3, M2, M1);

  vector_matrix_multiplication_4x4(R, M4, V);  

  printf("MV= %f %f %f %f", R[0], R[1], R[2], R[3]); 
  
  int i;
  for(i=0; i<9; ++i){
    if(i>0 && i%3==0)
      printf("\n");
    printf("%f ",M3[i]);
  }

  //bresenham(11, 22, 40, 101);
  //bresenham(13, 11, 111, 123);
  //bresenham(222, 22, 33, 101);



  //x y z
  float tr[3];
  float rt[3];
  for(i=0; i<3; ++i)
  {
    tr[i]=0.f;
    rt[i]=0.f;
  }
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
            rt[0]+=0.01;
            break; 
          case SDLK_j:
            rt[0]-=0.01;
            break;
          case SDLK_h:
            rt[1]+=0.01;
            break;
          case SDLK_k:
            rt[1]-=0.01;
            break;
          case SDLK_y:
            rt[2]+=0.01;
            break;
          case SDLK_i:
            rt[2]-=0.01;
            break;
        }
      }
      //printf("%f %f %f   %f %f %f\n", tr[0],tr[1],tr[2],rt[0],rt[1],rt[2]);
    }
    SDL_RenderClear(renderer);
    int x;
    int y;
    for(x=0; x<CANVAS_SIZE; ++x)
      for(y=0; y<CANVAS_SIZE; ++y)
          if(canvas[x][y])
            SDL_RenderDrawPoint(renderer, x, y);

    SDL_RenderPresent(renderer);
  }


  SDL_DestroyRenderer(renderer);
  SDL_DestroyWindow(window);
  SDL_Quit();

  return 0;
}
