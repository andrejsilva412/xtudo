unit utils;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, LCLType, Forms;

function GetResourceToString(AResource: String): String;
function IIf(Expressao: Variant; ParteTRUE, ParteFALSE: Variant): Variant;
function Path: String;

implementation

function GetResourceToString(AResource: String): String;
var
  RS: TResourceStream;
  SS: TStringStream;
begin

  SS := TStringStream.Create('');
  RS := TResourceStream.Create(HINSTANCE, AResource, RT_RCDATA);
  try
    Result := '';
    try
      RS.Position := 0;
      SS.CopyFrom(RS, RS.Size);
      Result := SS.DataString;
    except
      raise Exception.Create('Resource not found.');
    end;
  finally
    FreeAndNil(SS);
    FreeAndNil(RS);
  end;

end;

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

