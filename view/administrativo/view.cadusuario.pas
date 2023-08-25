unit view.cadusuario;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  DBCtrls, Buttons, BGRAShape, BGRAImageManipulation, rxmemds, view.bascadastro,
  DB;

type

  { TfrmCadUsuario }

  TfrmCadUsuario = class(TfrmBasCadastro)
    BGRAShape1: TBGRAShape;
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
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    FShowPassword: Boolean;
    procedure SetShowPassword(AValue: Boolean);
  private
    procedure LoadPictureUserDefault;
    property ShowPassword: Boolean read FShowPassword write SetShowPassword;
  protected
    procedure SetStyle; override;
  public

  end;

var
  frmCadUsuario: TfrmCadUsuario;

implementation

uses uconst;

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
  if not FShowPassword then
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
end;

end.

