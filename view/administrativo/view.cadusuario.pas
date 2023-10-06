unit view.cadusuario;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, DBCtrls,
  rxmemds, view.bascadastro, DB;

type

  { TfrmCadUsuario }

  TfrmCadUsuario = class(TfrmBasCadastro)
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    mdUsuario: TRxMemoryData;
    mdUsuarioconfsenha: TStringField;
    mdUsuarioid: TLongintField;
    mdUsuarionome: TStringField;
    mdUsuariosenha: TStringField;
    mdUsuariousername: TStringField;
    procedure acSalvarExecute(Sender: TObject);
  private
    function Valida: Boolean;
  public
    procedure Edit(AID: Integer); override;
  end;

var
  frmCadUsuario: TfrmCadUsuario;

implementation

{$R *.lfm}

{ TfrmCadUsuario }

procedure TfrmCadUsuario.acSalvarExecute(Sender: TObject);
begin
  if Valida then
  begin
    inherited;
    Sistema.Administrativo.User.ID := mdUsuarioid.AsInteger;
    Sistema.Administrativo.User.Nome := mdUsuarionome.AsString;
    Sistema.Administrativo.User.Username := mdUsuariousername.AsString;
    Sistema.Administrativo.User.Password := mdUsuariosenha.AsString;
    ModalResult := Sistema.Administrativo.User.Post;
  end;
end;

function TfrmCadUsuario.Valida: Boolean;
begin

  Result := true;

  if DBEdit3.Text <> DBEdit4.Text then
  begin
    Sistema.Mensagem.Alerta('As senhas informadas não são iguais.');
    mdUsuariosenha.AsString := '';
    mdUsuarioconfsenha.AsString := '';
    DBEdit3.SetFocus;
    Result := false;
  end;

end;

procedure TfrmCadUsuario.Edit(AID: Integer);
begin
  Sistema.Administrativo.User.Get(AID);
  mdUsuario.CloseOpen;
  mdUsuario.Edit;
  mdUsuarioid.AsInteger := Sistema.Administrativo.User.ID;
  mdUsuarionome.AsString := Sistema.Administrativo.User.Nome;
  mdUsuariousername.AsString := Sistema.Administrativo.User.Username;
end;

end.

