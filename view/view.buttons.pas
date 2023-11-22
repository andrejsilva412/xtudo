unit view.buttons;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  ExtCtrls, ActnList, DateTimePicker, Menus, BCButton, BCSVGButton,
  BCButtonFocus, BGRAThemeButton, BGRATheme, BGRAImageList, BCSVGViewer,
  view.basico;

type

  { TListButtons }

  TListButtons = class
    private
      FAction: TBasicAction;
      FLeft: Integer;
      FName: String;
    public
      property Action: TBasicAction read FAction;
      property Left: Integer read FLeft;
      property Name: String read FName;
      constructor Create(const aAction: TBasicAction; const aLeft: Integer;
        aName: String);
  end;


type

  { TfrmBasButtons }

  TfrmBasButtons = class(TfrmBasico)
    acFechar: TAction;
    acNovo: TAction;
    acSalvar: TAction;
    acCancelar: TAction;
    acImprimir: TAction;
    acGenerico1: TAction;
    acGenerico2: TAction;
    acExcluir: TAction;
    ActionList1: TActionList;
    BCButtonFocus1: TBCButtonFocus;
    BCButtonFocus2: TBCButtonFocus;
    BCButtonFocus3: TBCButtonFocus;
    BCButtonFocus4: TBCButtonFocus;
    BCButtonFocus5: TBCButtonFocus;
    BCButtonFocus6: TBCButtonFocus;
    BCButtonFocus8: TBCButtonFocus;
    BCButtonFocus9: TBCButtonFocus;
    procedure acFecharExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
     FPopUpMenuButtons: TPopupMenu;
     procedure ShowPopUpButtonMenu;
     function GetImgButton(aName: String): TBitmap;
  protected
     procedure SetStyle; override;
  end;

var
  frmBasButtons: TfrmBasButtons;

implementation

uses ueditchangecolor, urxdbgrid;

{$R *.lfm}

function SortButtons(Item1: Pointer; Item2: Pointer): Integer;
begin
  Result := TListButtons(Item1).Left - TListButtons(Item2).Left;
end;

{ TListButtons }

constructor TListButtons.Create(const aAction: TBasicAction;
  const aLeft: Integer; aName: String);
begin

  FAction := aAction;
  FLeft := aLeft;
  FName := aName;

end;

{ TfrmBasButtons }

procedure TfrmBasButtons.acFecharExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmBasButtons.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  FreeAndNil(FPopUpMenuButtons);
  inherited;
end;

procedure TfrmBasButtons.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  inherited;
  for i := 0 to ComponentCount -1 do
  begin
    if (Components[i] is TWinControl) then
    begin
      TWinControlTrocaCor.RegisterEdit(Components[i] as TWinControl);
    end;
    if (Components[i] is TRxDBGrid) then
    begin
      TRxGridRegister.RegisterRxDBGrid(Components[i] as TRxDBGrid);
    end;
  end;
  acGenerico1.Visible := false;
  acGenerico2.Visible := false;
  acImprimir.Visible := false;
  acCancelar.Visible := false;
  acSalvar.Visible := false;
  acExcluir.Visible := false;
  acNovo.Visible := false;

  FPopUpMenuButtons := TPopupMenu.Create(nil);
  FPopUpMenuButtons.Parent := Self;
  PopupMenu := FPopUpMenuButtons;

end;

procedure TfrmBasButtons.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

  if Button = mbRight then
    ShowPopUpButtonMenu;

end;

procedure TfrmBasButtons.ShowPopUpButtonMenu;
var
  i: Integer;
  Lista: TList;
  Buttons: TListButtons;
  Button: TBCButtonFocus;
  Img: TBitmap;
  Item: TMenuItem;
begin

  Lista := TList.Create;
  try
    for i := 0 to ComponentCount -1 do
    begin
      if (Components[i].ClassType = TBCButtonFocus) then
      begin
        Button := TBCButtonFocus(Components[i]);
        if Assigned(Button.Action) then
        begin
          if Button.Top > 80 then
          begin
            Buttons := TListButtons.Create(Button.Action,
              Button.Left, Button.Name);
            Lista.Add(Buttons);
          end;
        end;
      end;
    end;
    Lista.Sort(@SortButtons);

    FPopUpMenuButtons.Items.Clear;

    for i := 0 to Lista.Count -1 do
    begin
      if Lista.Count > 1 then
      begin
        Item := TMenuItem.Create(FPopUpMenuButtons);
        Item.Caption := '-';
        FPopUpMenuButtons.Items.Add(Item);
        Item := TMenuItem.Create(FPopUpMenuButtons);
        Img := TBitmap.Create;
        Img := GetImgButton(TListButtons(Lista[i]).Name);
        Item.Bitmap := Img;
        Img.Free;
      end else begin
        Item := TMenuItem.Create(FPopUpMenuButtons);
        Item.Action := TListButtons(Lista[i]).Action;
        FPopUpMenuButtons.Items.Add(Item);
        Img := TBitmap.Create;
        Img := GetImgButton(TListButtons(Lista[i]).Name);
        Item.Bitmap := Img;
        Img.Free;
      end;
    end;

  finally
    FreeAndNil(Lista);
  end;

end;

function TfrmBasButtons.GetImgButton(aName: String): TBitmap;
var
  i: Integer;
begin

  for i := 0 to ComponentCount -1 do
  begin
    if (Components[i] is TBCButtonFocus) then
    begin
      if (Components[i] as TBCButtonFocus).Name = aName then
      begin
        Result := (Components[i] as TBCButtonFocus).Glyph;
        Break;
      end;
    end;
  end;

end;

procedure TfrmBasButtons.SetStyle;
var
  i: Integer;
begin

  for i := 0 to ComponentCount -1 do
  begin
    if (Components[i] is TBCButtonFocus) then
    begin
      Sistema.Config.Theme.SetBcButtonStyle((Components[i] as TBCButtonFocus));
      (Components[i] as TBCButtonFocus).Color := FBorderColor;
    end;
  end;

end;

end.

