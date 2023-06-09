unit view.basico;

{$mode delphi}

interface


uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  IniPropStorage, ExtCtrls, JSONPropStorage;

type

  { TfrmBasico }

  TfrmBasico = class(TForm)
    JSONPropStorage1: TJSONPropStorage;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
    FBorderColor: TColor;
    FLeftMargin: Integer;
    FRightMargin: Integer;
    FTopMargin: Integer;
    FBottonMargin: Integer;
  protected

    procedure SetStyle; virtual;

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
    JSONPropStorage1.JSONFileName := Path + C_INI_FORM;
    JSONPropStorage1.Active := true;
    FBorderColor := Sistema.Tema.BackGround2;
    FLeftMargin := 8;
    FRightMargin := 8;
    FTopMargin := 27;
    FBottonMargin := 48;
    SetStyle;
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

procedure TfrmBasico.SetStyle;
begin

end;

procedure TfrmBasico.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  JSONPropStorage1.Save;
end;

end.

