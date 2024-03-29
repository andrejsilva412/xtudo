unit ustrutils;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

function DelChars(const S: string; Chr: Char): string; overload;
function DelChars(const S: string; Chr: String): string; overload;
// Remove espaços e acentos
function FiltraString(AStr: String; AUpperCase: Boolean = true): String;
function RemoveAcentos(Str: String;
   RemoveEspacosDuplos: Boolean = true; aStrToUpper: Boolean = false): String;
// Remove todos os caracteres deixando apenas os números
function RemoveChar(const Texto: String): String;
procedure Split(const Delimiter: Char; Input: String;
  const Strings: TStrings);
function TextoEntre(Texto,
    Caracter1, Caracter2: String; caseSensitive: Boolean = false): String;

implementation

uses withoutaccent_pt_br;

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

function FiltraString(AStr: String; AUpperCase: Boolean): String;
const
  cDouble = '  ';
  cOne = ' ';
begin

  while pos(cDouble, AStr) > 0 do
    AStr := StringReplace(AStr, cDouble, cOne, [rfReplaceAll]);

  AStr := Trim(RemoveAcentos(AStr));

  if AUpperCase then
    AStr := UpperCase(AStr);

  Result := AStr;

end;

function RemoveAcentos(Str: String; RemoveEspacosDuplos: Boolean;
  aStrToUpper: Boolean): String;
const
  xCarExt: array[1..48] of string = ('<','>','!','@','#','$','%','¨','&','*',
                                   '(',')','_','+','=','{','}','[',']','?',
                                   ';',':',',','|','*','"','~','^','´','`',
                                   '¨','æ','Æ','ø','£','Ø','ƒ','ª','º','¿',
                                   '®','½','¼','ß','µ','þ','ý','Ý');
var
  i: Integer;
begin

  Result := Str;

  if Result = '' then
    exit;

  Result := WithoutAccent_ptBR(Result);

  if RemoveEspacosDuplos then
    for i := 0 to Length(Result) do
      if (Result[i] = ' ') and (Result[i+1] = '') then
        Delete(Result, i+1, 1);

  if RemoveEspacosDuplos then
    Result := Trim(Result);

  for i := 1 to 48 do
    Result := StringReplace(Result, xCarExt[i], '', [rfReplaceAll]);

  if aStrToUpper then
    Result := UpperCase(Result);

end;

function RemoveChar(const Texto: String): String;
var
   I: Integer;
   S: String;
begin

   S := '';
   for I := 1 To Length(Texto) Do
   begin
      if (Texto[I] in ['0'..'9']) then
      begin
        S := S + Copy(Texto, I, 1);
      end;
   end;

   Result := S;

end;

procedure Split(const Delimiter: Char; Input: String; const Strings: TStrings);
begin
  Assert(Assigned(Strings));
  Strings.Clear;
  Strings.Delimiter := Delimiter;
  Strings.DelimitedText := Input;
end;

function TextoEntre(Texto, Caracter1, Caracter2: String; caseSensitive: Boolean
  ): String;
var
  Pos1, Pos2: Integer;
begin

  Result := Texto;

  if caseSensitive then
    Pos1 := Pos(Caracter1, Result)
  else
    Pos1 := Pos(AnsiUpperCase(Caracter1),
     AnsiLowerCase(Result));

  if Pos1 > 0 then
    Result := Copy(Result,
      Pos1 + Length(Caracter1), Length(Result));

  if caseSensitive then
   Pos2 := Pos(Caracter2, Result)
  else Pos2 := Pos(AnsiUpperCase(Caracter2), AnsiUpperCase(Result));

  if Pos2 > 0 then
    Result := Copy(Result, 1, Pos2 - 1);

end;

end.

