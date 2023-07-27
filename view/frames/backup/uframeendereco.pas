unit uframeendereco;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, DBCtrls, Buttons;

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
  //
end;

constructor TFrameEndereco.Create(TheOwner: TComponent);
var
  i: Integer;
begin
  inherited Create(TheOwner);
  for i := 0 to ComponentCount -1 do
  begin
    if (Components[i] is TWinControl) then
    begin
      TWinControlTrocaCor.RegisterEdit(Components[i] as TWinControl);
    end;
  end;
end;

end.

