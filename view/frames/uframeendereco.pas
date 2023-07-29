unit uframeendereco;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, db, Controls, StdCtrls, DBCtrls, Dialogs;

type

  { TFrameEndereco }

  TFrameEndereco = class(TFrame)
    DBComboBox1: TDBComboBox;
    DBComboBox2: TDBComboBox;
    DBComboBox3: TDBComboBox;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    procedure DBEdit1EditingDone(Sender: TObject);
  public
    constructor Create(TheOwner: TComponent); override;
  end;

implementation

uses ueditchangecolor, controller.endereco;

{$R *.lfm}

{ TFrameEndereco }

procedure TFrameEndereco.DBEdit1EditingDone(Sender: TObject);
var
  Endereco: TEndereco;
  ds: TDataSource;
begin

  if not Assigned(DBEdit1.DataSource) then
    exit;

  ds := DBEdit1.DataSource;

  if ds.State in [dsInsert, dsEdit] then
  begin
    Endereco := TEndereco.Create;
    try
      if Endereco.BuscaCEP(DBEdit1.Text) then
      begin
       ds.DataSet.FieldByName('endereco').AsString :=
         Endereco.Logradouro;
       ds.DataSet.FieldByName('complemento').AsString :=
         Endereco.Complemento;
       ds.DataSet.FieldByName('bairro').AsString :=
         Endereco.Bairro;
       ds.DataSet.FieldByName('cidade').AsString :=
         Endereco.Cidade.Nome + ' (' +
         Endereco.Cidade.UF.Sigla + ')';
      end;
    finally
      FreeAndNil(Endereco);
    end;
  end;

end;

constructor TFrameEndereco.Create(TheOwner: TComponent);
var
  i: Integer;
begin
  inherited Create(TheOwner);
  Label7.Visible := false;
  ParentColor := false;
  for i := 0 to ComponentCount -1 do
  begin
    if (Components[i] is TWinControl) then
    begin
      TWinControlTrocaCor.RegisterEdit(Components[i] as TWinControl);
    end;
  end;
end;

end.

