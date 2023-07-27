unit uframecnpj;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, MaskEdit, DBCtrls, Buttons;

type

  { TframeCNPJ }

  TframeCNPJ = class(TFrame)
    DBEditFrameCNPJ: TDBEdit;
    lblFrameCNPJ: TLabel;
    lblFrameCNPJCheck: TLabel;
    SpeedButton1: TSpeedButton;
    procedure InternalCheckValidade(Sender: TObject);
  private
    FCheckValidade: Boolean;
    FValid: Boolean;
    procedure SetValid(AValue: Boolean);
  public
    constructor Create(TheOwner: TComponent); override;
    property Valid: Boolean read FValid write SetValid;
    property CheckValidade: Boolean read FCheckValidade write FCheckValidade;
  end;

implementation

uses controller.sistema, uconst, ueditchangecolor;

{$R *.lfm}

{ TframeCNPJ }

procedure TframeCNPJ.InternalCheckValidade(Sender: TObject);
var
  Sistema: TSistema;
begin

  if not CheckValidade then
    exit;
  Sistema := TSistema.Create;
  try
    Valid := Sistema.Validador.CNPJ(DBEditFrameCNPJ.Text);
  finally
    FreeAndNil(Sistema);
  end;

end;

procedure TframeCNPJ.SetValid(AValue: Boolean);
begin
  FValid := AValue;
  if not AValue then
    lblFrameCNPJCheck.Caption := 'Inválido.'
  else
    lblFrameCNPJCheck.Caption := '';
end;

constructor TframeCNPJ.Create(TheOwner: TComponent);
var
  Sistema: TSistema;
begin
  Sistema := TSistema.Create;
  try
    inherited Create(TheOwner);
    ParentColor := false;
    lblFrameCNPJCheck.Caption := '';
    DBEditFrameCNPJ.EditMask := C_CNPJ_MASK;
    DBEditFrameCNPJ.CustomEditMask := true;
    SpeedButton1.Flat := true;
    Sistema.Image.SVG(SpeedButton1.Glyph, C_SVG_SEARCH, 16, 16);
    TWinControlTrocaCor.RegisterEdit(DBEditFrameCNPJ);
  finally
    FreeAndNil(Sistema);
  end;
end;

end.

