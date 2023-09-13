unit utils;

{$mode ObjFPC}{$H+}

interface

uses
  SysUtils, Forms;

function IIf(Expressao: Variant; ParteTRUE, ParteFALSE: Variant): Variant;
function Path: String;
function FileSize(const Filename: String): Int64;

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

function FileSize(const Filename: String): Int64;
var
  F: File of byte;
begin

  Assign(F, Filename);
  Reset(F);
  FileSize := System.FileSize(F);
  Close(F);

end;

end.

