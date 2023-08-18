unit view.dbgrid;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, urxdbgrid, view.buttons, Menus, Buttons, StdCtrls, ComCtrls, DB,
  uprogressbar;

type

  { TfrmDBGrid }

  TfrmDBGrid = class(TfrmBasButtons)
    btnGridOptions: TSpeedButton;
    btnPgFirst: TButton;
    BtnPgLast: TButton;
    btnPgNext: TButton;
    btnPgPrior: TButton;
    cboTPagina: TComboBox;
    dsDBGrid: TDataSource;
    pnFuncaoPagina: TPanel;
    pnOptions: TPanel;
    ProgressBar1: TProgressBar;
    RxDBGrid1: TRxDBGrid;
    procedure btnGridOptionsClick(Sender: TObject);
    procedure btnPgFirstClick(Sender: TObject);
    procedure BtnPgLastClick(Sender: TObject);
    procedure btnPgNextClick(Sender: TObject);
    procedure btnPgPriorClick(Sender: TObject);
    procedure cboTPaginaCloseUp(Sender: TObject);
    procedure dsDBGridDataChange(Sender: TObject; Field: TField);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FGridMenu: TPopupMenu;
    FMaxPage: Integer;
    FPage: Integer;
    procedure OnExportToExcel(Sender: TObject);
    procedure SetMaxPage(AValue: Integer);
    procedure UpdatePageButtons;
    procedure FirstPage;
    procedure PriorPage;
    procedure NextPage;
    procedure LastPage;
  protected
    procedure LoadPage; virtual;
    procedure Progress(const APosition: Integer; AMax: Integer);
    procedure SetStyle; override;
    function GetPage: Integer;
    property MaxPage: Integer read FMaxPage write SetMaxPage;
  public

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
  FGridMenu := TPopupMenu.Create(Self);
  cboTPagina.Items.Clear;
  cboTPagina.Text := '';
  cboTPagina.Enabled := false;
  btnPgFirst.Enabled := false;
  btnPgPrior.Enabled := false;
  btnPgNext.Enabled := false;
  BtnPgLast.Enabled := false;
  btnGridOptions.Enabled := false;
  FMaxPage := 0;
  FPage := 1;
  ProgressBar1.Visible := false;
end;

procedure TfrmDBGrid.btnPgPriorClick(Sender: TObject);
begin
  PriorPage;
end;

procedure TfrmDBGrid.btnPgFirstClick(Sender: TObject);
begin
  FirstPage;
end;

procedure TfrmDBGrid.btnGridOptionsClick(Sender: TObject);
var
  Item: TMenuItem;
begin
  FGridMenu.Items.Clear;
  Item := TMenuItem.Create(FGridMenu);
  Item.Caption := 'Exportar para o Excel';
  Item.OnClick  := @OnExportToExcel;
  Item.Enabled := not dsDBGrid.DataSet.IsEmpty;
  FGridMenu.Items.Add(Item);
  FGridMenu.PopUp;
end;

procedure TfrmDBGrid.BtnPgLastClick(Sender: TObject);
begin
  LastPage;
end;

procedure TfrmDBGrid.btnPgNextClick(Sender: TObject);
begin
  NextPage;
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
  if cboTPagina.Items.Count > 0 then
  begin
    cboTPagina.ItemIndex := 0;
    cboTPagina.Enabled := not dsDBGrid.DataSet.IsEmpty;
  end;
end;

procedure TfrmDBGrid.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if CanClose then
  begin
    FreeAndNil(FGridMenu);
    inherited
  end;
end;

procedure TfrmDBGrid.FormShow(Sender: TObject);
begin
  LoadPage;
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

procedure TfrmDBGrid.OnExportToExcel(Sender: TObject);
begin
  RxDBGrid1.ExportToSpreedSheet(LowerCase(
    dsDBGrid.DataSet.Name + '.xlsx'));
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

  btnPgFirst.Enabled := FEnable;
  btnPgPrior.Enabled := FEnable;
  btnPgNext.Enabled := FEnable;
  BtnPgLast.Enabled := FEnable;

  if FPage = 1 then
    btnPgFirst.Enabled := false;
  btnPgPrior.Enabled := btnPgFirst.Enabled;
  if FPage = MaxPage then
    BtnPgLast.Enabled := false;
  btnPgNext.Enabled := BtnPgLast.Enabled;

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
  FPage := 1;
  LoadPage;
end;

procedure TfrmDBGrid.PriorPage;
begin
  if FPage > 1 then
    FPage := FPage -1;
  LoadPage;
end;

procedure TfrmDBGrid.NextPage;
begin
  FPage := FPage + 1;
  if FPage > MaxPage then
    FPage := MaxPage;
  LoadPage;
end;

procedure TfrmDBGrid.LastPage;
begin
  FPage := MaxPage;
  LoadPage;
end;

procedure TfrmDBGrid.LoadPage;
begin
  UpdatePageButtons
end;

procedure TfrmDBGrid.Progress(const APosition: Integer; AMax: Integer);
begin
  ProgressBar1.Visible := APosition < AMax;
  ProgressBar1.Max := AMax;
  ProgressBar1.Position := APosition;
  Application.ProcessMessages;
end;

function TfrmDBGrid.GetPage: Integer;
begin
  Result := FPage;
end;

procedure TfrmDBGrid.SetStyle;
begin
  inherited SetStyle;
  Sistema.Image.SVG(btnGridOptions, C_SVG_MENU,
    InvertColor(pnOptions.Color));
  btnGridOptions.Flat := true;
end;

end.

