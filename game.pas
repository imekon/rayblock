unit game;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, raylib, thing, animator;

type

  { TGame }

  TGame = class
  private
    m_lives: integer;
    m_score: integer;
    m_blocks: TBlockList;
    m_ball: TBall;
    m_paddle: TPaddle;
    m_animator: TAnimator;
    procedure LoseALife;
    procedure ResetBall;
    procedure ResetLevel;
    procedure QueueBlockAnimation(x, y: double; colour: TColor);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Update;
    procedure Draw;
  end;

implementation

uses
  constants, utils;

{ TGame }

procedure TGame.LoseALife;
begin
  dec(m_lives);
  ResetBall;
end;

procedure TGame.ResetBall;
begin
  m_ball.X := Random(800) + 100;
  m_ball.Y := BALL_MARGIN;
  m_ball.DeltaY := -m_ball.Speed;
end;

procedure TGame.ResetLevel;
var
  block: TBlock;

begin
  for block in m_blocks do
    block.Visible := true;

  ResetBall;
  m_ball.Speed := m_ball.Speed + 1;
end;

procedure TGame.QueueBlockAnimation(x, y: double; colour: TColor);
var
  data: TBlockAnimateData;
  animation: TAnimate;
  source, dest: TColor;

begin
  data := TBlockAnimateData.Create(0);
  data.Initialise(x, y);
  source := ColorBrightness(colour, 0.7);
  dest := colour;
  dest.a := 0;
  animation := m_animator.AddAnimationColour(ANIM_EASEOUT, data, source, dest, 1);
  animation.Start;
end;

constructor TGame.Create;
var
  x, y: integer;
  block: TBlock;
  scoring: integer;
  colour: TColor;

begin
  Randomize;

  m_lives := 3;
  m_blocks := TBlockList.Create;

  for y := 0 to BLOCK_VERT_COUNT - 1 do
    for x := 0 to BLOCK_HORZ_COUNT - 1 do
      begin
        if y < 3 then
        begin
          colour := RED;
          scoring := 5;
        end
        else if y < 6 then
        begin
          colour := BLUE;
          scoring := 2;
        end
        else
        begin
          colour := GREEN;
          scoring := 1;
        end;

        block := TBlock.Create(scoring, colour);
        block.X := LEFT_MARGIN + x * (BLOCK_WIDTH + BLOCK_GAP);
        block.Y := TOP_MARGIN + y * (BLOCK_HEIGHT + BLOCK_GAP);
        m_blocks.Add(block);
      end;

  m_ball := TBall.Create;
  ResetBall;

  m_paddle := TPaddle.Create;
  m_paddle.X := 400;
  m_paddle.Y := PADDLE_MARGIN;

  m_animator := TAnimator.Create;
end;

destructor TGame.Destroy;
var
  block: TBlock;

begin
  m_paddle.Free;
  m_ball.Free;
  for block in m_blocks do
    block.Free;
  m_blocks.Free;
  m_animator.Free;
  inherited Destroy;
end;

procedure TGame.Update;
var
  delta: double;
  block: TBlock;
  vec: TVector2;
  val, center: double;
  counter: integer;

begin
  delta := GetFrameTime;

  m_ball.Update(delta);

  if (m_ball.X < 0) or (m_ball.X > screenWidth) then m_ball.DeltaX := -m_ball.DeltaX;
  if (m_ball.Y < 0) then m_ball.DeltaY := -m_ball.DeltaY;
  if (m_ball.Y > screenHeight) then
    LoseALife();

  vec := Vec2(m_ball.X, m_ball.Y);

  counter := 0;
  for block in m_blocks do
  begin
    if not block.Visible then continue;

    inc(counter);
    if CheckCollisionCircleRec(vec, BALL_RADIUS, block.Rect) then
    begin
      block.Visible := false;
      m_ball.DeltaY := -m_ball.DeltaY;
      m_score := m_score + block.Scoring * 10;
      QueueBlockAnimation(block.X, block.Y, block.Colour);
      exit;
    end;
  end;

  if CheckCollisionCircleRec(vec, BALL_RADIUS, m_paddle.Rect) then
  begin
    center := m_paddle.X + PADDLE_WIDTH / 2;
    val := m_ball.X - center;
    if abs(val) < 5 then m_ball.DeltaX := Random * 0.2 - 0.1
    else
      if val < 0 then m_ball.DeltaX := -m_ball.Speed else m_ball.DeltaX := m_ball.Speed;
    m_ball.DeltaY := -m_ball.DeltaY;
  end;

  m_paddle.X := GetMouseX;

  if counter = 0 then ResetLevel;

  m_animator.Update(delta);
end;

procedure TGame.Draw;
var
  colour: TColor;
  block: TBlock;

begin
  ClearBackground(GRAY);

  HideCursor;

  if m_lives > 0 then
  begin
    for block in m_blocks do
      block.Draw;

    m_paddle.Draw;
    m_ball.Draw;

    DrawText(PChar('Lives: ' + IntToStr(m_lives)), 10, 10, 20, WHITE);
    DrawText(PChar('Score: ' + IntToStr(m_score)), 10, 30, 20, WHITE);
  end
  else
  begin
    colour.r := 164;
    colour.g := 0;
    colour.b := 0;
    colour.a := 255;
    DrawText('GAME OVER', 150, 400, 120, colour);
  end;

  m_animator.Draw;
end;

end.

