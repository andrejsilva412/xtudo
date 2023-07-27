unit ucript;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DCPblowfish, DCPsha256, md5;

type

  { TCript }

  TCript = class
    private
      FCipher: TDCP_blowfish;
    public
      constructor Create;
      destructor Destroy; override;
      function Sha256Encrypt(AString: String): String;
      function Sha256Decrypt(AStrCript: String): String;
      function GetHash(const AString: String): String;
  end;

const
  FPrivateKey = 'EE8DC5E2B153665DA9F25B872FD60C2AE05D444D55A819FC757C156AC6878C33';

implementation

{ TCript }

constructor TCript.Create;
begin
  FCipher := TDCP_blowfish.Create(nil);
end;

destructor TCript.Destroy;
begin
  FreeAndNil(FCipher);
  inherited Destroy;
end;

function TCript.Sha256Encrypt(AString: String): String;
begin

  FCipher.InitStr(FPrivateKey, TDCP_sha256);
  Result := FCipher.EncryptString(AString);
  FCipher.Burn;

end;

function TCript.Sha256Decrypt(AStrCript: String): String;
begin

  FCipher.InitStr(FPrivateKey, TDCP_sha256);
  Result := FCipher.DecryptString(AStrCript);
  FCipher.Burn;

end;

function TCript.GetHash(const AString: String): String;
var
  Str: String;
begin

  Str := Sha256Encrypt(AString);
  Result := MD5Print(MD5String(Str));

end;

end.

