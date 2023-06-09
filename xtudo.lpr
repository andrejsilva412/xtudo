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
  Forms, rxnew, view.basico, uconst, utils, utema, view.buttons, uimage,
  uhtmlutils, utypes, view.bascadastro, model.sqldb, ustatus, ustrutils, 
model.database;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Title := 'X-Tudo';
  Application.Scaled := True;
  Application.Initialize;
  Application.CreateForm(TfrmBasCadastro, frmBasCadastro);
  Application.Run;
end.

