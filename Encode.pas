{CHARACTER ENCODING UNIT
(Second Edition)
Written by: Robert Abraham;
Date: 2010/01/10.}
unit Encode;

interface

function GetCharCode(c: Char; FullAscii: Boolean): Integer;
function GetChar(Code: Integer; FullAscii: Boolean): Char;
function Encodable(c: Char; FullAscii: Boolean): Boolean;

implementation

function GetCharCode(c: Char; FullAscii: Boolean): Integer;
Var
  n,m : Integer;
Begin
{ 0-9: 48-57;
  A-Z: 65-90;
  a-z: 97-122}
m:=0;
If Encodable(c, FullAscii) then
Begin
n:=Ord(c);
If FullAscii=False then
Begin
  If (n>=48) and (n<=57) then
    m:=n-48
  Else
    If (n>=65) and (n<=90) then
      m:=(n-65)+10
    Else
      If (n>=97) and (n<=122) then
        m:=((n-97)+10)+26
      Else
        m:=30;
  If m<0 then
    m:=0
  Else
    If m>61 then
      m:=61;
end
Else
m:=n;
end;
GetCharCode:=m;
end;

function GetChar(Code: Integer; FullAscii: Boolean): Char;
Var
  n : Integer;
  NORM: Integer;
  RES1 : Char;
Begin
{ 0-9: 48-57;
  A-Z: 65-90;
  a-z: 97-122}
RES1:=('A');
n:=0;
//Secure Values
If FullAscii=False then
Begin
NORM:=(ABS(Code) mod 62);
If Code<0 then
  Code:=(ABS(62-NORM) mod 62)
Else
  If Code>61 then
    Code:=NORM;
//Convert Number to Character
If Code<=9 then
  n:=48+Code
Else
  If Code<=35 then
    n:=65+(Code-10)
  Else
    n:=97+(Code-36);
If n<0 then
  n:=0
Else
  If n>255 then
    n:=255;
end
Else
Begin
NORM:=(ABS(Code) mod 256);
If Code<0 then
  Code:=(ABS(256-NORM) mod 256)
Else
  If Code>255 then
    Code:=NORM;
n:=Code;
end;
RES1:=Chr(n);
GetChar:=RES1;
end;

function Encodable(c: Char; FullAscii: Boolean): Boolean;
Var
  RES1: Boolean;
  n: Integer;
Begin
n:=Ord(c);
If (((n>=48) and (n<=57)) or ((n>=65) and (n<=90)) or ((n>=97) and (n<=122))) or (FullAscii=True) then
RES1:=True
Else
RES1:=False;
Encodable:=RES1;
end;

end.
