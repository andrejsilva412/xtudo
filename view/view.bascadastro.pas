unit view.bascadastro;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, DBCtrls,
  rxmemds, view.buttons, DB;

type

  { TfrmBasCadastro }

  TfrmBasCadastro = class(TfrmBasButtons)
    DataSource1: TDataSource;
    procedure acCancelarExecute(Sender: TObject);
    procedure acExcluirExecute(Sender: TObject);
    procedure acNovoExecute(Sender: TObject);
    procedure acSalvarExecute(Sender: TObject);
    procedure DataSource1StateChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FACNovoVisible: Boolean;
    FACExcluirVisible: Boolean;
    FValidado: Boolean;
    procedure ValidaDataSet;
  public
    procedure Insert; virtual;
    procedure Edit(AID: Integer); virtual;
    property Validado: Boolean read FValidado;
  end;

var
  frmBasCadastro: TfrmBasCadastro;

implementation

uses uconst;

{$R *.lfm}

{ TfrmBasCadastro }

procedure TfrmBasCadastro.FormCreate(Sender: TObject);
begin
  inherited;
  acSalvar.Visible := true;
end;

procedure TfrmBasCadastro.FormShow(Sender: TObject);
begin
  FACNovoVisible := acNovo.Visible;
  FACExcluirVisible := acExcluir.Visible;
end;

procedure TfrmBasCadastro.ValidaDataSet;
var
  i: Integer;
begin

  FValidado := true; // Assume que todos os campos estão preenchidos

  if DataSource1.DataSet.State in [dsInsert, dsEdit] then
  begin
    for i := 0 to DataSource1.DataSet.FieldCount -1 do
    begin
      if DataSource1.DataSet.Fields[i].Required then
      begin
        if (DataSource1.DataSet.Fields[i].IsNull) or
          (DataSource1.DataSet.Fields[i].AsString = '') then
        begin
          Sistema.Mensagem.Alerta('Falha na validação', Caption,
            Format(SMSGCampoObrigatorio, [DataSource1.DataSet.Fields[i].DisplayLabel]));
          FValidado := false;
          DataSource1.DataSet.Fields[i].FocusControl;
          break;
        end;
      end;
    end;
  end;

end;

procedure TfrmBasCadastro.Insert;
begin
  DataSource1.DataSet.Close;
  DataSource1.DataSet.Open;
  DataSource1.DataSet.Insert;
end;

procedure TfrmBasCadastro.Edit(AID: Integer);
begin

end;

procedure TfrmBasCadastro.DataSource1StateChange(Sender: TObject);
begin

  case DataSource1.DataSet.State of
    dsBrowse: begin
      acSalvar.Visible := false;
      acCancelar.Visible := false;
      acExcluir.Visible := (not DataSource1.DataSet.IsEmpty) and (FACExcluirVisible);

      acNovo.Visible := FACNovoVisible;
    end;
    dsInsert, dsEdit: begin
      acSalvar.Visible := true;
      acCancelar.Visible := true;
      acNovo.Visible := false;
      acExcluir.Visible := false;
    end;
  end;

end;

procedure TfrmBasCadastro.acNovoExecute(Sender: TObject);
begin
  DataSource1.DataSet.Insert;
end;

procedure TfrmBasCadastro.acCancelarExecute(Sender: TObject);
begin
  DataSource1.DataSet.Cancel;
end;

procedure TfrmBasCadastro.acExcluirExecute(Sender: TObject);
begin
  if Sistema.Mensagem.Excluir = True then
     DataSource1.DataSet.Delete;
end;

procedure TfrmBasCadastro.acSalvarExecute(Sender: TObject);
begin
  ValidaDataSet;
  if Validado then
    DataSource1.DataSet.Post;
end;

end.

