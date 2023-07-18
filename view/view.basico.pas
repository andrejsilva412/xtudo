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
    FDefaultTheme: String;
    FLeftMargin: Integer;
    FRightMargin: Integer;
    FTopMargin: Integer;
    FBottonMargin: Integer;
  protected
    procedure SetStyle; virtual;
    procedure Clear; virtual;
    property DefaultTheme: String read FDefaultTheme;
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
    Caption := C_APP_TITLE + ' ' + Caption ;
    JSONPropStorage1.JSONFileName := Path + C_INI_FORM;
    JSONPropStorage1.Active := true;
    FBorderColor := Sistema.Tema.BackGround2;
    FLeftMargin := 8;
    FRightMargin := 8;
    FTopMargin := 27;
    FBottonMargin := 48;
    SetStyle;
    Clear;
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
var
  Sistema: TSistema;
begin

  Sistema := TSistema.Create;
  try
    FDefaultTheme := Sistema.Config.Theme.FileTheme;
  finally
    FreeAndNil(Sistema);
  end;

end;

procedure TfrmBasico.Clear;
var
  i: Integer;
begin

  for i := 0 to ComponentCount -1 do
  begin
    if (Components[i] is TCustomEdit) then
    begin
      (Components[i] as TCustomEdit).Clear;
    end;
  end;


end;

procedure TfrmBasico.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  JSONPropStorage1.Save;
end;

end.

