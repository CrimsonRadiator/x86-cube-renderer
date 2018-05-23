#include <stdio.h>
#include <SDL2/SDL.h>

#include "renderer.h"

int main()
{
  int quit = 0;
  SDL_Event event;

  SDL_Init(SDL_INIT_VIDEO);

  SDL_Window * window = SDL_CreateWindow("x86-64 Cube Renderer",
      SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, CANVAS_SIZE, CANVAS_SIZE, 0);

  SDL_Renderer * renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);
 // SDL_Texture * texture = SDL_CreateTexture(renderer,
 //     SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_STATIC, CANVAS_SIZE, CANVAS_SIZE);
 // Uint32* pixels =malloc(CANVAS_SIZE* CANVAS_SIZE* sizeof(Uint32));
 // memset(pixels, 255, CANVAS_SIZE* CANVAS_SIZE* sizeof(Uint32));
  memset(canvas, 0, sizeof(canvas[0][0])*CANVAS_SIZE*CANVAS_SIZE); 
  printf("a");
  bresenham(11, 22, 40, 101);
  bresenham(13, 11, 111, 123);
  bresenham(222, 22, 33, 101);
  printf("b");
  //x y z
  float tr[3];
  float rt[3];
  int i;
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
      printf("%f %f %f   %f %f %f\n", tr[0],tr[1],tr[2],rt[0],rt[1],rt[2]);
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
