unit view.usuario;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Buttons, rxmemds,
  view.dbgrid, DB;

type

  { TfrmUsuario }

  TfrmUsuario = class(TfrmDBGrid)
    mdUsuario: TRxMemoryData;
    mdUsuarioguid: TStringField;
    mdUsuarionome: TStringField;
    mdUsuariousername: TStringField;
    procedure acNovoExecute(Sender: TObject);
  protected
    procedure LoadPage; override;
  public
  end;

var
  frmUsuario: TfrmUsuario;

implementation

{$R *.lfm}

{ TfrmUsuario }

procedure TfrmUsuario.acNovoExecute(Sender: TObject);
begin
  if Sistema.Forms.ShowCadastroUsuario = mrOK then
    LoadPage;
end;

procedure TfrmUsuario.LoadPage;
var
  i, APage: Integer;
begin

  APage := GetPage;
  mdUsuario.CloseOpen;
  with Sistema.Administrativo do
  begin
    User.OnProgress := @ProgressBar;
    User.Get(APage);
    MaxPage := User.Data.MaxPage;
    for i := 0 to User.Data.Count -1 do
    begin
      ProgressBar(i+1, User.Data.Count);
      mdUsuario.Insert;
      mdUsuarioguid.AsString := User.Data.Items[i].This.GUID;
      mdUsuarionome.AsString := User.Data.Items[i].This.Nome;
      mdUsuariousername.AsString := User.Data.Items[i].This.UserName;
      mdUsuario.Post;
    end;
    inherited;
  end;

end;

end.

