unit controller.contacorrente;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, controller.dataset, controller.banco, udatacollection;

type

  TContaCorrente = class;


type

  TDataContaCorrente = class(specialize TDataItem<TContaCorrente>);

type

  { TData }

  TData = class(specialize TDataCollecion<TDataContaCorrente>)
    public
      function Add: TDataContaCorrente;
  end;

type

  { TContaCorrente }

  TContaCorrente = class(TControllerDataSet)
    private
      FAbertura: TDateTime;
      FBanco: TBanco;
      FData: TData;
      FID: Integer;
      FNumero: String;
      FSaldo: Currency;
    public
      constructor Create;
      destructor Destroy; override;
      procedure Clear;
      function Post: Integer; override;
      function Get(AID: Integer): Integer;
      procedure GetPage(APage: Integer = 1); override;
      property ID: Integer read FID write FID;
      property Banco: TBanco read FBanco;
      property Numero: String read FNumero write FNumero;
      property Abertura: TDateTime read FAbertura write FAbertura;
      property Saldo: Currency read FSaldo write FSaldo;
      property Data: TData read FData;
  end;

implementation

uses model.contacorrente;

{ TData }

function TData.Add: TDataContaCorrente;
begin
  Result := inherited as TDataContaCorrente;
end;

{ TContaCorrente }

constructor TContaCorrente.Create;
begin
  FBanco := TBanco.Create;
  FData := TData.Create;
  Clear;
end;

destructor TContaCorrente.Destroy;
begin
  FreeAndNil(FData);
  FreeAndNil(FBanco);
  inherited Destroy;
end;

procedure TContaCorrente.Clear;
begin

  FID := 0;
  FBanco.Clear;
  FNumero := '';
  FAbertura := Date;
  FSaldo := 0;

end;

function TContaCorrente.Post: Integer;
var
  MContaCorrente: TModelContaCorrente;
begin

  MContaCorrente := TModelContaCorrente.Create;
  try
    inherited Post;
    Result := MContaCorrente.Post(Self);
  finally
    FreeAndNil(MContaCorrente);
  end;
end;

function TContaCorrente.Get(AID: Integer): Integer;
var
  MContaCorrente: TModelContaCorrente;
begin

  MContaCorrente := TModelContaCorrente.Create;
  try
    Result := MContaCorrente.Get(AID, Self);
  finally
    FreeAndNil(MContaCorrente);
  end;

end;

procedure TContaCorrente.GetPage(APage: Integer);
var
  MContaCorrente: TModelContaCorrente;
begin

  MContaCorrente := TModelContaCorrente.Create;
  try
    MContaCorrente.OnProgress := @DoProgress;
    MContaCorrente.Get(Self, APage);
  finally
    FreeAndNil(MContaCorrente);
  end;
end;

end.

