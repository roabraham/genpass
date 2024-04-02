program GenPass;

uses
  Forms, Interfaces,
  Main in 'Main.pas' {MainForm},
  Encode in 'Encode.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'GenPass - Password Generator';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
