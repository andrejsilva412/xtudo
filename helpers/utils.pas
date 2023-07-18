unit utils;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms;

function IIf(Expressao: Variant; ParteTRUE, ParteFALSE: Variant): Variant;
function Path: String;

implementation

function IIf(Expressao: Variant; ParteTRUE, ParteFALSE: Variant): Variant;
begin
  if Expressao then
    Result := ParteTRUE
  else Result := ParteFALSE;
end;

function Path: String;
begin

  Result := ExtractFilePath(Application.ExeName);

end;

function GetConfigFileName: String;
begin

  if not DirectoryExists('config') then
    CreateDir('config');

  Result := 'config\config.json';

end;

end.

