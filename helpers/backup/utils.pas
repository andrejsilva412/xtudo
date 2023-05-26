unit utils;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

function Path: String;

implementation

function Path: String;
begin

  Result := ExtractFilePath(Application.ExeName);

end;

end.

