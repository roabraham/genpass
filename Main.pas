unit Main;

interface

uses
  LCLIntf, LCLType, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Spin, Math, Encode, vinfo;

type
  TMainForm = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    SpinEdit1: TSpinEdit;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    Edit1: TEdit;
    Image1: TImage;
    Memo1: TMemo;
    Button2: TButton;
    Button1: TButton;
    Bevel2: TBevel;
    GroupBox4: TGroupBox;
    CheckBox4: TCheckBox;
    SpinEdit2: TSpinEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    CheckBox5: TCheckBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure CheckBox5Click(Sender: TObject);
  private
    { Private declarations }
    PWLength : Integer;
    function GetRandomChar(x,y : Integer) : Char;
    function Strength(Password : String; Base : Integer) : Real;
    procedure CreatePassword;
    Procedure CheckStrength(Password : String; Base : Integer);
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

procedure TMainForm.FormCreate(Sender: TObject);
var version_info: TVersionInfo;
begin
Randomize;
version_info := TVersionInfo.Create;
version_info.Load(HINSTANCE);
Caption:=trim(Application.Title)+' v'+trim(version_info.FileVersion);
CreatePassword;
end;

procedure TMainForm.Button2Click(Sender: TObject);
begin
Close;
end;

function TMainForm.GetRandomChar(x,y : Integer) : Char;
var
  n: Integer;
  RES1: Char;
Begin
{ 0-9: 48-57;
  A-Z: 65-90;
  a-z: 97-122}
//Secure Values
RES1:=('A');
If (((x>=0) and (x<=61)) and ((y>=0) and (y<=61))) and (x<=y) then
Begin
//Generate Random Number
n:=Random((y-x)+1)+x;
If CheckBox1.Checked=True then
n:=((n+Random(Trunc(Date))) mod 62);
If CheckBox2.Checked=True then
n:=((n+Random(Trunc(Time*86400.0))) mod 62);
If n<x then
  n:=x
Else
  If n>y then
    n:=y;
//Get Assigned Character
RES1:=GetChar(n, False);
end;
GetRandomChar:=RES1;
end;

procedure TMainForm.CreatePassword;
var
  i,j,k,l,m,LEN : Integer;
  NEWCHAR,TTEXT : String;
  TCHAR : Char;
Begin
//Create Password
LEN:=SpinEdit1.Value;
TTEXT:=('');
For i:=1 to LEN Do
Begin
NEWCHAR:=GetRandomChar(0,61);
TTEXT:=(TTEXT+NEWCHAR);
end;
//Correction
j:=LEN div 3;
If j>=1 then
Begin
For i:=1 to j Do
Begin
k:=Random(LEN)+1;
NEWCHAR:=GetRandomChar(0,9);
TTEXT[k]:=NEWCHAR[1];
end;
end;
//Filtering
If CheckBox3.Checked=True then
Begin
If LEN>=2 then
Begin
l:=0;
For i:=1 to LEN-1 Do
Begin
m:=Max((LEN div 3),1);
For j:=i+1 to i+m Do
Begin
If (j>=1) and (j<=LEN) then
Begin
If TTEXT[i]=TTEXT[j] then
Begin
TCHAR:=TTEXT[j];
k:=GetCharCode(TCHAR, False);
Inc(l);
k:=k+l;
TCHAR:=GetChar(k, False);
TTEXT[j]:=TCHAR;
end;
end;
end;
end;
end;
end;
If CheckBox4.Checked=True then
Begin
//Create Serial Number
Edit1.Text:=('');
j:=SpinEdit2.Value;
For i:=1 to LEN Do
Begin
Edit1.Text:=Edit1.Text+UpCase(TTEXT[i]);
If ((i mod j)=0) and (i<LEN) then
Edit1.Text:=Edit1.Text+Edit2.Text;
end;
end
Else
Begin
//Simple Output
If CheckBox5.Checked=True then
Begin
If RadioButton1.Checked=True then
Edit1.Text:=UpperCase(TTEXT)
Else
Edit1.Text:=LowerCase(TTEXT);
end
Else
Edit1.Text:=TTEXT;
end;
end;

function TMainForm.Strength(Password : String; Base : Integer) : Real;
Var
  RES1,AVG1,AVG2,AVG3,CHR2 : Real;
  SRATE1,SRATE2,SRATE3 : Real;
  VARY1,BASE1,BASE2 : Real;
  CHR1 : Array of Integer;
  i,PLEN,Sim : Integer;
Begin
RES1:=0;
PLEN:=Length(Password);
If PLEN>=1 then
Begin
//Get Average Code
AVG1:=0;
AVG2:=0;
SetLength(CHR1,PLEN);
For i:=0 to PLEN-1 Do
Begin
CHR1[i]:=GetCharCode(Password[i+1], False);
AVG1:=AVG1+CHR1[i];
AVG2:=AVG2+1;
end;
AVG3:=AVG1/AVG2;
//Get Similarity Rate
Sim:=0;
For i:=0 to PLEN-1 Do
Begin
CHR2:=CHR1[i];
If (CHR2>=AVG3-(AVG3/2.0)) and (CHR2<=AVG3+(AVG3/2.0)) then
Inc(Sim);
end;
SRATE1:=Sim;
SRATE2:=PLEN;
SRATE3:=SRATE1/SRATE2;
//Strength-Ratio
VARY1:=(1.0-SRATE3);
BASE1:=Base;
BASE2:=SRATE2/BASE1;
RES1:=BASE2*VARY1;
If RES1>1.0 then
RES1:=1.0;
end;
Strength:=RES1;
end;

Procedure TMainForm.CheckStrength(Password : String; Base : Integer);
Var
  PWSTRNG : Real;
  RED,GREEN : Real;
  IWIDTH1,IWIDTH2 : Real;
  OPTEXT : String;
  PERCENT : Integer;
  OX1,OY1,OX2,OY2,OW,OH : Integer;
Begin
PWSTRNG:=Strength(Password, Base);
With Image1.Canvas Do
Begin
Pen.Color:=clBlack;
Brush.Color:=clBlack;
Rectangle(0,0,Image1.Width,Image1.Height);
RED:=Abs(255.0*(1.0-PWSTRNG));
GREEN:=Abs(255.0*PWSTRNG);
IWIDTH1:=Image1.Width;
IWIDTH2:=Max(IWIDTH1*PWSTRNG,4.0);
Brush.Color:=rgb(Trunc(RED),Trunc(GREEN),0);
Rectangle(0,0,Trunc(IWIDTH2),Image1.Height);
PERCENT:=Trunc(PWSTRNG*100.0);
Case PERCENT of
  0..10: OPTEXT:=('Very weak!');
  11..20: OPTEXT:=('Weak!');
  21..30: OPTEXT:=('Nothing special...');
  31..40: OPTEXT:=('Could be stronger...');
  41..60: OPTEXT:=('Medium');
  61..70: OPTEXT:=('Acceptable.');
  71..80: OPTEXT:=('Good.');
  81..90: OPTEXT:=('Very good!');
Else
  OPTEXT:=('Excellent!');
end;
OW:=TextWidth(OPTEXT);
OH:=TextHeight(OPTEXT);
OX1:=Abs((Image1.Width div 2)-(OW div 2));
OY1:=Abs((Image1.Height div 2)-(OH div 2));
OX2:=Abs((Image1.Width div 2)+(OW div 2));
OY2:=Abs((Image1.Height div 2)+(OH div 2));
Brush.Color:=clWhite;
Rectangle(Abs(OX1-4),Abs(OY1-4),Abs(OX2+4),Abs(OY2+4));
TextOut(OX1,OY1,OPTEXT);
Refresh;
end;
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
CreatePassword;
end;

procedure TMainForm.CheckBox4Click(Sender: TObject);
begin
If CheckBox4.Checked=True then
Begin
Label2.Enabled:=True;
SpinEdit2.Enabled:=True;
Label3.Enabled:=True;
Edit2.Enabled:=True;
PWLength:=SpinEdit1.Value;
SpinEdit1.Value:=25;
CheckBox5.Enabled:=False;
RadioButton1.Enabled:=False;
RadioButton2.Enabled:=False;
end
Else
Begin
Label2.Enabled:=False;
SpinEdit2.Enabled:=False;
Label3.Enabled:=False;
Edit2.Enabled:=False;
SpinEdit1.Value:=PWLength;
CheckBox5.Enabled:=True;
RadioButton1.Enabled:=CheckBox5.Checked;
RadioButton2.Enabled:=CheckBox5.Checked;
end;
end;

procedure TMainForm.Edit1Change(Sender: TObject);
Var PASSWD : String;
begin
//Check Password Strength
PASSWD:=Edit1.Text;
CheckStrength(PASSWD,10);
end;

procedure TMainForm.CheckBox5Click(Sender: TObject);
begin
If CheckBox5.Checked=True then
Begin
RadioButton1.Enabled:=True;
RadioButton2.Enabled:=True;
end
Else
Begin
RadioButton1.Enabled:=False;
RadioButton2.Enabled:=False;
end;
end;

end.
