unit udatacollection;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type

  { TDataCollecion }

  generic TDataCollecion<T> = class(TCollection)
    private
      FMaxPage: Integer;
      function GetItems(Index: Integer): T;
      procedure SetItems(Index: Integer; AValue: T);
    public
      constructor Create; virtual;
      function Add: T;
      property Items[index : Integer]: T read GetItems write SetItems; default;
      property MaxPage: Integer read FMaxPage write FMaxPage;
  end;

type

  { TDataItem }

  generic TDataItem<T> = class(TCollectionItem)
    private
      FEntitie: T;
    public
      constructor Create(ACollection: TCollection); override;
      destructor Destroy; override;
      function This: T;
    end;

implementation

{ TDataItem }

constructor TDataItem.Create(ACollection: TCollection);
begin
  inherited Create(ACollection);
  FEntitie := T.Create;
end;

destructor TDataItem.Destroy;
begin
  FreeAndNil(FEntitie);
  inherited Destroy;
end;

function TDataItem.This: T;
begin
  Result := FEntitie;
end;

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

