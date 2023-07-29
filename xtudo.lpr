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
  view.assistenteinicial, uframetitulo, controller.config, model.config, ucript,
  uframecnpj, uframeendereco, uvalida, model.dmmain, controller.admin,
  controller.user, controller.crud, model.crud, model.user,
  model.database.sqlite, controller.log, model.log, udatacollection,
  model.endereco, controller.endereco, uformats, view.main, controller.forms,
  model.pessoa, controller.pessoa, model.empresa, controller.empresa;


{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Title := 'X-Tudo';
  Application.Scaled := True;
  Application.Initialize;
  Application.CreateForm(TdmMain, dmMain);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.

