unit utils;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, raylib;

  function Vec2(x, y: double): TVector2;

implementation

function Vec2(x, y: double): TVector2;
begin
  result.x := x;
  result.y := y;
end;

end.

