unit thing;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, raylib, fgl, animator;

type

  { TThing }

  TThing = class
  private
    m_x, m_y: double;
    function GetX: integer;
    function GetY: integer;
    procedure SetX(AValue: integer);
    procedure SetY(AValue: integer);
  protected
    function GetColour: TColor; virtual; abstract;
    function GetRectangle: TRectangle; virtual; abstract;
  public
    constructor Create; virtual;
    procedure Update(delta: double); virtual; abstract;
    procedure Draw; virtual; abstract;

    property X: integer read GetX write SetX;
    property Y: integer read GetY write SetY;
    property Rect: TRectangle read GetRectangle;
  end;

  { TBlock }

  TBlock = class(TThing)
  private
    m_visible: boolean;
    m_colour: TColor;
    m_scoring: integer;
  protected
    function GetColour: TColor; override;
    function GetRectangle: TRectangle; override;
  public
    constructor Create(scoring: integer; colour: TColor);
    procedure Update(delta: double); override;
    procedure Draw; override;

    property Visible: boolean read m_visible write m_visible;
    property Scoring: integer read m_scoring;
    property Colour: TColor read m_colour;
  end;

  TBlockList = specialize TFPGList<TBlock>;

  { TBlockAnimateData }

  TBlockAnimateData = class(TAnimateData)
  private
    m_x, m_y: double;
  public
    constructor Create(w: integer); override;
    destructor Destroy; override;
    procedure Initialise(x, y: double);
    procedure Draw(animate: TAnimate); override;
    property X: double read m_x;
    property Y: double read m_y;
  end;

  { TBall }

  TBall = class(TThing)
  private
    m_radius: double;
    m_deltaX, m_deltaY, m_speed: double;
  protected
    function GetColour: TColor; override;
    function GetRectangle: TRectangle; override;
  public
    constructor Create; override;
    procedure Update(delta: double); override;
    procedure Draw; override;
    property DeltaX: double read m_deltaX write m_deltaX;
    property DeltaY: double read m_deltaY write m_deltaY;
    property Speed: double read m_speed write m_speed;
  end;

  { TPaddle }

  TPaddle = class(TThing)
  protected
    function GetColour: TColor; override;
    function GetRectangle: TRectangle; override;
  public
    constructor Create; override;
    procedure Update(delta: double); override;
    procedure Draw; override;
  end;

implementation

uses
  constants;

{ TThing }

function TThing.GetX: integer;
begin
  result := round(m_x);
end;

function TThing.GetY: integer;
begin
  result := round(m_y);
end;

procedure TThing.SetX(AValue: integer);
begin
  m_x := AValue;
end;

procedure TThing.SetY(AValue: integer);
begin
  m_y := AValue;
end;

constructor TThing.Create;
begin
  m_x := 0;
  m_y := 0;
end;

{ TBlock }

function TBlock.GetColour: TColor;
begin
  result := m_colour;
end;

function TBlock.GetRectangle: TRectangle;
begin
  result.x := m_x;
  result.y := m_y;
  result.width := BLOCK_WIDTH;
  result.height := BLOCK_HEIGHT;
end;

constructor TBlock.Create(scoring: integer; colour: TColor);
begin
  inherited Create;
  m_visible := true;
  m_scoring := scoring;
  m_colour := colour;
end;

procedure TBlock.Update(delta: double);
begin

end;

procedure TBlock.Draw;
begin
  if m_visible then
    DrawRectangle(X, Y, BLOCK_WIDTH, BLOCK_HEIGHT, m_colour);
end;

{ TBlockAnimateData }

constructor TBlockAnimateData.Create(w: integer);
begin
  inherited Create(w);
end;

destructor TBlockAnimateData.Destroy;
begin
  inherited Destroy;
end;

procedure TBlockAnimateData.Initialise(x, y: double);
begin
  m_x := x;
  m_y := y;
end;

procedure TBlockAnimateData.Draw(animate: TAnimate);
var
  animColour: TAnimateColour;

begin
  animColour := animate as TAnimateColour;
  DrawRectangle(round(m_x), round(m_y), BLOCK_WIDTH, BLOCK_HEIGHT, animColour.Where);
end;

{ TBall }

function TBall.GetColour: TColor;
begin
  result := WHITE;
end;

function TBall.GetRectangle: TRectangle;
begin
  result.x := m_x - BALL_RADIUS;
  result.y := m_y - BALL_RADIUS;
  result.width := BALL_RADIUS * 2;
  result.height := BALL_RADIUS * 2;
end;

constructor TBall.Create;
begin
  inherited Create;
  m_radius := 10;
  m_speed := 4;
  m_deltaX := m_speed;
  m_deltaY := -m_speed;
end;

procedure TBall.Update(delta: double);
begin
  m_x := m_x + m_deltaX;
  m_y := m_y + m_deltaY;
end;

procedure TBall.Draw;
begin
  DrawCircle(X, Y, m_radius, WHITE);
end;

{ TPaddle }

function TPaddle.GetColour: TColor;
begin
  result := YELLOW;
end;

function TPaddle.GetRectangle: TRectangle;
begin
  result.x := m_x;
  result.y := m_y;
  result.width := PADDLE_WIDTH;
  result.height := PADDLE_HEIGHT;
end;

constructor TPaddle.Create;
begin
  inherited Create;
end;

procedure TPaddle.Update(delta: double);
begin

end;

procedure TPaddle.Draw;
begin
  DrawRectangle(x, y, PADDLE_WIDTH, PADDLE_HEIGHT, GetColour);
end;

end.

