unit ueditchangecolor;

interface

uses
  SysUtils, Classes, StdCtrls, Controls, Graphics, DateTimePicker, TypInfo,
  TreeFilterEdit, EditBtn;

type

  { TWinControlChangeColor }

  TWinControlChangeColor = class
    private
      FOldOnEnter: TNotifyEvent;
      FOldOnExit: TNotifyEvent;
      function GetOldOnEnter: TNotifyEvent;
      function GetOldOnExit: TNotifyEvent;
      procedure SetOldOnEnter(AValue: TNotifyEvent);
      procedure SetOldOnExit(AValue: TNotifyEvent);
    public
      constructor Create;
      procedure OnEnter(Sender: TObject);
      procedure OnExit(Sender: TObject);
      procedure RegisterEdit(var AWinControl: TWinControl);
      property OldOnEnter: TNotifyEvent read GetOldOnEnter write SetOldOnEnter;
      property OldOnExit: TNotifyEvent read GetOldOnExit write SetOldOnExit;
  end;

  { TWinControlTrocaCor }

  TWinControlTrocaCor = class
    public
      class procedure RegisterEdit(AWinControl: TWinControl);
  end;

procedure TrocaCor(Sender: TObject; bEnter, bFonteBold: Boolean;
    ALabel: TLabel = nil);
procedure DestacaLabel(ALabel: TLabel; bEnter: Boolean);

var
  NewColor: TColor;
  OldColor: TColor;

implementation

uses controller.sistema;

procedure TrocaCor(Sender: TObject; bEnter, bFonteBold: Boolean; ALabel: TLabel
  );
Var
   clColor: TColor;
   fsStyle: TFontStyles;
begin

  try

     if bEnter then
     begin
       clColor := NewColor;
     end
     else begin
         clColor := OldColor;
     end;
     if bFonteBold Then
        fsStyle := [fsBold]
     else
        fsStyle := [];

     if (Sender is TCustomEdit) then
     begin
        if bEnter then
           OldColor := (Sender as TCustomEdit).Color;
        (Sender as TCustomEdit).Color := clColor;
        (Sender as TCustomEdit).Font.Style := fsStyle;
     end;

     if (Sender is TCustomComboBox) then
     begin
        if bEnter then
           OldColor := (Sender as TCustomComboBox).Color;
        (Sender as TCustomComboBox).Color := clColor;
        (Sender as TCustomComboBox).Font.Style := fsStyle;
     end;

     if (Sender is TCustomCheckBox) then
        (Sender as TCustomCheckBox).Font.Style := fsStyle;

     if (Sender is TDateTimePicker) then
     begin
        if bEnter then
           OldColor := (Sender as TDateTimePicker).Color;
        (Sender as TDateTimePicker).Font.Style := fsStyle;
        (Sender as TDateTimePicker).Font.Color := clColor;
     end;

     if (Sender is TTreeFilterEdit) then
     begin
        if bEnter then
           OldColor := (Sender as TTreeFilterEdit).Color;
       (Sender as TTreeFilterEdit).Font.Style := fsStyle;
       (Sender as TTreeFilterEdit).Color := clColor;
     end;

     if (Sender is TCustomEditButton) then
     begin
       if bEnter then
         OldColor := (Sender as TCustomEditButton).Color;
       (Sender as TCustomEditButton).Font.Style := fsStyle;
       (Sender as TCustomEditButton).Color := clColor;
     end;

     if ALabel <> nil then
       DestacaLabel(ALabel, bEnter);

  except

  end;

end;

procedure DestacaLabel(ALabel: TLabel; bEnter: Boolean);
begin
  if ALabel = nil then exit;

  if bEnter then
  begin
    ALabel.Color :=  clBlue;
    ALabel.Font.Color := clYellow;
  end else begin
    ALabel.Color := clDefault;
    ALabel.Font.Color := clDefault;
    ALabel.Transparent := true;
    ALabel.Repaint;
  end;
end;

{ TWinControlTrocaCor }

class procedure TWinControlTrocaCor.RegisterEdit(AWinControl: TWinControl);
var
  ATrocaCor: TWinControlChangeColor;
begin

  ATrocaCor := TWinControlChangeColor.Create;
  ATrocaCor.RegisterEdit(AWinControl);

end;

{ TWinControlChangeColor }

function TWinControlChangeColor.GetOldOnEnter: TNotifyEvent;
begin
  Result := FOldOnEnter;
end;

function TWinControlChangeColor.GetOldOnExit: TNotifyEvent;
begin
  Result := FOldOnExit;
end;

procedure TWinControlChangeColor.SetOldOnEnter(AValue: TNotifyEvent);
begin
  FOldOnEnter := AValue;
end;

procedure TWinControlChangeColor.SetOldOnExit(AValue: TNotifyEvent);
begin
  FOldOnExit := AValue;
end;

constructor TWinControlChangeColor.Create;
var
  Sistema: TSistema;
begin
  Sistema := TSistema.Create;
  try
    NewColor := Sistema.Config.Theme.Secondary4;
  finally
    FreeAndNil(Sistema);
  end;
end;

procedure TWinControlChangeColor.OnEnter(Sender: TObject);
begin
  TrocaCor(Sender, true, true);
  if Assigned(FOldOnEnter) then
    FOldOnEnter(Sender);
end;

procedure TWinControlChangeColor.OnExit(Sender: TObject);
begin
  TrocaCor(Sender, false, false);
  if Assigned(FOldOnExit) then
    FOldOnExit(Sender);
end;

procedure TWinControlChangeColor.RegisterEdit(var AWinControl: TWinControl);
begin

  if not Assigned(AWinControl) then
    exit;

  if (AWinControl) is TCustomEdit then
  begin
    FOldOnEnter := AWinControl.OnEnter;
    AWinControl.OnEnter := @OnEnter;
    FOldOnExit := AWinControl.OnExit;
    AWinControl.OnExit := @OnExit;
  end;

end;

end.
