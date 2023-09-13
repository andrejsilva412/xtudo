unit view.cadusuario;

{$mode ObjFPC}{$H+}

interface

uses
  LCLType, LCLIntf, Classes, SysUtils, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls, DBCtrls, Buttons, ExtDlgs, BGRAShape, rxmemds, rxswitch,
  view.bascadastro, DB;

type

  { TfrmCadUsuario }

  TfrmCadUsuario = class(TfrmBasCadastro)
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    mdUser: TRxMemoryData;
    mdUserconfsenha: TStringField;
    mdUserguid: TStringField;
    mdUsernome: TStringField;
    mdUsersenha: TStringField;
    mdUserusuario: TStringField;
    RxSwitch1: TRxSwitch;
    Shape1: TShape;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    procedure acSalvarExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    FShowPassword: Boolean;
    procedure SetShowPassword(AValue: Boolean);
    procedure LoadPictureUserDefault;
    property ShowPassword: Boolean read FShowPassword write SetShowPassword;
  protected
    procedure SetStyle; override;
    procedure Edit(AGUID: String); override;
  public

  end;

var
  frmCadUsuario: TfrmCadUsuario;

implementation

uses uconst, utils, utypes;

{$R *.lfm}

{ TfrmCadUsuario }

procedure TfrmCadUsuario.SpeedButton2Click(Sender: TObject);
begin
  LoadPictureUserDefault;
end;

procedure TfrmCadUsuario.SetShowPassword(AValue: Boolean);
begin
  DBEdit3.PasswordChar := '*';
  DBEdit4.PasswordChar := '*';
  FShowPassword := AValue;
  if FShowPassword then
  begin
    DBEdit3.PasswordChar := #0;
    DBEdit4.PasswordChar := #0;
  end;
end;

procedure TfrmCadUsuario.FormCreate(Sender: TObject);
begin
  inherited;
  LoadPictureUserDefault;
  ShowPassword := false;
end;

procedure TfrmCadUsuario.acSalvarExecute(Sender: TObject);
begin
  inherited;
  if mdUsersenha.AsString <> mdUserconfsenha.AsString then
  begin
    Sistema.Mensagem.Alerta('As senhas estão diferentes.');
    mdUser.Edit;
    DBEdit3.SetFocus;
  end else begin
    Sistema.Administrativo.User.GUID := mdUserguid.AsString;
    Sistema.Administrativo.User.Nome := mdUsernome.AsString;
    Sistema.Administrativo.User.Username := mdUserusuario.AsString;
    Sistema.Administrativo.User.Password := mdUsersenha.AsString;
    Sistema.Administrativo.User.UserType := iif(RxSwitchStateToBoolean(
      RxSwitch1.StateOn) = true, utAdmin, utNormal);
    if Sistema.Administrativo.User.Post = 1 then
      ModalResult := mrOK;
  end;
end;

procedure TfrmCadUsuario.Image1Click(Sender: TObject);
var
  aFile: String;
begin

  aFile := Sistema.Image.OpenPictureDialog;
  if aFile <> '' then
  begin
    Image1.Picture.LoadFromFile(aFile);
  end;

end;

procedure TfrmCadUsuario.SpeedButton1Click(Sender: TObject);
begin
  ShowPassword := not ShowPassword;
end;

procedure TfrmCadUsuario.LoadPictureUserDefault;
begin
  Sistema.Image.SVG(Image1, C_SVG_USER, 90, 90, FBorderColor);
end;

procedure TfrmCadUsuario.SetStyle;
begin
  inherited SetStyle;
  SpeedButton1.Flat := true;
  SpeedButton2.Flat := true;
  Sistema.Image.SVG(SpeedButton1, C_SVG_EYE, FBorderColor);
  Sistema.Image.SVG(SpeedButton2, C_SVG_DELETE, clRed);
  RxSwitch1.Color := FBrushColor;
end;

procedure TfrmCadUsuario.Edit(AGUID: String);
begin

  Sistema.Administrativo.User.Get(AGUID);
  mdUser.CloseOpen;
  mdUser.Edit;
  mdUserguid.AsString := Sistema.Administrativo.User.GUID;
  mdUsernome.AsString := Sistema.Administrativo.User.Nome;
  mdUserusuario.AsString := Sistema.Administrativo.User.Username;
  RxSwitch1.StateOn := sw_off;
  if Sistema.Administrativo.User.UserType = utAdmin then
    RxSwitch1.StateOn := sw_on;
  inherited Edit(AGUID);

end;

end.

