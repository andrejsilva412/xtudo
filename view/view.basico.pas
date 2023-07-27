unit view.basico;

{$mode delphi}

interface


uses
  LMessages, LCLIntf, Classes, SysUtils, Forms, Controls, ComCtrls, Graphics,
  Dialogs, StdCtrls, IniPropStorage, ExtCtrls, JSONPropStorage,
  controller.sistema;

type

  { TForm }

  TForm = class(Forms.TForm)
    public
      procedure SetFocus(AControl: TWinControl); overload;
  end;

type

  { TfrmBasico }

  TfrmBasico = class(TForm)
    JSONPropStorage1: TJSONPropStorage;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
    FLeftMargin: Integer;
    FRightMargin: Integer;
    FTopMargin: Integer;
    FBottonMargin: Integer;
  protected
    FBorderColor: TColor;
    Sistema: TSistema;
    procedure SetStyle; virtual;
    procedure Clear; virtual;
  public

  end;

var
  frmBasico: TfrmBasico;

implementation

uses uconst, utils;

{$R *.lfm}

{ TForm }

procedure TForm.SetFocus(AControl: TWinControl);
var
  P: TWinControl;
begin

  try
    if AControl is TWinControl then
    begin
      P := TWinControl(AControl).Parent;
      while Assigned(P) and not (P is TCustomForm) do
      begin
        if P is TTabSheet then
          TTabSheet(P).PageControl.ActivePage := TTabSheet(P);
        P := P.Parent;
      end;
      if AControl.CanFocus then
      begin
        PostMessage(TWinControl(AControl).Handle, LM_SETFOCUS, 0, 0);
        TWinControl(AControl).SetFocus;
      end;
    end;
  except

  end;

end;

{ TfrmBasico }

procedure TfrmBasico.FormCreate(Sender: TObject);
begin

  Sistema := TSistema.Create;
  Application.Title := C_APP_TITLE;
  Icon := Application.Icon;
  Caption := C_APP_TITLE + ' ' + Caption ;
  JSONPropStorage1.JSONFileName := Path + C_INI_FORM;
  JSONPropStorage1.Active := true;
  FBorderColor := Sistema.Config.Theme.BackGround2;
  FLeftMargin := 8;
  FRightMargin := 8;
  FTopMargin := 27;
  FBottonMargin := 48;
  SetStyle;
  Clear;

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
  FreeAndNil(Sistema);
end;

end.

