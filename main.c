#include <stdio.h>
#include <SDL2/SDL.h>

#include "renderer.h"

int main()
{
  int quit = 0;
  float Cube[] = {0.5, 0.5, 0.5, 0.5, 0.5, -0.5, 0.5, -0.5, 0.5, 0.5, -0.5, -0.5, -0.5, 0.5, 0.5, -0.5, 0.5, -0.5, -0.5, -0.5, 0.5, -0.5, -0.5, -0.5};
  int lines[] = {2,0, 1,0, 4,0, 6,7, 5,7, 3,7, 3,1, 5,1, 3,2, 6,2, 6,4, 5,4};

  int coords[4];
  float Mrx[] = {1,0,0, 0,0,0, 0,0,0};
  float Mry[] = {0,0,0, 0,1,0, 0,0,0};
  float Mrz[] = {0,0,0, 0,0,0, 0,0,1};

  float M1[] = {1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0};
  float M2[] = {1.1, 3.2, 2.2, 4.4, 5.5, 7.7, 8.8, 8.8, 9.9};
  float M3[9];
  float R[9];

  float M4[] = {1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4};
  float V[4] = {0.5, 0.5, 0.5, 0};
  float VR[4];
  float a=0.0;
  int i,y,x;
  SDL_Event event;

  SDL_Init(SDL_INIT_VIDEO);

  SDL_Window * window = SDL_CreateWindow("x86-64 Cube Renderer",
      SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, CANVAS_SIZE, CANVAS_SIZE, 0);

  SDL_Renderer * renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);
  memset(canvas, 0, sizeof(canvas[0][0])*CANVAS_SIZE*CANVAS_SIZE); 

  
  matrix_multiplication_3x3(M3, M2, M1);

  //x y z
  enum axis{X=0, Y, Z}; 
  float translation[3];
  float rotation[3];
  for(i=0; i<3; ++i)
  {
    translation[i]=0.f;
    rotation[i]=0.f;
  }
    translation[Z] = 1.0f;
 
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
            translation[Y]-=0.03;
            break; 
          case SDLK_s:
            translation[Y]+=0.03;
            break;
          case SDLK_a:
            translation[X]-=0.03;
            break;
          case SDLK_d:
            translation[X]+=0.03;
            break;
          case SDLK_q:
            translation[Z]+=0.03;
            break;
          case SDLK_e:
            translation[Z]-=0.03;
            break;

          case SDLK_u:
            rotation[X]+=0.05;
            break; 
          case SDLK_j:
            rotation[X]-=0.05;
            break;
          case SDLK_h:
            rotation[Y]+=0.05;
            break;
          case SDLK_k:
            rotation[Y]-=0.05;
            break;
          case SDLK_y:
            rotation[Z]+=0.05;
            break;
          case SDLK_i:
            rotation[Z]-=0.05;
            break;
        }
      }
      printf("%f %f %f   %f %f %f\n", translation[0],translation[1],translation[2],rotation[0],rotation[1],rotation[2]);
    }
    
    //translation[X]=0.2;
    //translation[Y]=0.3;
    //translation[Z]=-0.4;
  
    memset(canvas, 0, sizeof(canvas[0][0])*CANVAS_SIZE*CANVAS_SIZE); 
    fill_Mrx(Mrx, &rotation[X]);
    fill_Mry(Mry, &rotation[Y]);
    fill_Mrz(Mrz, &rotation[Z]);
    fill_Projection(MProjection, translation);
 
    matrix_multiplication_3x3(M3, Mrx, Mrz);
    matrix_multiplication_3x3(MRotation, M3, Mry);
    //vector_matrix_multiplication_3x3(VR, R, V);
    for(i=0; i<24; i+=2) 
    {
      float *p = &Cube[lines[i]*3];
      V[0]=*p;
      V[1]=*(p+1);
      V[2]=*(p+2);
      V[3]=0;
      screen_coords(V, coords);
      int x0 = coords[0];
      int y0 = coords[1];

      p = &Cube[lines[i+1]*3];
      V[0]=*p;
      V[1]=*(p+1);
      V[2]=*(p+2);
      V[3]=0;
      screen_coords(V, coords);
      int x1 = coords[0];
      int y1 = coords[1];

      bresenham(x0, y0, x1, y1);    
    }        

    SDL_RenderClear(renderer);

  
    for(x=0; x<CANVAS_SIZE; ++x)
      for(y=0; y<CANVAS_SIZE; ++y)
          if(canvas[x][y])
            SDL_RenderDrawPoint(renderer, x, y);

    SDL_RenderPresent(renderer);
  ;}


  SDL_DestroyRenderer(renderer);
  SDL_DestroyWindow(window);
  SDL_Quit();
  return 0;
}
