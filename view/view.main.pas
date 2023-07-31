unit view.main;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, view.basico;

type

  { TfrmMain }

  TfrmMain = class(TfrmBasico)
    Label1: TLabel;
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  frmMain: TfrmMain;

implementation

{$R *.lfm}

{ TfrmMain }

procedure TfrmMain.FormShow(Sender: TObject);
begin
  if Sistema.ShowWizard then
  begin
    Hide;
    Sistema.Forms.ShowWizard;
  end;
  WindowState := wsMaximized;
end;

end.

