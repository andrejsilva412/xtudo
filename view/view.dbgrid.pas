unit view.dbgrid;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, urxdbgrid,
  view.buttons, Menus, Buttons, StdCtrls, Grids, ComCtrls, ActnList, DB,
  fpsTypes, uframetitulo,
  uprogressbar;

type

  { TfrmDBGrid }

  TfrmDBGrid = class(TfrmBasButtons)
    acFirst: TAction;
    acPrior: TAction;
    acNext: TAction;
    acLast: TAction;
    btnGridOptions: TSpeedButton;
    cboTPagina: TComboBox;
    dsDBGrid: TDataSource;
    frameTitulo1: TframeTitulo;
    lblDatabaseStatus: TLabel;
    Panel1: TPanel;
    pnFuncaoPagina: TPanel;
    pnOptions: TPanel;
    ProgressBar1: TProgressBar;
    RxDBGrid1: TRxDBGrid;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    procedure acFirstExecute(Sender: TObject);
    procedure acLastExecute(Sender: TObject);
    procedure acNextExecute(Sender: TObject);
    procedure acPriorExecute(Sender: TObject);
    procedure acSalvarExecute(Sender: TObject);
    procedure btnGridOptionsClick(Sender: TObject);
    procedure cboTPaginaCloseUp(Sender: TObject);
    procedure dsDBGridDataChange(Sender: TObject; Field: TField);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure RxDBGrid1DblClick(Sender: TObject);
  private
    FMaxPage: Integer;
    FPage: Integer;
    FTitulo: String;
    procedure OnExportToExcel(Sender: TObject);
    procedure SetMaxPage(AValue: Integer);
    procedure SetTitulo(AValue: String);
    procedure UpdatePageButtons;
    procedure FirstPage;
    procedure PriorPage;
    procedure NextPage;
    procedure LastPage;
    procedure DisableActions;
    procedure EnableActions;
    procedure DatabaseStatus(AUpdateStatus: TUpdateStatus;
      const RowsAffected: Integer);
  protected
    procedure LoadPage; virtual;
    procedure SetStyle; override;
    property MaxPage: Integer read FMaxPage write SetMaxPage;
    procedure ProgressBar(const APosition: Integer; const AMax: Integer);
    procedure Edit; virtual;
  public
    property Titulo: String read FTitulo write SetTitulo;
    property Page: Integer read FPage write FPage;
  end;

var
  frmDBGrid: TfrmDBGrid;

implementation

uses uconst;

{$R *.lfm}

{ TfrmDBGrid }

procedure TfrmDBGrid.FormResize(Sender: TObject);
begin
  pnFuncaoPagina.Left := Trunc(pnOptions.Width / 2) - Trunc(pnFuncaoPagina.Width / 2);
end;

procedure TfrmDBGrid.FormCreate(Sender: TObject);
begin
  inherited;
  cboTPagina.Items.Clear;
  cboTPagina.Text := '';
  cboTPagina.Enabled := false;
  acFirst.Enabled := false;
  acPrior.Enabled := false;
  acNext.Enabled := false;
  acLast.Enabled := false;
  btnGridOptions.Enabled := false;
  FMaxPage := 0;
  FPage := 1;
  ProgressBar1.Visible := false;
  lblDatabaseStatus.Caption := '';
  acNovo.Visible := true;
  acSalvar.Caption := 'Editar';
  acSalvar.Visible := true;
end;

procedure TfrmDBGrid.btnGridOptionsClick(Sender: TObject);
//var
  //Item: TMenuItem;
begin
{  FGridMenu.Items.Clear;
  Item := TMenuItem.Create(FGridMenu);
  Item.Caption := 'Exportar para o Excel';
  Item.OnClick  := @OnExportToExcel;
  Item.Enabled := not dsDBGrid.DataSet.IsEmpty;
  FGridMenu.Items.Add(Item);
  FGridMenu.PopUp;   }
end;

procedure TfrmDBGrid.acFirstExecute(Sender: TObject);
begin
  FirstPage;
end;

procedure TfrmDBGrid.acLastExecute(Sender: TObject);
begin
  LastPage;
end;

procedure TfrmDBGrid.acNextExecute(Sender: TObject);
begin
  NextPage;
end;

procedure TfrmDBGrid.acPriorExecute(Sender: TObject);
begin
  PriorPage;
end;

procedure TfrmDBGrid.acSalvarExecute(Sender: TObject);
begin
  Edit;
end;

procedure TfrmDBGrid.cboTPaginaCloseUp(Sender: TObject);
begin
  FPage := StrToIntDef(cboTPagina.Items[cboTPagina.ItemIndex], 1);
  LoadPage;
end;

procedure TfrmDBGrid.dsDBGridDataChange(Sender: TObject; Field: TField);
begin
  btnGridOptions.Enabled := not dsDBGrid.DataSet.IsEmpty;
  cboTPagina.Enabled := false;
  acSalvar.Enabled := btnGridOptions.Enabled;
  if cboTPagina.Items.Count > 0 then
  begin
//    cboTPagina.ItemIndex := 0;
    cboTPagina.Enabled := not dsDBGrid.DataSet.IsEmpty;
  end;
end;

procedure TfrmDBGrid.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if CanClose then
  begin
    //FreeAndNil(FGridMenu);
    inherited;
  end;
end;

procedure TfrmDBGrid.FormShow(Sender: TObject);
begin
  Titulo := Caption;
  LoadPage;
end;

procedure TfrmDBGrid.RxDBGrid1DblClick(Sender: TObject);
begin
  Edit;
end;

procedure TfrmDBGrid.SetMaxPage(AValue: Integer);
var
  i: Integer;
begin
  FMaxPage := AValue;
  cboTPagina.Items.Clear;
  cboTPagina.Text := '';
  for i := 1 to FMaxPage do
    cboTPagina.Items.Add(IntToStr(i));
  UpdatePageButtons;
end;

procedure TfrmDBGrid.SetTitulo(AValue: String);
begin
  if FTitulo = AValue then Exit;
  FTitulo := AValue;
  frameTitulo1.lblTitulo.Caption := FTitulo;
end;

procedure TfrmDBGrid.OnExportToExcel(Sender: TObject);
var
  aFileName: String;
begin

  aFileName := ChangeFileExt(GetTempFileName, STR_EXCEL_EXTENSION);
  RxDBGrid1.OnProgress := @ProgressBar;
  RxDBGrid1.ExportToSpreedSheet(aFileName);

end;

procedure TfrmDBGrid.UpdatePageButtons;
var
  i: Integer;
  FEnable: Boolean;
begin

  FEnable := false;

  if Assigned(dsDBGrid.DataSet) then
  begin
    FEnable := not dsDBGrid.DataSet.IsEmpty;
  end;

  acFirst.Enabled := FEnable;
  acPrior.Enabled := FEnable;
  acNext.Enabled := FEnable;
  acLast.Enabled := FEnable;

  if FPage = 1 then
    acFirst.Enabled := false;
  acPrior.Enabled := acFirst.Enabled;
  if FPage = MaxPage then
    acLast.Enabled := false;
  acNext.Enabled := acLast.Enabled;

  cboTPagina.Enabled := false;

  if cboTPagina.Items.Count > 0 then
  begin
    for i := 0 to cboTPagina.Items.Count -1 do
    begin
      if cboTPagina.Items[i] = IntToStr(FPage) then
      begin
        cboTPagina.ItemIndex := i;
        break;
      end;
    end;
    cboTPagina.Enabled := true;
  end;

end;

procedure TfrmDBGrid.FirstPage;
begin
  DisableActions;
  FPage := 1;
  LoadPage;
  EnableActions;
end;

procedure TfrmDBGrid.PriorPage;
begin
  DisableActions;
  if FPage > 1 then
    FPage := FPage -1;
  LoadPage;
  EnableActions;
end;

procedure TfrmDBGrid.NextPage;
begin
  DisableActions;
  FPage := FPage + 1;
  if FPage > MaxPage then
    FPage := MaxPage;
  LoadPage;
  EnableActions;
end;

procedure TfrmDBGrid.LastPage;
begin
  DisableActions;
  FPage := MaxPage;
  LoadPage;
  EnableActions;
end;

procedure TfrmDBGrid.DisableActions;
begin
  acFirst.Enabled := false;
  acPrior.Enabled := false;
  acNext.Enabled := false;
  acLast.Enabled := false;
end;

procedure TfrmDBGrid.EnableActions;
begin
  acFirst.Enabled := true;
  acPrior.Enabled := true;
  acNext.Enabled := true;
  acLast.Enabled := true;
end;

procedure TfrmDBGrid.DatabaseStatus(AUpdateStatus: TUpdateStatus;
  const RowsAffected: Integer);
begin
  case AUpdateStatus of
    usInserted: lblDatabaseStatus.Caption := IntToStr(RowsAffected) + ' registro inserido.';
    usModified: lblDatabaseStatus.Caption := IntToStr(RowsAffected) + ' registro(s) atualizado(s).';
    usDeleted: lblDatabaseStatus.Caption := IntToStr(RowsAffected) + ' registro(s) excluído(s).';
  end;
end;

procedure TfrmDBGrid.LoadPage;
begin
  UpdatePageButtons;
end;

procedure TfrmDBGrid.ProgressBar(const APosition: Integer; const AMax: Integer);
begin
  ProgressBar1.Visible := true;
  ProgressBar1.Max := AMax;
  ProgressBar1.Position := APosition;
  ProgressBar1.Repaint;
  if APosition = AMax then
  begin
    ProgressBar1.Position := 0;
    ProgressBar1.Visible := false;
  end;
end;

procedure TfrmDBGrid.Edit;
begin
  LoadPage;
end;

procedure TfrmDBGrid.SetStyle;
var
  aColor: TColor;
begin
  inherited SetStyle;
  RxDBGrid1.TitleStyle := tsNative;
  InitPanel(Panel1);
  aColor := InvertColor(pnOptions.Color);
  Sistema.Image.SVG(btnGridOptions, C_SVG_MENU, aColor);
  btnGridOptions.Flat := true;
  SpeedButton1.Flat := true;
  SpeedButton2.Flat := true;
  SpeedButton3.Flat := true;
  SpeedButton4.Flat := true;
  SpeedButton1.ShowCaption := false;
  SpeedButton2.ShowCaption := false;
  SpeedButton3.ShowCaption := false;
  SpeedButton4.ShowCaption := false;
  aColor := InvertColor(pnOptions.Color);
  Sistema.Image.SVG(SpeedButton1, C_SVG_FIRST, aColor);
  Sistema.Image.SVG(SpeedButton2, C_SVG_PRIOR, aColor);
  Sistema.Image.SVG(SpeedButton3, C_SVG_NEXT, aColor);
  Sistema.Image.SVG(SpeedButton4, C_SVG_LAST, aColor);
  frameTitulo1.ParentColor := false;
  frameTitulo1.Color := Sistema.Config.Theme.BackGround2;
  frameTitulo1.Bevel1.Visible := false;
  frameTitulo1.lblTitulo.Font.Color := InvertColor(frameTitulo1.Color);
  RxDBGrid1.AlternateColor := Sistema.Config.Theme.Secondary2;
end;

end.

