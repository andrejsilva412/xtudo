unit model.dmmain;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms;

type

  { TdmMain }

  TdmMain = class(TDataModule)
    ApplicationProperties1: TApplicationProperties;
    procedure ApplicationProperties1Exception(Sender: TObject; E: Exception);
  private

  public

  end;

var
  dmMain: TdmMain;

implementation

uses controller.sistema;

{$R *.lfm}

{ TdmMain }

procedure TdmMain.ApplicationProperties1Exception(Sender: TObject; E: Exception
  );
var
  Sistema: TSistema;
begin

  // Exceções do sistema
  Sistema := TSistema.Create;
  try
    Sistema.Log.Descricao := E.Message;
    Sistema.Log.Post;
    Sistema.Mensagem.Erro(E.Message);
  finally
    FreeAndNil(Sistema);
  end;

end;

end.

