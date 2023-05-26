program xtudo;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, view.basico, uconst, utils, utema, view.buttons;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Title := 'X-Tudo';
  Application.Scaled := True;
  Application.Initialize;
  Application.CreateForm(TfrmBasButtons, frmBasButtons);
  Application.Run;
end.

