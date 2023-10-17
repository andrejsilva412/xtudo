unit view.basico;

{$mode ObjFPC}{$H+}

interface


uses
  LMessages, LCLIntf, Classes, SysUtils, Forms, Controls, ComCtrls, Graphics,
  Dialogs, StdCtrls, IniPropStorage, ExtCtrls, JSONPropStorage, usyserror,
  controller.sistema, rxswitch;

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
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FLeftMargin: Integer;
    FPaintBorder: Boolean;
    FRightMargin: Integer;
    FTopMargin: Integer;
    FBottonMargin: Integer;
  protected
    FBorderColor: TColor;
    FBrushColor: TColor;
    Sistema: TSistema;
    procedure SetStyle; virtual;
    procedure Clear; virtual;
    procedure InitPanel(APanel: TPanel);
    property PaintBorder: Boolean read FPaintBorder write FPaintBorder;
    function RxSwitchStateToBoolean(ARxSwitchState: TSwithState): Boolean;
    function BooleanToRxSwitchState(ARxSwitchState: Boolean): TSwithState;
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
  Application.OnException  := @SysError.OnException;
  Application.Title := C_APP_TITLE;
  Icon := Application.Icon;
  JSONPropStorage1.JSONFileName := Sistema.Administrativo.User.ConfigFile;
  JSONPropStorage1.Active := true;
  FBorderColor := Sistema.Config.Theme.BackGround2;
  FLeftMargin := 8;
  FRightMargin := 8;
  FTopMargin := 27;
  FBottonMargin := 48;
  FBrushColor := clDefault;
  SetStyle;
  Clear;
  FPaintBorder := true;

end;

procedure TfrmBasico.FormPaint(Sender: TObject);
begin

  if FPaintBorder then
  begin
    Color := FBorderColor;
    Canvas.Brush.Color := FBrushColor;
    Canvas.Brush.Style := bsSolid;
    Canvas.FillRect(FLeftMargin, FTopMargin, ClientWidth - FRightMargin,
      ClientHeight - FBottonMargin);
  end;

end;

procedure TfrmBasico.FormShow(Sender: TObject);
begin
  if Sistema.ShowWizard then
  begin
    Hide;
    Sistema.Forms.ShowWizard;
  end;
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

procedure TfrmBasico.InitPanel(APanel: TPanel);
begin
  APanel.Caption := '';
  APanel.ParentColor := false;
  APanel.BevelOuter := bvNone;
  APanel.BevelInner := bvNone;
end;

function TfrmBasico.RxSwitchStateToBoolean(ARxSwitchState: TSwithState
  ): Boolean;
begin
  Result := iif(ARxSwitchState = sw_on, true, false);
end;

function TfrmBasico.BooleanToRxSwitchState(ARxSwitchState: Boolean
  ): TSwithState;
begin

  Result := iif(ARxSwitchState = true, sw_on, sw_off);

end;

procedure TfrmBasico.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  JSONPropStorage1.JSONFileName := Sistema.Administrativo.User.ConfigFile;
  JSONPropStorage1.Save;
  FreeAndNil(Sistema);
end;

procedure TfrmBasico.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction := caFree;
end;

end.

