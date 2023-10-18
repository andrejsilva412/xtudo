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
    mdUsuarioid: TLongintField;
    mdUsuarionome: TStringField;
    mdUsuariousername: TStringField;
    procedure acNovoExecute(Sender: TObject);
  protected
    procedure LoadPage; override;
    procedure Edit; override;
  public
  end;

var
  frmUsuario: TfrmUsuario;

implementation

{$R *.lfm}

{ TfrmUsuario }

procedure TfrmUsuario.acNovoExecute(Sender: TObject);
begin
  if Sistema.Forms.Administrativo.Usuario(0) = mrOK then
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
    User.GetPage(APage);
    MaxPage := User.Data.MaxPage;
    for i := 0 to User.Data.Count -1 do
    begin
      ProgressBar(i+1, User.Data.Count);
      mdUsuario.Insert;
      mdUsuarioid.AsInteger := User.Data.Items[i].This.ID;
      mdUsuarionome.AsString := User.Data.Items[i].This.Nome;
      mdUsuariousername.AsString := User.Data.Items[i].This.UserName;
      mdUsuario.Post;
    end;
    inherited;
  end;

end;

procedure TfrmUsuario.Edit;
begin
  if Sistema.Forms.Administrativo.Usuario(dsDBGrid.DataSet.FieldByName('id').AsInteger) = mrOK then
    inherited;
end;

end.

