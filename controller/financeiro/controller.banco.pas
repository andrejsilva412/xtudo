unit controller.banco;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, controller.dataset, udatacollection;

type

  TBanco = class;


type
  TDataBanco = class(specialize TDataItem<TBanco>);

type

  { TData }

  TData = class(specialize TDataCollecion<TDataBanco>)
    public
      function Add: TDataBanco;
  end;


type

  { TBanco }

  TBanco = class(TControllerDataSet)
    private
      FCodigo: String;
      FData: TData;
      FID: Integer;
      FNome: String;
    public
      constructor Create;
      destructor Destroy; override;
      procedure Clear;
      function Post: Integer; override;
      function Get(AID: Integer): Integer;
      procedure GetPage(APage: Integer = 1); override;
      property ID: Integer read FID write FID;
      property Codigo: String read FCodigo write FCodigo;
      property Nome: String read FNome write FNome;
      property Data: TData read FData write FData;
  end;


implementation

uses model.banco;

{ TData }

function TData.Add: TDataBanco;
begin
  Result := inherited as TDataBanco;
end;

{ TBanco }

constructor TBanco.Create;
begin
  FData := TData.Create;
  Clear;
end;

destructor TBanco.Destroy;
begin
  FreeAndNil(FData);
  inherited Destroy;
end;

procedure TBanco.Clear;
begin
  FID := 0;
  FCodigo := EmptyStr;
  FNome := EmptyStr;
end;

function TBanco.Post: Integer;
var
  MBanco: TModelBanco;
begin

  MBanco := TModelBanco.Create;
  try
    inherited Post;
    Result := MBanco.Post(Self);
  finally
    FreeAndNil(MBanco);
  end;

end;

function TBanco.Get(AID: Integer): Integer;
var
  MBanco: TModelBanco;
begin

  MBanco := TModelBanco.Create;
  try
    Result := MBanco.Get(AID, Self);
  finally
    FreeAndNil(MBanco);
  end;

end;

procedure TBanco.GetPage(APage: Integer);
var
  MBanco: TModelBanco;
begin

  MBanco := TModelBanco.Create;
  try
    MBanco.OnProgress := @DoProgress;
    MBanco.Get(Self, APage);
  finally
    FreeAndNil(MBanco);
  end;

end;

end.

