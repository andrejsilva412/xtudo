unit model.pais;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type

  { TModelPais }

  TModelPais = class
    private
      FID: Integer;
      FNome: String;
    public
      constructor Create;
      property ID: Integer read FID;
      property Nome: String read FNome;
  end;

implementation

{ TModelPais }

constructor TModelPais.Create;
begin
  FID := 1058;
  FNome := 'BRASIL';
end;

end.

