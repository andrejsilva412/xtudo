unit controller.pessoa;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, utypes, controller.endereco,
  controller.crud, udatacollection;

type

  { TContatoItem }

  TContatoItem = class(TCollectionItem)
    private
      FContato: String;
      FTipo: String;
    public
      property Tipo: String read FTipo write FTipo;
      property Contato: String read FContato write FContato;
  end;

  TContato = class(specialize TDataCollecion<TContatoItem>)
    public
      function Add: TContatoItem;
  end;
type

  { TPessoa }

  TPessoa = class(TControllerCRUD)
    private
      FContato: TContato;
      FEndereco: TEndereco;
      FGUID: String;
      FNome: String;
      FTipoContato: TTipoContato;
    public
      constructor Create;
      destructor Destroy; override;
      procedure Clear; virtual;
      property GUID: String read FGUID write FGUID;
      property Nome: String read FNome write FNome;
      property Endereco: TEndereco read FEndereco;
      property TipoContato: TTipoContato read FTipoContato write FTipoContato;
      property Contato: TContato read FContato;
  end;

implementation

{ TContato }

function TContato.Add: TContatoItem;
begin
  Result := inherited Add as TContatoItem;
end;

{ TPessoa }

constructor TPessoa.Create;
begin
  FEndereco := TEndereco.Create;
  FContato := TContato.Create;
end;

destructor TPessoa.Destroy;
begin
  FreeAndNil(FEndereco);
  FreeAndNil(FContato);
  inherited Destroy;
end;

procedure TPessoa.Clear;
begin

  FGUID := '';
  FNome := '';
  FEndereco.Clear;
  FContato.Clear;

end;

end.

