unit view.main;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, view.basico;

type

  { TfrmMain }

  TfrmMain = class(TfrmBasico)
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  frmMain: TfrmMain;

implementation

uses controller.sistema;

{$R *.lfm}

{ TfrmMain }

procedure TfrmMain.FormShow(Sender: TObject);
begin
  if Sistema.ShowWizard then
  begin
    Hide;
    Sistema.Forms.ShowWizard;
  end;
  WindowState := wsMaximized;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  LSistema: TSistema;
begin

  LSistema := TSistema.Create;
  try
    LSistema.Config.CreateConfigFolder;
    LSistema.Config.Database.CreateConfigTable(false);
    inherited;
  finally
    FreeAndNil(LSistema);
  end;
end;

end.

