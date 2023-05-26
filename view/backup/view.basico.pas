unit view.basico;

{$mode delphi}

interface


uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  IniPropStorage, ExtCtrls;

type

  { TfrmBasico }

  TfrmBasico = class(TForm)
    IniPropStorage1: TIniPropStorage;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
    FBorderColor: TColor;
    FLeftMargin: Integer;
    FRightMargin: Integer;
    FTopMargin: Integer;
    FBottonMargin: Integer;
  public

  end;

var
  frmBasico: TfrmBasico;

implementation

uses controller.sistema, uconst, utils;

{$R *.lfm}

{ TfrmBasico }

procedure TfrmBasico.FormCreate(Sender: TObject);
var
  Sistema: TSistema;
begin

  Sistema := TSistema.Create;
  try
    Application.Title := C_APP_TITLE;
    Icon := Application.Icon;
    Caption := C_APP_TITLE;
    IniPropStorage1.IniFileName := Path + C_INI_FORM;
    IniPropStorage1.Active := true;
    FBorderColor := Sistema.Tema.BorderColor;
    FLeftMargin := 8;
    FRightMargin := 8;
    FTopMargin := 27;
    FBottonMargin := 48;
  finally
    FreeAndNil(Sistema);
  end;

end;

procedure TfrmBasico.FormPaint(Sender: TObject);
begin

  Color := FBorderColor;
  Canvas.Brush.Color := clDefault;
  Canvas.Brush.Style := bsSolid;
  Canvas.FillRect(FLeftMargin, FTopMargin, ClientWidth - FRightMargin,
    ClientHeight - FBottonMargin);

end;

procedure TfrmBasico.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  IniPropStorage1.Save;
end;

end.

