unit uframeendereco;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, DBCtrls, Dialogs, Buttons;

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
    procedure LocalizarEndereco(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    procedure InternalLocalizarEndereco;
  public
    constructor Create(TheOwner: TComponent); override;
  end;

implementation

uses ueditchangecolor;

{$R *.lfm}

{ TFrameEndereco }

procedure TFrameEndereco.LocalizarEndereco(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Shift = [ssCtrl]) and (Key = 70) then
  begin
    Key := 0;
    InternalLocalizarEndereco;
  end;
end;

procedure TFrameEndereco.InternalLocalizarEndereco;
begin

  ShowMessage('Localizar Endereço');

end;

constructor TFrameEndereco.Create(TheOwner: TComponent);
var
  i: Integer;
begin
  inherited Create(TheOwner);
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

