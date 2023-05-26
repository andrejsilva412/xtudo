unit controller.sistema;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, utema;

type

  { TSistema }

  TSistema = class
    private
      FTema: TTema;
    public
      destructor Destroy; override;
      function DiretorioUsuario: String;
      function Tema: TTema;
  end;

implementation

uses utils;

{ TSistema }

destructor TSistema.Destroy;
begin

  if Assigned(FTema) then
    FreeAndNil(FTema);

  inherited Destroy;
end;

function TSistema.DiretorioUsuario: String;
begin

  Result := Path;

end;

function TSistema.Tema: TTema;
begin

  if not Assigned(FTema) then
    FTema := TTema.Create;
  Result := FTema;

end;

end.

