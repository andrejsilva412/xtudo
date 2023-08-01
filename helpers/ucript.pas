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
      function GetSha256(AString: String): String;
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

function TCript.GetSha256(AString: String): String;
var
  Hash: TDCP_sha256;
  Digest: array[0..31] of byte;  // sha256 produces a 256bit digest (32bytes)
  i: integer;
  str1: string;
begin

  Result := AString;

  if AString <> '' then
  begin
    Hash := TDCP_sha256.Create(nil);
    try
      Hash.Init;
      Hash.UpdateStr(AString);
      Hash.Final(Digest);
      str1 := '';
      for i := 0 to 31 do
        str1 := str1 + IntToHex(Digest[i], 2);
      Result := str1;
    finally
      FreeAndNil(Hash);
    end;
  end;

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

