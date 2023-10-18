unit view.banco;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, rxmemds, view.dbgrid,
  DB;

type

  { TfrmBanco }

  TfrmBanco = class(TfrmDBGrid)
    mdBanco: TRxMemoryData;
    mdBancocodigo: TStringField;
    mdBancoid: TLongintField;
    mdBanconome: TStringField;
    procedure acNovoExecute(Sender: TObject);
  private

  protected
    procedure LoadPage; override;
    procedure Edit; override;
  public

  end;

var
  frmBanco: TfrmBanco;

implementation

{$R *.lfm}

{ TfrmBanco }

procedure TfrmBanco.acNovoExecute(Sender: TObject);
begin
  if Sistema.Forms.Financeiro.Banco(0) = mrOK then
    LoadPage;
end;

procedure TfrmBanco.LoadPage;
var
  i, APage: Integer;
begin

  APage := GetPage;
  mdBanco.CloseOpen;
  with Sistema.Financeiro do
  begin
    Banco.OnProgress := @ProgressBar;
    Banco.GetPage(APage);
    MaxPage := Banco.Data.MaxPage;
    for i := 0 to Banco.Data.Count -1 do
    begin
      ProgressBar(i+1, Banco.Data.Count);
      mdBanco.Insert;
      mdBancoid.AsInteger := Banco.Data.Items[i].This.ID;
      mdBancocodigo.AsString := Banco.Data.Items[i].This.Codigo;
      mdBanconome.AsString := Banco.Data.Items[i].This.Nome;
      mdBanco.Post;
    end;
    inherited;
  end;
end;

procedure TfrmBanco.Edit;
begin
  if Sistema.Forms.Financeiro.Banco(
    dsDBGrid.DataSet.FieldByName('id').AsInteger) = mrOK then
    inherited;
end;

end.

