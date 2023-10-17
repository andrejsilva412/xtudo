unit uformats;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, MaskEdit, SysUtils;

function FormataCEP(ACEP: String): String;
function FormataCNPJCPF(ADoc: String): String;
function FormataTelefone(aTelefone: String): String;

implementation

uses ustrutils;

function FormataCEP(ACEP: String): String;
begin
  Result := '';
  ACEP := RemoveChar(ACEP);
  if Length(ACEP) = 8 then
    Result := Copy(ACEP, 1, 5) + '-' + Copy(ACEP, 6, 8);
end;

function FormataCNPJCPF(ADoc: String): String;
begin
  ADoc := RemoveChar(ADoc);

  if length(ADoc) = 11 then
    Result := Copy(ADoc,1,3)+'.'+Copy(ADoc,4,3)+'.'+Copy(ADoc,7,3)+'-'+Copy(ADoc,10,2)
  else if length(ADoc) = 14 then
    Result := Copy(ADoc,1,2)+'.'+Copy(ADoc,3,3)+'.'+Copy(ADoc,6,3)+'/'+Copy(ADoc,9,4)+'-'+Copy(ADoc,13,2)
  else Result := ADoc;
end;

function FormataTelefone(aTelefone: String): String;
var
  sTel: String;
  bZero: Boolean;
  iDigitos: Integer;
begin

  aTelefone := FiltraString(aTelefone);
  sTel := RemoveChar(aTelefone);
  if sTel = '' then
    Result := ''
  else begin
    if sTel[1] = '0' then // Verifica se foi adicionado o 0 no ínicio do número
    begin
      bZero := true;
      sTel := Trim(copy(sTel, 2, Length(sTel))); // Remove para fazer a formatação depois adiciona
    end else
      bZero := false;
    iDigitos := Length(sTel);
    // Formata de acordo com a quantidade de números encontrados
    case iDigitos of
      8: begin
          Result := FormatMaskText('9999-9999;0;_', sTel); //8 digitos SEM DDD (ex: 34552318)
          if bZero then
            Insert('0', Result, 1);
         end;
      9 : begin
            Result := FormatMaskText('9 9999-9999;0;_', sTel); //9 digitos SEM DDD (ex: 991916889)
            if bZero then
              Insert('0', Result, 1)
            else

          end;
     10 : begin
            Result := FormatMaskText('(99) 9999-9999;0;_', sTel); //8 Digitos (convencional, ex: 7734552318)
           if bZero then
             Insert('0', Result, 2);
          end;
     11 : begin
            Result := FormatMaskText('(99) 9 9999-9999;0;_', sTel); //9 Digitos (novos números, ex: 77991916889)
            if bZero then
              Insert('0', Result, 2);
          end;
     12 : begin
            Result := FormatMaskText('99(99)9999-9999;0;_', sTel); //Se foram 12 digitos possívelmente digitou a operadora também
            if bZero then
              Insert('0', Result, 4);
          end;
     13 : begin
            Result := FormatMaskText('99(099)9 9999-9999;0;_', sTel); //Se foram 13 digitos possívelmente digitou a operadora também
            if bZero then
              Insert('0', Result, 4);
          end
     else
       Result := aTelefone; //Mantém na forma que o usuário digitou
    end;
  end;

end;

end.

