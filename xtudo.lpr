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
  Forms, datetimectrls, rxnew, view.basico, uconst, utils, view.buttons, uimage,
  uhtmlutils, utypes, view.bascadastro, udbnotifier, ustrutils,
  view.assistenteinicial, uframetitulo, model.config, ucript,
  uframecnpj, uframeendereco, uvalida,
  model.crud, model.user, model.database.sqlite,
  usyserror, model.log, udatacollection, model.endereco,
  uformats, view.main, model.pessoa,
  model.empresa, view.dbgrid, view.usuario,
  urxdbgrid, uprogressbar, view.cadusuario, model.database.mariadb;


{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Title := 'X-Tudo';
  Application.Scaled := True;
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.

