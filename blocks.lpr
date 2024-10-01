program blocks;

{$mode objfpc}{$H+}

uses 
cmem, 
{uncomment if necessary}
//raymath, 
//rlgl, 
raylib, game, thing, constants, utils;

var
  thegame: TGame;

begin
  // Initialization
  thegame := TGame.Create;
  InitWindow(screenWidth, screenHeight, 'Blocks');
  SetTargetFPS(60);// Set our game to run at 60 frames-per-second

  // Main game loop
  while not WindowShouldClose do
    begin
      // Update
      thegame.Update;

      // Draw
      BeginDrawing;
        thegame.Draw;
        DrawFPS(900, 10);
      EndDrawing;
    end;

  // De-Initialization
  CloseWindow;        // Close window and OpenGL context
  theGame.Free;
end.

