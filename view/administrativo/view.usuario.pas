unit view.usuario;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Buttons, view.dbgrid;

type

  { TfrmUsuario }

  TfrmUsuario = class(TfrmDBGrid)
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  frmUsuario: TfrmUsuario;

implementation

{$R *.lfm}

{ TfrmUsuario }

procedure TfrmUsuario.FormCreate(Sender: TObject);
begin
  inherited;

  Sistema.Image.SVG(SpeedButton1.Glyph, -180, 'ARROW-RIGHT',
     SpeedButton1.Width, SpeedButton1.Height);

  Sistema.Image.SVG(SpeedButton2, 'ARROW-RIGHT');


end;

end.

