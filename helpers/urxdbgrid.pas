unit urxdbgrid;

{$mode ObjFPC}{$H+}

// Referencia
//https://wiki.lazarus.freepascal.org/Grids_Reference_Page#Sorting_columns_or_rows_in_DBGrid_with_sort_arrows_in_column_header

interface

uses
  LCLIntf, LazUTF8, Forms, Classes, Graphics, uhtmlutils, DBGrids, SysUtils,
  ustatus, RxDBGrid, db, fpsTypes, fpSpreadsheet;

type

  { TRxDBGrid }

  TRxDBGrid = class(RxDBGrid.TRxDBGrid)
    private
      FOnProgress: TProgress;
      procedure ConfigPageLayoutWorkSheet(AWorkSheet: TsWorksheet);
      function ColorToHtml(AColor: TColor): String;
      function toTXT(Sender: TObject; lpp: Integer; PageBreak: Boolean): TStringList;
      function toHTML(Sender: TObject; ACaption: String): TStringList;
      function StrToHtml(mStr: string; mFont: TFont = nil): string;
      procedure AddMask(Sender: TObject);
    protected
      procedure DoProgress(const APosition: Integer; const AMax: Integer);
    public
      constructor Create(AOwner: TComponent); override;
      procedure ExportToSpreedSheet(aFileName: String;  aOpenFile: Boolean = true);
      // AGrid the Grid to Export, lpp: Lines per page. Not including the text header, pageBreak: insert a page break that some printers could use for starting a new page
      procedure ExportToTXT(aFileName: String; lpp: Integer = 80;
        PageBreak: Boolean = true; aOpenFile: Boolean = true);
      procedure ExportToHTML(aFileName: String; ACaption: String;
        aOpenFile: Boolean = true);
      property OnProgress: TProgress read FOnProgress write FOnProgress;
  end;

implementation

uses uconst, utils;

{ TRxDBGrid }

procedure TRxDBGrid.ConfigPageLayoutWorkSheet(AWorkSheet: TsWorksheet);
begin
  AWorkSheet.PageLayout.Headers[HEADER_FOOTER_INDEX_ALL] := '&C&D &T';
  AWorkSheet.PageLayout.Footers[HEADER_FOOTER_INDEX_ODD] := '&RPage &P of &N';
  AWorkSheet.PageLayout.Footers[HEADER_FOOTER_INDEX_EVEN] := '&LPage &P of &N';
end;

function TRxDBGrid.ColorToHtml(AColor: TColor): String;
var
  htmlUtils: THTMLUtils;
begin

  htmlUtils := THTMLUtils.Create;
  try
    Result := htmlUtils.ColorToHTML(AColor);
  finally
    FreeAndNil(htmlUtils);
  end;

end;

function TRxDBGrid.toTXT(Sender: TObject; lpp: Integer; PageBreak: Boolean
  ): TStringList;
const
  PX_PER_CHAR = 7;
var
  Ds: TDataSet;
  Book: TBookMark;
  RecCount: Integer;
  Line: String;
  Column: TColumn;


  function WidthToChar(aWidth: Integer): Integer;
  begin
    Result := Trunc(aWidth / PX_PER_CHAR);
  end;

  procedure AddNext(theText: String; Alignment: TAlignment);
  var
    Width: Integer;
  begin
    if (Line <> '') and (Line <> #12) then
      Line := Line + ' ';
    Width := WidthToChar(Column.Width);

    case Alignment of
      taRightJustify: Line := Line + UTF8PadLeft(theText, Width);
      taCenter: Line := Line + UTF8PadCenter(theText, Width);
      else
        Line := Line + UTF8PadRight(theText, Width);
    end;
  end;

  procedure CollectHeader;
  begin
    AddNext(Column.Title.Caption, Column.Title.Alignment);
  end;

  procedure CollectField;
  var
    field: TField;
  begin
    field := Column.Field;

    if (field.DataType = ftMemo) and (dgDisplayMemoText in TRXDBGrid(Sender).Options) then
      AddNext(field.AsString, Column.Alignment)
    else if field.DataType <> ftBlob then
      AddNext(field.DisplayText, Column.Alignment)
    else
      AddNext('(blob)',  Column.Alignment);
  end;

  procedure LoopColumns(PrintingRecord: Boolean);
  var
    c: TCollectionItem;
  begin

    if (not PrintingRecord) and PageBreak and (result.Count > 0) then
      Line := #12
    else
      Line := '';

    for c in TRXDBGrid(Sender).Columns do
    begin
      Column := TColumn(c);
      if Column.Visible and (Column.Width >= PX_PER_CHAR) then
      begin
        if PrintingRecord then
          CollectField
        else CollectHeader;
      end;
    end;
    result.Add(Line);
  end;
begin

  Result := TStringList.Create;

  Ds := TRXDBGrid(Sender).DataSource.DataSet;
  Ds.DisableControls;
  Book := Ds.GetBookmark;
  try
    Ds.First;
    RecCount := 0;
    while not Ds.EOF do
    begin
      if RecCount mod lpp = 0 then
        LoopColumns(false);
      LoopColumns(True);
      inc(RecCount);
      DoProgress(Ds.RecNo, Ds.RecordCount);
      Application.ProcessMessages;
      Ds.Next;
    end;
  finally
    Ds.GotoBookmark(Book);
    Ds.FreeBookmark(Book);
    Ds.EnableControls;
  end;

end;

function TRxDBGrid.toHTML(Sender: TObject; ACaption: String): TStringList;
const
  cAlignText: array[TAlignment] of string = ('LEFT', 'RIGHT', 'CENTER');
var
  vColFormat: string;
  vColText: string;
  vAllWidth: Integer;
  vWidths: array of Integer;
  vBookmark: TBookMark;
  I, J: Integer;
  AGrid: TRxDBGrid;
begin

  AGrid := TRxDBGrid(Sender);

  if not AGrid.DataSource.DataSet.Active then exit;
  if AGrid.DataSource.DataSet.IsEmpty then exit;

  Result := TStringList.Create;

  vBookmark := AGrid.DataSource.DataSet.Bookmark;
  AGrid.DataSource.DataSet.DisableControls;
  try
    J := 0;
    vAllWidth := 0;
    vWidths := [];
    for I := 0 to AGrid.Columns.Count - 1 do
      if AGrid.Columns[I].Visible then
      begin
        Inc(J);
        SetLength(vWidths, J);
        vWidths[J - 1] := AGrid.Columns[I].Width;
        Inc(vAllWidth, AGrid.Columns[I].Width);
      end;
    if J <= 0 then exit;
    Result.Clear;
    Result.Add(Format('<TABLE BGCOLOR="%s" BORDER=1 WIDTH="100%%">',
      [ColorToHtml(AGrid.Color)]));
    if ACaption <> '' then
      Result.Add(Format('<CAPTION>%s</CAPTION>', [StrToHtml(ACaption)]));
    vColFormat := '';
    vColText := '';
    vColFormat := vColFormat + '<TR>'#13#10;
    vColText := vColText + '<TR>'#13#10;
    J := 0;
    for I := 0 to AGrid.Columns.Count - 1 do
      if AGrid.Columns[I].Visible then
      begin
        vColFormat := vColFormat + Format(
          '  <TD BGCOLOR="%s" ALIGN=%s WIDTH="%d%%">DisplayText%d</TD>'#13#10,
          [ColorToHtml(AGrid.Columns[I].Color),
          cAlignText[AGrid.Columns[I].Alignment],
            Round(vWidths[J] / vAllWidth * 100), J]);
        vColText := vColText + Format(
          '  <TD BGCOLOR="%s" ALIGN=%s WIDTH="%d%%">%s</TD>'#13#10,
          [ColorToHtml(AGrid.Columns[I].Title.Color),
          cAlignText[AGrid.Columns[I].Alignment],
            Round(vWidths[J] / vAllWidth * 100),
            StrToHtml(Utf8ToAnsi(AGrid.Columns[I].Title.Caption),
            AGrid.Columns[I].Title.Font)]);
        Inc(J);
      end;
    vColFormat := vColFormat + '</TR>'#13#10;
    vColText := vColText + '</TR>'#13#10;
    Result.Text := Result.Text + vColText;
    AGrid.DataSource.DataSet.First;
    while not AGrid.DataSource.DataSet.Eof do
    begin
      DoProgress(AGrid.DataSource.DataSet.RecNo,
       AGrid.DataSource.DataSet.RecordCount);
      Application.ProcessMessages;

      J := 0;
      vColText := vColFormat;
      for I := 0 to AGrid.Columns.Count - 1 do
        if AGrid.Columns[I].Visible then
        begin
          vColText := StringReplace(vColText, Format('>DisplayText%d<', [J]),
            Format('>%s<', [StrToHtml(Utf8ToAnsi(AGrid.Columns[I].Field.DisplayText),
              AGrid.Columns[I].Font)]),
            [rfReplaceAll]);
          Inc(J);
        end;
      Result.Text := Result.Text + vColText;
      AGrid.DataSource.DataSet.Next;
    end;
    Result.Add('</TABLE>');
  finally
    AGrid.DataSource.DataSet.Bookmark := vBookmark;
    AGrid.DataSource.DataSet.EnableControls;
    vWidths := nil;
  end;

end;

function TRxDBGrid.StrToHtml(mStr: string; mFont: TFont): string;
var
  vLeft, vRight: string;
begin

  Result := mStr;
  Result := StringReplace(Result, '&', '&AMP;', [rfReplaceAll]);
  Result := StringReplace(Result, '<', '&LT;', [rfReplaceAll]);
  Result := StringReplace(Result, '>', '&GT;', [rfReplaceAll]);
  if not Assigned(mFont) then
    Exit;
  vLeft := Format('<FONT FACE="%s" COLOR="%s">',
    [mFont.Name, ColorToHtml(mFont.Color)]);
  vRight := '</FONT>';
  if fsBold in mFont.Style then
  begin
    vLeft := vLeft + '<B>';
    vRight := '</B>' + vRight;
  end;
  if fsItalic in mFont.Style then
  begin
    vLeft := vLeft + '<I>';
    vRight := '</I>' + vRight;
  end;
  if fsUnderline in mFont.Style then
  begin
    vLeft := vLeft + '<U>';
    vRight := '</U>' + vRight;
  end;
  if fsStrikeOut in mFont.Style then
  begin
    vLeft := vLeft + '<S>';
    vRight := '</S>' + vRight;
  end;
  Result := vLeft + Result + vRight;

end;

procedure TRxDBGrid.AddMask(Sender: TObject);
var
  i: Integer;
  AGrid: TRxDBGrid;
begin

  AGrid := TRxDBGrid(Sender);
  for i := 0 to AGrid.Columns.Count - 1 do
  begin
    if AGrid.Columns.Items[i].Field.DataType = ftCurrency then
    begin
      AGrid.Columns.Items[i].DisplayFormat := C_MOEDA;
      AGrid.Columns.Items[i].Footer.DisplayFormat := C_MOEDA;
    end;
  end;

end;

procedure TRxDBGrid.DoProgress(const APosition: Integer; const AMax: Integer);
begin
  if Assigned(FOnProgress) then
    FOnProgress(APosition, AMax);
end;

constructor TRxDBGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TRxDBGrid.ExportToSpreedSheet(aFileName: String; aOpenFile: Boolean);
var
  MyWorkbook: TsWorkbook;
  MyWorksheet: TsWorksheet;
  i, j, x: integer;
  bk: TBookMark;
begin

  if not Assigned(DataSource) then exit;
  if not Assigned(DataSource.DataSet) then exit;
  if not DataSource.DataSet.Active then exit;
  if DataSource.DataSet.IsEmpty then exit;

  if aFileName = '' then
    raise Exception.Create(SMSGInformeNomeArquivo);

  MyWorkbook := TsWorkbook.Create;
  MyWorksheet := MyWorkbook.AddWorksheet('Planilha 1');
  ConfigPageLayoutWorkSheet(MyWorksheet);

  DataSource.DataSet.DisableControls;
  try
    for i := 0 to Columns.Count -1 do
    begin
      if Columns[i].Visible then
      begin
        MyWorksheet.WriteText(
          0, i, Columns[i].Title.Caption);
        MyWorksheet.WriteFontStyle(0, i, [fssBold]);
      end;
    end;

    DataSource.DataSet.First;

    j := 1;
    bk := DataSource.DataSet.GetBookmark;
    if SelectedRows.Count > 0 then
    begin
      for x := 0 to SelectedRows.Count -1 do
      begin
        DoProgress(x+1, SelectedRows.Count);
        Application.ProcessMessages;

        DataSource.DataSet.GotoBookmark(
          Pointer(SelectedRows.Items[x]));

        for i := 0 to Columns.Count - 1 do
        begin
          if Columns[i].Visible then
          begin
            case Columns[i].Field.DataType of
              ftSmallint, ftLargeint, ftInteger:
                 MyWorksheet.WriteNumber(j + 1, i,
                    Columns[i].Field.AsFloat, nfGeneral, 0);
              ftDate: begin
                if (Columns[i].Field.AsDateTime <> 0)
                  and (not Columns[i].Field.IsNull)
                  and (DateToStr(Columns[i].Field.AsDateTime) <> '30/12/1899') then
                  MyWorksheet.WriteDateTime(j + 1, i,
                      Columns[i].Field.AsDateTime, nfShortDate)
                 else MyWorksheet.WriteText(j + 1, i, '');
              end;
              ftTime:
                MyWorksheet.WriteDateTime(j + 1, i,
                   Columns[i].Field.AsDateTime, nfShortTime);
              ftDateTime:
                 MyWorksheet.WriteDateTime(j + 1, i,
                   Columns[i].Field.AsDateTime, nfShortDateTime);
              ftFloat:
                MyWorksheet.WriteNumber(j + 1, i,
                   Columns[i].Field.AsFloat, nfGeneral, 3);
              ftFMTBcd, ftCurrency, ftBCD:
                MyWorksheet.WriteCurrency(j + 1, i,
                   Columns[i].Field.AsCurrency,
                   iif(Columns[i].Field.AsCurrency >= 0,  nfCurrency, nfCurrencyRed), 2);
              else
                MyWorksheet.WriteText(j + 1, i, Columns[i].Field.DisplayText);
            end;
          end;
        end;
        inc(j);
      end;
    end else begin
      while not DataSource.DataSet.EOF do
      begin
        DoProgress(DataSource.DataSet.RecNo,
          DataSource.DataSet.RecordCount);
        Application.ProcessMessages;

        for i := 0 to Columns.Count -1 do
        begin
          if Columns[i].Visible then
          begin
            case Columns[i].Field.DataType of
              ftSmallint, ftLargeint, ftInteger:
                 MyWorksheet.WriteNumber(j + 1, i,
                    Columns[i].Field.AsFloat, nfGeneral, 0);
              ftDate: begin
                if (Columns[i].Field.AsDateTime <> 0)
                  and (not Columns[i].Field.IsNull)
                  and (DateToStr(Columns[i].Field.AsDateTime) <> '30/12/1899') then
                  MyWorksheet.WriteDateTime(j + 1, i,
                      Columns[i].Field.AsDateTime, nfShortDate)
                 else MyWorksheet.WriteText(j + 1, i, '');
              end;
              ftTime:
                MyWorksheet.WriteDateTime(j + 1, i,
                   Columns[i].Field.AsDateTime, nfShortTime);
              ftDateTime:
                 MyWorksheet.WriteDateTime(j + 1, i,
                   Columns[i].Field.AsDateTime, nfShortDateTime);
              ftFloat:
                MyWorksheet.WriteNumber(j + 1, i,
                   Columns[i].Field.AsFloat, nfGeneral, 3);
              ftFMTBcd, ftCurrency, ftBCD:
                MyWorksheet.WriteCurrency(j + 1, i,
                   Columns[i].Field.AsCurrency,
                   iif(Columns[i].Field.AsCurrency >= 0,  nfCurrency, nfCurrencyRed), 2);
              else
                MyWorksheet.WriteText(j + 1, i, Columns[i].Field.DisplayText);
            end;
          end;
        end;
        DataSource.DataSet.Next;
        inc(j);
      end;
    end;
    DataSource.DataSet.GotoBookmark(bk);
  finally
    DataSource.DataSet.EnableControls;
  end;
  MyWorkbook.WriteToFile(aFileName, sfExcel8);
  MyWorkbook.Free;

  if aOpenFile then
    if not OpenDocument(aFileName) then
      raise Exception.Create(SMGFalhaAoAbrirArquivo);

end;

procedure TRxDBGrid.ExportToTXT(aFileName: String; lpp: Integer;
  PageBreak: Boolean; aOpenFile: Boolean);
var
  Arq: TStringList;
begin

  Arq := TStringList.Create;
  try
    Arq := toTXT(Self, lpp, PageBreak);
    Arq.SaveToFile(aFileName);
    if aOpenFile then
      OpenDocument(aFileName);
  finally
    FreeAndNil(Arq);
  end;

end;

procedure TRxDBGrid.ExportToHTML(aFileName: String; ACaption: String;
  aOpenFile: Boolean);
var
  Arq: TStringList;
begin

  Arq := TStringList.Create;
  try
    Arq := toHTML(Self, ACaption);
    Arq.SaveToFile(aFileName);
    if aOpenFile then
      OpenDocument(aFileName);
  finally
    FreeAndNil(Arq);
  end;

end;

end.

