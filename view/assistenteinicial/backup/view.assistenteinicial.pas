unit view.assistenteinicial;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, StdCtrls,
  ExtCtrls, uframetitulo, view.buttons;

type

  { TfrmAssistenteInicial }

  TfrmAssistenteInicial = class(TfrmBasButtons)
    frameTitulo1: TframeTitulo;
    PageControl1: TPageControl;
    RadioGroup1: TRadioGroup;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  frmAssistenteInicial: TfrmAssistenteInicial;

implementation

{$R *.lfm}

{ TfrmAssistenteInicial }

procedure TfrmAssistenteInicial.FormCreate(Sender: TObject);
begin
  inherited;
  PageControl1.ShowTabs := false;
end;

end.

