unit view.buttons;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  ExtCtrls, ActnList, BCButton, BCSVGButton, BCButtonFocus, BGRAThemeButton,
  BGRATheme, BGRAImageList, BCSVGViewer, view.basico;

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
    procedure FormCreate(Sender: TObject);
  private

  protected
     procedure SetStyle; override;
  public

  end;

var
  frmBasButtons: TfrmBasButtons;

implementation

uses controller.sistema;

{$R *.lfm}

{ TfrmBasButtons }

procedure TfrmBasButtons.acFecharExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmBasButtons.FormCreate(Sender: TObject);
begin
  inherited;
  acGenerico1.Visible := false;
  acGenerico2.Visible := false;
  acImprimir.Visible := false;
  acCancelar.Visible := false;
  acSalvar.Visible := false;
  acExcluir.Visible := false;
  acNovo.Visible := false;
end;

procedure TfrmBasButtons.SetStyle;
var
  Sistema: TSistema;
  i: Integer;
begin

  Sistema := TSistema.Create;
  try
    for i := 0 to ComponentCount -1 do
    begin
      if (Components[i] is TBCButtonFocus) then
      begin
        Sistema.Tema.SetBcButtonStyle((Components[i] as TBCButtonFocus))
      end;
    end;
    inherited SetStyle;
  finally
    FreeAndNil(Sistema);
  end;

end;

end.

