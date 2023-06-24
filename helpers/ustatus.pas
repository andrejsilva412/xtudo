unit ustatus;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, db;

type

  TProgress = procedure(const APosition: Integer; const AMax: Integer) of object;
  TDatabaseNotifier = procedure(AUpdateStatus: TUpdateStatus; const ARowsAffected: Integer) of object;

type

  { TDBStatus }

  TDBStatus = class
    private
      FOnDatabaseNotify: TDatabaseNotifier;
      FOnProgress: TProgress;
    protected
      procedure DoDataBaseNotify(AUpdateStatus: TUpdateStatus; const ARowsAffected: Integer);
      procedure DoProgress(const APosition: Integer; const AMax: Integer);
    public
      property OnDatabaseNotify: TDatabaseNotifier read FOnDatabaseNotify write FOnDatabaseNotify;
      property OnProgress: TProgress read FOnProgress write FOnProgress;
  end;


implementation

{ TDBStatus }

procedure TDBStatus.DoDataBaseNotify(AUpdateStatus: TUpdateStatus;
  const ARowsAffected: Integer);
begin

  if Assigned(FOnDatabaseNotify) then
    FOnDatabaseNotify(AUpdateStatus, ARowsAffected);

end;

procedure TDBStatus.DoProgress(const APosition: Integer; const AMax: Integer);
begin

  if Assigned(FOnProgress) then
    FOnProgress(APosition, AMax);

end;

end.

