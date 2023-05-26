unit view.buttons;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, BCButton,
  view.basico;

type

  { TfrmBasButtons }

  TfrmBasButtons = class(TfrmBasico)
    BCButton1: TBCButton;
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

procedure TfrmBasButtons.SetStyle;
var
  Sistema: TSistema;
begin

  Sistema := TSistema.Create;
  try
    Sistema.Tema.SetBcButtonStyle(BCButton1);
    inherited SetStyle;
  finally
    FreeAndNil(Sistema);
  end;

end;

end.
