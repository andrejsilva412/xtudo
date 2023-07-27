unit uframetitulo;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, ExtCtrls, StdCtrls;

type

  { TframeTitulo }

  TframeTitulo = class(TFrame)
    Bevel1: TBevel;
    lblTitulo: TLabel;
  private

  public
    constructor Create(TheOwner: TComponent); override;
  end;

implementation

{$R *.lfm}

{ TframeTitulo }

constructor TframeTitulo.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  ParentColor := false;
end;

end.

