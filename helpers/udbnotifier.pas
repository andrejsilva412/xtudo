unit udbnotifier;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, db;

type

  TProgress = procedure(const APosition: Integer; const AMax: Integer) of object;
  TDatabaseNotifier = procedure(AUpdateStatus: TUpdateStatus; const ARowsAffected: Integer) of object;

type

  { TDBNotifier }

  TDBNotifier = class
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

{ TDBNotifier }

procedure TDBNotifier.DoDataBaseNotify(AUpdateStatus: TUpdateStatus;
  const ARowsAffected: Integer);
begin

  if Assigned(FOnDatabaseNotify) then
    FOnDatabaseNotify(AUpdateStatus, ARowsAffected);

end;

procedure TDBNotifier.DoProgress(const APosition: Integer; const AMax: Integer);
begin

  if Assigned(FOnProgress) then
    FOnProgress(APosition, AMax);

end;

end.

