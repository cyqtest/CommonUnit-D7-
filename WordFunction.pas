{*********************************************************************}
{                                                                     }
{     WordFunction  //Modified by  By CYQ                             }
{                                                                     }
{                                                                     }
{     �޸���ǰ��Word������Ԫ                                          }
{                                                                     }
{*********************************************************************}
unit WordFunction;

interface

uses
  Windows, Forms, Classes, DB, Comobj, ExtCtrls, Chart, DBGridEh, OleServer, Word2000,
  Clipbrd, SysUtils, ComCtrls, DBGrids,
  Controls, JExcelProc, TypInfo, Grids, Dialogs;

//��ʼ����Word
procedure StartOperationWord(bHide: Boolean = True);  //bHide�Ƿ���ʾWord����������
//����Word�������ͷű���
procedure EndOperationWord(bSave: Boolean = True);   //bSave�Ƿ��Զ������ĵ�


//�½�Word
function AddNewDocument(AFileName: String = ''): Boolean;
//��ӱ���
procedure AddTitleText(TitleText: String; FontSize: Integer = 16; FontName: String = '����';
      //0����  1�����  2�Ҷ���
      Alignment: Integer = 0; bBold: Boolean = True);


//��ģ��
function CopyAndOpenWordModel(ScrFileName, DestFileName: String; bOpen: Boolean = True): Boolean;
//�����ļ�
function CopyWordFile(ScrFile, DestFile: String; bDelete: Boolean = True): Boolean;
//�滻�ĵ��е��ַ�
function WordReplaceText(OldText, NewText: String): Boolean;
//ɾ��ָ������Range�е��ַ���
procedure DeleteBlank(n: Integer);
//��ָ����ǩ������ı�����ǩΪ��ʱ�����ĵ�����������
function WordInsertText(txt: String; bFormat: Boolean; sBookMark: String = ''; bNewLine: Boolean = True): Boolean;
//��ָ����ǩ�����ָ���С��еı�񣬱�ǩΪ��ʱ�����ĵ�����������
function WordAddTable(Col, Row: Integer; sBookMark: String = ''; bNewLine: Boolean = True): Boolean;
//���ñ��ı߿���ʾ������ TrueΪ��ʾ��FalseΪ����
procedure SetTableBorderVisible(wTable: Variant; B: Boolean);
{DataSet}
//==============================================================================
{DBGrid}
//���� TDataSet �� FieldList ���ֶ����ݵ� xList �У�������Ҫ�������������浽 Col �С�
//procedure DataSetToList(qry: TDataSet; FieldList: Array of String; TitleList: Array of String;
//        var xList: TStringList; var Col: Integer; DBGrid: TDBGrid = nil);

//���� TDataSet �� FieldList ���ֶ����ݵ� Word ָ����ǩ�ı���С�
//����ȫ���ֶΣ�DataSetToWord(Table1, [])
//    ָ���ֶΣ�DataSetToWord(Table1, ['Field1', 'Field2', 'Field3'])
procedure DataSetToWord(qry: TDataSet; FieldList: Array of String; TitleList: Array of String;
        sBookMark: String = ''; DBGrid: TDBGrid = nil; bHint: Boolean = True);
//���� DBGrid ָ�������� TitleList ���ֶ����ݵ� Word
//����ȫ���У�DBGridToWord(DBGrid1, [])
//    ָ���У�DBGridToWord(DBGrid1, ['��1', '��2', '��3']
procedure DBGridToWord(DBGrid: TDBGrid; TitleList: Array of String; sBookMark: String = '');
{DBGridEh}
//���� TDataSet �� FieldList ���ֶ����ݵ� xList �У�������Ҫ�������������浽 Col �С�
procedure DataSetEhToList(qry: TDataSet; FieldList: Array of String;
        var xList: TStringLIst; var Col: Integer; DBGridEh: TComponent = nil);
//���� TDataSet �� FieldList ���ֶ����ݵ� Word ָ����ǩ�ı���С�
//����ȫ���ֶΣ�DataSetEhToWord(Table1, [])
//    ָ���ֶΣ�DataSetEhToWord(Table1, ['Field1', 'Field2', 'Field3'])
procedure DataSetEhToWord(qry: TDataSet; FieldList: Array of String;
        DBGridEh: TComponent = nil; sBookMark: String = '');
//���� DBGridEh ָ�������� TitleList ���ֶ����ݵ� Word
//����ȫ���У�DBGridEhToWord(DBGridEh1, [])
//    ָ���У�DBGridEhToWord(DBGridEh1, ['��1', '��2', '��3']
procedure DBGridEhToWord(DBGridEh: TComponent; TitleList: Array of String; sBookMark: String = '');
//==============================================================================
{StringGrid}
//���� StringGrid ָ���� ColList �����ݵ� Word
//����ȫ���У�StrGridToWordCol(StrGrid1, [])
//    ָ���У�StrGridToWordCol(StrGrid1, [1, 2, 3]
//procedure StrGridToWordCol(StrGrid: TStringGrid; ColList: Array of Integer;
//        sBookMark: String = '');

//���� StringGrid ָ�������� TitleList �����ݵ� Excel
//����ȫ���У�StrGridToWord(StrGrid1, [])
//    ָ���У�StrGridToWord(StrGrid1, ['��1', '��2', '��3']
//procedure StrGridToWord(StrGrid: TStringGrid; TitleList: Array of String;
//        sBookMark: String = '');
//==============================================================================

//����������ݵ�ͳһ����(������DBGrid��StringGrid��DBGridEh��
procedure GridToWord(Grid: TWinControl; TitleList: Array of String;
        sBookMark: String = ''; UseTree: Boolean = True);
//��tsList������ Word ָ����ǩ�ı���С�
procedure WriteListToWord(tsList: TStringList; Col: Integer; sBookMark: String = ''; bHint: Boolean = True);
//==============================================================================
var
  wDoc, wApp: Variant;

implementation

//��ʼ����Word
procedure StartOperationWord(bHide: Boolean);
begin
    try
        try
            wApp := GetActiveOleObject('Word.Application');
        except
            wApp := CreateOleObject('Word.Application');
        end;
        wApp.Visible := Not bHide;
    except
        Application.MessageBox('δ��װMicrosoft Word', '����', MB_ICONERROR);
        Exit;
    end;
end;

//����Word�������ͷű���
procedure EndOperationWord(bSave: Boolean);
begin
    try
        wDoc.Close(bSave);
        wApp.Quit;
    except
        Application.MessageBox('����δ֪���󣬹ر�Wordʧ��', '����', MB_ICONERROR);
        Exit;
    end;
end;

//�½�Word
function AddNewDocument(AFileName: String = ''): Boolean;
begin
    Result := False;
    
    try
        wDoc := wApp.Documents.Add();
        if AFileName <> '' then
        begin
            wDoc.SaveAs(AFileName);
        end;
    except
        Application.MessageBox('�½�Word�ĵ�ʧ��', '����', MB_ICONERROR);
        Exit;
    end;

    Result := True;
end;

//��ӱ��� 
procedure AddTitleText(TitleText: String; FontSize: Integer; FontName: String; Alignment: Integer; bBold: Boolean);
begin
    //��λ�����еĵ�һ����
    wApp.ActiveDocument.Range(0, 0).InsertAfter(#13);
    wApp.ActiveDocument.Range(0, 0).InsertAfter(TitleText);
    if Alignment = 0 then
        wApp.ActiveDocument.Range.ParagraphFormat.Alignment := wdAlignParagraphCenter
    else
    if Alignment = 1 then
        wApp.ActiveDocument.Range.ParagraphFormat.Alignment := wdAlignParagraphLeft
    else
        wApp.ActiveDocument.Range.ParagraphFormat.Alignment := wdAlignParagraphRight;

    wApp.ActiveDocument.Range.Font.Name := FontName;
    wApp.ActiveDocument.Range.Font.Size := FontSize;
    wApp.ActiveDocument.Range.Bold := bBold;
end;

//��ģ��
function CopyAndOpenWordModel(ScrFileName, DestFileName: String; bOpen: Boolean = True): Boolean;
var
  AFileName: String;
  sd: TSaveDialog;
begin
    Result := False;

    sd := TSaveDialog.Create(nil);
    try
        sd.InitialDir := ExtractFilePath(Application.ExeName);
        sd.FileName := DestFileName;
        sd.Filter := 'Word �ļ�|*.doc';
        sd.DefaultExt := 'doc';
        if Not sd.Execute then Exit;
        if sd.FileName = '' then Exit;
        AFileName := sd.FileName;
    finally
        FreeAndNil(sd);
    end;
    //�����ļ�
    if Not CopyWordFile(ScrFileName, AFileName) then Exit;
    //���ļ�
    if bOpen then
    begin
        try
            wDoc := wApp.Documents.Open(AFileName);
        except
            Application.MessageBox('���ļ�ʧ��', '����', MB_ICONERROR);
            Exit;
        end;
    end;

    Result := True;
end;

//�����ļ�
function CopyWordFile(ScrFile, DestFile: String; bDelete: Boolean = True): Boolean;
begin
    Result := False;

    if Not FileExists(ScrFile) then
    begin
        Application.MessageBox('Դ�ļ������ڣ����ܸ��ơ�', '����', MB_ICONERROR);
        Exit;
    end;

    if ScrFile = DestFile then
    begin
        Application.MessageBox('Դ�ļ���Ŀ���ļ���ͬ�����ܸ��ơ�', '����', MB_ICONERROR);
        Exit;
    end;

    if FileExists(DestFile) then
    begin
        if Not bDelete then
        begin
            Application.MessageBox('Ŀ���ļ��Ѿ����ڣ����ܸ��ơ�', '����', MB_ICONERROR);
            Exit;
        end;
        //if Not FcDeleteFile(PChar(DestFile)) then Exit;
    end;

    if Not CopyFile(PChar(ScrFile), PChar(DestFile), False) then
    begin
        Application.MessageBox('����δ֪�Ĵ��󣬸����ļ�ʧ�ܡ�', '����', MB_ICONERROR);
        Exit;
    end;
    //Ŀ���ļ�ȥ��ֻ������
    FileSetAttr(DestFile, FileGetAttr(DestFile) And Not $00000001);

    Result := True;
end;

//�滻�ĵ��е��ַ�
function WordReplaceText(OldText, NewText: String): Boolean;
begin
    Result := False;
    //�򵥴���ֱ��ִ���滻����
    try
        //����������ݺ��滻���ݵĸ�ʽ�����и�ֵ��
        wApp.Selection.Find.ClearFormatting;
        wApp.Selection.Find.Replacement.ClearFormatting;
        wApp.Selection.Find.Text := OldText;
        wApp.Selection.Find.Replacement.Text := NewText;
        //��������
        wApp.Selection.Find.Forward := True;
        //���ҵ��Ժ����������һ��
        wApp.Selection.Find.Wrap := wdFindContinue;
        //���޶���ʽ
        wApp.Selection.Find.Format := False;
        //�����ִ�Сд
        wApp.Selection.Find.MatchCase := False;
        //ȫ��ƥ��
        wApp.Selection.Find.MatchWholeWord := True;
        //����ȫ/���
        wApp.Selection.Find.MatchByte := True;
        //��ʹ��ͨ���
        wApp.Selection.Find.MatchWildcards := False;
        wApp.Selection.Find.MatchSoundsLike := False;
        wApp.Selection.Find.MatchAllWordForms := False;

        //�ر�ƴ�����Һ��﷨���ң��Ա���߳������е�Ч��
        wApp.Options.CheckSpellingAsYouType := False;
        wApp.Options.CheckGrammarAsYouType := False;
        
        //ִ���滻���еĲ���
        wApp.Selection.Find.Execute(Replace := wdReplaceAll);
    except
        Application.MessageBox('�滻ʧ��', '����', MB_ICONERROR);
        Exit;
    end;
    Result := True;
end;

//ɾ��ָ������Range�е��ַ���
procedure DeleteBlank(n: Integer);
var
  i: Integer;
begin
    for i := 1 to n do
        wApp.Selection.TypeBackspace;
end;

//��ָ����ǩ������ı�����ǩΪ��ʱ�����ĵ�����������
function WordInsertText(txt: String; bFormat: Boolean; sBookMark: String = ''; bNewLine: Boolean = True): Boolean;
var
  wRange: Variant;
  iRangeEnd: Integer;
begin
    Result := False;

    try
        if sBookMark = '' then
        begin
            //���ĵ�ĩβ
            iRangeEnd := wDoc.Range.End - 1;
            if iRangeEnd < 0 then iRangeEnd := 0;

            wRange:= wDoc.Range(iRangeEnd, iRangeEnd);
        end
        else
        begin
            //����ǩ��
            try
                //��λ��ǩ
                if wDoc.BookMarks.Exists(sBookMark) then
                begin
                    wRange := wDoc.Bookmarks.Item(sBookMark).Range;
                end
                else
                //�Ҳ�����ǩ������
                begin
                    Result := True;
                    Exit;
                end;
            except
                Application.MessageBox('�����쳣�����뿪����Ա��ϵ��', '����', MB_ICONERROR);
                Exit;
            end;
        end;
        //���в���
        if bNewLine then
            wRange.InsertAfter(#13);

        wRange.InsertAfter(txt);

        //ɾ�����ֺ�������Ӧ���ȵĿո�
        if bFormat then
        begin
            wRange := wDoc.Range(wRange.End + Length(txt), wRange.End + Length(txt));
            wRange.Select;
            DeleteBlank(Length(txt));
        end;
    except
        Exit;
    end;
    Result := True;
end;

//��ָ����ǩ�����ָ���С��еı�񣬱�ǩΪ��ʱ�����ĵ�����������
function WordAddTable(Col, Row: Integer; sBookMark: String = ''; bNewLine: Boolean = True): Boolean;
var
  wRange, wTable: Variant;
  iRangeEnd: Integer;
begin
    Result := False;
    try
        if sBookMark = '' then
        begin
            //���ĵ�ĩβ
            iRangeEnd := wDoc.Range.End - 1;
            if iRangeEnd < 0 then iRangeEnd := 0;

            wRange:= wDoc.Range(iRangeEnd, iRangeEnd);
        end
        else
        begin
            //����ǩ��
            try
                //��λ��ǩ
                if wDoc.BookMarks.Exists(sBookMark) then
                begin
                    wRange := wDoc.Bookmarks.Item(sBookMark).Range;
                end
                else
                //�Ҳ�����ǩ������
                begin
                    Result := True;
                    Exit;
                end;
            except
                Application.MessageBox('�����쳣�����뿪����Ա��ϵ��', '����', MB_ICONERROR);
                Exit;
            end;
        end;
        //���в���
        if bNewLine then
            wRange.InsertAfter(#13);
        //������
        wTable := wDoc.Tables.Add(wRange, Row, Col);
        //���ñ��߿���ʾ
        SetTableBorderVisible(wTable, True);
        //�ı����п�ʹ֮�ڵ�Ԫ���ı����з�ʽ���������£���Ӧ�ı���ȡ�
        wTable.Columns.AutoFit;
    except
        Exit;
    end;
    Result := True;
end;

//���ñ��ı߿���ʾ������ TrueΪ��ʾ��FalseΪ����
procedure SetTableBorderVisible(wTable: Variant; B: Boolean);
begin
    if B then
    begin
        wTable.Borders.Item(wdborderLeft).LineStyle := wdLineStyleSingle;
        wTable.Borders.Item(wdBorderRight).LineStyle := wdLineStyleSingle;
        wTable.Borders.Item(wdBorderTop).LineStyle := wdLineStyleSingle;
        wTable.Borders.Item(wdBorderBottom).LineStyle := wdLineStyleSingle;
        wTable.Borders.Item(wdBorderHorizontal).LineStyle := wdLineStyleSingle;
        wTable.Borders.Item(wdBorderVertical).LineStyle := wdLineStyleSingle;
        wTable.Borders.Shadow := False;
    end
    else
    begin
        wTable.Borders.Item(wdborderLeft).LineStyle := wdLineStyleNone;
        wTable.Borders.Item(wdBorderRight).LineStyle := wdLineStyleNone;
        wTable.Borders.Item(wdBorderTop).LineStyle := wdLineStyleNone;
        wTable.Borders.Item(wdBorderBottom).LineStyle := wdLineStyleNone;
        wTable.Borders.Item(wdBorderHorizontal).LineStyle := wdLineStyleNone;
        wTable.Borders.Item(wdBorderVertical).LineStyle := wdLineStyleNone;
        wTable.Borders.Shadow := False;
    end;
end;

{DataSet}
//==============================================================================
{DBGrid}
//���� TDataSet �� FieldList ���ֶ����ݵ� xList �У�������Ҫ�������������浽 Col �С�
//procedure DataSetToList(qry: TDataSet; FieldList: Array of String; TitleList: Array of String;
//        var xList: TStringList; var Col: Integer; DBGrid: TDBGrid = nil);
//var
//  i, j: Integer;
//  FList, FTitleList: TStringList; //FieldName List
//  s, sTemp: String;
//  BM: TBookMark;
//  FTreeCount: Integer;
//  FTreeValues: TStringList;
//  bNotGetTree, bUseMultiTitle: Boolean;
//  eTemp: Extended;
//  Cur: TCursor;
//  pCol: TColumn;
//begin
//    FTreeCount := 0;
//    bNotGetTree := True;
//    Cur := Screen.Cursor;
//    Screen.Cursor := crHourGlass;
//    FTreeValues := TStringList.Create;
//    try
//        FList := TStringList.Create;
//        try
//            FTitleList := TStringList.Create;
//            try
//                s := '';
//                bUseMultiTitle := (DBGrid <> nil) And (DBGrid is TCustomDBGrid)
//                    And (DBGrid as TCustomDBGrid).UseMultiTitle;
//                //���û�д��뵼���ֶΣ����ȡ�����ֶ�
//                if Length(FieldList) = 0 then
//                begin
//                    //�������DBGrid�������ȡDBGrid�������������ֶΣ��Լ������������� s
//                    if DBGrid <> nil then
//                    begin
//                        for i := 0 to DBGrid.Columns.Count - 1 do
//                        begin
//                            if DBGrid.Columns[i].FieldName <> '' then
//                            begin
//                                FList.Add(DBGrid.Columns[i].FieldName);
//                                //������״����ͷ
//                                sTemp := DBGrid.Columns[i].Title.Caption;
//                                pCol := DBGrid.Columns[i].ParentColumn;
//                                while pCol <> nil do
//                                begin
//                                    sTemp := pCol.Title.Caption + '|' + sTemp;
//                                    pCol := pCol.ParentColumn;
//                                    bUseMultiTitle := True;
//                                end;
//                                FTitleList.Add(sTemp);
//                                //FTitleList.Add(DBGrid.Columns[i].Title.Caption);
//                                //s := s + DBGrid.Columns[i].Title.Caption + #9;
//                            end; //if
//                        end; //for
//                        if DBGrid is TJCustomDBGrid then
//                            FTreeCount := (DBGrid as TJCustomDBGrid).TreeLayerCount;    //�õ������״����
//                    end
//                    else //���򣬶�ȡ�����ֶ�
//                    begin
//                        for i := 0 to qry.FieldCount - 1 do
//                            FList.Add(qry.Fields[i].FieldName);
//                    end;
//                end
//                else //�����˵����ֶ�
//                begin
//                    //�������DBGrid�������ȡҪ�󵼳�����DBGrid�������������ֶΣ��Լ������������� s
//                    if DBGrid <> nil then
//                    begin
//                        if DBGrid is TJCustomDBGrid then
//                            FTreeCount := (DBGrid as TJCustomDBGrid).TreeLayerCount;    //�õ������״����
//
//                        for i := 0 to Length(FieldList) - 1 do
//                        begin
//                            for j := 0 to DBGrid.Columns.Count - 1 do
//                            begin
//                                if (DBGrid.Columns[j].FieldName <> '')
//                                    And (CompareText(DBGrid.Columns[j].FieldName, FieldList[i]) = 0) then
//                                begin
//                                    FList.Add(FieldList[i]);
//                                    //������״����ͷ
//                                    sTemp := DBGrid.Columns[j].Title.Caption;
//                                    pCol := DBGrid.Columns[j].ParentColumn;
//                                    while pCol <> nil do
//                                    begin
//                                        sTemp := pCol.Title.Caption + '|' + sTemp;
//                                        pCol := pCol.ParentColumn;
//                                        bUseMultiTitle := True;
//                                    end;
//                                    FTitleList.Add(sTemp);
//                                    //FTitleList.Add(DBGrid.Columns[j].Title.Caption);
//                                    //s := s + DBGrid.Columns[j].Title.Caption + #9;
//                                    if (j >= FTreeCount - 1) And bNotGetTree then
//                                    begin
//                                        //�õ�ָ���ֶε���״����
//                                        if j > FTreeCount - 1 then
//                                            FTreeCount := FList.Count - 1
//                                        else
//                                            FTreeCount := FList.Count;
//                                        bNotGetTree := False;
//                                    end;
//                                    break;
//                                end; //if
//                            end; //for
//                        end; //for
//                    end
//                    else  //���򣬶�ȡ���е����ֶ�
//                    begin
//                        for i := 0 to Length(FieldList) - 1 do
//                            FList.Add(FieldList[i]);
//
//                        //���������⣬���մ���ı�����ʾ
//                        if Length(TitleList) > 0 then
//                        begin
//                            for i := 0 to Length(TitleList) - 1 do
//                            begin
//                                FTitleList.Add(TitleList[i]);
//                            end;
//                        end;
//                    end;
//                end;
//                s := GetExcelTitleStr(FTitleList, bUseMultiTitle);
//                if s <> '' then
//                begin
//                    //s := Copy(s, 1, Length(s) - Length(#9));
//                    xList.Add(s);  //������������ s
//                end;
//            finally
//                FreeAndNil(FTitleList);
//            end;
//
//            //��ȡ���ݼ�������
//            Col := FList.Count;
//
//            //��ȡ��������
//            BM := qry.GetBookmark;
//            try
//                qry.DisableControls;
//                //qry.DisableConstraints;
//                qry.First;
//                while not qry.Eof do
//                begin
//                    s := '';
//                    for i := 0 to FList.Count - 1 do
//                    begin
//                        sTemp := ValidExcelCell(qry.FieldByName(FList[i]).DisplayText);
//
//                        //������״�����ʾ
//                        if i < FTreeCount then
//                        begin
//                            if i >= FTreeValues.Count then
//                                FTreeValues.Add(sTemp)
//                            else
//                            if FTreeValues[i] = sTemp then
//                                sTemp := ''
//                            else
//                            begin
//                                for j := FTreeValues.Count - 1 downto i + 1 do
//                                    FTreeValues.Delete(j);
//                                FTreeValues[i] := sTemp;
//                            end;
//                        end;
//
//                       { //��ֹ�ַ����͵���ֵ, ����Excel���Ϊ��ֵ�Ͷ�ʧǰ�����(��: '001' ===> 1).
//                        if (sTemp <> '') And (qry.FieldByName(FList[i]).DataType = ftString)
//                                And TryStrToFloat(sTemp, eTemp) then
//                        begin
//                            if (FloatToStr(eTemp) <> sTemp) or (eTemp > 1E14) then //������Ȼ�eTemp����(�����֤), ��ת��
//                                sTemp := '=Trim("' + sTemp + '")';
//                        end;   }
//
//                        s := s + sTemp + #9;
//                        Application.ProcessMessages;
//                    end;
//                    if StringReplace(s, #9, '', [rfReplaceAll]) <> '' then
//                    begin
//                        s := Copy(s, 1, Length(s) - Length(#9));
//                        xList.Add(s);
//                    end;
//                    qry.Next;
//                end;
//            finally
//                qry.GotoBookmark(BM);
//                qry.FreeBookmark(BM);
//                //qry.EnableConstraints;
//                qry.EnableControls;
//            end;
//        finally
//            FList.Free;
//        end;
//    finally
//        Screen.Cursor := Cur;
//        FTreeValues.Free;
//    end;
//end;


//���� TDataSet �� FieldList ���ֶ����ݵ� Word ָ����ǩ�ı���С�
//����ȫ���ֶΣ�DataSetToWord(Table1, [])
//    ָ���ֶΣ�DataSetToWord(Table1, ['Field1', 'Field2', 'Field3'])
procedure DataSetToWord(qry: TDataSet; FieldList: Array of String; TitleList: Array of String;
        sBookMark: String = ''; DBGrid: TDBGrid = nil; bHint: Boolean = True);
var
  xList: TStringList;
  iCol: Integer;
begin
    xList := TStringList.Create;
    try
        //DataSetToList(qry, FieldList, TitleList, xList, iCol, DBGrid);

        WriteListToWord(xList, iCol, sBookMark, bHint);
    finally
        FreeAndNil(xList);
    end;
end;

//���ܣ����� DBGrid ָ�������� TitleList ���ֶε� Word
//����ȫ���У�DBGridToWord(DBGrid1, [])
//    ָ���У�DBGridToWord(DBGrid1, ['��1', '��2', '��3']
procedure DBGridToWord(DBGrid: TDBGrid; TitleList: Array of String; sBookMark: String = '');
    //���ܣ�ͨ�� TitleList �ֽ� ��ȡ�ֶΡ�
    procedure GetDBGridFieldList(DBGrid: TDBGrid; TitleList: Array of String;
            var FList: TStringList);
    var
      i, j: Integer;
    begin
        if Length(TitleList) = 0 then
        begin
            for i := 0 to DBGrid.Columns.Count - 1 do
            begin
                if DBGrid.Columns[i].FieldName <> '' then
                    FList.Add(DBGrid.Columns[i].FieldName);
            end;
        end
        else
        begin
            for i := 0 to Length(TitleList) - 1 do
            begin
                for j := 0 to DBGrid.Columns.Count - 1 do
                begin
                    if (DBGrid.Columns[j].FieldName <> '')
                        And (CompareText(DBGrid.Columns[j].Title.Caption, TitleList[i]) = 0) then
                    begin
                        FList.Add(DBGrid.Columns[j].FieldName);
                        break;
                    end;
                end; //for j
            end; //for i
        end; //if
    end; 
var
  FieldList: Array of String;
  FList: TStringList;
  i: Integer;
begin
    if Not Assigned(DBGrid.DataSource) then
    begin
        Application.MessageBox('DBGrid��δָ��DataSource��', '����', MB_ICONERROR);
        Exit;
    end;
    if Not Assigned(DBGrid.DataSource.DataSet) then
    begin
        Application.MessageBox('DBGrid��δָ��DataSet���ݼ���', '����', MB_ICONERROR);
        Exit;
    end;
    if Not DBGrid.DataSource.DataSet.Active then
    begin
        Application.MessageBox('DBGrid�����ݼ���δ�򿪣�', '����', MB_ICONERROR);
        Exit;
    end;

    FList := TStringList.Create;
    try
        //�����ָ���У���ֻ�������ӵ���
        if Length(TitleList) = 0 then
        begin
            for i := 0 to DBGrid.Columns.Count - 1 do
            begin
                if DBGrid.Columns[i].Visible And (DBGrid.Columns[i].Width > 0) then
                    FList.Add(DBGrid.Columns[i].FieldName);
            end;
        end
        else
            GetDBGridFieldList(DBGrid, TitleList, FList);
        SetLength(FieldList, FList.Count);
        for i := 0 to FList.Count - 1 do
            FieldList[i] := FList[i];
    finally
        FList.Free;
    end;
    DataSetToWord(DBGrid.DataSource.DataSet, FieldList, TitleList, sBookMark, DBGrid);
end;

//�������Ƿ�TDBGridEh��TJDBGridEh��
function IsValidDBGridEh(DBGridEh: TComponent): Boolean;
begin
    Result := False;
    if DBGridEh = nil then Exit;
    Result := Pos('$' + UpperCase(DBGridEh.ClassName) + '$', '$TDBGRIDEH$TJDBGRIDEH$') > 0;
end;

//�������Ƿ��ǺϷ���TDBGridEh��TJDBGridEh��
procedure CheckValidDBGridEh(DBGridEh: TComponent);
begin
    if DBGridEh = nil then
        raise Exception.Create('DBGridEh does not Exist!');
    if Not IsValidDBGridEh(DBGridEh) then
        raise Exception.Create(Format('%s is not a valid DBGridEh!', [DBGridEh.Name]));
end;

{DBGridEh}
//���� TDataSet �� FieldList ���ֶ����ݵ� xList �У�������Ҫ�������������浽 Col �С�
procedure DataSetEhToList(qry: TDataSet; FieldList: Array of String;
        var xList: TStringLIst; var Col: Integer; DBGridEh: TComponent = nil);
var
  i, j: Integer;
  FList, FTitleList: TStringList; //FieldName List
  s, sTemp: String;
  BM: TBookMark;
  FTreeCount: Integer;
  FTreeValues: TStringList;
  bNotGetTree, bUseMultiTitle: Boolean;
  eTemp: Extended;
  Cur: TCursor;
  FCol, FTitle: LongInt;
  sFieldName: String;
begin
    if DBGridEh <> nil then
      CheckValidDBGridEh(DBGridEh);
    FTreeCount := 0;
    bNotGetTree := True;
    Cur := Screen.Cursor;
    Screen.Cursor := crHourGlass;
    FTreeValues := TStringList.Create;
    try
        FList := TStringList.Create;
        try
            FTitleList := TStringList.Create;
            try
                s := '';
                //bUseMultiTitle := (DBGridEh <> nil) And GetPropValue(DBGridEh, 'UseMultiTitle');
                bUseMultiTitle := (DBGridEh as TDBGridEh).UseMultiTitle;
                //���û�д��뵼���ֶΣ����ȡ�����ֶ�
                if Length(FieldList) = 0 then
                begin
                    //�������DBGridEh�������ȡDBGridEh�������������ֶΣ��Լ������������� s
                    if DBGridEh <> nil then
                    begin
                        FCol := GetOrdProp(DBGridEh, 'Columns');
                        for i := 0 to TCollection(FCol).Count - 1 do
                        begin
                            sFieldName := GetStrProp(TCollection(FCol).Items[i], 'FieldName');
                            if sFieldName <> '' then
                            begin
                                FList.Add(sFieldName);
                                FTitle := GetOrdProp(TCollection(FCol).Items[i], 'Title');
                                FTitleList.Add(GetStrProp(TPersistent(FTitle), 'Caption'));
                            end; //if
                        end; //for
                        if Assigned(GetPropInfo(DBGridEh, 'TreeLayerCount')) then
                            FTreeCount := GetOrdProp(DBGridEh,'TreeLayerCount');      //�õ������״����
                    end
                    else //���򣬶�ȡ�����ֶ�
                        for i := 0 to qry.FieldCount - 1 do
                            FList.Add(qry.Fields[i].FieldName);
                end
                else //�����˵����ֶ�
                begin
                    //�������DBGridEh�������ȡҪ�󵼳�����DBGridEh�������������ֶΣ��Լ������������� s
                    if DBGridEh <> nil then
                    begin
                        if Assigned(GetPropInfo(DBGridEh, 'TreeLayerCount')) then
                            FTreeCount := GetOrdProp(DBGridEh, 'TreeLayerCount');     //�õ������״����

                        FCol := GetOrdProp(DBGridEh, 'Columns');
                        for i := 0 to Length(FieldList) - 1 do
                        begin
                            for j := 0 to TCollection(FCol).Count - 1 do
                            begin
                                sFieldName := GetStrProp(TCollection(FCol).Items[j], 'FieldName');
                                if (sFieldName <> '') And (CompareText(sFieldName, FieldList[i]) = 0) then
                                begin
                                    FList.Add(FieldList[i]);
                                    FTitle := GetOrdProp(TCollection(FCol).Items[j], 'Title');
                                    FTitleList.Add(GetStrProp(TPersistent(FTitle), 'Caption'));
                                    if (j >= FTreeCount - 1) And bNotGetTree then
                                    begin
                                        //�õ�ָ���ֶε���״����
                                        if j > FTreeCount - 1 then
                                            FTreeCount := FList.Count - 1
                                        else
                                            FTreeCount := FList.Count;
                                        bNotGetTree := False;
                                    end;
                                    break;
                                end; //if
                            end; //for
                        end; //for
                    end
                    else  //���򣬶�ȡ���е����ֶ�
                        for i := 0 to Length(FieldList) - 1 do
                            FList.Add(FieldList[i]);
                end;
                s := GetExcelTitleStr(FTitleList, bUseMultiTitle);
                if s <> '' then
                begin
                    //s := Copy(s, 1, Length(s) - Length(#9));
                    xList.Add(s);  //������������ s
                end;
            finally
                FreeAndNil(FTitleList);
            end;

            //��ȡ���ݼ�������
            Col := FList.Count;

            //��ȡ��������
            BM := qry.GetBookmark;
            try
                qry.DisableControls;
                //qry.DisableConstraints;
                qry.First;
                while not qry.Eof do
                begin
                    s := '';
                    for i := 0 to FList.Count - 1 do
                    begin
                        sTemp := ValidExcelCell(qry.FieldByName(FList[i]).DisplayText);

                        //������״�����ʾ
                        if i < FTreeCount then
                        begin
                            if i >= FTreeValues.Count then
                                FTreeValues.Add(sTemp)
                            else
                            if FTreeValues[i] = sTemp then
                                sTemp := ''
                            else
                            begin
                                for j := FTreeValues.Count - 1 downto i + 1 do
                                    FTreeValues.Delete(j);
                                FTreeValues[i] := sTemp;
                            end;
                        end;

                        {//��ֹ�ַ����͵���ֵ, ����Excel���Ϊ��ֵ�Ͷ�ʧǰ�����(��: '001' ===> 1).
                        if (sTemp <> '') And (qry.FieldByName(FList[i]).DataType = ftString)
                                And TryStrToFloat(sTemp, eTemp) then
			                  begin
                            if FloatToStr(eTemp) <> sTemp then  //�������, ��ת��
                                sTemp := '=Trim("' + sTemp + '")';
			                  end;    }

                        s := s + sTemp + #9;
                        Application.ProcessMessages;
                    end;
                    if StringReplace(s, #9, '', [rfReplaceAll]) <> '' then
                    begin
                        s := Copy(s, 1, Length(s) - Length(#9));
                        xList.Add(s);
                    end;
                    qry.Next;
                end;
            finally
                qry.GotoBookmark(BM);
                //qry.EnableConstraints;
                qry.EnableControls;
            end;
        finally
            FList.Free;
        end;
    finally
        Screen.Cursor := Cur;
        FTreeValues.Free;
    end;
end;

//���� TDataSet �� FieldList ���ֶ����ݵ� Word ָ����ǩ�ı���С�
//����ȫ���ֶΣ�DataSetEhToWord(Table1, [])
//    ָ���ֶΣ�DataSetEhToWord(Table1, ['Field1', 'Field2', 'Field3'])
procedure DataSetEhToWord(qry: TDataSet; FieldList: Array of String;
        DBGridEh: TComponent = nil; sBookMark: String = '');
var
  xList: TStringList;
  iCol: Integer;
begin
    xList := TStringList.Create;
    try
        DataSetEhToList(qry, FieldList, xList, iCol, DBGridEh);

        WriteListToWord(xList, iCol, sBookMark);
    finally
        FreeAndNil(xList);
    end;
end;

//���� DBGridEh ָ�������� TitleList ���ֶ����ݵ� Word
//����ȫ���У�DBGridEhToWord(DBGridEh1, [])
//    ָ���У�DBGridEhToWord(DBGridEh1, ['��1', '��2', '��3']
procedure DBGridEhToWord(DBGridEh: TComponent; TitleList: Array of String; sBookMark: String = '');
    //���ܣ�ͨ�� TitleList �ֽ� ��ȡ�ֶΡ�
    procedure GetDBGridEhFieldList(DBGridEh: TComponent; TitleList: Array of String;
            var FList: TStringList);
    var
      i, j: Integer;
      FCol, FTitle: LongInt;
      sFieldName, sCaption: String;
    begin
        FCol := GetOrdProp(DBGridEh, 'Columns');
        if Length(TitleList) = 0 then
        begin
            for i := 0 to TCollection(FCol).Count - 1 do
            begin
                sFieldName := GetStrProp(TCollection(FCol).Items[i], 'FieldName');
                if sFieldName <> '' then
                    FList.Add(sFieldName);
            end;
        end
        else
        begin
            for i := 0 to Length(TitleList) - 1 do
            begin
                for j := 0 to TCollection(FCol).Count - 1 do
                begin
                    sFieldName := GetStrProp(TCollection(FCol).Items[j], 'FieldName');
                    FTitle := GetOrdProp(TCollection(FCol).Items[j], 'Title');
                    sCaption := GetStrProp(TPersistent(FTitle), 'Caption');
                    if (sFieldName <> '') And (CompareText(sCaption, TitleList[i]) = 0) then
                    begin
                        FList.Add(sFieldName);
                        break;
                    end;
                end; //for j
            end; //for i
        end; //if
    end; 
var
  FieldList: Array of String;
  FList: TStringList;
  i: Integer;
  FDS, FCol, FWidth: LongInt;
  FVisible: Boolean;
begin
    CheckValidDBGridEh(DBGridEh);

    FDS := GetOrdProp(DBGridEh, 'DataSource');
    if FDS = 0 then
    begin
        Application.MessageBox('DBGridEh��δָ��DataSource��', '����', MB_ICONERROR);
        Exit;
    end;
    if Not Assigned(TDataSource(FDS).DataSet) then
    begin
        Application.MessageBox('DBGridEh��δָ��DataSet���ݼ���', '����', MB_ICONERROR);
        Exit;
    end;
    if Not TDataSource(FDS).DataSet.Active then
    begin
        Application.MessageBox('DBGridEh�����ݼ���δ�򿪣�', '����', MB_ICONERROR);
        Exit;
    end;

    FList := TStringList.Create;
    try
        //�����ָ���У���ֻ�������ӵ���
        if Length(TitleList) = 0 then
        begin
            FCol := GetOrdProp(DBGridEh, 'Columns');
            for i := 0 to TCollection(FCol).Count - 1 do
            begin
                FWidth := GetOrdProp(TCollection(FCol).Items[i], 'Width');
                FVisible := GetPropValue(TCollection(FCol).Items[i], 'Visible');
                if FVisible And (FWidth > 0) then
                    FList.Add(GetStrProp(TCollection(FCol).Items[i], 'FieldName'));
            end;
        end
        else
            GetDBGridEhFieldList(DBGridEh, TitleList, FList);
        SetLength(FieldList, FList.Count);
        for i := 0 to FList.Count - 1 do
            FieldList[i] := FList[i];
    finally
        FList.Free;
    end;
    DataSetEhToWord(TDataSource(FDS).DataSet, FieldList, DBGridEh, sBookMark);
end;

////���ܣ����� StringGrid ָ���� ColList �����ݵ� Word
//procedure StrGridToWordCol(StrGrid: TStringGrid; ColList: Array of Integer; sBookMark: String = '');
//var
//  i, j, k, m: Integer;
//  s, sTemp: String;
//  xList: TStringList;
//  FTreeCount: Integer;
//  FTreeValues: TStringList;
//  FList: TStringList;
//  bNotGetTree: Boolean;
//  Cur: TCursor;
//  Col: Integer;
//begin
//    FTreeCount := 0;
//    bNotGetTree := True;
//    if StrGrid is TStrGrid then
//        FTreeCount := (StrGrid as TJStrGrid).TreeLayerCount;   //�õ������״����
//
//    Cur := Screen.Cursor;
//    Screen.Cursor := crHourGlass;
//    xList := TStringList.Create;
//    FTreeValues := TStringList.Create;
//    FList := TStringList.Create;
//    try
//        //�õ�������FList�͵����е���״����FTreeCount
//        if Length(ColList) = 0 then
//        begin
//            for i := StrGrid.FixedCols to StrGrid.ColCount - 1 do
//            begin
//                if StrGrid.ColWidths[i] > 0 then    //�����ָ���У���ֻ��ʾ�п���������
//                    FList.Add(IntToStr(i));
//            end;
//        end
//        else
//        begin
//            for i := 0 to Length(ColList) - 1 do
//                for j := StrGrid.FixedCols to StrGrid.ColCount - 1 do
//                begin
//                    if ColList[i] = j then
//                    begin
//                        FList.Add(IntToStr(j));
//                        if (j >= FTreeCount - 1) And bNotGetTree then
//                        begin
//                            //�õ�ָ���ֶε���״����
//                            if j > FTreeCount - 1 then
//                                FTreeCount := FList.Count - 1
//                            else
//                                FTreeCount := FList.Count;
//                            bNotGetTree := False;
//                        end;
//                        Break;
//                    end;
//                end;
//        end;
//
//        //��ȡ���ݼ�������
//        Col := FList.Count;
//
//        //��������
//        for i := 0 to StrGrid.RowCount - 1 do
//        begin
//            s := '';
//            for j := 0 to FList.Count - 1 do
//            begin
//                k := StrToInt(FList[j]);
//                sTemp := ValidExcelCell(StrGrid.Cells[k, i]);
//
//                //������״�����ʾ
//                if j < FTreeCount then
//                begin
//                    if j >= FTreeValues.Count then
//                        FTreeValues.Add(sTemp)
//                    else
//                    if FTreeValues[j] = sTemp then
//                        sTemp := ''
//                    else
//                    begin
//                        for m := FTreeValues.Count - 1 downto j + 1 do
//                            FTreeValues.Delete(m);
//                        FTreeValues[j] := sTemp;
//                    end;
//                end;
//
//                s := s + sTemp + #9;
//            end; //for j
//            if StringReplace(s, #9, '', [rfReplaceAll]) <> '' then
//                s := Copy(s, 1, Length(s) - Length(#9));
//            xList.Add(s);
//        end; //for i
//
//        WriteListToWord(xList, Col, sBookMark);
//    finally
//        xList.Free;
//        FTreeValues.Free;
//        FList.Free;
//        Screen.Cursor := Cur;
//    end;
//end;

//���� StringGrid ָ�������� TitleList �����ݵ� Excel
//����ȫ���У�StrGridToWord(StrGrid1, [])
////    ָ���У�StrGridToWord(StrGrid1, ['��1', '��2', '��3']
//procedure StrGridToWord(StrGrid: TStringGrid; TitleList: Array of String;
//        sBookMark: String = '');
//var
//  iRow, iCol, k, m: Integer;
//  ColList: Array of Integer;
//begin
//    if (Length(TitleList) = 0) or (StrGrid.FixedRows <= 0) then
//        StrGridToWordCol(StrGrid, [], sBookMark)
//    else
//    begin
//        iRow := StrGrid.FixedRows - 1;  //������ڶ���̶��У������һ���̶���Ϊ������
//        SetLength(ColList, Length(TitleList));
//        m := 0;
//        //����ָ����Ŀ����
//        for k := 0 to Length(TitleList) - 1 do
//        begin
//            for iCol := StrGrid.FixedCols to StrGrid.ColCount - 1 do
//            begin
//                if CompareText(TitleList[k], StrGrid.Cells[iCol, iRow]) = 0 then
//                begin
//                    ColList[m] := iCol;
//                    m := m + 1;
//                    break;
//                end;
//            end; //for k
//        end; //for iCol
//        StrGridToWordCol(StrGrid, ColList, sBookMark);
//    end;
//end;

//����������ݵ�ͳһ����(������DBGrid��StringGrid��DBGridEh��
procedure GridToWord(Grid: TWinControl; TitleList: Array of String;
        sBookMark: String = ''; UseTree: Boolean = True);
var
  bHadTree: Boolean;
  FTreeCount: Integer;
begin
  if Assigned(Grid) then
  begin
    bHadTree := False;
    FTreeCount := 0;
    if (Not UseTree) And ((Grid is TDBGrid) or (Grid is TStringGrid) or IsValidDBGridEh(Grid)) then
    begin
      FTreeCount := 0;
      bHadTree := Assigned(GetPropInfo(Grid, 'TreeLayerCount'));
      if bHadTree then
      begin
        FTreeCount := GetOrdProp(Grid, 'TreeLayerCount');       //�õ������״����
        SetOrdProp(Grid, 'TreeLayerCount', 0);                  //��������, ���趨������Ϊ��
      end;
    end;

    try
      if IsValidDBGridEh(Grid) then
          DBGridEhToWord(Grid, TitleList, sBookMark);
    finally
      if (Not UseTree) And bHadTree And (FTreeCount <> 0) then    //�ָ�������
          SetOrdProp(Grid, 'TreeLayerCount', FTreeCount);
    end;
  end;
end;

//��tsList������ Word ָ����ǩ�ı���С�
procedure WriteListToWord(tsList: TStringList; Col: Integer; sBookMark: String = ''; bHint: Boolean = True);
var
  wRange, wTable: Variant;
  iRangeEnd, Row, i: Integer;
  Cur: TCursor;
  Clipboard1: TClipboard;
begin
  if tsList.Count = 0 then
  begin
    if bHint then
      Application.MessageBox('û�����ݿ��Ե�����', '��ʾ', MB_ICONWARNING);
    Exit;
  end;

  if tsList.Count > 1000 then
  begin
    if Application.MessageBox(PChar('��Ҫ���� ' + IntToStr(tsList.Count) + ' �����ݣ�����Ҫ���ѽϳ�ʱ�䡣'
          + #13#10 + #13#10 + 'Ҫ������'), '��ʾ', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2) = ID_NO then
      Exit;
  end;

  Row := tsList.Count;

  Cur := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  try
    if sBookMark = '' then
    begin
      //���ĵ�ĩβ
      iRangeEnd := wDoc.Range.End - 1;
      if iRangeEnd < 0 then iRangeEnd := 0;

      wRange:= wDoc.Range(iRangeEnd, iRangeEnd);
    end
    else
    begin
      //����ǩ��
      try
        //��λ��ǩ
        if wDoc.BookMarks.Exists(sBookMark) then
        begin
          wRange := wDoc.Bookmarks.Item(sBookMark).Range;
        end
        else
        //�Ҳ�����ǩ������
        begin
          Exit;
        end;
      except
        Application.MessageBox('�����쳣�����뿪����Ա��ϵ��', '����', MB_ICONERROR);
        Exit;
      end;
    end;
    //������֮ǰ����
    wRange.InsertAfter(#13);
    //������
    wTable := wDoc.Tables.Add(wRange, Row, Col);
    //���ñ��߿���ʾ
    SetTableBorderVisible(wTable, True);
    //�ı����п�ʹ֮�ڵ�Ԫ���ı����з�ʽ���������£���Ӧ�ı���ȡ�
    wTable.Columns.AutoFit;

    //==���а�== ��Ҫuses : Clipbrd
    try
      if Clipboard1 = nil then
      begin
        Clipboard1 := TClipboard.Create;
      end;
      Clipboard1.AsText := tsList.Text;
      wTable.Range.Paste;
      Clipboard1.Clear;
  //            for i := 1 to Col do
  //              wTable.Columns.Item(i).SetWidth(50, wdAdjustNone);
    finally
      FreeAndNil(Clipboard1);
    end;
  finally
    Screen.Cursor := Cur;
  end;
end;
end.
