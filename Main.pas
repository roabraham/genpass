unit Main;

interface

uses
  LCLIntf, LCLType, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Spin, DOM, XMLWrite, XMLRead, Math, Encode, vinfo;

type

  { TMainForm }

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
    procedure CheckBox4Change(Sender: TObject);
    procedure CheckBox5Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate (Sender: TObject);
    procedure Button2Click (Sender: TObject);
    procedure Button1Click (Sender: TObject);
    procedure Edit1Change (Sender: TObject);
  private
    { Private declarations }
    PWLength: Integer;
    function GetRandomChar (x, y: Integer): Char;
    function Strength (Password: String; Base: Integer): Real;
    procedure CreatePassword;
    procedure CheckStrength (Password: String; Base: Integer);
  public
    { Public declarations }
    config_filepath: ansistring;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

procedure TMainForm.FormCreate (Sender: TObject);
var
  version_info: TVersionInfo;
  XMLDoc: TXMLDocument;
  RootNode, SettingsNode: TDOMNode;
  SettingNode: TDOMNode;
begin
  Randomize;
  version_info := TVersionInfo.Create;
  version_info.Load(HINSTANCE);
  Caption := trim(Application.Title) + ' v' + trim(version_info.FileVersion);
  config_filepath := extractfilepath(Application.ExeName)+'config.xml';
  if fileexists(config_filepath) then
  begin
    try
      ReadXMLFile(XMLDoc, config_filepath);
      RootNode := XMLDoc.DocumentElement;
      SettingsNode := RootNode.FindNode('FormSettings');
      if Assigned(SettingsNode) then
      begin
        SettingNode := SettingsNode.FindNode('SpinEdit1Value');
        if Assigned(SettingNode) then SpinEdit1.Value := StrToIntDef(SettingNode.TextContent, SpinEdit1.MinValue);
        SettingNode := SettingsNode.FindNode('CheckBox1Checked');
        if Assigned(SettingNode) then CheckBox1.Checked := StrToBoolDef(SettingNode.TextContent, False);
        SettingNode := SettingsNode.FindNode('CheckBox2Checked');
        if Assigned(SettingNode) then CheckBox2.Checked := StrToBoolDef(SettingNode.TextContent, False);
        SettingNode := SettingsNode.FindNode('CheckBox3Checked');
        if Assigned(SettingNode) then CheckBox3.Checked := StrToBoolDef(SettingNode.TextContent, False);
        SettingNode := SettingsNode.FindNode('CheckBox4Checked');
        if Assigned(SettingNode) then CheckBox4.Checked := StrToBoolDef(SettingNode.TextContent, False);
        SettingNode := SettingsNode.FindNode('CheckBox5Checked');
        if Assigned(SettingNode) then CheckBox5.Checked := StrToBoolDef(SettingNode.TextContent, False);
        SettingNode := SettingsNode.FindNode('RadioButton1Checked');
        if Assigned(SettingNode) then RadioButton1.Checked := StrToBoolDef(SettingNode.TextContent, False);
        SettingNode := SettingsNode.FindNode('RadioButton2Checked');
        if Assigned(SettingNode) then RadioButton2.Checked := StrToBoolDef(SettingNode.TextContent, False);
        SettingNode := SettingsNode.FindNode('SpinEdit2Value');
        if Assigned(SettingNode) then SpinEdit2.Value := StrToIntDef(SettingNode.TextContent, SpinEdit2.MinValue);
        SettingNode := SettingsNode.FindNode('Edit2Text');
        if Assigned(SettingNode) then Edit2.Text := SettingNode.TextContent;
      end;
    finally
      XMLDoc.Free;
    end;
  end;
  CreatePassword;
end;

procedure TMainForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var
  XMLDoc: TXMLDocument;
  RootNode, SettingsNode, SettingNode: TDOMElement;
begin
  try
    // Create a new XML document
    XMLDoc := TXMLDocument.Create;
    // Create root node and add to document
    RootNode := XMLDoc.CreateElement('Configuration');
    XMLDoc.AppendChild(RootNode);
    RootNode := XMLDoc.DocumentElement;
    // Create a node to hold the settings
    SettingsNode := XMLDoc.CreateElement('FormSettings');
    RootNode.AppendChild(SettingsNode);
    // Add SpinEdit1 value in a separate node
    SettingNode := XMLDoc.CreateElement('SpinEdit1Value');
    SettingNode.TextContent := IntToStr(SpinEdit1.Value);
    SettingsNode.AppendChild(SettingNode);
    // Add CheckBox1 value in a separate node
    SettingNode := XMLDoc.CreateElement('CheckBox1Checked');
    SettingNode.TextContent := BoolToStr(CheckBox1.Checked, True);
    SettingsNode.AppendChild(SettingNode);
    // Add CheckBox2 value in a separate node
    SettingNode := XMLDoc.CreateElement('CheckBox2Checked');
    SettingNode.TextContent := BoolToStr(CheckBox2.Checked, True);
    SettingsNode.AppendChild(SettingNode);
    // Add CheckBox3 value in a separate node
    SettingNode := XMLDoc.CreateElement('CheckBox3Checked');
    SettingNode.TextContent := BoolToStr(CheckBox3.Checked, True);
    SettingsNode.AppendChild(SettingNode);
    // Add CheckBox4 value in a separate node
    SettingNode := XMLDoc.CreateElement('CheckBox4Checked');
    SettingNode.TextContent := BoolToStr(CheckBox4.Checked, True);
    SettingsNode.AppendChild(SettingNode);
    // Add CheckBox5 value in a separate node
    SettingNode := XMLDoc.CreateElement('CheckBox5Checked');
    SettingNode.TextContent := BoolToStr(CheckBox5.Checked, True);
    SettingsNode.AppendChild(SettingNode);
    // Add RadioButton1 value in a separate node
    SettingNode := XMLDoc.CreateElement('RadioButton1Checked');
    SettingNode.TextContent := BoolToStr(RadioButton1.Checked, True);
    SettingsNode.AppendChild(SettingNode);
    // Add RadioButton2 value in a separate node
    SettingNode := XMLDoc.CreateElement('RadioButton2Checked');
    SettingNode.TextContent := BoolToStr(RadioButton2.Checked, True);
    SettingsNode.AppendChild(SettingNode);
    // Add SpinEdit2 value in a separate node
    SettingNode := XMLDoc.CreateElement('SpinEdit2Value');
    SettingNode.TextContent := IntToStr(SpinEdit2.Value);
    SettingsNode.AppendChild(SettingNode);
    // Add Edit2.Text value in a separate node
    SettingNode := XMLDoc.CreateElement('Edit2Text');
    SettingNode.TextContent := Edit2.Text;
    SettingsNode.AppendChild(SettingNode);
    WriteXMLFile(XMLDoc, config_filepath);
  finally
    XMLDoc.Free;
  end;
end;

procedure TMainForm.CheckBox5Change(Sender: TObject);
begin
  if CheckBox5.Checked = True then
  begin
    RadioButton1.Enabled := True;
    RadioButton2.Enabled := True;
  end
  else begin
    RadioButton1.Enabled := False;
    RadioButton2.Enabled := False;
  end;
end;

procedure TMainForm.CheckBox4Change(Sender: TObject);
begin
  if CheckBox4.Checked = True then
  begin
    Label2.Enabled := True;
    SpinEdit2.Enabled := True;
    Label3.Enabled := True;
    Edit2.Enabled := True;
    PWLength := SpinEdit1.Value;
    SpinEdit1.Value := 25;
    CheckBox5.Enabled := False;
    RadioButton1.Enabled := False;
    RadioButton2.Enabled := False;
  end
  else begin
    Label2.Enabled := False;
    SpinEdit2.Enabled := False;
    Label3.Enabled := False;
    Edit2.Enabled := False;
    SpinEdit1.Value := PWLength;
    CheckBox5.Enabled := True;
    RadioButton1.Enabled := CheckBox5.Checked;
    RadioButton2.Enabled := CheckBox5.Checked;
  end;
end;

procedure TMainForm.Button2Click (Sender: TObject);
begin
  Close;
end;

function TMainForm.GetRandomChar (x, y: Integer): Char;
var
  n: Integer;
  RES1: Char;
begin
{ 0-9: 48-57;
  A-Z: 65-90;
  a-z: 97-122}
  //Secure Values
  RES1 := ('A');
  if (((x >= 0) and (x <= 61)) and ((y >= 0) and (y <= 61))) and (x <= y) then
  begin
    //Generate Random Number
    n := Random((y - x) + 1) + x;
    if CheckBox1.Checked = True then
      n := ((n + Random(Trunc(Date))) mod 62);
    if CheckBox2.Checked = True then
      n := ((n + Random(Trunc(Time * 86400.0))) mod 62);
    if n < x then
      n := x
    else if n > y then
      n := y;
    //Get Assigned Character
    RES1 := GetChar(n, False);
  end;
  GetRandomChar := RES1;
end;

procedure TMainForm.CreatePassword;
var
  i, j, k, l, m, LEN: Integer;
  NEWCHAR, TTEXT: String;
  TCHAR: Char;
begin
  //Create Password
  LEN := SpinEdit1.Value;
  TTEXT := ('');
  for i := 1 to LEN do
  begin
    NEWCHAR := GetRandomChar(0, 61);
    TTEXT := (TTEXT + NEWCHAR);
  end;
  //Correction
  j := LEN div 3;
  if j >= 1 then
    for i := 1 to j do
    begin
      k := Random(LEN) + 1;
      NEWCHAR := GetRandomChar(0, 9);
      TTEXT[k] := NEWCHAR[1];
    end;
  //Filtering
  if CheckBox3.Checked = True then
    if LEN >= 2 then
    begin
      l := 0;
      for i := 1 to LEN - 1 do
      begin
        m := Max((LEN div 3), 1);
        for j := i + 1 to i + m do
          if (j >= 1) and (j <= LEN) then
            if TTEXT[i] = TTEXT[j] then
            begin
              TCHAR := TTEXT[j];
              k := GetCharCode(TCHAR, False);
              Inc(l);
              k := k + l;
              TCHAR := GetChar(k, False);
              TTEXT[j] := TCHAR;
            end;
      end;
    end;
  if CheckBox4.Checked = True then
  begin
    //Create Serial Number
    Edit1.Text := ('');
    j := SpinEdit2.Value;
    for i := 1 to LEN do
    begin
      Edit1.Text := Edit1.Text + UpCase(TTEXT[i]);
      if ((i mod j) = 0) and (i < LEN) then
        Edit1.Text := Edit1.Text + Edit2.Text;
    end;
  end
  else if CheckBox5.Checked = True then
  begin
    if RadioButton1.Checked = True then
      Edit1.Text := UpperCase(TTEXT)
    else
      Edit1.Text := LowerCase(TTEXT);
  end
  else
    Edit1.Text := TTEXT//Simple Output
  ;
end;

function TMainForm.Strength (Password: String; Base: Integer): Real;
var
  RES1, AVG1, AVG2, AVG3, CHR2: Real;
  SRATE1, SRATE2, SRATE3: Real;
  VARY1, BASE1, BASE2: Real;
  CHR1: array of Integer;
  i, PLEN, Sim: Integer;
begin
  RES1 := 0;
  PLEN := Length(Password);
  if PLEN >= 1 then
  begin
    //Get Average Code
    AVG1 := 0;
    AVG2 := 0;
    SetLength(CHR1, PLEN);
    for i := 0 to PLEN - 1 do
    begin
      CHR1[i] := GetCharCode(Password[i + 1], False);
      AVG1 := AVG1 + CHR1[i];
      AVG2 := AVG2 + 1;
    end;
    AVG3 := AVG1 / AVG2;
    //Get Similarity Rate
    Sim := 0;
    for i := 0 to PLEN - 1 do
    begin
      CHR2 := CHR1[i];
      if (CHR2 >= AVG3 - (AVG3 / 2.0)) and (CHR2 <= AVG3 + (AVG3 / 2.0)) then
        Inc(Sim);
    end;
    SRATE1 := Sim;
    SRATE2 := PLEN;
    SRATE3 := SRATE1 / SRATE2;
    //Strength-Ratio
    VARY1 := (1.0 - SRATE3);
    BASE1 := Base;
    BASE2 := SRATE2 / BASE1;
    RES1 := BASE2 * VARY1;
    if RES1 > 1.0 then
      RES1 := 1.0;
  end;
  Strength := RES1;
end;

procedure TMainForm.CheckStrength (Password: String; Base: Integer);
var
  PWSTRNG: Real;
  RED, GREEN: Real;
  IWIDTH1, IWIDTH2: Real;
  OPTEXT: String;
  PERCENT: Integer;
  OX1, OY1, OX2, OY2, OW, OH: Integer;
begin
  PWSTRNG := Strength(Password, Base);
  with Image1.Canvas do
  begin
    Pen.Color := clBlack;
    Brush.Color := clBlack;
    Rectangle(0, 0, Image1.Width, Image1.Height);
    RED := Abs(255.0 * (1.0 - PWSTRNG));
    GREEN := Abs(255.0 * PWSTRNG);
    IWIDTH1 := Image1.Width;
    IWIDTH2 := Max(IWIDTH1 * PWSTRNG, 4.0);
    Brush.Color := rgb(Trunc(RED), Trunc(GREEN), 0);
    Rectangle(0, 0, Trunc(IWIDTH2), Image1.Height);
    PERCENT := Trunc(PWSTRNG * 100.0);
    case PERCENT of
    0..10: OPTEXT := ('Very weak!');
    11..20: OPTEXT := ('Weak!');
    21..30: OPTEXT := ('Nothing special...');
    31..40: OPTEXT := ('Could be stronger...');
    41..60: OPTEXT := ('Medium');
    61..70: OPTEXT := ('Acceptable.');
    71..80: OPTEXT := ('Good.');
    81..90: OPTEXT := ('Very good!');
    else
      OPTEXT := ('Excellent!');
    end;
    OW := TextWidth(OPTEXT);
    OH := TextHeight(OPTEXT);
    OX1 := Abs((Image1.Width div 2) - (OW div 2));
    OY1 := Abs((Image1.Height div 2) - (OH div 2));
    OX2 := Abs((Image1.Width div 2) + (OW div 2));
    OY2 := Abs((Image1.Height div 2) + (OH div 2));
    Brush.Color := clWhite;
    Rectangle(Abs(OX1 - 4), Abs(OY1 - 4), Abs(OX2 + 4), Abs(OY2 + 4));
    TextOut(OX1, OY1, OPTEXT);
    Refresh;
  end;
end;

procedure TMainForm.Button1Click (Sender: TObject);
begin
  CreatePassword;
end;

procedure TMainForm.Edit1Change (Sender: TObject);
var PASSWD: String;
begin
  //Check Password Strength
  PASSWD := Edit1.Text;
  CheckStrength(PASSWD, 10);
end;

end.
