{CHARACTER ENCODING UNIT
(Second Edition)
Written by: Robert Abraham;
Date: 2010/01/10.}
unit Encode;

interface

function GetCharCode (c: Char; FullAscii: Boolean): Integer;
function GetChar (Code: Integer; FullAscii: Boolean): Char;
function Encodable (c: Char; FullAscii: Boolean): Boolean;

implementation

function GetCharCode (c: Char; FullAscii: Boolean): Integer;
var
  n, m: Integer;
begin
{ 0-9: 48-57;
  A-Z: 65-90;
  a-z: 97-122}
  m := 0;
  if Encodable(c, FullAscii) then
  begin
    n := Ord(c);
    if FullAscii = False then
    begin
      if (n >= 48) and (n <= 57) then
        m := n - 48
      else if (n >= 65) and (n <= 90) then
        m := (n - 65) + 10
      else if (n >= 97) and (n <= 122) then
        m := ((n - 97) + 10) + 26
      else
        m := 30;
      if m < 0 then
        m := 0
      else if m > 61 then
        m := 61;
    end
    else
      m := n;
  end;
  GetCharCode := m;
end;

function GetChar (Code: Integer; FullAscii: Boolean): Char;
var
  n: Integer;
  NORM: Integer;
  RES1: Char;
begin
{ 0-9: 48-57;
  A-Z: 65-90;
  a-z: 97-122}
  RES1 := ('A');
  n := 0;
  //Secure Values
  if FullAscii = False then
  begin
    NORM := (ABS(Code) mod 62);
    if Code < 0 then
      Code := (ABS(62 - NORM) mod 62)
    else if Code > 61 then
      Code := NORM;
    //Convert Number to Character
    if Code <= 9 then
      n := 48 + Code
    else if Code <= 35 then
      n := 65 + (Code - 10)
    else
      n := 97 + (Code - 36);
    if n < 0 then
      n := 0
    else if n > 255 then
      n := 255;
  end
  else begin
    NORM := (ABS(Code) mod 256);
    if Code < 0 then
      Code := (ABS(256 - NORM) mod 256)
    else if Code > 255 then
      Code := NORM;
    n := Code;
  end;
  RES1 := Chr(n);
  GetChar := RES1;
end;

function Encodable (c: Char; FullAscii: Boolean): Boolean;
var
  RES1: Boolean;
  n: Integer;
begin
  n := Ord(c);
  if (((n >= 48) and (n <= 57)) or ((n >= 65) and (n <= 90)) or ((n >= 97) and (n <= 122))) or (FullAscii = True) then
    RES1 := True
  else
    RES1 := False;
  Encodable := RES1;
end;

end.
