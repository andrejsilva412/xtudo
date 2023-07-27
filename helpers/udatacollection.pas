unit udatacollection;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type

  { TDataCollecion }

  generic TDataCollecion<T> = class(TCollection)
    private
      function GetItems(Index: Integer): T;
      procedure SetItems(Index: Integer; AValue: T);
    public
      constructor Create; virtual;
      function Add: T;
      property Items[index : Integer]: T read GetItems write SetItems; default;
  end;

implementation

{ TDataCollecion }

function TDataCollecion.GetItems(Index: Integer): T;
begin
  Result := T(inherited Items[Index]);
end;

procedure TDataCollecion.SetItems(Index: Integer; AValue: T);
begin
  Items[Index].Assign(AValue);
end;

constructor TDataCollecion.Create;
begin
   inherited Create(T);
end;

function TDataCollecion.Add: T;
begin
  Result := T(inherited Add);
end;

end.

