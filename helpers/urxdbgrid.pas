unit urxdbgrid;

{$mode ObjFPC}{$H+}

// Referencia
//https://wiki.lazarus.freepascal.org/Grids_Reference_Page#Sorting_columns_or_rows_in_DBGrid_with_sort_arrows_in_column_header

interface

uses
  Classes, Controls, Menus, SysUtils, RxDBGrid;

type

  { TRxDBGrid }

  TRxDBGrid = class(RxDBGrid.TRxDBGrid)
    private
      FGridMenu: TPopupMenu;
      procedure ExportarParaExcel(Sender: TObject);
      procedure ExportarParaHTML(Sender: TObject);
      procedure ExportarParaTXT(Sender: TObject);
      procedure OnGridMouseDown(Sender: TObject; Button: TMouseButton;
        Shift: TShiftState; X, Y: Integer);
    public
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
  end;

implementation

uses uexport;

{ TRxDBGrid }

procedure TRxDBGrid.ExportarParaExcel(Sender: TObject);
var
  AExport: TExport;
begin

  AExport := TExport.Create;
  try
    AExport.ToSpreedSheet(Self);
  finally
    FreeAndNil(AExport);
  end;

end;

procedure TRxDBGrid.ExportarParaHTML(Sender: TObject);
var
  AExport: TExport;
begin

  AExport := TExport.Create;
  try
    AExport.toHTML(Self);
  finally
    FreeAndNil(AExport);
  end;

end;

procedure TRxDBGrid.ExportarParaTXT(Sender: TObject);
var
  AExport: TExport;
begin

  AExport := TExport.Create;
  try
    AExport.toTXT(Self);
  finally
    FreeAndNil(AExport);
  end;

end;

procedure TRxDBGrid.OnGridMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  Item: TMenuItem;
begin

  FGridMenu.Items.Clear;
  Item := TMenuItem.Create(FGridMenu);
  Item.Caption := 'Exportar';

  FGridMenu.Items.Add(Item);

  Item := TMenuItem.Create(FGridMenu);
  Item.Caption := 'Para o Excel';
  Item.OnClick  := @ExportarParaExcel;
  FGridMenu.Items.Items[0].Add(Item);

  Item := TMenuItem.Create(FGridMenu);
  Item.Caption := 'Para HTML';
  Item.OnClick  := @ExportarParaHTML;
  FGridMenu.Items.Items[0].Add(Item);

  Item := TMenuItem.Create(FGridMenu);
  Item.Caption := 'Para Texto';
  Item.OnClick  := @ExportarParaTXT;
  FGridMenu.Items.Items[0].Add(Item);

end;

constructor TRxDBGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FGridMenu := TPopupMenu.Create(nil);
  PopupMenu := FGridMenu;
  OnMouseDown   := @OnGridMouseDown;
end;

destructor TRxDBGrid.Destroy;
begin
  FreeAndNil(FGridMenu);
  inherited Destroy;
end;

end.

