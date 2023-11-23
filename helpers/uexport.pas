unit uexport;

{$mode ObjFPC}{$H+}

interface

uses
  LazUTF8, Classes, SysUtils, Graphics, Forms, Dialogs, RxDBGrid, db,
  fpsTypes, fpSpreadsheet, DBGrids, fpsallformats;

type

  { TExport }

  TExport = class
    private
      procedure isValidDBGrid(AGrid: TRxDBGrid);
      procedure ConfigPageLayoutWorkSheet(AWorkSheet: TsWorksheet);
      function SaveDialog(out AFileName: String; AFilter: String; AExt: String): Boolean;
    public
      procedure ToSpreedSheet(AGrid: TRxDBGrid);
      procedure toTXT(AGrid: TRxDBGrid);
      procedure toHTML(AGrid: TRxDBGrid);
  end;

implementation

uses uconst, utils, uhtmlutils;

{ TExport }

procedure TExport.isValidDBGrid(AGrid: TRxDBGrid);
begin
  if not Assigned(AGrid.DataSource) then
    raise Exception.Create('DataSource not assigned.');

  if not Assigned(AGrid.DataSource.DataSet) then
    raise Exception.Create('DataSet not assigned.');

  if not AGrid.DataSource.DataSet.Active then
    raise Exception.Create('DataSet not active.');

  if AGrid.DataSource.DataSet.IsEmpty then
    raise Exception.Create('DataSet is empty.');
end;

procedure TExport.ConfigPageLayoutWorkSheet(AWorkSheet: TsWorksheet);
begin
  AWorkSheet.PageLayout.Headers[HEADER_FOOTER_INDEX_ALL] := '&C&D &T';
  AWorkSheet.PageLayout.Footers[HEADER_FOOTER_INDEX_ODD] := '&RPage &P of &N';
  AWorkSheet.PageLayout.Footers[HEADER_FOOTER_INDEX_EVEN] := '&LPage &P of &N';
end;

function TExport.SaveDialog(out AFileName: String; AFilter: String; AExt: String
  ): Boolean;
var
  SD: TSaveDialog;
begin

  SD := TSaveDialog.Create(nil);
  try
    SD.Filter := AFilter;
    SD.FileName := FormatDateTime('ddmmyyyyhhmmss', Now) + AExt;
    Result := SD.Execute;
    if Result then
      AFileName := SD.FileName;
  finally
    FreeAndNil(SD);
  end;

end;

procedure TExport.ToSpreedSheet(AGrid: TRxDBGrid);
var
  MyWorkbook: TsWorkbook;
  MyWorksheet: TsWorksheet;
  i, j, x: integer;
  bk: TBookMark;
  aFileName: String;
begin

  isValidDBGrid(AGrid);

  MyWorkbook := TsWorkbook.Create;
  MyWorksheet := MyWorkbook.AddWorksheet('Planilha 1');
  ConfigPageLayoutWorkSheet(MyWorksheet);

  with AGrid do
  begin

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
  end;

  if SaveDialog(aFileName, 'Planilha do Excel|.xls', STR_EXCEL_EXTENSION) then
    MyWorkbook.WriteToFile(aFileName, sfExcel8);

  MyWorkbook.Free;

end;

procedure TExport.toTXT(AGrid: TRxDBGrid);
const
  PX_PER_CHAR = 7;
  PAGEBREAK = true;
  LPP = 80;
var
  Ds: TDataSet;
  Book: TBookMark;
  RecCount: Integer;
  AFileName, Line: String;
  Column: TColumn;
  AText: TStringList;

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

    if (field.DataType = ftMemo) and (dgDisplayMemoText in AGrid.Options) then
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

    if (not PrintingRecord) and PageBreak and (AText.Count > 0) then
      Line := #12
    else
      Line := '';

    for c in AGrid.Columns do
    begin
      Column := TColumn(c);
      if Column.Visible and (Column.Width >= PX_PER_CHAR) then
      begin
        if PrintingRecord then
          CollectField
        else CollectHeader;
      end;
    end;
    AText.Add(Line);
  end;
begin

  isValidDBGrid(AGrid);

  AText := TStringList.Create;
  try
    Ds := AGrid.DataSource.DataSet;
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
        Ds.Next;
      end;
    finally
      Ds.GotoBookmark(Book);
      Ds.FreeBookmark(Book);
      Ds.EnableControls;
    end;

    if AText.Count > 0 then
    begin
      if SaveDialog(AFileName, 'Arquivo de Texto|.txt', '.txt') then
        AText.SaveToFile(AFileName);
    end;

  finally
    FreeAndNil(AText);
  end;

end;

procedure TExport.toHTML(AGrid: TRxDBGrid);
const
  cAlignText: array[TAlignment] of string = ('LEFT', 'RIGHT', 'CENTER');
var
  vColFormat: string;
  vColText: string;
  vAllWidth: Integer;
  vWidths: array of Integer;
  vBookmark: TBookMark;
  I, J: Integer;
  HTML: TStringList;
  AFileName: String;
begin

  isValidDBGrid(AGrid);

  HTML := TStringList.Create;
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
    HTML.Clear;
    HTML.Add('<TABLE BORDER=1 WIDTH="100%%">');
    HTML.Add(Format('<CAPTION>%s</CAPTION>', [StrToHtml(C_APP_TITLE)]));
    vColFormat := '';
    vColText := '';
    vColFormat := vColFormat + '<TR>'#13#10;
    vColText := vColText + '<TR>'#13#10;
    J := 0;
    for I := 0 to AGrid.Columns.Count - 1 do
      if AGrid.Columns[I].Visible then
      begin
        vColFormat := vColFormat + Format(
          '  <TD ALIGN=%s WIDTH="%d%%">DisplayText%d</TD>'#13#10,
          [cAlignText[AGrid.Columns[I].Alignment],
            Round(vWidths[J] / vAllWidth * 100), J]);
        vColText := vColText + Format(
          '  <TD ALIGN=%s WIDTH="%d%%">%s</TD>'#13#10,
          [cAlignText[AGrid.Columns[I].Alignment],
            Round(vWidths[J] / vAllWidth * 100),
            StrToHtml(Utf8ToAnsi(AGrid.Columns[I].Title.Caption),
            AGrid.Columns[I].Title.Font)]);
        Inc(J);
      end;
    vColFormat := vColFormat + '</TR>'#13#10;
    vColText := vColText + '</TR>'#13#10;
    HTML.Text := HTML.Text + vColText;
    AGrid.DataSource.DataSet.First;
    while not AGrid.DataSource.DataSet.Eof do
    begin
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
      HTML.Text := HTML.Text + vColText;
      AGrid.DataSource.DataSet.Next;
    end;
    HTML.Add('</TABLE>');

    if SaveDialog(AFileName, 'Página da Web|.html', '.html') then
      HTML.SaveToFile(AFileName);

  finally
    AGrid.DataSource.DataSet.Bookmark := vBookmark;
    AGrid.DataSource.DataSet.EnableControls;
    vWidths := nil;
    FreeAndNil(HTML);
  end;

end;

end.

