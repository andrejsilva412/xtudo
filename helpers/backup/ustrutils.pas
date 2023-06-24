unit ustrutils;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

function DelChars(const S: string; Chr: Char): string; overload;
function DelChars(const S: string; Chr: String): string; overload;
procedure Split(const Delimiter: Char; Input: String;
  const Strings: TStrings);

implementation

function DelChars(const S: string; Chr: Char): string;
var
  I: Integer;
begin

  Result := S;
  for I := Length(Result) downto 1 do
     if Result[I] = Chr then Delete(Result, I, 1);

end;

function DelChars(const S: string; Chr: String): string;
var
  i: Integer;
begin

  Result := S;
  for i := Length(Result) downto 1 do
      if Result[i] = Chr then Delete(Result, I, 1);

end;

procedure Split(const Delimiter: Char; Input: String; const Strings: TStrings);
begin
  Assert(Assigned(Strings));
  Strings.Clear;
  Strings.Delimiter := Delimiter;
  Strings.DelimitedText := Input;
end;

end.

