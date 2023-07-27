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
  controller.user, controller.crud, model.crud, model.user, model.database,
  model.database.sqlite, controller.log, model.log, model.pais, model.cidade,
  model.uf, udatacollection, model.endereco, model.cep;


{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Title := 'X-Tudo';
  Application.Scaled := True;
  Application.Initialize;
  Application.CreateForm(TdmMain, dmMain);
  Application.CreateForm(TfrmAssistenteInicial, frmAssistenteInicial);
  Application.Run;
end.

