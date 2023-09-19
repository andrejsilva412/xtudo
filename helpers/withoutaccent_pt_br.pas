(*
  WithoutAccent_pt_BR, Version 1.0.
  Copyright (C) 2010-2012 Silvio Clecio.

  http://silvioprog.com.br

  LICENSE LGPL v2.1 - http://www.gnu.org/licenses/lgpl-2.1.txt

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*)

unit withoutaccent_pt_br;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, StdCtrls, Classes;

const
  CWithAccent: array [0..48] of string = ('à', 'á', 'â', 'ã', 'ä', 'è', 'é',
    'ê', 'ë', 'ì', 'í', 'î', 'ï', 'ò', 'ó', 'ô', 'õ', 'ö', 'ù', 'ú', 'û', 'ü',
    'À', 'Á', 'Â', 'Ã', 'Ä', 'È', 'É', 'Ê', 'Ë', 'Ì', 'Í', 'Î', 'Ò', 'Ó', 'Ô',
    'Õ', 'Ö', 'Ù', 'Ú', 'Û', 'Ü', 'ç', 'Ç', 'ñ', 'Ñ', 'º', 'ª');
  CWithoutAccent: array [0..48] of string = ('a', 'a', 'a', 'a', 'a', 'e', 'e',
    'e', 'e', 'i', 'i', 'i', 'i', 'o', 'o', 'o', 'o', 'o', 'u', 'u', 'u', 'u',
    'A', 'A', 'A', 'A', 'A', 'E', 'E', 'E', 'E', 'I', 'I', 'I', 'O', 'O', 'O',
    'O', 'O', 'U', 'U', 'U', 'U', 'c', 'C', 'n', 'N','','');

type

  { TRegisteredObjects }

  TRegisteredObjects = class(TList)
  public
    destructor Destroy; override;
  end;

  { TWithoutAccent }

  TWithoutAccent = class
  private
    FOldOnChange: TNotifyEvent;
    function GetOldOnChange: TNotifyEvent;
    procedure SetOldOnChange(const AValue: TNotifyEvent);
  public
    procedure OnChange(Sender: TObject);
    procedure RegisterEdit(var AEdit: TCustomEdit);
    property OldOnChange: TNotifyEvent read GetOldOnChange write SetOldOnChange;
  end;

  { TWithoutAccent_pt_BR }

  TWithoutAccent_pt_BR = class
  public
    class procedure RegisterEdits(AEdits: array of TCustomEdit);
    class procedure RegisterEdit(AEdit: TCustomEdit);
  end;

function WithoutAccent_ptBR(const AWithAccent: string): string;

implementation

uses
  StrUtils;

var
  _RegisteredObjects: TRegisteredObjects;

function WithoutAccent_ptBR(const AWithAccent: string): string;
begin
  Result := StringsReplace(AWithAccent, CWithAccent, CWithoutAccent, [rfReplaceAll]);
end;

{ TWithoutAccent }

procedure TWithoutAccent.OnChange(Sender: TObject);
var
  I: integer;
  S: string;
  VEdit: TCustomEdit;
begin
  VEdit := TCustomEdit(Sender);
  S := WithoutAccent_ptBR(VEdit.Text);
  if S <> VEdit.Text then
  begin
    I := VEdit.SelStart;
    VEdit.Text := S;
    VEdit.SelStart := I;
  end;
  if Assigned(FOldOnChange) then
    FOldOnChange(Sender);
end;

function TWithoutAccent.GetOldOnChange: TNotifyEvent;
begin
  Result := FOldOnChange;
end;

procedure TWithoutAccent.SetOldOnChange(const AValue: TNotifyEvent);
begin
  FOldOnChange := AValue;
end;

procedure TWithoutAccent.RegisterEdit(var AEdit: TCustomEdit);
begin
  if Assigned(AEdit.OnChange) then
    FOldOnChange := AEdit.OnChange;
  AEdit.OnChange := @OnChange;
end;

{ TWithoutAccent_pt_BR }

class procedure TWithoutAccent_pt_BR.RegisterEdits(AEdits: array of TCustomEdit);
var
  I: Integer;
  VWithoutAccent: TWithoutAccent;
begin
  for I := 0 to Pred(High(AEdits)) do
  begin
    VWithoutAccent := TWithoutAccent.Create;
    VWithoutAccent.RegisterEdit(AEdits[I]);
    _RegisteredObjects.Add(VWithoutAccent);
  end;
end;

class procedure TWithoutAccent_pt_BR.RegisterEdit(AEdit:TCustomEdit);
var
  VWithoutAccent: TWithoutAccent;
begin
    VWithoutAccent := TWithoutAccent.Create;
    VWithoutAccent.RegisterEdit(AEdit);
    _RegisteredObjects.Add(VWithoutAccent);
end;

{ TRegisteredObjects }

destructor TRegisteredObjects.Destroy;
var
  I: Integer;
begin
  for I := 0 to Pred(Count) do
    TObject(Items[I]).Free;
  inherited Destroy;
end;

initialization
  _RegisteredObjects := TRegisteredObjects.Create;

finalization
  _RegisteredObjects.Free;

end.
