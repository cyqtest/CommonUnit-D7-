unit JExcelProc;

interface

uses
  Windows, Forms, Classes, SysUtils, Dialogs, ComObj,
  Clipbrd, Variants, Controls;


//��tsList������ Excel
procedure WriteListToExcel(tsList: TStringList; StrColList: TStrings = nil);

//��tsList������ Excel �ļ�������Ҫϵͳ��װExcel��
procedure WriteListToExcelFile(xList: TStringList; AFileName: String = '');

//�滻��Ԫ�����ݵ� Tab �� �� ���м�
function ValidExcelCell(txt: String): String;

//��FTitleList�н��������ͷ���ַ�������#9�ָ��У���#13#10�ָ���
function GetExcelTitleStr(var FTitleList: TStringList; UseMultiTitle: Boolean): String;


implementation

//�滻 Tab ��ֵ �� ���м�ֵ
function ValidExcelCell(txt: String): String;
var
  sTemp: String;
begin
    sTemp := txt;
    if Pos(#9, sTemp) > 0 then
        sTemp := StringReplace(sTemp, #9, ' ', [rfReplaceAll]);
    if Pos(#13, sTemp) > 0 then
        sTemp := StringReplace(sTemp, #13, ' ', [rfReplaceAll]);
    if Pos(#10, sTemp) > 0 then
        sTemp := StringReplace(sTemp, #10, ' ', [rfReplaceAll]);
    Result := sTemp;
end;

//�滻�ַ�����ǰ�� =Trim("")
function ValidTrimCell(txt: String): String;
begin
    if Pos('=Trim("', txt) = 0 then
        Result := txt
    else
        Result := Copy(txt, Length('=Trim("') + 1, Length(txt) - Length('=Trim("') - Length('")'));
end;

//�����ͷ�ı�����
function GetExcelTitleStr(var FTitleList: TStringList; UseMultiTitle: Boolean): String;

  function GetFirstItem(var Str: String; Splitter: String): String;
  var
    p: Integer;
  begin
    Str := TrimLeft(Str);
    p := Pos(Splitter, Str);
    if p = 0 then begin
      Result := Trim(Str);
      Str := '';
    end else begin
      Result := TrimLeft(Copy(Str, 1, p - 1));
      Delete(Str, 1, p + Length(Splitter) - 1);
      Str := TrimLeft(Str);
    end
  end;
var
  s, sRow, sPre, sCur, sTemp: String;
  i: Integer;
  bEnd: Boolean;
  FList: TStringList;
begin
    bEnd := False;
    s := '';
    if UseMultiTitle then
    begin
        FList := TStringList.Create;
        FList.Assign(FTitleList);
        try
            While Not bEnd do
            begin
                sPre := '';
                sRow := '';
                bEnd := True;
                for i := 0 to FList.Count - 1 do
                begin
                    if bEnd then
                        bEnd := Pos('|', FList[i]) = 0;
                    sTemp := FList[i];
                    sCur := GetFirstItem(sTemp, '|');
                    FList[i] := sTemp;
                    sTemp := sCur;
                    if FList[i] <> '' then
                    begin
                        if sCur + '|' = sPre then
                            sTemp := '';
                        sPre := sCur + '|';
                    end
                    else
                        sPre := '';
                    sRow := sRow + ValidExcelCell(sTemp) + #9;
                end;  //for
                if sRow <> '' then
                    sRow := Copy(sRow, 1, Length(sRow) - Length(#9));

                //����
                s := s + sRow + #13#10;
            end;
            if s <> '' then
                s := Copy(s, 1, Length(s) - Length(#13#10));
        finally
            FreeAndNil(FList);
        end;
    end
    else
    begin
        for i := 0 to FTitleList.Count - 1 do
            s := s + ValidExcelCell(FTitleList[i]) + #9;
        if s <> '' then
            s := Copy(s, 1, Length(s) - Length(#9));
    end;

    Result := s;
end;

function GetFirstStr(var Str: String; Splitter: String): String;
var
  p: Integer;
begin
  p := Pos(Splitter, Str);
  if p = 0 then begin
    Result := Str;
    Str := '';
  end else begin
    Result := Copy(Str, 1, p - 1);
    Delete(Str, 1, p + Length(Splitter) - 1);
  end;
end;

//����Excel�ĵڼ��з����кţ��磺A��B��C�ȣ�
function GetExcelColName(ColIndex: Integer): String;
var
  Index, Rate: Integer;
begin
  if ColIndex < 26 then
    Result := Char(65 + ColIndex)
  else
  begin
    Rate := ColIndex div 26;
    Index := ColIndex mod 26;
    Result := GetExcelColName(Rate - 1) + GetExcelColName(Index);
  end;
end;

procedure XlsWriteCellLabel(XlsStream: TStream; const ACol, ARow: Word;
 const AValue: string);
var
    L: Word;
const
 {$J+}
  CXlsLabel: array[0..5] of Word = ($204, 0, 0, 0, 0, 0);
 {$J-}
begin 
    L := Length(AValue);
    CXlsLabel[1] := 8 + L;
    CXlsLabel[2] := ARow;
    CXlsLabel[3] := ACol;
    CXlsLabel[5] := L;
    XlsStream.WriteBuffer(CXlsLabel, SizeOf(CXlsLabel));
    XlsStream.WriteBuffer(Pointer(AValue)^, L);
end;

//���ܣ���List�����ݵ�����Excel�ļ���
procedure WriteListToExcelFile(xList: TStringList; AFileName: String);
const
  {$J+} CXlsBof: array[0..5] of Word = ($809, 8, 00, $10, 0, 0); {$J-}
  CXlsEof: array[0..1] of Word = ($0A, 00);
var 
  FStream: TFileStream;
  p, I, J: Integer;
  s, sRow, sCell: String;
  sd: TSaveDialog;
begin
    if xList.Count = 0 then
    begin
        Application.MessageBox('û�����ݿ��Ե�����', '��ʾ', MB_ICONWARNING);
        Exit;
    end;

    if AFileName = '' then
    begin
        sd := TSaveDialog.Create(nil);
        try
            sd.InitialDir := ExtractFilePath(Application.ExeName);
            sd.Filter := 'EXCEL �ļ�|*.xls';
            sd.DefaultExt := 'xls';
            if Not sd.Execute then Exit;
            if sd.FileName = '' then Exit;
            AFileName := sd.FileName;
        finally
            FreeAndNil(sd);
        end;
    end;

    FStream := TFileStream.Create(PChar(AFileName), fmCreate or fmOpenWrite);
    try
        CXlsBof[4] := 0;
        FStream.WriteBuffer(CXlsBof, SizeOf(CXlsBof));
        i := 0;
        for p := 0 to xList.Count - 1 do
        begin
            sRow := xList[p];
            while sRow <> '' do
            begin
                j := 0;
                s := GetFirstStr(sRow, #13#10);
                While s <> '' do
                begin
                    sCell := GetFirstStr(s, #9);
                    if sCell <> '' then
                        XlsWriteCellLabel(FStream, j, I, sCell); //ValidTrimCell(sCell));
                    Inc(j);
                end;
                Inc(i);
            end;
        end;
        FStream.WriteBuffer(CXlsEof, SizeOf(CXlsEof));
    finally
        FStream.Free;
    end;
end;

//���ܣ���List�����ݵ�����Excel�С�����StrColList�ᶨҪ���ı���ʽ��ʾ���к�
procedure WriteListToExcel(tsList: TStringList; StrColList: TStrings);
var
  Clipboard1: TClipboard;
  ExcelApp, ExcelSheet: Variant;
  Cur: TCursor;
  i: Integer;
  sColName: String;
begin
    if tsList.Count = 0 then
    begin
        Application.MessageBox('û�����ݿ��Ե�����', '��ʾ', MB_ICONWARNING);
        Exit;
    end;

    if tsList.Count > 10000 then
    begin
        if Application.MessageBox(PChar('��Ҫ���� ' + IntToStr(tsList.Count) + ' �����ݣ�����Ҫ���ѽϳ�ʱ�䡣'
                + #13#10 + #13#10 + 'Ҫ������'), '��ʾ', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2) = ID_NO then
            Exit;
    end;

    Cur := Screen.Cursor;
    Screen.Cursor := crHourGlass;
    try
        try
            ExcelApp := CreateOleObject('Excel.Application');
        except
            WriteListToExcelFile(tsList);
            //Application.MessageBox('�밲װExcel��', '����');
            Exit;
        end;
        ExcelSheet := CreateOleObject('Excel.Sheet');
        ExcelSheet := ExcelApp.WorkBooks.Add;
        ExcelApp.Visible := True;
        try
            //==���а�== ��Ҫuses : Clipbrd
            try
                if Clipboard1 = nil then
                begin
                    Clipboard1 := TClipboard.Create;
                end;
                Clipboard1.AsText := tsList.Text;
                //�����õ�Ԫ���ʽΪ�ı���ʽ
                if Assigned(StrColList) And (StrColList.Count > 0) then
                begin
                    for i := 0 to StrColList.Count - 1 do
                    begin
                        sColName := GetExcelColName(StrToInt(StrColList[i]));
                        ExcelSheet.ActiveSheet.Range[sColName + ':' + sColName].NumberFormatLocal := '@';
                    end;
                end
                else  //�����ָ����Щ�����ı���ʽ����Ĭ�����е�Ԫ�����ı���ʽ��
                    ExcelSheet.ActiveSheet.Cells.NumberFormatLocal := '@';
                ExcelSheet.ActiveSheet.Paste;
                ExcelSheet.ActiveSheet.Columns.AutoFit;
                Clipboard1.Clear;
            finally
                FreeAndNil(Clipboard1);
            end;
            //==���а�
        finally
            ExcelApp := UnAssigned;
        end;
    finally
        Screen.Cursor := Cur;
        FreeAndNil(ExcelApp);
    end;
end;


end.
