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
  Forms, datetimectrls, rxnew, view.basico, uconst, utils, view.buttons,
  uimage, uhtmlutils, utypes, view.bascadastro, ustatus, ustrutils,
  view.assistenteinicial, uframetitulo, controller.config,
  model.config;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Title := 'X-Tudo';
  Application.Scaled := True;
  Application.Initialize;
  Application.CreateForm(TfrmAssistenteInicial, frmAssistenteInicial);
  Application.Run;
end.

