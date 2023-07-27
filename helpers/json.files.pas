unit json.files;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Variants, fpjson, jsonparser;

type

  { TFPJson }

  TFPJson = class
    private
      FFileName: String;
      function ReadVariant(Ident: String; Default: Variant): Variant;
      procedure WriteVariant(Ident: String; Value: Variant);
    public
      function ReadString(Ident: String; Default: String): String; overload;
      function ReadBoolean(Ident: String; Default: Boolean): Boolean; overload;
      procedure WriteString(Ident: String; Value: String); overload;
      procedure WriteBoolean(IDent: String; Value: Boolean); overload;
      property FileName: String read FFileName write FFileName;
  end;

implementation

uses utils;

{ TFPJson }

function TFPJson.ReadVariant(Ident: String; Default: Variant): Variant;
var
  AFile: TStringList;
  JSON: TJSONObject;
begin

  if not FileExists(FFileName) then
    raise Exception.Create('Arquivo não encontrado.');

  AFile := TStringList.Create;
  try
    AFile.LoadFromFile(FFileName);
    JSON := TJSONData(GetJSON(AFile.Text)) as TJSONObject;
    if JSON <> nil then
    begin
      if JSON.FindPath(Ident) <> nil then
        Result := JSON.Get(Ident)
      else
        Result := Default;
    end else Result := Default;
  finally
    FreeAndNil(JSON);
    FreeAndNil(AFile);
  end;

end;

procedure TFPJson.WriteVariant(Ident: String; Value: Variant);
var
  JSON: TJSONObject;
  AFile: TStringList;
begin

  JSON := TJSONObject.Create;
  AFile := TStringList.Create;
  try
    if FileExists(FFileName) then
    begin
      AFile.LoadFromFile(FFileName);
      JSON := TJSONData(GetJSON(AFile.Text)) as TJSONObject;
    end;
    if (JSON = nil) then
      JSON := TJSONObject.Create;
    if JSON.Get(Ident) <> '' then
    begin
      case VarType(Value) of
        varSmallInt, varInteger, varInt64:
          JSON.Integers[Ident] := Value;
        varDouble:
          JSON.Floats[Ident] := Value;
        varBoolean:
          JSON.Booleans[Ident] := Value;
        else
         JSON.Strings[Ident] := Value;
      end;
    end else begin
      case VarType(Value) of
        varSmallInt, varInteger, varInt64:
           {$ifdef CPU32}
           JSON.Add(Ident, TJSONIntegerNumber(Integer(Value)));
           {$endif}
           {$ifdef CPU64}
           JSON.Add(Ident, TJSONInt64Number(Int64(Value)));
           {$endif}
        varDouble:
           JSON.Add(Ident, TJSONFloat(Value));
        varBoolean: begin
            Value := iif(Value = true, 1, 0);
            {$ifdef CPU32}
            JSON.Add(Ident, TJSONIntegerNumber(Integer(Value)));
            {$endif}
            {$ifdef CPU64}
            JSON.Add(Ident, TJSONInt64Number(Int64(Value)));
            {$endif}
            end;
        else
           JSON.Add(Ident, TJSONString(String(Value)));
      end;
    end;
    Value := JSON.AsJSON;
    AFile.Text := Value;
    AFile.SaveToFile(FFileName);
  finally
    FreeAndNil(JSON);
    FreeAndNil(AFile);
  end;

end;

function TFPJson.ReadString(Ident: String; Default: String): String;
begin

  Result := ReadVariant(Ident, Default);

end;

function TFPJson.ReadBoolean(Ident: String; Default: Boolean): Boolean;
begin

  Result := ReadVariant(Ident, Default);

end;

procedure TFPJson.WriteString(Ident: String; Value: String);
begin

  WriteVariant(Ident, Value);

end;

procedure TFPJson.WriteBoolean(IDent: String; Value: Boolean);
begin
  WriteVariant(IDent, Value);
end;

end.

