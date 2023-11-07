unit udatabaseutils;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Math;

// Retorna a quantidade máxima de páginas
function MaxPage(ARecords: Integer): Integer;
function GetOffSet(APage: Integer): Integer;
function SetLimit(AOffSet: Integer): String;

const

  C_MAX_REG = 100; // Limite de Resultado de Registros por página

implementation

uses utils;

function MaxPage(ARecords: Integer): Integer;
var
  AMaxPage: Integer;
begin
  AMaxPage := Ceil(ARecords / C_MAX_REG);
  AMaxPage := iif(AMaxPage = 0, 1, AMaxPage);
  Result := AMaxPage;
end;

function GetOffSet(APage: Integer): Integer;
begin

  Result := (C_MAX_REG * APage) - C_MAX_REG;

end;

function SetLimit(AOffSet: Integer): String;
const
  C_LIMIT = ' limit %d, %d';
begin

  Result := Format(C_LIMIT, [AOffSet, C_MAX_REG]);

end;


end.

