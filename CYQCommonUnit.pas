{*********************************************************************}
{                                                                     }
{     CYQCommonUnit v1.0  Create By cyq 2013��5��10��11:03:18         }
{                                                                     }
{                                                                     }
{     ��Ԫ���ܣ����ù����������¼�                                    }
{                                                                     }
{*********************************************************************}
unit CYQCommonUnit;

interface
uses
  Windows, Messages, SysUtils, Classes, Controls, Graphics, Dialogs, Variants, StdCtrls, Forms,
  IniFiles, DB, DBTables,GridsEh, DBGridEh, PrnDbgeh, Printers, Grids, DBGrids, Excel2000, ComObj,
  ShellAPI, Contnrs, StrUtils,
  ADODB, DateUtils, WinSock, TypInfo, DBGridEhImpExp, ExtCtrls,TlHelp32, ColorGrd, DBgridEhToExcel;
  //GridsEh, DBGridEh, Grids, DBGridsλ�ò��ܵ���
  //���²�������������Excel

Var
  arXlsBegin: array[0..5] of Word = ($809, 8, 0, $10, 0, 0);
  arXlsEnd: array[0..1] of Word = ($0A, 00);
  arXlsString: array[0..5] of Word = ($204, 0, 0, 0, 0, 0);
  arXlsNumber: array[0..4] of Word = ($203, 14, 0, 0, 0);
  arXlsInteger: array[0..4] of Word = ($27E, 10, 0, 0, 0);
  arXlsBlank: array[0..4] of Word = ($201, 6, 0, 0, $17);
  oldMode: Cardinal;
  
  //��õ�ǰ����Ŀ¼Ini�ļ���
  function GetIniFile: string; overload;
  function GetIniFile(FileName:string):string;overload;
  //����Ini�ļ�
  function CreateIniFile(var IniFile: TIniFile; FileIni: string): Boolean;

  //*************************************************************************
  procedure GetGrdEhColList(DBGridEh: TDBGridEh; TitleList: Array of String;
    var FList: TStringList);
  //ͨ��DBGridEh����
  procedure DBGridEhToExcel(DBGridEh: TWinControl; TitleList: Array of String; SaveToFile: Boolean;DocName: string = '������');
  procedure GridToExcel(Grid: TWinControl; TitleList: Array of String;
        SaveToFile: Boolean = False; UseTree: Boolean = True); overload;
  procedure DataSetEhToList(qry: TDataSet; FieldList: Array of String;
        var xList, StrColList: TStringList; DBGridEh: TWinControl = nil); overload;
  procedure DataSetEhToList(qry: TDataSet; FieldList: Array of String;
          var xList: TStringList; DBGridEh: TWinControl = nil); overload;
  procedure CheckValidDBGridEh(DBGridEh: TWinControl);
  function IsValidDBGridEh(DBGridEh: TWinControl): Boolean;
  //��FTitleList�н��������ͷ���ַ�������#9�ָ��У���#13#10�ָ���
  function GetExcelTitleStr(var FTitleList: TStringList; UseMultiTitle: Boolean): String;
  procedure GetDBGridCheckBoxList(DBGrid: TWinControl; var CheckBoxColList: TStringList);
  function IsCheckBoxCol(FCol: TCollection; FieldName: String; CheckBoxColList: TStringList): Boolean;

  //֧�ֶ��ͷ����DBgridEh����;
  procedure ExportExcelEh(const CurDS : TDBGridEh; vSum: Boolean = False; Title: String ='');
  //����DbGrid����
  procedure ExportExcelDbGrid(ADbgrid: TDBGrid);
  //�����ķ�ʽ����Excel���ʺϴ��������ݵ���
  procedure ExportExcelByStream(DBGridEh: TDBGridEh;bWriteTitle: Boolean; Title: String ='';
    bWriteFirst: Boolean= False; TitleFirst: string = '');
  //�����ķ�ʽ����Excel���ʺϴ��������ݵ���(֧�ֶ��ͷ)
  procedure ExportExcelByStreamMut(DBGridEh: TDBGridEh;Title: String ='';ShowPross: Boolean = True);

  //��ӡDBgridEh�������
  procedure PrintDBGridEhData(DBGridEh: TWinControl; Title: string);
  //���DBGridEhĳһ���Ƿ�����ظ�ֵ
  function CheckGridFieldDuplicate(DBGridEh:TWinControl;FieldName:Array of String;EMsg: string =''):Boolean;
  //�رմ���DataSet����CloseFormʱ����
  procedure CloseAllDataSet(frm: TForm);

  //*************************************************************************
  //��tsList������ Excel �ļ�������Ҫϵͳ��װExcel��
  //�����ָ���ļ��� AFileName�����Զ��������Ϊ�ĶԻ���
  procedure WriteListToExcelFile(xList: TStringList; AFileName: String = '');
  //��tsList������ Excel
  procedure WriteListToExcel(tsList: TStringList; StrColList: TStrings = nil);

  //*************************************************************************
  //��ComboBox�����ֵ
  procedure AddValueToCombobox(qryTemp: TADOQuery; strSQL: string; Combox: TCustomComboBox);
  procedure AddValueToComboboxByID(qryTemp: TADOQuery; strSQL: string;Combox: TCustomComboBox);
  function GetComboboxID(Combox:TCustomComboBox): string;
  function SetComboboxValue(Combox:TCustomComboBox; ID: string): Boolean;

  //��ָ�����ݼ�
  function OpenDataSet(qry: TADOQuery; strSQL: string): Boolean;
  //ִ��ָ��SQL���
  function ExecuteSQL(qry:TADOQuery; strSQL: string):Boolean;

  procedure RefreshQuery(qry: TADOQuery); //ˢ��ADO���ݼ�
  procedure RefreshDataSet(DataSet: TDataSet);//ˢ�����ݼ���ˢ�º󷵻ص���ǰ״̬(��¼λ��)
  procedure RefreshDataSetEX(DataSet: TDataSet; bDisableControls: Boolean = True);
  procedure RefreshMemTable(DataSet: TDataSet);//ˢ�����ݼ�MemTable(EH)��ˢ�º󷵻ص���ǰ״̬(��¼λ��)

  //*************************************************************************
  //Сд��ת��д����
  function CashSmallToBig(small: Real): string;
  //��һ�����壬���Ӵ���
  procedure OpenNormalForm(AForm:TCustomForm;const AFormClass:TFormClass);
  //��һ���Ӵ��壺FormClass:������ Fm:������ AOwner:������(SELF)
  procedure OpenChildForm(FormClass: TFormClass; var Fm; AOwner: TComponent); overload
  procedure DontCareIme(Parent: TWinControl);
  procedure OpenChildForm(FormClass: TCustomFormClass; var Form; bDontCareIme: Boolean = True); overload
  //ִ��ָ��·��Exe
  function ExcuteExe(Exe_Dir: string): Boolean;
  //�����Ƿ��Ѿ����У���������򼤻���
  function CheckAppHasRun(AppHandle: THandle): Boolean;
  //����ָ������
  function FindProcess(AFileName: string): boolean;
  //����ָ������
  procedure EndProcess(AFileName: string);


  //����һ����ʾ����ʾ������ɹ�������ѯ�ʡ���ʾ
  function ShowMsbInfo(AMsg,IType: string): Boolean;
  procedure HideTaskbar; //����������
  procedure ShowTaskbar; //��ʾ������
  procedure DisableTask(Key: Boolean); //��ֹ���������
  //��ʾ������һ�����ﴫ�뻭������ʾ���С����ʾ�ַ�����ʾ��ɫ
  procedure ShowDigiInRect(Canvas: TCanvas; mRect: TRect; str : string; Color: TColor);

  //*************************************************************************
  function StartDate(Date: TDateTime): string;  //������ڿ�ʼʱ�� ��ȷ��Date
  function EndDate(Date: TDateTime): string;    //������ڽ���ʱ�� ��ȷ��Date
  function StartOfDate(Date: TDateTime): string; //������ڿ�ʼʱ��  ��ȷ��ǧ��֮һ
  function EndOfDate(Date: TDateTime): string;   //������ڽ���ʱ��  ��ȷ��ǧ��֮һ
  function StartOfTheDate(Date: TDateTime): string; //������ڿ�ʼʱ��  ��ȷ����
  function EndOfTheDate(Date: TDateTime): string; //������ڽ���ʱ��  ��ȷ����
  function GetServerDateTime(qry: TADOQuery): TDateTime; //��÷�����ʱ��  ��ȷ��ǧ��֮��,�����ݿ�ʱ��
  function GetMonthOfDate(ReturnType: Integer): TDateTime; overload;//����·���ص�����
  function GetMonthOfDate(InputDate: TDateTime ;ReturnType: Integer): TDateTime; overload;

  //*************************************************************************
  procedure IntegerOnly(var Key: Char);  //������������
  procedure FloatOnly(var Key: Char; iText: String);   //�������븡����
  procedure NumberOrLetterOnly(var Key: Char);
  function IsNumber(str: string): Boolean; //�ж��ַ��Ƿ�����
  function IsFloat(str: string): Boolean; //�ж��ַ��Ƿ񸡵���
  function IsNumeric(Value: string; const AllowFloat: Boolean;
    const TrimWhiteSpace: Boolean = True): Boolean;  //�ж��ַ��Ƿ񸡵���

  //���ؼ�����CheckBox��ѡ�����ڲ�ѯ
  function IsCheckNull(Container: TWinControl; DefaultCheckBox: TCheckBox = nil): Boolean;
  //���ÿؼ�����Edit�ؼ�Enable����
  function EditEnable(Container: TWinControl;Able: Boolean; DefaultEdit: TEdit = nil): Boolean;

  //*************************************************************************
  //�ַ�ת��Utf8����
  function DecodeUtf8Str(const S:UTF8String): WideString;
  //����ĳһ�ַ�����Դ�ַ����г��ֵĴ���
  function SubStrCount(MainStr,SubStr: string): Integer;
  //ͨ���ָ�����ȡ�����Ӵ�
  function SplitStr(const Source,Split:string):TStringList;
  //���ַ����е�ָ���Ӵ��滻���ض��Ӵ�������һ�����ַ���
  function SubStrReplace(MainStr,SubStr,ReplaceStr:String):String;
  //���ַ����е�ָ���Ӵ��滻���ض��Ӵ�������һ�����ַ�������ɱMemo�Ļس������У��ո������ַ���
  procedure ReplaceMeoToStr(var s:string;const SourceChar:pchar;const RChar:pchar);
  //ɾ��StringList�����ظ�����Ŀ
  procedure DelStrListDuplicates(const AStringList : TStringList);
  //���TstringList��û���ظ����ַ���
  procedure GetUniqueStringList(const AStringList: TStringList);
  //����ָ��Ŀ¼���ļ�������TStringList
  procedure EnumFileInQueue(path: PChar; fileExt: string; fileList: TStringList);
  //ת���ļ���ʱ���ʽ
  function CovFileDate(Fd:_FileTime):TDateTime;
  //��ȡ�ļ�ʱ�䣬Tf��ʾĿ���ļ�·��������
  function GetFileTime(const Tf:string): string;
  //��ȡSQL����������Ϣ
  function GetSQLErrorChineseInfo(ErrorInfo: string): string;
  //�ϼ�DataSet��ָ���ֶ�
  function FieldSumValue(DataSet: TDataSet; FieldName: string): Extended;
  //��ʾ���ָ�����������ͣ��еĺϼ�ֵ
  function FieldSumValueFooter(grd: TDBGridEh; FieldName: string;
    DisplayFormat: string = '#0.00'): string;
  //��ָ���ֶ�Footer��ֵ
  function FieldFooterValue(grd: TDBGridEh; FieldName: string;
    FieldValue: string = '��';DisplayFormat: string = '#0.00'): string;
  //�ѿؼ�Ĭ��ֵ���浽ini�ļ�
  procedure SaveIni(FormName: String; Cmb: TWinControl);
  procedure LoadIni(FormName: String; Cmb: TWinControl);

  function GetLocalComputerIP: string;   //��ñ���IP
  function GetLocalComputerName: string; //��ñ�����
  function GetWinLogonName: string;      //���Windows��¼�û���

  //���̹��ܣ���ʾ������Ϣ
  procedure ShowLodingMessage(Mes: String; BackgroundColorB: TColor = $00AFAF61; BackgroundColorE: TColor = $00FFFF80);
  //���̹��ܣ����ؼ�����Ϣ
  procedure HideLodingMessage;

  //�򿪹��ڴ���
  procedure ShowAboutForm(sysName, useUnit: string);

  function GetWindowsVertion: string;
  function GetFileVersion(FileName:PChar):String;
  function GetFilesTime(sFilename: String; Timetype: Integer): TDateTime;
  
  //����XXXX��XX��XX�� ����X��ʽ
  function ReturnToday(CurrTime: TDateTime): string;
  //����Ӳ����Ϣ
  function GetDisksInfo(strL: TStringList): TStringList;
  //һ�κ���ת����ƴ��
  function ChineseToLetter(const S: widestring): widestring;
  function IsEnCase(strTemp:string): Boolean; //�ж��ַ��Ƿ�Ӣ��
  //��Excel��ʽ��Ӣ����ĸ����ת��Ϊ������26��������Z = A0
  function AlphaToInt(Value: string): Integer;
  //�ѷǸ�����ת����Excel��ʽ��Ӣ����ĸ����
  function IntToAlpha(Value: Integer): string;

  //�ַ�������
  function EncryptionStr(Src:String; Key:String = 'WhComTec'):string;
  //�����ַ���
  function DecryptStr(Src:String; Key:String= 'WhComTec'):string;

type
  TCharSegmentSet = set of 0{1}..7;
  TCharSegment = TCharSegmentSet;

//
const
  MapFileName = '{CAF49BBB-AF40-4FDE-8757-51D5AEB5BBBF}';
type
  //�����ڴ�
  PShareMem = ^TShareMem;
  TShareMem = record
    AppHandle: THandle;  //�������ľ��
  end;
var
  hMapFile: THandle;
  PSMem: PShareMem;

var
  sOpenWindowClassStr: String;  //���ڼ�¼OpenWindow�����򿪵Ĵ�����������ֹһ������(Form1)�ڴ���ʱ��
                                //ͬʱ����һ����ͬ����(Form1_1)������Form1_1���Ȩ�޲��ɹ���

implementation

uses
  Registry, Math, LodingForm, UState;

//��ǰ�����Ŀ¼Ini�ļ�
function GetIniFile: string;
begin
  Result := ExtractFilePath(ParamStr(0));
  if DirectoryExists(Result) then
    Result := Result + 'Setting.ini'
  else
    Result := '';
end;

//��ǰ�����Ŀ¼Ini�ļ�
function GetIniFile(FileName:string):string;
begin
  Result := ExtractFilePath(Application.ExeName);
  if DirectoryExists(Result) then
    Result := Result + FileName
  else
    Result := '';
end;

function CreateIniFile(var IniFile: TIniFile; FileIni: string): Boolean;
begin
  Result := Assigned(IniFile);
  if Result then Exit;
  Result := (FileIni <> '');
  if Result then
  begin
    try
      IniFile := TIniFile.Create(FileIni);
    except
      Result := False;
    end;
  end;
end;

procedure CloseAllDataSet(frm: TForm);
var
  i: Integer;
begin
  if not Assigned(frm) then Exit;
  with frm do
  for I := 0 to ComponentCount- 1 do
  if (Components[i] is TCustomADODataSet)  then
    if (Components[i] as TCustomADODataSet).Active then
      (Components[i] as TCustomADODataSet).Close;
end;

function EditEnable(Container: TWinControl;Able: Boolean; DefaultEdit: TEdit = nil): Boolean;
var
  AControl: TControl;
  I: Integer;
begin
  Result := False;
  with Container do
  begin
    for I := 0 to ControlCount - 1 do
    begin
      AControl := Controls[I];
      if AControl is TEdit then
      begin
        TEdit(AControl).Enabled := Able;
        Result := Result or TEdit(AControl).Enabled;
      end;
    end;
  end;
end;

//����DBGrid����// Added by CYQ 2013-08-15 10:04:49
procedure ExportExcelDbGrid(ADbgrid: tdbgrid);
var
  excel: variant;
  WorkBook: variant;
  WorkSheet: variant;
  SaveDialog1: tsavedialog;
  i, j: integer;
  CurDir: string;
  Pnl: TPanel;
begin
  try
{   ADbgrid;
   ADbgrid.DataSource.DataSet;
}
    with ADbgrid.DataSource.DataSet do
    if (Bof and Eof) then Exit;
    if (ADbgrid.DataSource.DataSet.state = dsedit) or (ADbgrid.DataSource.DataSet.state = dsinsert) then
    begin
      ShowMessage('�����༭��������״̬��');
      Exit;
    end;
    try
      Excel := CreateOleObject('Excel.Application');
    except
      ShowMessage('Excel����ʧ�ܻ��߸õ���û�а�װExcel�����飡');
      Abort;
      Exit;
    end;

    SaveDialog1 := TSaveDialog.Create(nil);
    SaveDialog1.DefaulText := 'xls';
    SaveDialog1.Filter := '*.xls';
    GetDir(0, CurDir);
    SaveDialog1.InitialDir := CurDir;

    if SaveDialog1.Execute then
    begin
      if FileExists(SaveDialog1.FileName) then
      begin
        if MessageDlg('Excel�Ѿ����ڣ��Ƿ񸲸�?', MtConfirmation, [MBNO, MBYES], 0) = MRNO then
          Exit;
        Excel.WorkBooks.Open(SaveDialog1.Filename);
      end
      else
        Excel.WorkBooks.Add(1);
    end
    else
    begin
      ShowMessage('��ָ��Ҫ������ļ�����');
      Exit;
    end;
    WorkBook := Excel.Application.WorkBooks[1];
    WorkSheet := WorkBook.WorkSheets[1];

    //��ʾPanel
    Pnl := TPanel.Create(nil);
    Pnl.Parent := ADbgrid;
    Pnl.Caption := '�������ڵ��������Ժ򡣡���';
    Pnl.Width := 220;
    Pnl.Alignment := taCenter;
    Pnl.Left := ADbgrid.Left+ Floor(ADbgrid.Width /2) - Floor(pnl.Width /4);
    Pnl.Top := ADbgrid.Top + Floor(ADbgrid.Height/4) - pnl.Height;
    Pnl.Font.Name := '����';
    Pnl.Font.Color := clRed;
    Pnl.Color := $00B871FF;
    Pnl.Show;

    for i := 0 to ADbgrid.columns.count - 1 do
      WorkSheet.Cells.Item[1, i + 1] := ADbgrid.Columns[i].Title.Caption;

    j := 2;
    with ADbgrid.DataSource.DataSet do
    begin
      DisableControls;
      First;
      While not eof do
      begin
        for i := 0 to ADbgrid.columns.count - 1 do
        begin
  //             ShowMessage(ADbgrid.columns[i].Fieldname);
          WorkSheet.Cells.Item[j, i + 1] := Trim(Fieldbyname(ADbgrid.Columns[i].Fieldname).AsString);
        end;
        next;
        j := j + 1;
      end;
      EnableControls;
    end;
    WorkBook.Saveas(SaveDialog1.Filename);
    Excel.application.quit;
    //ShowMessage('�ɹ��������ļ� : ' + SaveDialog1.Filename);
    pnl.Caption := '������ɣ�';

    SaveDialog1.Free;
  except
    SaveDialog1.Free;
    ADbgrid.DataSource.DataSet.EnableControls;
    Excel.Application.Quit;
    WorkSheet.Free;
    WorkBook.Free;
    Excel.Free;
    ShowMessage('����ʧ�ܣ������ļ��Ƿ��ڴ�״̬���رպ�����!');
  end;
end;

procedure ExportExcelByStream(DBGridEh: TDBGridEh;bWriteTitle: Boolean; Title: String ='';
  bWriteFirst: Boolean= False; TitleFirst: string = '');
var
i,j: integer;
Col , row: word;
ABookMark: TBookMark;
aFileStream: TFileStream;
SaveDialog: TSaveDialog;
FileName: string;
  procedure incColRow; //�������к�
  begin
    if Col = DBGridEh.FieldCount - 1 then
      begin
        Inc(Row);
        Col :=0;
      end
    else
      Inc(Col);
  end;
  procedure WriteStringCell(AValue: string);//д�ַ�������
  var
   L: Word;
  begin
     L := Length(AValue);
     arXlsString[1] := 8 + L;
     arXlsString[2] := Row;
     arXlsString[3] := Col;
     arXlsString[5] := L;
     aFileStream.WriteBuffer(arXlsString, SizeOf (arXlsString));
     aFileStream.WriteBuffer(Pointer(AValue)^, L);
     IncColRow;
  end;
  procedure WriteIntegerCell(AValue: integer);//д����
  var
  V: Integer;
  begin
    arXlsInteger[2] := Row;
    arXlsInteger[3] := Col;
    aFileStream.WriteBuffer(arXlsInteger, SizeOf(arXlsInteger));
    V := (AValue shl 2) or 2;
    aFileStream.WriteBuffer(V, 4);
    IncColRow;
  end;
  procedure WriteFloatCell(AValue: double );//д������
  begin
     arXlsNumber[2] := Row;
     arXlsNumber[3] := Col;
     aFileStream.WriteBuffer(arXlsNumber, SizeOf(arXlsNumber));
     aFileStream.WriteBuffer(AValue, 8);
     IncColRow;
  end;
begin
  DBGridEh.datasource.DataSet.DisableControls;
  SaveDialog := TSaveDialog.Create(nil);
  try
    SaveDialog.Filter := 'Excel Files (*.xls)|*.xls|All Files (*.*)|*.*';
    SaveDialog.Filename := Title+'.xls';
    if SaveDialog.Execute then
    begin
      FileName := SaveDialog.Filename;
      if FileName='' then
        FileName:='תExcel';
    end else begin
      DBGridEh.datasource.DataSet.EnableControls;
      Exit;
    end;
  finally
    SaveDialog.Free;
  end;

  if FileExists(FileName) then DeleteFile(FileName); //�ļ����ڣ���ɾ��
    aFileStream := TFileStream.Create(FileName, fmCreate);
  Try    //д�ļ�ͷ ��
    ShowLodingMessage('���ڵ������ݵ�Excel������');
    aFileStream.WriteBuffer(arXlsBegin, SizeOf(arXlsBegin));   //д��ͷ��

    if bWriteFirst then
    begin
    Col := 0; Row := 0;
    WriteStringCell(TitleFirst);
    Col := 0; Row := 1;
    end else begin
    Col := 0; Row := 0;
    end;

    if bWriteTitle then
    begin
      for i := 0 to DBGridEh.FieldCount - 1 do
        WriteStringCell(DBGridEh.Columns[i].Title.Caption);
    end;
    //д���ݼ��е�����
    ABookMark := DBGridEh.datasource.DataSet.GetBookmark;
    DBGridEh.datasource.DataSet.First ;
    while not DBGridEh.datasource.DataSet.Eof do
    begin
       for i := 0 to DBGridEh.FieldCount - 1 do
       case DBGridEh.Fields[i].DataType of
            ftSmallint, ftInteger, ftWord, ftAutoInc, ftBytes:
            WriteIntegerCell(DBGridEh.Fields[i].AsInteger);
            ftFloat, ftCurrency, ftBCD:
            WriteFloatCell(DBGridEh.Fields[i].AsFloat)
        else
            WriteStringCell(DBGridEh.Fields[i].AsString);
       end;
       DBGridEh.datasource.DataSet.Next;
    end;
    //д�ļ�β ��
    AFileStream.WriteBuffer(arXlsEnd, SizeOf(arXlsEnd));
    if DBGridEh.datasource.DataSet.BookmarkValid(ABookMark) then
      DBGridEh.datasource.DataSet.GotoBookmark(ABookMark);
  Finally
    HideLodingMessage;
    AFileStream.Free;
    DBGridEh.datasource.DataSet.EnableControls;
  end;
end;

procedure ExportExcelByStreamMut(DBGridEh: TDBGridEh;Title: String ='';ShowPross: Boolean = True);
var
  DBGridEhToExcel: TDBGridEhToExcel;
begin
  DBGridEhToExcel := TDBGridEhToExcel.Create(nil);
  try
    DBGridEhToExcel.TitleName := Title;
    DBGridEhToExcel.DBGridEh := DBGridEh;
    DBGridEhToExcel.ShowProgress := ShowPross;
    DBGridEhToExcel.ExportToExcel;
  finally
    DBGridEhToExcel.Free;
  end;
end;

procedure PrintDBGridEhData(DBGridEh: TWinControl; Title: string);
var
  PrintDialog: TPrintDialog;
  RowHeight, Temp_X, Temp_Y, PageEdgeX, PageEdgeY, PixelsPerInchX, PixelsPerInchY, PageCount: integer;
  TempStr: string;
  Scale: Double;
  Rect: TRect;
  //1.�������
  procedure Print_Title;
  begin
    Rect := Bounds(0,0,Printer.PageWidth,PageEdgeY);
    Printer.Canvas.Font.Name := '����_GB2312';
    Printer.Canvas.Font.Style := Printer.Canvas.Font.Style + [fsBold];
    Printer.Canvas.Font.Size := 20;
    DrawText(Printer.Canvas.Handle,PChar(Title),Length(Title),Rect,DT_CENTER or DT_VCENTER or DT_SINGLELINE);
    Printer.Canvas.Rectangle(PageEdgeX, PageEdgeY, Printer.PageWidth - PageEdgeX, PageEdgeY + 1);
  end;
  //2.�����ͷ
  procedure Print_Column;
  var j: integer;
  begin
    Printer.Canvas.Font.Name := '����';
    Printer.Canvas.Font.Size := 9;
    Temp_X := PageEdgeX;
    Temp_Y := PageEdgeY;

    for j:=1 to (DBGridEh as TDBGridEh).Columns.Count do
    begin
      if not (DBGridEh as TDBGridEh).Columns[j-1].Visible then Continue;

      TempStr := (DBGridEh as TDBGridEh).Columns[j-1].Title.Caption;
      Rect := Bounds(Temp_X, Temp_Y, Trunc((DBGridEh as TDBGridEh).Columns[j-1].Width*Scale), RowHeight);
      case (DBGridEh as TDBGridEh).Columns[j-1].Field.Alignment of
        taCenter: DrawText(Printer.Canvas.Handle,PChar(TempStr),Length(TempStr),Rect,DT_CENTER
          or DT_VCENTER or DT_SINGLELINE); //case.1.����
        taLeftJustify: DrawText(Printer.Canvas.Handle,PChar(TempStr),Length(TempStr),Rect,DT_LEFT
          or DT_VCENTER or DT_SINGLELINE);//case.2.����
        taRightJustify:  //case.3.����
        if Rect.Right-Rect.Left>=Printer.Canvas.TextWidth(TempStr) then
          DrawText(Printer.Canvas.Handle,PChar(TempStr),Length(TempStr),Rect,DT_RIGHT
            or DT_VCENTER or DT_SINGLELINE)
        else DrawText(Printer.Canvas.Handle,PChar(TempStr),Length(TempStr),Rect,DT_LEFT
            or DT_VCENTER or DT_SINGLELINE);
      end;
      Temp_X := Temp_X + Trunc((DBGridEh as TDBGridEh).Columns[j-1].Width*Scale);
    end;
    Temp_Y := Temp_Y + RowHeight;
  end;
  //3.���DBGrid����
  procedure Print_Cells;
  var j: integer;
  begin
    Printer.Canvas.Font.Name := '����';
    Printer.Canvas.Font.Style := Printer.Canvas.Font.Style - [fsBold];
    while Temp_Y<Printer.PageHeight-PageEdgeY do
    begin
      Temp_X := PageEdgeX;
      for j:=1 to (DBGridEh as TDBGridEh).Columns.Count do
      begin
        if not (DBGridEh as TDBGridEh).Columns[j-1].Visible then Continue;

        Rect := Bounds(Temp_X, Temp_Y, Trunc((DBGridEh as TDBGridEh).Columns[j-1].Width*Scale), RowHeight);
        if ((DBGridEh as TDBGridEh).Columns[j-1].Field is TCurrencyField)
          or ((DBGridEh as TDBGridEh).Columns[j-1].Field is TLargeIntField)
          or ((DBGridEh as TDBGridEh).Columns[j-1].Field is TSmallIntField)
          or ((DBGridEh as TDBGridEh).Columns[j-1].Field is TIntegerField)
          or ((DBGridEh as TDBGridEh).Columns[j-1].Field is TFloatField)
          or ((DBGridEh as TDBGridEh).Columns[j-1].Field is TWordField)
        then TempStr := FormatFloat(',##0.00',(DBGridEh as TDBGridEh).Columns[j-1].Field.AsFloat)
        else TempStr := (DBGridEh as TDBGridEh).Columns[j-1].Field.AsString;
        case (DBGridEh as TDBGridEh).Columns[j-1].Field.Alignment of
          taCenter: DrawText(Printer.Canvas.Handle,PChar(TempStr),Length(TempStr),Rect,DT_CENTER
            or DT_VCENTER or DT_SINGLELINE); //case.1.����
          taLeftJustify: DrawText(Printer.Canvas.Handle,PChar(TempStr),Length(TempStr),Rect,DT_LEFT
            or DT_VCENTER or DT_SINGLELINE); //case.2.����
          taRightJustify: DrawText(Printer.Canvas.Handle,PChar(TempStr),Length(TempStr),Rect,DT_RIGHT
            or DT_VCENTER or DT_SINGLELINE);//case.3.����
        end;
        Temp_X := Temp_X + Trunc((DBGridEh as TDBGridEh).Columns[j-1].Width*Scale);
      end;
      Temp_Y := Temp_Y + RowHeight;
      (DBGridEh as TDBGridEh).DataSource.DataSet.Next;
      if (DBGridEh as TDBGridEh).DataSource.DataSet.Eof then Exit;
    end;
  end;
  //4.���ҳ��
  procedure Print_Footer;
  begin
    Temp_Y := Printer.PageHeight - PageEdgeY + RowHeight;
    Printer.Canvas.Rectangle(PageEdgeX, Temp_Y, Printer.PageWidth - PageEdgeX, Temp_Y + 1); //4.0.�������
    Rect := Bounds(PageEdgeX, Temp_Y, Printer.PageWidth-PageEdgeX, RowHeight); //4.1.�������
    DrawText(Printer.Canvas.Handle,PChar(DateTimeToStr(Now)),Length(DateTimeToStr(Now)),Rect,DT_LEFT
      or DT_VCENTER or DT_SINGLELINE);
    //4.2.���ҳ��
    Rect := Bounds(PageEdgeX, Temp_Y, Printer.PageWidth-PageEdgeX*2, RowHeight);
    DrawText(Printer.Canvas.Handle,PChar('��'+IntToStr(Printer.PageNumber)+'ҳ'),
      Length('��'+IntToStr(Printer.PageNumber)+'ҳ'),
      Rect,DT_RIGHT or DT_VCENTER or DT_SINGLELINE);
  end;
begin
  CheckValidDBGridEh(DBGridEh);

  (DBGridEh as TDBGridEh).DataSource.DataSet.DisableControls;

  PrintDialog := TPrintDialog.Create(DBGridEh);
  if PrintDialog.Execute then
  begin
    //0.ȡ��ǰ��ӡ��X,Y����ÿӢ������
    PixelsPerInchX := GetDeviceCaps(Printer.Handle, LOGPIXELSX);
    PixelsPerInchY := GetDeviceCaps(Printer.Handle, LOGPIXELSY);
    //1.������ʼ��
    PageEdgeX := PixelsPerInchX div 6;
    PageEdgeY := PixelsPerInchY div 5 * 4;
    RowHeight := Trunc(1.5 * 9 * PixelsPerInchY / 72);
    Scale := PixelsPerInchX / Screen.PixelsPerInch;

    try
      Printer.BeginDoc;
      ShowLodingMessage('���ڴ�ӡ����,���Ժ򡣡���');
      (DBGridEh as TDBGridEh).DataSource.DataSet.First;
      PageCount := 0;
      while not (DBGridEh as TDBGridEh).DataSource.DataSet.Eof do
      begin
        Print_Title;
        Print_Column;
        Print_Cells;
        Print_Footer;
        Printer.NewPage;
      end;
      if not Printer.Aborted then Printer.EndDoc;
    except
      on E:EPrinter do
      begin
        MessageBox(Application.Handle,PChar('��ӡ��û��׼���ã�'),'��ʾ��',MB_OK+MB_ICONINFORMATION);
        Printer.Abort;
        Exit;
      end;
      on E:Exception do
      begin
        raise;
        Exit;
      end;
    end;
  end;
  (DBGridEh as TDBGridEh).DataSource.DataSet.EnableControls;
  PrintDialog.Free;
  HideLodingMessage;
end;

//���DBGridEhָ���е���ֵ�Ƿ����ظ�
function CheckGridFieldDuplicate(DBGridEh:TWinControl;FieldName:Array of String;EMsg: string =''):Boolean;
var
  i:Integer;
  strlTemp:TStringList;
  strTemp:String;
begin
  Result := False;
  CheckValidDBGridEh(DBGridEh);
  if (DBGridEh as TDBGridEh).DataSource.DataSet.IsEmpty then Exit;
  (DBGridEh as TDBGridEh).DataSource.DataSet.DisableControls;
  strlTemp:= TStringList.Create;
  Try
    (DBGridEh as TDBGridEh).DataSource.DataSet.First;
    while not (DBGridEh as TDBGridEh).DataSource.DataSet.eof do
    begin
      strTemp := '';
      for i:= Low(FieldName) to High(FieldName) do
        strTemp := strTemp + #1
          + (DBGridEh as TDBGridEh).DataSource.DataSet.Fieldbyname(FieldName[i]).AsString;
      if strlTemp.IndexOf(strTemp)<> -1 then begin
        Result := True;
        if EMsg <> '' then ShowMsbInfo(EMsg,'info');
        Exit;
      end
      else
      strlTemp.Add(strTemp);
      (DBGridEh as TDBGridEh).DataSource.DataSet.Next;
    end;
  Finally
    FreeAndNil(strlTemp);
    (DBGridEh as TDBGridEh).DataSource.DataSet.EnableControls;
  end;
end;

//���DBGrdeh��FieldList
procedure GetGrdEhColList(DBGridEh: TDBGridEh; TitleList: Array of String;
  var FList: TStringList);
var
  i, j: Integer;
  FCol, FTitle: TObject;
  sFieldName, sCaption: String;
  FWidth: LongInt;
  FVisible: Boolean;
begin
  FCol := GetObjectProp(DBGridEh, 'Columns');
  if Length(TitleList) = 0 then
  begin
    for i := 0 to TCollection(FCol).Count - 1 do
    begin
      sFieldName := GetStrProp(TCollection(FCol).Items[i], 'FieldName');
      if (sFieldName <> '') then  FList.Add(sFieldName);
    end;
  end else
  begin
    for i := 0 to Length(TitleList) - 1 do
    for j := 0 to TCollection(FCol).Count - 1 do begin
      sFieldName := GetStrProp(TCollection(FCol).Items[j], 'FieldName');
      FTitle := GetObjectProp(TCollection(FCol).Items[j], 'Title');
      sCaption := GetStrProp(FTitle, 'Caption');
      if (sFieldName <> '') And SameText(sCaption, TitleList[i]) then begin
        FList.Add(sFieldName);
        break;
      end;
    end;
  end;
end;

type
  TGetFooterValueFunc = function (Row, Col: Integer): String of object;

//���ܣ����� DBGridEh ָ�������� TitleList ���ֶε� Excel
procedure DBGridEhToExcel(DBGridEh: TWinControl; TitleList: Array of String; SaveToFile: Boolean; DocName: string = '������');
  //���ܣ�ͨ�� TitleList �ֽ� ��ȡ�ֶΡ�
  procedure GetDBGridEhFieldList(DBGridEh: TWinControl; TitleList: Array of String;
          var FList, FColList: TStringList);
  var
    i, j: Integer;
    FCol, FTitle: TObject;
    sFieldName, sCaption: String;
    FWidth: LongInt;
    FVisible: Boolean;
  begin
    FCol := GetObjectProp(DBGridEh, 'Columns');
    //�����ָ���У���ֻ�������ӵ���
    if Length(TitleList) = 0 then
    begin
      for i := 0 to TCollection(FCol).Count - 1 do
      begin
        sFieldName := GetStrProp(TCollection(FCol).Items[i], 'FieldName');
        FWidth := GetOrdProp(TCollection(FCol).Items[i], 'Width');
        FVisible := GetPropValue(TCollection(FCol).Items[i], 'Visible');
        if FVisible And (FWidth > 0) And (sFieldName <> '') then
        begin
            FList.Add(sFieldName);
            FColList.Add(IntToStr(i));
        end;
      end;
    end
    else
    begin
      for i := 0 to Length(TitleList) - 1 do
      begin
        for j := 0 to TCollection(FCol).Count - 1 do
        begin
          sFieldName := GetStrProp(TCollection(FCol).Items[j], 'FieldName');
          FTitle := GetObjectProp(TCollection(FCol).Items[j], 'Title');
          sCaption := GetStrProp(FTitle, 'Caption');
          if (sFieldName <> '') And SameText(sCaption, TitleList[i]) then
          begin
              FList.Add(sFieldName);
              FColList.Add(IntToStr(j));
              break;
          end;
        end; //for j
      end; //for i
    end; //if
  end;
var
  FieldList: Array of String;
  FList, FColList: TStringList;
  i, j: Integer;
  FDS: TObject;
  FCanExport: Boolean;
  xList, StrColList: TStringList;
  FFooterRowCount: Integer;
  FGetValue: TGetFooterValueFunc;
  s, lsFile: String;
  ExpClass:TDBGridEhExportClass;
  SaveDialog: TSaveDialog;
begin
  CheckValidDBGridEh(DBGridEh);

  FDS := GetObjectProp(DBGridEh, 'DataSource');
  if Not Assigned(FDS) then
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

  if Assigned(GetPropInfo(DBGridEh, 'CanExportExcel')) then
  begin
      FCanExport := GetPropValue(DBGridEh, 'CanExportExcel');
      if Not FCanExport then
      begin
          Application.MessageBox('ϵͳ��ֹ�ñ�񵼳����ݣ�', '��ʾ', MB_ICONWARNING);
          Exit;
      end;
  end;

  (DBGridEh as TDBGridEh).datasource.DataSet.DisableControls;
  FColList := TStringList.Create;
  try
    FList := TStringList.Create;
    try
      GetDBGridEhFieldList(DBGridEh, TitleList, FList, FColList);
      SetLength(FieldList, FList.Count);
      for i := 0 to FList.Count - 1 do
          FieldList[i] := FList[i];
    finally
      FList.Free;
    end;

    //�������б�
    xList := TStringList.Create;
    StrColList := TStringList.Create;
    try
      DataSetEhToList(TDataSource(FDS).DataSet, FieldList, xList, StrColList, DBGridEh);
      //��ȡҳ��ֵ
      if Assigned(GetPropInfo(DBGridEh, 'FooterRowCount')) And
         Assigned(GetPropInfo(DBGridEh, 'OnGetFooterValue'))then
      begin
        FFooterRowCount := GetOrdProp(DBGridEh, 'FooterRowCount');
        FGetValue := TGetFooterValueFunc(GetMethodProp(DBGridEh, 'OnGetFooterValue'));
        for i := 0 to FFooterRowCount - 1 do
        begin
          s := '';
          for j := 0 to FColList.Count - 1 do
              s := s + FGetValue(i, StrToInt(FColList[j])) + #9;
          if StringReplace(s, #9, '', [rfReplaceAll]) <> '' then
          begin
              s := Copy(s, 1, Length(s) - Length(#9));
              xList.Add(s);
          end;
        end; //for i
      end;
      //������Excel
      ShowLodingMessage('���ڵ������ݵ�Excel������');
      ExpClass := TDBGridEhExportAsXLS;
      if SaveToFile then
      begin
        SaveDialog := TSaveDialog.Create(nil);
        try
          SaveDialog.Filter := 'Excel files (*.xls)|*.xls|All files (*.*)|*.*';
          SaveDialog.Filename := DocName+'.xls';
          if SaveDialog.Execute then
          begin
            lsFile := SaveDialog.Filename;
            if lsFile='' then
              lsFile:='תExcel';
          end else begin
            (DBGridEh as TDBGridEh).datasource.DataSet.EnableControls;
            Exit;
          end;
        finally
          SaveDialog.Free;
        end;
          //WriteListToExcelFile(xList);
        SaveDBGridEhToExportFile(ExpClass,(DBGridEh as TDBGridEh) ,lsFile,True);
      end;
      //ExportExcelEh(DBGridEh as TDBGridEh);
//            else
//                WriteListToExcel(xList, StrColList);
    finally
        FreeAndNil(xList);
        FreeAndNil(StrColList);
    end;
  finally
    HideLodingMessage;
    FreeAndNil(FColList);
    (DBGridEh as TDBGridEh).datasource.DataSet.EnableControls;
  end;
end;
//����������ݵ�ͳһ����(������DBGrid��StringGrid��DBGridEh��
procedure GridToExcel(Grid: TWinControl; TitleList: Array of String;
        SaveToFile: Boolean = False; UseTree: Boolean = True);
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
      begin
        DBGridEhToExcel(Grid, TitleList, SaveToFile);
      end;
    finally
      if (Not UseTree) And bHadTree And (FTreeCount <> 0) then    //�ָ�������
          SetOrdProp(Grid, 'TreeLayerCount', FTreeCount);
    end;
  end;
end;
//�������Ƿ��ǺϷ���TDBGridEh��TJDBGridEh��
procedure CheckValidDBGridEh(DBGridEh: TWinControl);
begin
  if DBGridEh = nil then
      raise Exception.Create('DBGridEh does not Exist!');
  if Not IsValidDBGridEh(DBGridEh) then
      raise Exception.Create(Format('%s is not a valid DBGridEh!', [DBGridEh.Name]));
end;

function IsValidDBGridEh(DBGridEh: TWinControl): Boolean;
begin
  Result := False;
  if DBGridEh = nil then Exit;
  Result := Pos('$' + UpperCase(DBGridEh.ClassName) + '$', '$TDBGRIDEH$TDBGRID$') > 0;
end;

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
    end;
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

//�õ�DBGrid����ʾΪ��ѡ����м�
procedure GetDBGridCheckBoxList(DBGrid: TWinControl; var CheckBoxColList: TStringList);
var
  i: Integer;
  FCol: TObject;
  B: Boolean;
begin
  if DBGrid = nil then Exit;
  //�õ���Щ����ʾCheckBoxͼ��
  if Assigned(GetPropInfo(DBGrid, 'CheckBoxColList')) then   //JDBGrid�����
      CheckBoxColList.Assign(TStringList(GetObjectProp(DBGrid, 'CheckBoxColList')))
  else
  if Assigned(GetPropInfo(DBGrid, 'Columns')) then           //DBGridEh�����
  begin
    FCol := GetObjectProp(DBGrid, 'Columns');
    for i := 0 to TCollection(FCol).Count - 1 do
    begin
      if Not Assigned(GetPropInfo(TCollection(FCol).Items[i], 'CheckBoxes')) then
          Break;
      B := GetPropValue(TCollection(FCol).Items[i], 'CheckBoxes');
      if B then
          CheckBoxColList.Add(IntToStr(TCollection(FCol).Items[i].ID - 1));
    end;
  end;
end;

//���ܣ����� TDataSet �� FieldList �ֶ����ݵ�xList�С�
procedure DataSetEhToList(qry: TDataSet; FieldList: Array of String;
        var xList, StrColList: TStringList; DBGridEh: TWinControl);
var
  i, j: Integer;
  FList, FSrcList, FTitleList, FCheckBoxColList: TStringList; //FieldName List
  s, sTemp: String;
  BM: TBookMark;
  FTreeCount: Integer;
  FTreeValues: TStringList;
  {bNotGetTree, }bUseMultiTitle, bDrawMemoText, bTemp: Boolean;
  //eTemp: Extended;
  Cur: TCursor;
  FCol, FTitle: TObject;
  sFieldName: String;
  FVisible: Boolean;
begin
  if DBGridEh <> nil then
    CheckValidDBGridEh(DBGridEh);
  FTreeCount := 0;
  //bNotGetTree := True;
  Cur := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  FTreeValues := TStringList.Create;
  try
    FCheckBoxColList := TStringList.Create;
    FList := TStringList.Create;
    try
      FSrcList := TStringList.Create;
      FTitleList := TStringList.Create;
      try
          //���û�д��뵼���ֶΣ����ȡ�����ֶ�
          if Length(FieldList) = 0 then
          begin
              for i := 0 to qry.FieldCount - 1 do
                  FSrcList.Add(qry.Fields[i].FieldName);
          end
          else   //�����ȡ���е����ֶ�
          begin
              for i := 0 to Length(FieldList) - 1 do
                  FSrcList.Add(FieldList[i]);
          end;

          s := '';
          //DBGridEh 6.0���Ѿ����ض��ͷ����,ֱ�Ӹ�ֵ
          //bUseMultiTitle := (DBGridEh <> nil) And GetPropValue(DBGridEh as TDBGridEh, 'UseMultiTitle');
          bUseMultiTitle := (DBGridEh as TDBGridEh).UseMultiTitle;
          bDrawMemoText := (DBGridEh <> nil) And GetPropValue(DBGridEh, 'DrawMemoText');

          //�������DBGridEh�������ȡҪ�󵼳�����DBGridEh�������������ֶΣ��Լ������������� s
          if DBGridEh <> nil then
          begin
              if Assigned(GetPropInfo(DBGridEh, 'TreeLayerCount')) then
                  FTreeCount := GetOrdProp(DBGridEh, 'TreeLayerCount');     //�õ������״����

              FCol := GetObjectProp(DBGridEh, 'Columns');
              for j := 0 to TCollection(FCol).Count - 1 do
              begin
                  FVisible := GetPropValue(TCollection(FCol).Items[j], 'Visible');
                  if Not FVisible then Continue;
                  (* add over *)
                  sFieldName := GetStrProp(TCollection(FCol).Items[j], 'FieldName');
                  if sFieldName <> '' then
                  begin
                      for i := 0 to FSrcList.Count - 1 do
                      begin
                          if SameText(sFieldName, FSrcList[i]) then
                          begin
                              FList.Add(FSrcList[i]);
                              FTitle := GetObjectProp(TCollection(FCol).Items[j], 'Title');
                              FTitleList.Add(GetStrProp(FTitle, 'Caption'));
                              {ע��:��������������ʾ������ʾ�����еĲ���, ���������β�����Ҫ.
                              if (j >= FTreeCount - 1) And bNotGetTree then
                              begin
                                  //�õ�ָ���ֶε���״����
                                  if j > FTreeCount - 1 then
                                      FTreeCount := FList.Count - 1
                                  else
                                      FTreeCount := FList.Count;
                                  bNotGetTree := False;
                              end;
                              }
                              break;
                          end; //if
                      end; //for i
                  end; //if sFieldName <> ''
              end; //for j

              //������������ s
              s := GetExcelTitleStr(FTitleList, bUseMultiTitle);
              if s <> '' then
              begin
                  //s := Copy(s, 1, Length(s) - Length(#9));
                  xList.Add(s);
              end;
          end
          else  //���򣬶�ȡ���е����ֶ�
              FList.Assign(FSrcList);
      finally
          FreeAndNil(FTitleList);
          FreeAndNil(FSrcList);
      end;

      //����ֶ�����Ϊ�ַ���������ʱ���ͣ��򵼳����Excel��Ԫ������Ϊ�ı���ʽ��
      StrColList.Clear;
      for i := 0 to FList.Count - 1 do
      begin
          if qry.FieldByName(FList[i]).DataType in [ftString, ftDate, ftTime, ftDateTime] then
              StrColList.Add(IntToStr(i));
      end;

      //�õ�Ҫ��ʾΪ��ѡ�����
      GetDBGridCheckBoxList(DBGridEh, FCheckBoxColList);

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
            if (qry.FieldByName(FList[i]).DataType = ftMemo) and bDrawMemoText then
                sTemp := qry.FieldByName(FList[i]).AsString
            else
            (* add over *)
                sTemp := qry.FieldByName(FList[i]).DisplayText;
            sTemp := ValidExcelCell(sTemp);

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

            //����ѡ����ʾ
            if (sTemp <> '') And (DBGridEh <> nil) then
            begin
              FCol := GetObjectProp(DBGridEh, 'Columns');
              if IsCheckBoxCol(TCollection(FCol), FList[i], FCheckBoxColList) then
              begin
                if tryStrToBool(qry.FieldByName(FList[i]).AsString, bTemp) And bTemp then
                    sTemp := '��'
                else
                    sTemp := '';
              end;
            end;

            {//ע��:��ʹ��ǿ�Ƶ�Ԫ���ʽΪ�ı���ʽ�İ취�����
            //��ֹ�ַ����͵���ֵ, ����Excel���Ϊ��ֵ�Ͷ�ʧǰ�����(��: '001' ===> 1).
            if (sTemp <> '') And (qry.FieldByName(FList[i]).DataType = ftString)
                    And TryStrToFloat(sTemp, eTemp) then
            begin
                if FloatToStr(eTemp) <> sTemp then  //�������, ��ת��
                    sTemp := '=Trim("' + sTemp + '")';
            end;}

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
        FreeAndNil(FList);
        FreeAndNil(FCheckBoxColList);
    end;
  finally
    Screen.Cursor := Cur;
    FreeAndNil(FTreeValues);
  end;
end;

//ͬ��
procedure DataSetEhToList(qry: TDataSet; FieldList: Array of String;
        var xList: TStringList; DBGridEh: TWinControl);
var
  StrColList: TStringList;
begin
    StrColList := TStringList.Create;
    try
      DataSetEhToList(qry, FieldList, xList, StrColList, DBGridEh);
    finally
      FreeAndNil(StrColList);
    end;
end;

//��ColIndex�Ƿ�Ϊ��ѡ����
function IsCheckBoxCol(FCol: TCollection; FieldName: String; CheckBoxColList: TStringList): Boolean;
  //�ҵ�����С��ID
  function GetMinColID: Integer;
  var
    i: Integer;
  begin
    Result := FCol.Items[0].ID;
    for i := 1 to FCol.Count - 1 do
    begin
      if FCol.Items[i].ID < Result then
          Result := FCol.Items[i].ID;
    end;
  end;
var
  i, ColIndex: Integer;
  Offset: Integer;  //��Column.ID��ƫ��ֵ����Ϊ���һ��ʼʱû�а��У���ȱʡ״̬�¶�̬������һ���У�
                    //�����ݼ��󣬸��б�ɾ�����ٽ������У����е�ID��2��ʼ������ر����ݼ������´򿪣����е�IDֵ����
begin
  if TDBGridColumns(FCol).State = csDefault then
    Offset := GetMinColID - 1
  else
    Offset := 0;
  ColIndex := -1;
  for i := 0 to FCol.Count - 1 do
  begin
    if SameText(FieldName, GetPropValue(TCollection(FCol).Items[i], 'FieldName')) then
    begin
      ColIndex := i;
      Break;
    end;
  end;
  Result := (ColIndex <> -1) And (CheckBoxColList.Count > 0)
    And (CheckBoxColList.IndexOf(IntToStr(FCol.Items[ColIndex].ID - Offset - 1)) <> -1);
end;

//��tsList������ Excel �ļ�������Ҫϵͳ��װExcel��
procedure WriteListToExcelFile(xList: TStringList; AFileName: String = '');
begin
  WriteListToExcelFile(xList, AFileName);
end;

//���ܣ���List�����ݵ��뵽Excel��
procedure WriteListToExcel(tsList: TStringList; StrColList: TStrings);
begin
  WriteListToExcel(tsList, StrColList);
end;


//Added by CYQ 2013-08-09
//����DBGridEh����(�ش�)���Ƿ�����ײ��ϼ���(Ĭ��False)���������(Ĭ��Ϊ'')��
procedure ExportExcelEh(const CurDS : TDBGridEh; vSum: Boolean = False; Title: String ='');
  function IntToChr(i: integer): string;
  var
    c: string;
  begin
    if i < 26 then
      c := ''
    else
      c := Chr((i div 26) - 1 + 65);
    result := UpperCase(c + Chr((i mod 26) + 65));
  end;
var
  nowhangi, i, j, k, ii, LCID, liRecNu, liFieldNu: integer; //nowhangi��ǰ execl�������У�jilushu��ǰ�ļ�¼λ��
  lsFile, cols, lsstr: string;
  ExcelApplication1: TExcelApplication;
  ExcelWorkbook1: TExcelWorkbook;
  ExcelWorkSheet1: TExcelWorksheet;
  xl: OleVariant;
  SaveDialog1: TSaveDialog;

  isGroups: Boolean;
  MultiArr: OleVariant;
begin
  if not Assigned(CurDS) then begin
    ShowMsbInfo('����ѡ��Ҫ�������ݵı��','Info');
    Exit;
  end;
  CurDS.datasource.DataSet.DisableControls;
  CurDS.datasource.DataSet.Last;   //����ȡȫ������

  if not CurDS.datasource.DataSet.Active then Exit;

  liRecNu := CurDS.datasource.DataSet.RecordCount; //ȡ��¼��
  liFieldNu := CurDS.Columns.Count; //ȡ�ֶ���
  ii := 0;
  for i := 1 to liFieldNu do
  begin
    if not CurDS.Columns.Items[i - 1].Visible then
      Continue;
    Inc(ii);
  end;
  cols := IntToChr(ii - 1);  //����к�

  if (liRecNu < 1) or (ii < 1) then
  begin
    Application.MessageBox('���������Ϊ�գ�', '����', MB_ICONHAND);
    Exit;
  end;

  //ȡҪ��Ϊ���ļ�����·��
  SaveDialog1 := TSaveDialog.Create(nil);
  try
    SaveDialog1.Filter := 'Excel files (*.xls)|*.xls|All files (*.*)|*.*';
    SaveDialog1.Filename := Title+'.xls';
    if SaveDialog1.Execute then
    begin
      lsFile := SaveDialog1.Filename;
      if lsFile='' then
        lsFile:='תExcel';
    end else begin
      CurDS.datasource.DataSet.EnableControls;
      Exit;
    end;
  finally
    SaveDialog1.Free;
  end;

  try
    ShowLodingMessage('�������ڵ�����...',$00F97C00,$00FFBC79);
    if Pos('.', lsFile) = 0 then lsFile := lsFile + '.xls';

    //����Excel
    try
      ExcelApplication1 := TExcelApplication.Create(ExcelApplication1);
      ExcelWorkbook1 := TExcelWorkbook.Create(ExcelWorkbook1);
      ExcelWorkSheet1 := TExcelWorksheet.Create(ExcelWorkSheet1);
    except
      Application.MessageBox('�Բ������Ĳ���ϵͳû�а�װExcel����Excel�����������⣡', '����', MB_ICONHAND);
      CurDS.datasource.DataSet.EnableControls;
      Abort;
      Exit;
    end;
    Screen.Cursor := crHourGlass;
    LCID := LOCALE_USER_DEFAULT;

    if FileExists(lsFile) then //ɾ����̬���ɵ���ʱtemp.xls�ļ�
    try
      DeleteFile(lsFile);
    except

    end;

    try
      ExcelApplication1.Connect;
      //  ExcelApplication1.Workbooks.Add(null,0);
      ExcelApplication1.Workbooks.Add(1, 0);
      //�������һ��ģ�� ���Ķ��þ��磺
      //  ExcelApplication1.Workbooks.Add(lsFile, 0);
      ExcelWorkbook1.ConnectTo(ExcelApplication1.Workbooks[1]);
      ExcelWorkSheet1.ConnectTo(ExcelWorkbook1.Sheets[1] as _WorkSheet);

      nowhangi := 1;

      //��ʼ��Excel��Ԫ�������
      ExcelApplication1.Range['A' + IntToStr(nowhangi), cols + IntToStr(nowhangi)].Merge(xl); //�ϲ�execl��Ԫ��
      ExcelWorkSheet1.Cells.Item[nowhangi, 1].Font.Size := 24;
      ExcelWorkSheet1.Cells.Item[nowhangi, 1].Font.Name := '����';
      ExcelWorkSheet1.cells.Item[nowhangi, 1].font.fontStyle := fsBold;
      ExcelWorkSheet1.Cells.Item[nowhangi, 1].RowHeight := 24;
      ExcelWorkSheet1.Cells.Item[nowhangi, 1] := Title;
      ExcelWorkSheet1.Cells.Item[nowhangi, 1].HorizontalAlignment := xlCenter;
      ExcelWorkSheet1.cells.Item[nowhangi, 1].font.Color := clred;

      //�ж��Ƿ��ж��ͷ
      isGroups := False;
      lsstr := '';
      k := 1;
      if CurDS.UseMultiTitle then
      for i := 0 to liFieldNu - 1 do
      if CurDS.Columns.Items[i].Visible then
      begin
        if Pos('|', CurDS.Columns.Items[i].Title.Caption) > 0 then
        begin
          lsstr := Trim(Copy(CurDS.Columns.Items[i].Title.Caption, 1, Pos('|', CurDS.Columns.Items[i].Title.Caption) - 1));
          j := k;
          isGroups := TRUE;
          Break;
        end;
        Inc(k);
      end;

      //��ö��ͷ����
      if isGroups then
      begin
        k := 1;
        MultiArr := VarArrayCreate([0, ii - 1], VarVariant);
        for i := 0 to liFieldNu - 1 do
        begin
          if CurDS.Columns.Items[i].Visible then
          begin
            if Pos('|', CurDS.Columns.Items[i].Title.Caption) > 0 then
            begin

              if Trim(Copy(CurDS.Columns.Items[i].Title.Caption, 1, Pos('|', CurDS.Columns.Items[i].Title.Caption) - 1)) <> lsstr then
              begin
                j := k;
                lsstr := Copy(CurDS.Columns.Items[i].Title.Caption, 1, Pos('|', CurDS.Columns.Items[i].Title.Caption) - 1);
              end;
              MultiArr[k - 1] := VarArrayOf([j, k]); //���ͷ
            end
            else
              MultiArr[k - 1] := VarArrayOf([0, 0]); //һ����ͷ
            Inc(k);
          end;
        end;
      end;

      //���������
      if isGroups then
      begin
        nowhangi := nowhangi + 1;
        ii := 1;
        for i := 0 to liFieldNu - 1 do
        begin
          if CurDS.Columns.Items[i].Visible then
          begin
            if MultiArr[ii - 1][0] = MultiArr[ii - 1][1] then
            begin
              if MultiArr[ii - 1][0] > 0 then //���ͷ��ʾ����
              begin
                ExcelWorkSheet1.Cells.Item[nowhangi, ii] := Copy(CurDS.Columns.Items[i].Title.Caption, 1, Pos('|', CurDS.Columns.Items[i].Title.Caption) - 1);
                ExcelWorkSheet1.Cells.Item[nowhangi + 1, ii] := Trim(Copy(CurDS.Columns.Items[i].Title.Caption, Pos('|', CurDS.Columns.Items[i].Title.Caption) + 1, 20));
              end else
              begin
                ExcelWorkSheet1.Cells.Item[nowhangi, ii] := CurDS.Columns.Items[i].Title.Caption;
                ExcelApplication1.Range[IntToChr(ii - 1) + '2', IntToChr(ii - 1) + '3'].Merge(xl); //�ϲ���ά��ͷ
              end;
            end
            else //����ͷ��ʾ����
            begin
              ExcelWorkSheet1.Cells.Item[nowhangi + 1, ii] := Trim(Copy(CurDS.Columns.Items[i].Title.Caption, Pos('|', CurDS.Columns.Items[i].Title.Caption) + 1, 20));
              ExcelApplication1.Range[IntToChr(MultiArr[ii - 1][0] - 1) + '2', IntToChr(MultiArr[ii - 1][1] - 1) + '2'].Merge(xl); //��ά��ͷ�ϲ�
            end;
            ExcelWorkSheet1.Cells.Item[nowhangi, ii].HorizontalAlignment := xlCenter; //����
            ExcelWorkSheet1.Cells.Item[nowhangi + 1, ii].HorizontalAlignment := xlCenter;
            ExcelWorkSheet1.Cells.Item[nowhangi, ii].Font.Color := CurDS.Columns[i].Font.Color;
            Inc(ii);
          end;
        end;
        nowhangi := nowhangi + 1;
      end
      else //�޶�ά��ͷ
      begin
        nowhangi := nowhangi + 1;
        ii := 1;
        for i := 0 to liFieldNu - 1 do
        begin
          if CurDS.Columns.Items[i].Visible then
          begin
            ExcelWorkSheet1.Cells.Item[nowhangi, ii] := CurDS.Columns.Items[i].Title.Caption;
            ExcelWorkSheet1.Cells.Item[nowhangi, ii].Font.Color := CurDS.Columns[i].Font.Color;
            ExcelWorkSheet1.Cells.Item[nowhangi, ii].HorizontalAlignment := xlCenter;
            Inc(ii);
          end;
        end;
      end;

      //�����е���������
      ii:=1;
      for i := 0 to liFieldNu - 1 do
      begin
        if CurDS.Columns.Items[i].Visible then
        begin
          if CurDS.Columns[i].Field.DataType in [ftString, ftFixedChar, ftwidestring, ftMemo] then
            ExcelApplication1.Range[IntToChr(ii - 1) + IntToStr(nowhangi), IntToChr(ii - 1) + IntToStr(liRecNu+nowhangi)].NumberFormatLocal := '@'  //�ַ���
          else if CurDS.Columns[i].Field.DataType = ftDateTime then
            ExcelApplication1.Range[IntToChr(ii - 1) + IntToStr(nowhangi), IntToChr(ii - 1) + IntToStr(liRecNu+nowhangi)].NumberFormatLocal := 'yyyy-MM-dd HH:mm:ss'  //������
          else if CurDS.Columns[i].Field.DataType = ftDate then
            ExcelApplication1.Range[IntToChr(ii - 1) + IntToStr(nowhangi), IntToChr(ii - 1) + IntToStr(liRecNu+nowhangi)].NumberFormatLocal := 'yyyy-MM-dd'
          else if CurDS.Columns[i].Field.DataType = ftTime then
            ExcelApplication1.Range[IntToChr(ii - 1) + IntToStr(nowhangi), IntToChr(ii - 1) + IntToStr(liRecNu+nowhangi)].NumberFormatLocal := 'HH:mm:ss'; //�ַ���

          inc(ii);
        end;
      end;

      //�����ѯ����
      with CurDS do
      begin
        datasource.DataSet.First;
        while not datasource.DataSet.Eof do
        begin
          nowhangi := nowhangi + 1;
          ii := 1;
          for i := 0 to liFieldNu - 1 do
            if Columns.Items[i].Visible then
            begin
              ExcelWorkSheet1.Cells.Item[nowhangi, ii] := Fields[i].Text;
              ExcelWorkSheet1.Cells.Item[nowhangi, ii].Font.Color := CurDS.Columns[i].Font.Color;
              //ExcelWorkSheet1.Cells.Item[nowhangi, ii].Interior.style := CurDS.Columns[i].Font.Style;
              ExcelWorkSheet1.Cells.Item[nowhangi, ii].Interior.Pattern:= 1;
//              if CurDS.Columns[i].Color = clBlack then
//              ExcelWorkSheet1.Cells.Item[nowhangi, ii].Interior.Color := clWhite else
//              ExcelWorkSheet1.Cells.Item[nowhangi, ii].Interior.Color := CurDS.Columns[i].Color;
              Inc(ii);
            end;
          datasource.DataSet.next;
        end;
        datasource.DataSet.First;
      end;

      //��Ҫ����ϼ���
      if vSum then
      begin
        ii := 0;
        if isGroups then
          k := 4
        else
          k := 3;
        nowhangi := nowhangi + 1;
        for i := 0 to liFieldNu - 1 do
          if CurDS.Columns.Items[i].Visible then
          begin
            if (CurDS.Columns[i].Field.DataType in [ftSmallint, ftInteger, ftFloat, ftCurrency, ftLargeint, ftFMTBcd, ftBCD]) then
              ExcelWorkSheet1.Cells.Item[nowhangi, ii + 1] := '=Sum(' + IntToChr(ii) + IntToStr(k) + ':' + IntToChr(ii) + Trim(IntToStr(nowhangi - 1)) + ')';
            Inc(ii);
          end;
        ii := 0;
        for i := 0 to liFieldNu - 1 do
          if CurDS.Columns.Items[i].Visible then
          begin
            if (CurDS.Columns[i].Field.DataType in [ftString, ftwidestring, ftMemo]) then
            begin
              ExcelWorkSheet1.Cells.Item[nowhangi, ii + 1] := '�ϼ�';
              ExcelWorkSheet1.Cells.Item[nowhangi, ii + 1].HorizontalAlignment := xlCenter;
              Break;
            end;
            Inc(ii);
          end;
      end;
      //����Ԫ��߿�
      if isGroups then  //����������
        k := 3
      else
        k := 2;
      if vSum then
        ii := liRecNu + k + 1
      else
        ii := liRecNu + k;
      with ExcelApplication1.Range['A' + IntToStr(2), cols + IntToStr(ii)].Borders do //����Ԫ��߿�
      begin
        LineStyle := xlContinuous;
        Weight := xlThin;
        ColorIndex := xlAutomatic;
      end;

      ExcelWorkbook1.SaveCopyAs(lsFile);
      HideLodingMessage;
      ShowMsbInfo('������ɣ�','info');
      //ShowMsbInfo('�����ѳɹ�������' + lsFile + '��','info');
    except
      HideLodingMessage;
      Application.MessageBox('������EXCELʧ�ܣ�', '����', MB_ICONHAND);
      CurDS.datasource.DataSet.EnableControls;
    end;
  finally
    HideLodingMessage;
    CurDS.datasource.DataSet.EnableControls;
    ExcelApplication1.DisplayAlerts[LCID] := False;
    ExcelApplication1.Quit;
    ExcelWorkSheet1.Disconnect;
    ExcelWorkbook1.Disconnect;
    ExcelApplication1.Disconnect;
    //HideLodingMessage;

    if not VarIsNull(MultiArr) then VarClear(MultiArr);
    Screen.Cursor := crDefault;
  end;
end;

procedure AddValueToCombobox(qryTemp: TADOQuery; strSQL: string; Combox: TCustomComboBox);
begin
  if strSQL = '' then Exit;
  Combox.Items.Clear;

  with qryTemp do
  begin
    Close;
    SQL.Text := strSQL;
    try
      Open;
      DisableControls;
      First;
      if RecordCount > 0 then
      while Not Eof do
      begin
        Combox.Items.Add(Trim(PChar(Fields[0].AsString)));
        Next;
      end;
      //Combox.ItemIndex := 0;
      EnableControls;
    except
    end;
  end;
end;
//һ��Ҫ������ID����Name��˳����
procedure AddValueToComboboxByID(qryTemp: TADOQuery; strSQL: string;Combox: TCustomComboBox);
var
  i: Integer;
  sID: PString;
begin
  if strSQL = '' then Exit;
  Combox.Items.Clear;

  with qryTemp do
  begin
    Close;
    SQL.Text := strSQL;
    try
      Open;
      DisableControls;
      First;
      if RecordCount > 0 then
      while Not Eof do
      begin
        New(sID);
        sID^ := Fields[0].AsString;
        Combox.Items.AddObject(Fields[1].AsString,TObject(sID^)); //ָ������ַ
        Next;
      end;
      Combox.ItemIndex := 0;
      EnableControls;
    except
      EnableControls;
    end;
  end;
end;

function GetComboboxID(Combox:TCustomComboBox): string;
begin
  if Combox.ItemIndex >= 0 then
  Result := string(Combox.Items.Objects[Combox.ItemIndex])
  else Result := '';
  //Result := PChar(string(Combox.Items.Objects[Combox.ItemIndex]));
end;

function SetComboboxValue(Combox:TCustomComboBox;ID:string): Boolean;
var
  i:Integer;
begin
  Result := False;
  Combox.ItemIndex := -1;
  if Combox.Items.Count >= 0 then
  for i := 0 to Pred(Combox.Items.Count) do
  begin
    if SameText(string(Combox.Items.Objects[i]),ID) then
    begin
      Combox.ItemIndex := i;
      Result := True;
      Exit;
      //Combox.SelText := Combox.Items.Strings[i];
    end;
  end;
  //Result := PChar(string(Combox.Items.Objects[Combox.ItemIndex]));
end;

function CashSmallToBig(small: Real): string;
//Сд���ת��Ϊ��д���
var
    SmallMonth, BigMonth :string;
    wei1, qianwei1 :string[2];
    wei,qianwei,dianweizhi,qian:integer;
begin
  Result := '';
  {------- �޸Ĳ�����ֵ����ȷ -------}
  {С������λ��,��Ҫ�Ļ�Ҳ���ԸĶ���ֵ}
  qianwei:=-2;
  {ת���ɻ�����ʽ,��Ҫ�Ļ�С�����Ӷ༸����}
  Smallmonth:=formatfloat('0.00',small);
  BigMonth := '';
  {---------------------------------}
  dianweizhi :=pos('.',Smallmonth);{С�����λ��}
  {ѭ��Сд���ҵ�ÿһλ,��Сд���ұ�λ�õ����}
  for qian:=length(Smallmonth) downto 1 do
  begin
    {��������Ĳ���С����ͼ���}
    if qian<>dianweizhi then
    begin
      {λ���ϵ���ת���ɴ�д}
      case strtoint(copy(Smallmonth,qian,1)) of
        1:wei1:='Ҽ';
        2:wei1:='��';
        3:wei1:='��';
        4:wei1:='��';
        5:wei1:='��';
        6:wei1:='½';
        7:wei1:='��';
        8:wei1:='��';
        9:wei1:='��';
        0:wei1:='��';
      end;
      {�жϴ�дλ��,���Լ�������real���͵����ֵ}
      case qianwei of
        -3:qianwei1:='��';
        -2:qianwei1:='��';
        -1:qianwei1:='��';
        0 :qianwei1:='Ԫ';
        1 :qianwei1:='ʰ';
        2 :qianwei1:='��';
        3 :qianwei1:='ǧ';
        4 :qianwei1:='��';
        5 :qianwei1:='ʰ';
        6 :qianwei1:='��';
        7 :qianwei1:='ǧ';
        8 :qianwei1:='��';
        9 :qianwei1:='ʮ';
        10:qianwei1:='��';
        11:qianwei1:='ǧ';
      end;
      inc(qianwei);
      BigMonth :=wei1+qianwei1+BigMonth;{��ϳɴ�д���}
    end;
  end;
  Result:=BigMonth;
end;

procedure OpenNormalForm(AForm:TCustomForm;const AFormClass:TFormClass);
  function IsExistForm:Boolean;
  var
    i:Integer;
  begin
    Result:=False;
    for i :=0 to Screen.FormCount-1 do
    begin
      if Screen.Forms[i].ClassType=AFormClass then
      begin
        Result:=True;
        AForm:=TForm(Screen.Forms[i]);
        Break;
      end;
    end;
  end;
begin
  try
    if not IsExistForm then
    begin
      AForm:=AFormClass.Create(nil);
      AForm.ShowModal;
    end else
    begin
      ShowWindow(AForm.Handle,SW_NORMAL);
      AForm.BringToFront;
      AForm.ShowModal;
    end;
  finally
    AForm.Free;
  end;
end;

procedure OpenChildForm(FormClass: TFormClass; var Fm; AOwner: TComponent);
var
  i: integer;
  Child: TForm;
begin
  for i := 0 to Screen.FormCount - 1 do
  if Screen.Forms[i].ClassType = FormClass then
  begin
    Child := Screen.Forms[i];
    if Child.WindowState = wsMinimized then
      ShowWindow(Child.handle, SW_SHOWMAXIMIZED)
    else
      ShowWindow(Child.handle, SW_SHOWMAXIMIZED);
    if (not Child.Visible) then Child.Visible := True;
    Child.BringToFront;
    Child.Setfocus;
    TForm(Fm) := Child;
    exit;
  end;
  Child := TForm(FormClass.NewInstance);
  TForm(fm) := Child;
  Child.Create(AOwner);
  Child.WindowState := wsMaximized;
end;

//��ĳ����Parent������пؼ��������뷨ΪimDontCare, ������.
procedure DontCareIme(Parent: TWinControl);
var
  Ctrl: TControl;
  i: Integer;
begin
    if Assigned(GetPropInfo(Parent, 'ImeMode')) then
    begin
        SetStrProp(Parent, 'ImeMode', 'imDontCare');
        SetStrProp(Parent, 'ImeName', '');
    end;
    for i := 0 to Parent.ControlCount - 1 do
    begin
        Ctrl := Parent.Controls[i];
        if Ctrl is TWinControl then
            DontCareIme(TWinControl(Ctrl));
    end;
end;

procedure OpenChildForm(FormClass: TCustomFormClass; var Form; bDontCareIme: Boolean);
var
    Data: TDataModule;
    i, j: Integer;
    Comp, MesComp: TComponent;
    SaveCursor: TCursor;
begin
    MesComp := nil;
    Application.ProcessMessages;
    if Pos('$' + FormClass.ClassName + '$', '$' + sOpenWindowClassStr + '$') > 0 then Exit; //cyw 09.1.15
    sOpenWindowClassStr := sOpenWindowClassStr + FormClass.ClassName + '$';                 //cyw 09.1.15
    SaveCursor := Screen.Cursor;                                                            //cyw 09.1.15
    try
        //Screen.Cursor := crHourGlass;                                                       //cyw 09.1.15
        if Assigned(Application.MainForm) then
            LockWindowUpdate(Application.MainForm.ClientHandle);

        if Assigned(TCustomForm(Form)) then
        begin
            if TCustomForm(Form).WindowState = wsMinimized then
                TCustomForm(Form).Perform(WM_SYSCOMMAND, SC_RESTORE, 0);
        end
        else
        begin
            TCustomForm(Form) := FormClass.Create(Application);
            TCustomForm(Form).WindowState :=  wsMaximized;//Ĭ�����
            if bDontCareIme then DontCareIme(TCustomForm(Form));
        end;
        TCustomForm(Form).BringToFront;
    finally
        LockWindowUpdate(0);
        Screen.Cursor := SaveCursor;
        sOpenWindowClassStr := StringReplace(sOpenWindowClassStr, FormClass.ClassName + '$', '', [rfIgnoreCase]); //cyw 09.1.15
    end;
end;

function ExcuteExe(Exe_Dir: string): Boolean;
var
  ScommandLine: string;
  LpStartUpInfo: TStartupInfo;
  LpProcessInformation: TProcessInformation;
begin
  try
    ScommandLine := exe_dir;
    Fillchar(LpStartUpInfo, sizeof(TStartupInfo), #0);
    LpStartUpInfo.cb := SizeOf(TStartupInfo);
    LpStartUpInfo.dwflags := STARTF_USESHOWWINDOW;
    LpStartUpInfo.wshowwindow := SW_NORMAL;
    CreateProcess(nil, Pchar(ScommandLine), nil, nil, True, CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS,
      nil, nil, LpStartUpInfo, LpProcessInformation);
    Result := True;
  except
    Result := False;
  end;
end;

procedure CreateMapFile;
begin
  hMapFile := OpenFileMapping(FILE_MAP_ALL_ACCESS, False, PChar(MapFileName));
  if hMapFile = 0 then
  begin
    hMapFile := CreateFileMapping($FFFFFFFF, nil, PAGE_READWRITE, 0,
      SizeOf(TShareMem), MapFileName);
    PSMem := MapViewOfFile(hMapFile, FILE_MAP_WRITE or FILE_MAP_READ, 0, 0, 0);
    if PSMem = nil then
    begin
      CloseHandle(hMapFile);
      Exit;
    end;
    PSMem^.AppHandle := 0;
  end
  else begin
    PSMem := MapViewOfFile(hMapFile, FILE_MAP_WRITE or FILE_MAP_READ, 0, 0, 0);
    if PSMem = nil then
    begin
      CloseHandle(hMapFile);
    end
  end;
end;

procedure FreeMapFile;
begin
  UnMapViewOfFile(PSMem);
  CloseHandle(hMapFile);
end;

function CheckAppHasRun(AppHandle: THandle): Boolean;
var
  TopWindow: HWnd;
begin
  Result := False;
  if PSMem <> nil then
  begin
    if PSMem^.AppHandle <> 0 then
    begin
      SendMessage(PSMem^.AppHandle, WM_SYSCOMMAND, SC_RESTORE, 0);
      TopWindow := GetLastActivePopup(PSMem^.AppHandle);
      if (TopWindow <> 0) and (TopWindow <> PSMem^.AppHandle) and
        IsWindowVisible(TopWindow) and IsWindowEnabled(TopWindow) then
        SetForegroundWindow(TopWindow);
      Result := True;
    end
    else
      PSMem^.AppHandle := AppHandle;
  end;
end;


function FindProcess(AFileName: string): boolean;
var
  hSnapshot: THandle;//���ڻ�ý����б�
  lppe: TProcessEntry32;//���ڲ��ҽ���
  Found: Boolean;//�����жϽ��̱����Ƿ����
begin
  Result :=False;
  hSnapshot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS,   0);//���ϵͳ�����б�
  lppe.dwSize := SizeOf(TProcessEntry32);//�ڵ���Process32First   API֮ǰ����Ҫ��ʼ��lppe��¼�Ĵ�С
  Found := Process32First(hSnapshot, lppe);//�������б�ĵ�һ��������Ϣ����ppe��¼��
  while Found do
  begin
    if ((UpperCase(ExtractFileName(lppe.szExeFile))=UpperCase(AFileName))   or   (UpperCase(lppe.szExeFile   )=UpperCase(AFileName)))   then
    begin
      Result :=True;
    end;
    Found := Process32Next(hSnapshot, lppe);//�������б����һ��������Ϣ����lppe��¼��
  end;
end;

procedure EndProcess(AFileName: string);
const
  PROCESS_TERMINATE = $0001;
var
  ContinueLoop: BOOL;
  FSnapShotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  FSnapShotHandle := CreateToolhelp32SnapShot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  while integer(ContinueLoop) <> 0 do
  begin
      if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile))=UpperCase(AFileName)) or (UpperCase(FProcessEntry32.szExeFile )=UpperCase(AFileName))) then
      TerminateProcess(OpenProcess(PROCESS_TERMINATE, BOOL(0),FProcessEntry32.th32ProcessID), 0);
      ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
end;

function ShowMsbInfo(AMsg,IType: string): Boolean;
begin
  Result := False;
  if UpperCase(IType) = 'SUCCESS' then  //�ɹ�
    Application.MessageBox(Pchar(AMsg), '���', MB_ICONINFORMATION + MB_OK)
  else if UpperCase(IType) = 'ERROR' then //����
     Application.MessageBox(Pchar(AMsg), '����', MB_ICONSTOP + MB_OK)
  else if UpperCase(IType) = 'ASK' then  //ѯ��
    if Application.MessageBox(Pchar(AMsg), 'ȷ��',
      MB_ICONQUESTION + MB_YESNO) = IDYES then
      result := true else result := false
  else if UpperCase(IType) = 'INFO' then  //��ʾ
    Application.MessageBox(Pchar(AMsg), '��ʾ', MB_ICONINFORMATION + MB_OK);
end;

procedure HideTaskbar; //����
var
  wndHandle: THandle;
  wndClass: array[0..50] of Char;
begin
  StrPCopy(@wndClass[0], 'Shell_TrayWnd');
  wndHandle := FindWindow(@wndClass[0], nil);
  ShowWindow(wndHandle, SW_HIDE);
End;

procedure ShowTaskbar; //��ʾ
var
  wndHandle: THandle;
  wndClass: array[0..50] of Char;
begin
  StrPCopy(@wndClass[0], 'Shell_TrayWnd');
  wndHandle := FindWindow(@wndClass[0], nil);
  ShowWindow(wndHandle, SW_RESTORE);
end;

procedure DisableTask(Key: Boolean);  //��ֹ
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_CURRENT_USER;
  if Reg.OpenKey('\Software\MicroSoft\Windows\CurrentVersion\Policies\System',True) then
  begin
    if Key then
      Reg.WriteString('DisableTaskMgr','1')
    else
      Reg.WriteInteger('DisableTaskMgr',0);
    Reg.CloseKey;
  end;
  Reg.Free;
end;

//**********��ʾ������һ������start**********//
procedure DrawSegment(Canvas: TCanvas; dSegNum : Integer;const SegmentRect : TRect);
const
  cBorderGap = 1;  //�߽���
  cSegmentThickness = 2; //ÿ���������
  cHorzMargine = 1; //ˮƽ�����߽�����
  cVertMargine = 1; //��ֱ�����߽�����
var
   Ht,Lt,Rt,Tp,Bt,VertCentre, SegHalf : Integer;
   fPoints   : array [1..6] of TPoint;
begin
  Ht := SegmentRect.Bottom - SegmentRect.Top;
  Lt := SegmentRect.Left+cBorderGap;
  Rt := SegmentRect.Right-cBorderGap - 1 - (cSegmentThickness * 2); //move in a seg and a half
  Tp := SegmentRect.Top+cBorderGap;
  Bt := Ht-cBorderGap-1 +  SegmentRect.Top;

  VertCentre := ((Bt - Tp) div 2);
  SegHalf    := (cSegmentThickness div 2);

  case dSegNum of
    0 :
    begin
      fPoints[1].x := Rt + cSegmentThickness{SegHalf};
      fPoints[1].y := Bt - (VertCentre div 2);// - (cSegmentThickness * 2);
      fPoints[2].x := Rt + SegHalf + cSegmentThickness * 2;// - (SegHalf + cSegmentThickness);
      fPoints[2].y := Bt;
      Canvas.Ellipse(fPoints[1].x, fPoints[1].y, fPoints[2].x, fPoints[2].y);
    end;
    3 :
    begin
      fPoints[1].x := Lt + cHorzMargine;
      fPoints[1].y := Tp;

      fPoints[2].x := Rt - cHorzMargine;
      fPoints[2].y := Tp;
      fPoints[3].x := fPoints[2].x - cSegmentThickness;
      fPoints[3].y := fPoints[2].y + cSegmentThickness;
      fPoints[4].x := fPoints[1].x + cSegmentThickness;
      fPoints[4].y := fPoints[1].y + cSegmentThickness;
      Canvas.Polygon(Slice(fPoints,4));
    end;
    4 :
    begin
      fPoints[1].x := Lt ;
      fPoints[1].y := Tp+cVertMargine;
      fPoints[2].x := Lt;
      fPoints[2].y := Tp+VertCentre-cVertMargine;
      fPoints[3].x := fPoints[2].x + cSegmentThickness;
      fPoints[3].y := fPoints[2].y - cSegmentThickness;
      fPoints[4].x := fPoints[1].x + cSegmentThickness;
      fPoints[4].y := fPoints[1].y + cSegmentThickness;
      Canvas.Polygon(Slice(fPoints,4));
    end;
    5:
    begin
      fPoints[1].x := Lt ;
      fPoints[1].y := Tp+cVertMargine+VertCentre;
      fPoints[2].x := Lt;
      fPoints[2].y := Tp+VertCentre-cVertMargine+VertCentre;
      fPoints[3].x := fPoints[2].x + cSegmentThickness;
      fPoints[3].y := fPoints[2].y - cSegmentThickness;
      fPoints[4].x := fPoints[1].x + cSegmentThickness;
      fPoints[4].y := fPoints[1].y + cSegmentThickness;
      Canvas.Polygon(Slice(fPoints,4));
    end;
    6:
    begin
      fPoints[1].x := Lt + cHorzMargine;
      fPoints[1].y := Tp+VertCentre+VertCentre;
      fPoints[2].x := Rt - cHorzMargine;
      fPoints[2].y := fPoints[1].y;
      fPoints[3].x := fPoints[2].x - cSegmentThickness;
      fPoints[3].y := fPoints[2].y - cSegmentThickness;
      fPoints[4].x := fPoints[1].x + cSegmentThickness;
      fPoints[4].y := fPoints[1].y - cSegmentThickness;
      Canvas.Polygon(Slice(fPoints,4));
    end;
    2:
    begin

      fPoints[1].x := Rt;
      fPoints[1].y := Tp+cVertMargine;
      fPoints[2].x := fPoints[1].x;
      fPoints[2].y := Tp+VertCentre-cVertMargine;
      fPoints[3].x := fPoints[2].x - cSegmentThickness;
      fPoints[3].y := fPoints[2].y - cSegmentThickness;
      fPoints[4].x := fPoints[1].x - cSegmentThickness;
      fPoints[4].y := fPoints[1].y + cSegmentThickness;
      Canvas.Polygon(Slice(fPoints,4));
    end;
    7:
    begin
      fPoints[1].x := Rt;
      fPoints[1].y := Tp+cVertMargine+VertCentre;
      fPoints[2].x := fPoints[1].x;
      fPoints[2].y := Tp+VertCentre-cVertMargine+VertCentre;
      fPoints[3].x := fPoints[2].x - cSegmentThickness;
      fPoints[3].y := fPoints[2].y - cSegmentThickness;
      fPoints[4].x := fPoints[1].x - cSegmentThickness;
      fPoints[4].y := fPoints[1].y + cSegmentThickness;
      Canvas.Polygon(Slice(fPoints,4));
    end;   
    1:
    begin
      fPoints[1].x := Lt+cHorzMargine;
      fPoints[1].y := Tp+VertCentre;
      fPoints[2].x := fPoints[1].x + SegHalf;
      fPoints[2].y := Tp+VertCentre - SegHalf  ; // 1 is Pen size
      fPoints[3].x := Rt-cHorzMargine-SegHalf;
      fPoints[3].y := fPoints[2].y;
      fPoints[4].x := Rt-cHorzMargine;
      fPoints[4].y := fPoints[1].y;
      fPoints[5].x := Rt-cHorzMargine-SegHalf;
      fPoints[5].y := Tp+VertCentre + SegHalf;
      fPoints[6].x := fPoints[2].x;
      fPoints[6].y := fPoints[5].y ;
      Canvas.Polygon(fPoints);
    end;
  end;
end;

procedure ShowDigiInRect(Canvas: TCanvas; mRect: TRect; str : string; Color: TColor); //��ʾ������һ������
  function Padr(s : String;numPad : Integer) : String;
  var
     i,l: Integer;
  begin
    Result := '';
    l := numPad-Length(s);
    for i := 1 to l do
        Result := Result+'';
    Result := Result + s;
  end;

  procedure MakeSegments(dChar : Char;var dSegment : TCharSegment);
  begin
    dSegment := [];
    case dChar of
      '1':  dSegment := [2,7];
      '2':  dSegment := [3,2,1,5,6];
      '3':  dSegment := [3,2,1,7,6];
      '4':  dSegment := [4,1,2,7];
      '5':  dSegment := [3,4,1,7,6];
      '6':  dSegment := [3,4,5,6,7,1];
      '7':  dSegment := [3,2,7];
      '8':  dSegment := [3,4,5,6,7,2,1];
      '9':  dSegment := [3,4,1,2,7];
      '0':  dSegment := [3,4,5,6,7,2];
      '-':  dSegment := [1];
      '.':  dSegment := [0];
    end;
  end;

  procedure DrawSegments(Canvas: TCanvas; dSegment : TCharSegment;SegmentRect : TRect);
  var
    i: Byte;
  begin
    for i := 0 to 7 do
    if (byte(i) in dSegment) then
      DrawSegment(Canvas,i,SegmentRect);
  end;
const
  cNumChars = 2;
var
   MySeg  : TCharSegment;
   xPos, i : Integer;
   MyRect : TRect;
   csize  : Integer;
   s  : String;
   clFront, clBack : TColor;
begin
  s := Padr(str,cNumChars);
  cSize := (mRect.Right - mRect.Left) div Length(s);
  xPos := 0;
  clFront := canvas.Pen.Color ;
  clBack := canvas.Brush.Color;
  canvas.Brush.Color := Color;//clPurple; // ���ɫ
  canvas.Pen.Color := Color;//clPurple;//clLime; //ǰ��ɫ

  for i := 1 to Length(s) do
  begin
    MakeSegments(s[i],MySeg);
    MyRect.Top := mRect.Top;
    MyRect.Bottom := mRect.Bottom;
    MyRect.Left := mRect.Left + (xPos)*cSize;
    MyRect.Right:= MyRect.Left+cSize;
    DrawSegments(Canvas,MySeg,MyRect);
    Inc(xPos);
  end;
  Canvas.Pen.Color := clBlack;//clFront;
  Canvas.Brush.Color := clBack;
end;

function OpenDataSet(qry: TADOQuery; strSQL: string): Boolean;
var
  FErrorInfo: string;
begin
  Result := True;
  if Trim(strSQL) = '' then  begin
    ShowMsbInfo('��SQL��ѯ���!','INFO');
    Exit;
  end;

  with qry do
  Try
    Close;
    SQL.Clear;
    SQL.Add(strSQL);
    Open;
  Except
    on e: Exception do
    begin
      Result := False;
      FErrorInfo := e.Message;
      FErrorInfo := GetSQLErrorChineseInfo(FErrorInfo);
      Application.MessageBox(PChar(FErrorInfo), '����', MB_ICONERROR);
      Exit;
    end;
  end;
end;

function ExecuteSQL(qry:TADOQuery; strSQL: string):Boolean;
var
  FErrorInfo: string;
begin
  Result := False;
  if Trim(strSQL) = '' then  begin
    ShowMsbInfo('��SQL���!','INFO');
    Exit;
  end;
  //һ���漰���ݸ�����䣬ʹ������
  qry.Connection.BeginTrans;
  with qry do
  Try
    Close;
    SQL.Clear;
    SQL.Add(strSQL);
    ExecSQL;
    qry.Connection.CommitTrans;
    Result := True;
  Except
    on e: Exception do
    begin
      FErrorInfo := e.Message;
      FErrorInfo := GetSQLErrorChineseInfo(FErrorInfo);
      Application.MessageBox(PChar(FErrorInfo), '����', MB_ICONERROR);
      qry.Connection.RollbackTrans;
      Exit;
    end;
  end;
end;

function StartDate(Date: TDateTime): string;
begin
  Result := FormatDateTime('yyyy-MM-dd', StartOfTheDay(Date));
end;

function StartOfDate(Date: TDateTime): string;
begin
  Result := FormatDateTime('yyyy-MM-dd hh:mm:ss:zzz', StartOfTheDay(Date));
end;

function StartOfTheDate(Date: TDateTime): string;
begin
  Result := FormatDateTime('yyyy-MM-dd hh:mm:ss', StartOfTheDay(Date));
end;

function EndDate(Date: TDateTime): string;
begin
  Result := FormatDateTime('yyyy-MM-dd', EndOfTheDay(Date));
end;

function EndOfDate(Date: TDateTime): string;
begin
  Result := FormatDateTime('yyyy-MM-dd hh:mm:ss:zzz', EndOfTheDay(Date));
end;

function EndOfTheDate(Date: TDateTime): string;
begin
  Result := FormatDateTime('yyyy-MM-dd hh:mm:ss', EndOfTheDay(Date));
end;

procedure RefreshQuery(qry: TADOQuery); //ˢ��ADO���ݼ�
begin
  qry.Close;
  qry.Open;
end;

//ˢ�����ݼ���ˢ�º󷵻ص���ǰ״̬(��¼λ��)
procedure RefreshDataSet(DataSet: TDataSet);
var
  BM: TBookmark;
begin
  with DataSet do
  begin
    DisableControls;
    try
      if Active then BM := GetBookmark
      else BM := nil;
      try
        Close;
        Open;
        if (BM <> nil) and not (Bof and Eof) and BookmarkValid(BM) then
        try
          GotoBookmark(BM);
        except
        end;
      finally
        if BM <> nil then FreeBookmark(BM);
      end;
    finally
      EnableControls;
    end;
  end;
end;

procedure RefreshDataSetEX(DataSet: TDataSet; bDisableControls: Boolean);
var
  BM: TBookMark;
begin
    if bDisableControls then       //cyw 08.8.13
        DataSet.DisableControls;
    try
        BM := DataSet.GetBookMark;
        try
            DataSet.Close;
            DataSet.Open;
            if (not DataSet.IsEmpty) And Assigned(BM) then
            try
                if DataSet.BookmarkValid(BM) then  //cyw 08.4.29
                   DataSet.GotoBookMark(BM)
                else
                   DataSet.Last;
            except
                DataSet.First;
            end;
        finally
            DataSet.FreeBookMark(BM);
        end;
    finally
        if bDisableControls then   //cyw 08.8.13
            DataSet.EnableControls;
    end;
end;

//ˢ�����ݼ�MebTableEh��ˢ�º󷵻ص���ǰ״̬(��¼λ��)
procedure RefreshMemTable(DataSet: TDataSet);
var
  BM: TBookmark;
begin
  with DataSet do
  begin
    if DataSet.RecordCount > 0 then BM := GetBookmark
    else BM := nil;
    try
      Close;
      Active := True;
      if (BM <> nil) and not (Bof and Eof) and BookmarkValid(BM) then
      try
        GotoBookmark(BM);
      except
      end;
    finally
      if BM <> nil then FreeBookmark(BM);
    end;
  end;
end;

procedure IntegerOnly(var Key: Char);
begin
  if not (Key in ['0'..'9', ^C, ^V, Chr(VK_BACK), Chr(VK_RETURN)]) then
    Key := #0;
end;

procedure NumberOrLetterOnly(var Key: Char);
begin
  if not (Key in ['0'..'9', 'a'..'z', 'A'..'Z', #8, #13, ^C, ^V, Chr(VK_BACK), Chr(VK_RETURN)]) then
    Key := #0;
end;

procedure FloatOnly(var Key: Char; iText: String);
begin
  if not (Key in ['0'..'9', '.','-', ^C, ^V, Chr(VK_BACK), Chr(VK_RETURN)]) then
    Key := #0;

  if (Key = '.') and (Pos('.', iText) > 0) then
    Key := #0;
end;

function IsNumber(str: string): Boolean;
var
  i: Integer;
begin
  Result := False;
  if Trim(str) = '' then Exit;
  for i := 1 to Length(str) do
  if (str[i] in ['0'..'9']) then Result := True;
end;


function IsFloat(str:string): Boolean;
var
  i, j, k: Integer;
  tmpStr: string;
begin
  Result := True;
  if Trim(str) = '' then Exit;
  j:= 0; k:=0;
  //ֻ����һ��.�Ż�-��
  for i := 1 to Length(str) do begin
    if not (str[i] in ['0'..'9','.','-']) then
    begin
      Result := False;
      Exit;
    end;
    if (str[i] = '.') then Inc(j);
    if (str[i] = '-') then Inc(k);
  end;
  if j > 1 then begin Result := False; Exit; end;
  if k > 1 then begin Result := False; Exit; end;

  //-��ֻ������λ
  if Pos('-', str) > 1 then begin Result := False; Exit; end;

  //��β����Ϊ.
  if (str[1] = '.') or (str[Length(str)] = '.') then begin Result := False; Exit; end;

  //�������λ��������Ϊ��;
  tmpStr := Copy(str,1,Pos('.',str)-1);
  j := 0;
  if Length(str) > 1 then
  for i := 1 to Length(tmpStr) do if (tmpStr[1] = '0') and (tmpStr[2] = '0')
  then begin Result := False; Exit; end;

  //������λΪ�㣬�����Ϊ��λ����С��
  tmpStr := Copy(str,1,Pos('.',str)-1);
  if Length(tmpStr) > 1 then
  for i := 1 to Length(tmpStr) do if tmpStr[1] = '0' then begin Result := False; Break; Exit; end;
end;

function IsNumeric(Value: string; const AllowFloat: Boolean;
  const TrimWhiteSpace: Boolean = True): Boolean;
var
  ValueInt: Int64;
  ValueFloat: Extended;
begin
  if TrimWhiteSpace then
    Value := SysUtils.Trim(Value);
  // Check for valid integer
  Result := SysUtils.TryStrToInt64(Value, ValueInt);
  if not Result and AllowFloat then
    // Wasn't valid as integer, try float
    Result := SysUtils.TryStrToFloat(Value, ValueFloat);
end;


function GetServerDateTime(qry: TADOQuery): TDateTime;
begin
  with qry do
  begin
    SQL.Text := 'Select GetDate() As ServerDateTime';
    Open;
    Result := FieldByName('ServerDateTime').AsDateTime;
    Close;
  end;
end;

function GetMonthOfDate(ReturnType: Integer): TDateTime; overload;
var
  Year,Month,Day1, Day2:Word;
  NewDate:TDateTime;
begin
  DecodeDate(Now, Year,Month,Day1);
  case ReturnType of
    0: NewDate := StartOfTheMonth(Now);                 // This Month First Day
    1: NewDate := EndOfTheMonth(Now);                   // This Month Last Day
    3:                                                  // Last Month First Day
    begin
      DecodeDate(Now-Day1,Year,Month,Day2);
      NewDate := StrToDate(FormatDateTime('yyyy-MM-dd',Now - Day1 - Day2 + 1));
    end;      
    4: NewDate := EncodeDate(Year,Month - 1, Day1);      // Last Month Today
    5: NewDate := EncodeDate(Year,Month,1)-1;            // Last Month Last Day
    6: NewDate := EncodeDate(Year - 1, Month ,1);        // Last Year This Day
    7: NewDate := EncodeDate(Year - 1, Month - 1, Day1); // Last Year Last Month Today
    8: NewDate := EncodeDate(Year - 1, Month, 1)-1;      // Last Year Last Month Last Day
    9: NewDate := EncodeDate(Year, Month, Day1);         // This Month This Day
    10: NewDate := EncodeDate(Year, Month, Day1) -1;     //Yesterday
  end;
  Result := NewDate;
end;

function GetMonthOfDate(InputDate: TDateTime ;ReturnType: Integer): TDateTime; overload;
var
  Year,Month,Day1, Day2:Word;
  NewDate:TDateTime;
begin
  DecodeDate(InputDate, Year,Month,Day1);
  case ReturnType of
    0: NewDate := EncodeDate(Year, Month, 1);           // This InputDate Month First Day
    1: NewDate := EncodeDate(Year, Month + 1, 1) -1;    // This InputDate Month Last Day
    3:                                                  // Last InputDate Month First Day
    begin
      DecodeDate(Now-Day1,Year,Month,Day2);
      NewDate := StrToDate(FormatDateTime('yyyy-MM-dd',Now - Day1 - Day2 + 1));
    end;
    4: NewDate := EncodeDate(Year,Month - 1, Day1);      // Last InputDate Month Today
    5: NewDate := EncodeDate(Year,Month,1)-1;            // Last InputDate Month Last Day
    6: NewDate := EncodeDate(Year - 1, Month ,1);        // Last InputDate Year This Day
    7: NewDate := EncodeDate(Year - 1, Month - 1, Day1); // Last InputDate Year Last Month Today
    8: NewDate := EncodeDate(Year - 1, Month, 1)-1;      // Last InputDate Year Last Month Last Day
    9: NewDate := EncodeDate(Year, Month, Day1);         // This InputDate Month This Day
    10: NewDate := EncodeDate(Year, Month, Day1) -1;     //InputDate Yesterday
  end;
  Result := NewDate;
end;

function IsCheckNull(Container: TWinControl; DefaultCheckBox: TCheckBox = nil): Boolean;
var
  AControl: TControl;
  I: Integer;
begin
  Result := False;
  with Container do
  begin
    for I := 0 to ControlCount - 1 do
    begin
      AControl := Controls[I];
      if AControl is TCheckBox then
        Result := Result or TCheckBox(AControl).Checked;//���� Result := TCheckBox(AControl).Checked��
      if Result then Exit;
    end;
  end;
  if AsSigned(DefaultCheckBox) then DefaultCheckBox.Checked := True;
  raise Exception.Create('Ϊ����߲�ѯ�ٶȣ�������ѡ��һ����ѯ������');
end;

//�ַ�ת��UTF-8����
function DecodeUtf8Str(const S:UTF8String): WideString;
var
  lenSrc,lenDst: Integer;
begin
  lenSrc  := Length(S);
  if(lenSrc=0)then Exit;
  lenDst  := MultiByteToWideChar(CP_UTF8, 0, Pointer(S),lenSrc, nil, 0);
  SetLength(Result, lenDst);
  MultiByteToWideChar(CP_UTF8, 0, Pointer(S),lenSrc, Pointer(Result), lenDst);
end;

//����ĳһ��������Դ���г��ֵĴ���
function SubStrCount(MainStr,SubStr: string): Integer;
var  
  iCount,i:integer;
  Str:string;
begin
  Result := 0;
  if Length(MainStr) = 0 then Exit;
  iCount:=0;
  str:=trim(MainStr);
  for i:= 0 to StrLen(Pchar(Str)) do begin
    if Copy(Str,i,1)=SubStr then iCount:=iCount+1;
  end;
  Result := iCount;
end;

//ͨ���ָ�����ȡ�����Ӵ�
function SplitStr(const Source,Split:string):TStringList;
var
  Temp:String;
  i:Integer;
begin
  Result:=TStringList.Create;
  if Source='' then exit;
  Temp:=Source;
  i:=pos(Split,Source);
  while i<>0 do
  begin
     Result.add(copy(Temp,0,i-1));
     Delete(Temp,1,i+Length(Split)-1);
     i:=Pos(Split,Temp);
  end;
  Result.Add(Temp);
end;

//���ַ����е�ָ���Ӵ��滻���ض��Ӵ�������һ�����ַ���
function SubStrReplace(MainStr,SubStr,ReplaceStr:String):String;
var
  Instr,SubLen,MainLen:Integer;
  Templ,Tempr:String;
begin
  SubLen:=length(substr);
  MainLen:=length(MainStr);
  if (SubLen=0) or (SubLen>MainLen) or (SubStr=ReplaceStr) then
  begin
    Result:=MainStr;
    Exit;
  end;
  while pos(substr,MainStr)<>0 do
  begin
    Instr:=pos(SubStr,MainStr);
    Templ:=Copy(MainStr,1,instr-1);
    Tempr:=Copy(MainStr,instr+SubLen,MainLen);
    MainStr:=Templ+ReplaceStr+Tempr;
  end;
  Result:=MainStr;
end;

//���ַ����е�ָ���Ӵ��滻���ض��Ӵ�������һ�����ַ�������ɱMemo�Ļس������У��ո������ַ���
procedure ReplaceMeoToStr(var s:string;const SourceChar:pchar;const RChar:pchar);
//�����ַ�����Ҫ�滻���ַ����滻���ַ�
var
  ta,i,j:integer;
  m,n,pn,sn:integer;
  SLen,SCLen,RCLen:integer;//SLen�����ַ����ĳ��ȣ�SCLen��ʾҪ�滻�ַ����ĳ��ȣ�RCLen��ʾ�滻���ַ����ĳ���
  IsSame:integer;
  newp:array of char;//�����滻����ַ�����
begin
  SLen:=strlen(pchar(s));SCLen:=strlen(SourceChar);RCLen:=strlen(RChar);
  j:=pos(string(SourceChar),s);
  s:=s+chr(0);ta:=0;i:=j;
  while s[i]<>chr(0) do   //���ѭ����taͳ��ģʽ����ԭ���г��ֵĴ���
  begin
    n:=0;IsSame:=1;
    for m:=i to i+SCLen-1 do
    begin
      if m>SLen then begin IsSame:=0;break; end;
      if s[m]<>sourceChar[n] then begin IsSame:=0;break; end;
      n:=n+1;
    end;
    if IsSame=1 then begin ta:=ta+1;i:=m; end else i:=i+1;
  end;
  if j>0 then
  begin
    pn:=0;sn:=1;
    setlength(newp,SLen-ta*SCLen+ta*RCLen+1);//����newp�ĳ��ȣ�+1��ʾ���滹��һ��#0������
    while s[sn]<>chr(0) do //��Ҫѭ������ʼ�滻
    begin
      n:=0;IsSame:=1;
      for m:=sn to sn+SCLen-1 do //�Ƚ��Ӵ��Ƿ��ģʽ����ͬ
      begin
        if m>SLen then begin IsSame:=0;break; end;
        if s[m]<>sourceChar[n] then begin IsSame:=0;break; end;
        n:=n+1;
      end;
      if IsSame=1 then//��ͬ
      begin
        for m:=0 to RCLen-1 do
        begin
        newp[pn]:=RChar[m];pn:=pn+1;
        end;
        sn:=sn+SCLen;
      end
      else
      begin //��ͬ
        newp[pn]:=s[sn];
        pn:=pn+1;sn:=sn+1;
      end;
    end;
    newp[pn]:=#0;
    s:=string(newp); //����s���滻��ɣ�
  end;
end;

//ɾ��StringList�����ظ�����Ŀ
procedure DelStrListDuplicates(const AStringList : TStringList);
var
 buffer: TStringList;
 cnt: Integer;
begin
  AStringList.Sort;
  buffer := TStringList.Create;
  try
    buffer.Sorted := True;
    buffer.Duplicates := dupIgnore;
    buffer.BeginUpdate;
    for cnt := 0 to Pred(AStringList.Count) do
    buffer.Add(AStringList[cnt]) ;
    buffer.EndUpdate;
    AStringList.Assign(buffer) ;
  finally
    FreeandNil(buffer) ;
  end;
end;

//���TstringList��û���ظ����ַ���
procedure GetUniqueStringList(const AStringList: TStringList);
var
  CurrentString: string;
  LastString: string;
  Count: Integer;
  Index: Integer;
  UniqueList: TStringList;
begin
  Count := 1;
  LastString := '';

  try
    UniqueList := TStringList.Create;
    AStringList.Sorted := True;
    for Index := 0 to Pred(AStringList.Count) do
    begin
      CurrentString := AStringList[Index];
      if CurrentString = LastString then
        Count := Count + 1
      else
      begin
        if LastString <> '' then
        begin
          if Count = 1 then
            UniqueList.Add(LastString)
          else
            Count := 1;
        end;
      end;
      LastString := CurrentString;
    end;
    if Count = 1 then UniqueList.Add(LastString);
    AStringList.Assign(UniqueList);
  finally
    UniqueList.Free;
  end;
end;

//����ָ��Ŀ¼���ļ�������TStringList
procedure EnumFileInQueue(path: PChar; fileExt: string; fileList: TStringList);
var 
   searchRec: TSearchRec;
   found: Integer;
   tmpStr: string;  
   curDir: string;  
   dirs: TQueue;  
   pszDir: PChar;  
begin 
   dirs := TQueue.Create; //����Ŀ¼����
   dirs.Push(path); //����ʼ����·�����  
   pszDir := dirs.Pop;  
   curDir := StrPas(pszDir);
   //��ʼ����,ֱ������Ϊ��(��û��Ŀ¼��Ҫ����)
   while (True) do 
   begin 
      //����������׺,�õ�����'c:\*.*' ��'c:\windows\*.*'������·��  
      tmpStr := curDir + '\*.*';  
      //�ڵ�ǰĿ¼���ҵ�һ���ļ�����Ŀ¼  
      found := FindFirst(tmpStr, faAnyFile, searchRec);  
      while found = 0 do //�ҵ���һ���ļ���Ŀ¼��  
      begin 
          //����ҵ����Ǹ�Ŀ¼  
         if (searchRec.Attr and faDirectory) <> 0 then 
         begin 
          {�������Ǹ�Ŀ¼(C:\��D:\)�µ���Ŀ¼ʱ�����'.','..'��"����Ŀ¼"
          ����Ǳ�ʾ�ϲ�Ŀ¼���²�Ŀ¼�ɡ�����Ҫ���˵��ſ���} 
            if (searchRec.Name <> '.') and (searchRec.Name <> '..') then 
            begin
               {���ڲ��ҵ�����Ŀ¼ֻ�и�Ŀ¼��������Ҫ�����ϲ�Ŀ¼��·�� 
                searchRec.Name = 'Windows'; 
                tmpStr:='c:\Windows'; 
                �Ӹ��ϵ��һ������� 
               } 
               tmpStr := curDir + '\' + searchRec.Name;  
               {����������Ŀ¼��ӡ����������š� 
                ��ΪTQueue���������ֻ����ָ��,����Ҫ��stringת��ΪPChar 
                ͬʱʹ��StrNew������������һ���ռ�������ݣ������ʹ�Ѿ��� 
                ����е�ָ��ָ�򲻴��ڻ���ȷ������(tmpStr�Ǿֲ�����)��} 
               dirs.Push(StrNew(PChar(tmpStr)));  
            end;  
         end 
         else //����ҵ����Ǹ��ļ�  
         begin
            if fileExt = '.*' then
               fileList.Add(curDir + '\' + searchRec.Name)  
            else 
            begin 
               if SameText(RightStr(curDir + '\' + searchRec.Name, Length(fileExt)), fileExt) then
                  fileList.Add(curDir + '\' + searchRec.Name);  
            end;  
         end;  
          //������һ���ļ���Ŀ¼  
         found := FindNext(searchRec);  
      end;  
      {��ǰĿ¼�ҵ������������û�����ݣ����ʾȫ���ҵ��ˣ� 
        ������ǻ�����Ŀ¼δ���ң�ȡһ�������������ҡ�} 
      if dirs.Count > 0 then 
      begin 
         pszDir := dirs.Pop;  
         curDir := StrPas(pszDir);  
         StrDispose(pszDir);  
      end 
      else 
         break;  
   end;  
   //�ͷ���Դ  
   dirs.Free;  
   FindClose(searchRec);  
end;

//ת���ļ���ʱ���ʽ
function CovFileDate(Fd:_FileTime):TDateTime;
var
  SystemTime:_SystemTime;
  TempFileTime:_FileTime;
begin
  FileTimeToLocalFileTime(Fd,TempFileTime);
  FileTimeToSystemTime(TempFileTime,SystemTime);
  CovFileDate:=SystemTimeToDateTime(SystemTime);
end;

//��ȡ�ļ�ʱ�䣬Tf��ʾĿ���ļ�·��������
function GetFileTime(const Tf:string): string;
const
  TimeFormat='yyyy-MM-dd hh:mm:ss';
var 
  Tp:TSearchRec;
  T1,T2,T3:string;
begin
  Result := '';
  FindFirst(Tf,faAnyFile,Tp); //����Ŀ���ļ�
  //�����ļ��Ĵ���ʱ��
  T1:=FormatDateTime(TimeFormat,CovFileDate(Tp.FindData.ftCreationTime));
  //�����ļ����޸�ʱ��
  T2:=FormatDateTime(TimeFormat, CovFileDate(Tp.FindData.ftLastWriteTime));
  //�����ļ��ĵ�ǰ����ʱ��
  T3:=FormatDateTime(TimeFormat,Now);

  FindClose(Tp);
  Result := T2;
end;

//��ȡSQL�����ĳ�����Ϣ
function GetSQLErrorChineseInfo(ErrorInfo: string): string;
var
  sTemp: String;
Begin
  sTemp := ErrorInfo;
  sTemp := StringReplace(sTemp,
      '[Microsoft][ODBC SQL Server Driver][SQL Server]', '', [rfReplaceAll]);
  sTemp := StringReplace(sTemp,
      '[Microsoft][ODBC SQL Server Driver][SQL'#13#10'Server]', '', [rfReplaceAll]);
  sTemp := StringReplace(sTemp, 'General SQL error.'#13#10, '', [rfReplaceAll]);
  sTemp := StringReplace(sTemp, 'Key violation.'#13#10, '', [rfReplaceAll]);
  Result := sTemp;
end;

//�ϼ�DataSetָ���ֶ�
function FieldSumValue(DataSet: TDataSet; FieldName: string): Extended;
var
  BM: TBookmark;
  fn: TField;
begin
  Result := 0;
  with DataSet do
  begin
    BM := GetBookmark;
    fn := FieldByName(FieldName);  //��ȡ�ֶζ�Ӧ���е������б�
    DisableControls;
    try
      First;
      while not Eof do
      begin
        Result := Result + StrToFloatDef(fn.AsString, 0);
        Next;
      end;
    finally
      GotoBookmark(BM);
      //Bookmark := BM;
      EnableControls;
      FreeBookmark(BM);
    end;
  end;
end;
//��ʾ���ָ�����������ͣ��еĺϼ�ֵ
//�������ֶ���ֱ��ʹ�ö�Ӧ����Footer����
function FieldSumValueFooter(grd: TDBGridEh; FieldName: string;
  DisplayFormat: string = '#0.00'): string;
var
 cf: TColumnFooterEh;
begin
  with grd do
  begin
    grd.DataSource.DataSet.DisableControls;
    cf := FieldColumns[FieldName].Footer;  //��ȡ�ֶζ�Ӧ�ı�ŵ�Ԫ��
    cf.ValueType := fvtStaticText;         //�Ծ�̬�ı��ķ�ʽ��ʾ
    cf.Alignment := taRightJustify;        //������ʾ
    cf.Value := FormatFloat(DisplayFormat, //��ʽ��
      FieldSumValue(DataSource.DataSet, FieldName));
    grd.DataSource.DataSet.EnableControls;
  end;
  Result := cf.Value;
end;

function FieldFooterValue(grd: TDBGridEh; FieldName: string;
  FieldValue: string = '��'; DisplayFormat: string = '#0.00'): string;
//  function IsFloatValid(Value: string): Boolean;
//  var
//    i: Integer;
//    TempValue: Boolean;
//  begin
//    TempValue:=True;
//    for i:=1 to Length(Value) do
//    if not (Value[i] in ['-','.','1','2','3','4','5','6','7','8','9','0']) then
//    begin
//      TempValue:=False;
//      Break;
//    end;
//    Result:=TempValue;
//  end;
var
 cf: TColumnFooterEh;
begin
  with grd do
  begin
    cf := FieldColumns[FieldName].Footer;  //��ȡ�ֶζ�Ӧ�ı�ŵ�Ԫ��
    cf.ValueType := fvtStaticText;         //�Ծ�̬�ı��ķ�ʽ��ʾ
    cf.Alignment := taRightJustify;        //������ʾ
    if IsNumeric(FieldValue, True) then
      cf.Value := FormatFloat(DisplayFormat,StrToFloat(FieldValue))
    else cf.Value := FieldValue;
  end;
  Result := cf.Value;
end;

//����ؼ�ֵ��֧��ComboBox��Edit��RadioButton,CheckBox �����Ҫ�ٰ����¸�ʽ�ֶ��޸Ĵ���
procedure SaveIni(FormName: String; Cmb: TWinControl);
var
  IniFile: TIniFile;
  Value: String;
  bValue: Boolean;
begin
  if CreateIniFile(IniFile, GetIniFile)  then
  try
    if Not (Cmb is TCheckBox) then Begin
      if (Cmb is TComboBox) then
        Value := (Cmb As TComboBox).Text;
      if Cmb is TEdit then
        Value := Trim((Cmb As TEdit).Text);
      IniFile.WriteString(FormName,  Cmb.Name, Value);
      if (Cmb is TRadioButton) then Begin
        bValue := (Cmb As TRadioButton).Checked;
        IniFile.WriteBool(FormName, Cmb.Name, bValue);
      end;
    end else Begin
      bValue := (Cmb As TCheckBox).Checked;
      IniFile.WriteBool(FormName, Cmb.Name, bValue);
    end;
  finally
    IniFile.Free;
  end;
end;

procedure LoadIni(FormName: String; Cmb: TWinControl);
var
  IniFile: TIniFile;
begin
  if CreateIniFile(IniFile, GetIniFile)  then
  try
    if Not (Cmb is TCheckBox) then Begin
      if (Cmb is TComboBox) then
        (Cmb as TComboBox).Text := IniFile.ReadString(FormName, Cmb.Name, '');
      if Cmb is TEdit then
        (Cmb As TEdit).Text := IniFile.ReadString(FormName, Cmb.Name, '');
      if (Cmb is TRadioButton) then
        (Cmb As TRadioButton).Checked := IniFile.ReadBool(FormName, Cmb.Name, False);
    end else
      (Cmb As TCheckBox).Checked := IniFile.ReadBool(FormName, Cmb.Name, False);
  finally
    IniFile.Free;
  end;
end;

function GetLocalComputerIP: string;
var
   ch: array[1..32] of char;
   wsData: TWSAData;
   myHost: PHostEnt;
   i: integer;
begin
   Result := '';
  if WSAstartup(2,wsData)<>0 then Exit; // can��t start winsock
  try
    if GetHostName(@ch[1],32)<>0 then Exit; // getHostName failed
  except
     Exit;
  end;
   myHost := GetHostByName(@ch[1]); // GetHostName error
  if myHost=nil then exit;
  for i:=1 to 4 do
  begin
     Result := Result + IntToStr(Ord(myHost.h_addr^[i-1]));
    if i<4 then
       Result := Result + '.';
  end;
end;

function GetLocalComputerName: string;
var
   FStr: PChar;
   FSize: Cardinal;
begin
   FSize := 255;
   GetMem(FStr, FSize);
   Windows.GetComputerName(FStr, FSize);
   Result := FStr;
   FreeMem(FStr);
end;

function GetWinLogonName: string;
var
   FStr: PChar;
   FSize: Cardinal;
begin
   FSize := 255;
   GetMem(FStr, FSize);
   GetUserName(FStr, FSize);
   Result := FStr;
   FreeMem(FStr);
end;

//��ʾ������Ϣ
procedure ShowLodingMessage(Mes: String; BackgroundColorB: TColor = $00AFAF61; BackgroundColorE: TColor = $00FFFF80);
begin
  if not Assigned(frmLoding) then
    frmLoding := TfrmLoding.Create(Application);

  with frmLoding do
  begin
    bgdShowLoadingMsg.GradientColorStart := BackgroundColorB;
    bgdShowLoadingMsg.GradientColorStop := BackgroundColorE;
    lblTime.Color := BackgroundColorE;
    lblTime.Transparent := False;
    if Mes <> '' then
      pnlShowMessage.Caption := Mes
    else
      pnlShowMessage.Caption := 'ϵͳ���ڼ������ݣ����Ժ򡭡�';
    frmLoding.AutoFormSize;
    frmLoding.Show;
    pnlShowMessage.Repaint;
  end;
end;

//���ؼ�����Ϣ
procedure HideLodingMessage;
begin
  if Assigned(frmLoding) then
    FreeAndNil(frmLoding);
end;

//��ʾ���ڴ���
procedure ShowAboutForm(sysName, useUnit: string);
begin
  if not Assigned(frmState) then
    frmState := TfrmState.Create(Application);
  try
//    frmState.lbSysName.Caption := sysName;
//    frmState.lbUseUnit.Caption := UseUnit;
    frmState.Update;
    frmState.ShowModal;
  finally
    FreeAndNil(frmState);
  end;
end;

function ReturnToday(CurrTime: TDateTime): string;
var
  Year, Month, Day: Word;
const
  Days: array[1..7] of string = ('������','����һ','���ڶ�','������','������','������','������');
begin
  DecodeDate(CurrTime, Year, Month, Day);
  Result := IntToStr(Year) + '��'+ IntToStr(Month)+ '��'+ IntToStr(Day)  + '��'
    + ' '+Days[DayOfWeek(CurrTime)];
end;

function ChineseToLetter(const S: widestring): widestring;
  function GetLetter(const w: AnsiString): WideString;
  var
    i: Integer;
  begin
    case WORD(w[1]) shl 8 + WORD(w[2]) of
      $B0A1..$B0C4 : Result := 'A';
      $B0C5..$B2C0 : Result := 'B';
      $B2C1..$B4ED : Result := 'C';
      $B4EE..$B6E9 : Result := 'D';
      $B6EA..$B7A1 : Result := 'E';
      $B7A2..$B8C0 : Result := 'F';
      $B8C1..$B9FD : Result := 'G';
      $B9FE..$BBF6 : Result := 'H';
      $BBF7..$BFA5 : Result := 'J';
      $BFA6..$C0AB : Result := 'K';
      $C0AC..$C2E7 : Result := 'L';
      $C2E8..$C4C2 : Result := 'M';
      $C4C3..$C5B5 : Result := 'N';
      $C5B6..$C5BD : Result := 'O';
      $C5BE..$C6D9 : Result := 'P';
      $C6DA..$C8BA : Result := 'Q';
      $C8BB..$C8F5 : Result := 'R';
      $C8F6..$CBF9 : Result := 'S';
      $CBFA..$CDD9 : Result := 'T';
      $CDDA..$CEF3 : Result := 'W';
      $CEF4..$D188 : Result := 'X';
      $D1B9..$D4D0 : Result := 'Y';
      $D4D1..$D7F9 : Result := 'Z';
    else result:=w;
    end;
  end;
var
  i: integer;
begin
  result:='';
  for i := 1 to Length(S) do
    Result := Result + GetLetter(S[i]);
end;

function IsEnCase(strTemp:string): Boolean;
var
  i: integer;
begin
  if strTemp = '' then
  begin
    Result := False;
    Exit;
  end;
  Result := True;
  strTemp := Trim(strTemp);
  for i := 1 to Length(strTemp) do
  if (strTemp[i] in ['A'..'Z']) or (strTemp[i] in ['a'..'z']) then
    Result := True else begin
    Result := False;
    Exit;
  end;
end;

function AlphaToInt(Value: string): Integer;
//��Excel��ʽ��Ӣ����ĸ����ת��Ϊ������26��������Z = A0
  function IntegerType(Value: Char; Index: Integer): Integer;
  begin
    Value := UpCase(Value);
    if (Value >= 'A') or (Value <= 'Z') then
    begin
      Result := (Ord(Value) - 64);
      if Index > 0 then
        Result := Result * Trunc(IntPower(26, Index));
    end
    else
      Result := 0;
  end;

var
  i, Len: Integer;
  Temp: Integer;
begin
  Result := 0;
  if (Value = '0') or (Length(Value) < 1) then Exit;
  Len := Length(Value);
  if (Len > 7) or ((Len = 7) and (Value > 'FXSHRXW')) then
    raise EConvertError.Create('Overflow while converting to Integer type');

  for i := 1 to Len do
  begin
    Temp := IntegerType(Value[i], Len - i);
    if Temp > 0 then
      Result := Result + Temp
    else
      raise EConvertError.Create('Cannot convert to Integer type');
  end;
end;

function IntToAlpha(Value: Integer): string;
//�ѷǸ�����ת����Excel��ʽ��Ӣ����ĸ����
  function Alphabetic(Value: Integer): string;
  var
    CharMod: Integer;
  begin
    CharMod := Value mod 26;
    Value := Value div 26;

    if CharMod = 0 then         //26
    begin
      Result := 'Z';            //A0
      Value := Value - 1;       //ĩβλ��0���26��ǰһλӦ�ٳ�һ��26
    end
    else
      Result := Char(64 + CharMod);

    if Value <= 0 then         //0 ~ 26
      Exit
    else if Value <= 26 then   //26 + 1 ~ 26 * 26���Ż�����[Value = Value mod 26]
      Result := Char(64 + Value) + Result
    else                       // 26 * 26 + 1 ~
      Result := Alphabetic(Value) + Result;
  end;
begin
  if Value <= 0 then
    Result := '0'
  else
    Result := Alphabetic(Value);
end;

//����û�����ϵͳ��Ϣ������֧��Win8
function GetWindowsVertion: string;
  function GetWindowsVersionString: string;  
  var  
    oSVersion: TOSVersionInfoA;  
  begin  
    Result := '';  
    oSversion.dwOSVersionInfoSize := SizeOf(TOSVersionInfoA);  
    if GetVersionExA(oSVersion) then
      with oSVersion do  
        Result := Trim(Format('%s', [szCSDVersion]));  
  end;  
var  
  AWin32Version: Extended;
  sWin, SNo: string;
begin  
  sWin := 'Windows';
  SNo := Format('%d.%d', [Win32MajorVersion, Win32MinorVersion]);
  AWin32Version := StrToFloat(SNo);
  case Win32Platform of
    VER_PLATFORM_WIN32s:
      Result := sWin + '32';
    VER_PLATFORM_WIN32_WINDOWS:  
    begin  
      if AWin32Version = 4.0 then  
        Result := sWin + '95'
      else if AWin32Version = 4.1 then
        Result := sWin + '98'
      else if AWin32Version = 4.9 then
        Result := sWin + 'Me'  
      else  
        Result := sWin + '9x';
    end;
    VER_PLATFORM_WIN32_NT:
    begin  
      if AWin32Version = 3.51 then
        Result := sWin + 'NT 3.51'  
      else if AWin32Version = 4.0 then  
        Result := sWin + 'NT 4.0'  
      else if AWin32Version = 5.0 then
        Result := sWin + '2000'
      else if AWin32Version = 5.1 then
        Result := sWin + 'XP'  
      else if AWin32Version = 5.2 then
        Result := sWin + '2003'
      else if AWin32Version = 6.0 then
        Result := sWin + 'Vista'
      else if AWin32Version = 6.1 then
        Result := sWin + '7'
      else if AWin32Version = 6.2 then
        Result := sWin + '8'
      else if AWin32Version = 6.2 then
        Result := sWin + 'RT'
      else if AWin32Version = 6.3 then
        Result := sWin + '8.1'
      else
        Result := sWin;
    end else
      Result := sWin;  
  end;
  Result := Result + '  ' + GetWindowsVersionString + '('+ SNo+')';
end;

//���ִ�г���汾�ţ����û�汾���򷵻�'Not Found Version Information'
function GetFileVersion(FileName:PChar):String;
var
  VerInfo:Pointer;
  VerInfoSize:DWORD;
  VerValueSize:DWORD;
  VerValue:PVSFixedFileInfo;
  Dummy:DWORD;
  V1,V2,V3,V4:Word;
begin
  VerInfoSize:=GetFileVersionInfoSize(FileName,Dummy);
  if VerInfoSize = 0 then
  begin
    Result:=NoVersionInfoStr;
    Exit;
  end;
  GetMem(VerInfo,VerInfoSize);
  try
    GetFileVersionInfo(FileName,0,VerInfoSize,VerInfo);
    VerQueryValue(VerInfo,'\',Pointer(VerValue),VerValueSize);
    with VerValue^ do
    begin
      V1:=dwFileVersionMS shr 16;
      V2:=dwFileVersionMS and $FFFF;
      V3:=dwFileVersionLS shr 16;
      V4:=dwFileVersionLS and $FFFF;
    end;
    Result:=Format('%d.%d.%d.%d',[V1,V2,V3,V4]);
  finally
    FreeMem(VerInfo,VerInfoSize);
  end;
end;

//���ִ�г��򴴽�ʱ�䣬�޸�ʱ��������ʱ�䣻
function GetFilesTime(sFilename: String; Timetype: Integer): TDateTime;
var
  ffd: TWin32FindData;
  dft: DWord;
  lft, Time: TFileTime;
  sHandle: THandle;
begin
  sHandle:= Windows.FindFirstFile(PChar(sFileName), ffd);
  if (sHandle <>INVALID_HANDLE_VALUE) then begin
    case Timetype of
      0: Time:= ffd.ftCreationTime;    //����ʱ��
      1: Time:= ffd.ftLastWriteTime;   //�޸�ʱ��
      2: Time:= ffd.ftLastAccessTime;  //����ʱ��
    end;
    Windows.FindClose(sHandle);
    FileTimeToLocalFileTime(Time, lft);
    FileTimeToDosDateTime(lft, LongRec(dft).HI, LongRec(dft).Lo);
    Result:= FileDateToDateTime(dft);
  end else Result:= 0;
end;

function GetDisksInfo(strL: TStringList): TStringList;
var
  str:string;
  Drivers:Integer;
  driver:char;
  i,temp,disksizee:integer;
  d1,d2,d3,d4: DWORD;
begin
  strL := TStringList.Create;
  Drivers:=GetLogicalDrives;
  temp:=(1 and Drivers);
  for i:=0 to 26 do
  begin
    if temp=1 then
    begin
      driver:=char(i+integer('A'));
      str:=driver+':';
      if (driver<>'') and (getdrivetype(pchar(str))<>drive_cdrom) and (getdrivetype(pchar(str))<>DRIVE_REMOVABLE) then
      begin
        GetDiskFreeSpace(pchar(str),d1,d2,d3,d4);
        strL.Add(str+Format('�ܿռ�:%f GB',[d4/1024/1024/1024*d2*d1])+Format(' ʣ��ռ�:%f GB',[d3/1024/1024/1024*d2*d1]));
      end;
    end;
    drivers:=(drivers shr 1);
    temp:=(1 and Drivers);
  end;
  Result := strL;
  SetErrorMode(oldMode);
end;

//�ַ�������
function EncryptionStr(Src:String; Key:String = 'WhComTec'):string;
var
  idx :integer;
  KeyLen :Integer;
  KeyPos :Integer;
  offset :Integer;
  dest :string;
  SrcPos :Integer;
  SrcAsc :Integer;
  TmpSrcAsc :Integer;
  Range :Integer;
begin
  KeyLen:=Length(Key);
  if KeyLen = 0 then key:='Think Space';
  KeyPos:=0;
  SrcPos:=0;
  SrcAsc:=0;
  Range:=256;
 
  Randomize;
  offset:=Random(Range);
  dest:=format('%1.2x',[offset]);
  for SrcPos := 1 to Length(Src) do 
  begin
    SrcAsc:=(Ord(Src[SrcPos]) + offset) MOD 255;
    if KeyPos < KeyLen then KeyPos:= KeyPos + 1 else KeyPos:=1;
    SrcAsc:= SrcAsc xor Ord(Key[KeyPos]);
    dest:=dest + format('%1.2x',[SrcAsc]);
    offset:=SrcAsc;
  end; 
  Result:=Dest;
end; 
 
//���ܺ���
function DecryptStr(Src:String; Key:String= 'WhComTec'):string;
var 
  idx :integer;
  KeyLen :Integer;
  KeyPos :Integer;
  offset :Integer;
  dest :string;
  SrcPos :Integer;
  SrcAsc :Integer;
  TmpSrcAsc :Integer;
  Range :Integer;
begin
  KeyLen:=Length(Key);
  if KeyLen = 0 then key:='Think Space';
  KeyPos:=0; 
  SrcPos:=0;
  SrcAsc:=0; 
  Range:=256;
  offset:=StrToInt('$'+ copy(src,1,2)); 
  SrcPos:=3;
  repeat
    SrcAsc:=StrToInt('$'+ copy(src,SrcPos,2));
    if KeyPos < KeyLen Then KeyPos := KeyPos + 1 else KeyPos := 1;
    TmpSrcAsc := SrcAsc xor Ord(Key[KeyPos]);
    if TmpSrcAsc <= offset then TmpSrcAsc := 255 + TmpSrcAsc - offset
    else TmpSrcAsc := TmpSrcAsc - offset;
    dest := dest + chr(TmpSrcAsc);
    offset:=srcAsc;
    SrcPos:=SrcPos + 2;
  until SrcPos >= Length(Src); 
  Result:=Dest;
end;


initialization
  CreateMapFile;

finalization
  FreeMapFile;

end.
