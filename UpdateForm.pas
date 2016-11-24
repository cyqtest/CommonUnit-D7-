{*********************************************************************}
{                                                                     }
{     UpdateForm  Create By cyq 2016��2��19��                         }
{                                                                     }
{     ��ʾ�������ʱ�ļ��ش��ڣ����������ļ����������ȡ�              }
{     ���ã�����CYQCommonUnit                                         }
{           ShowLodingMessage(��ʾ����,��ɫ����Ϊ�ա�)��ʾ���ش���    }
{           HideLodingMessage���ؼ��ش���                             }
{*********************************************************************}
unit UpdateForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, RzPanel, RzBckgnd, RzPrgres,
  RzButton, IdAntiFreezeBase, IdAntiFreeze, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, RzLabel, pngimage;

type
  TfrmUpdate = class(TForm)
    pnlShowMessage: TRzPanel;
    btnClose: TSpeedButton;
    pbFilePrecent: TRzProgressBar;
    btnUpdate: TRzButton;
    idhtpDownLoad: TIdHTTP;
    idntfrz1: TIdAntiFreeze;
    pbTotalFile: TRzProgressBar;
    lb1: TRzLabel;
    lb2: TRzLabel;
    lbPrecent: TRzLabel;
    imgBackgroud: TImage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure idhtpDownLoadWork(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCount: Integer);
    procedure idhtpDownLoadWorkBegin(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCountMax: Integer);
  private
    { Private declarations }
    procedure DownloadHttpFile(FileUrl, FileName:string); //�����ļ�����
    procedure DownLoadURLFileList; //�����ļ�
    function GetURLFileName(aURL: string): string; //��÷�������ص��ļ���
    function DeleteDirectory(NowPath: string): Boolean; //ɾ��ָ��Ŀ¼
    procedure MoveDownloadFile; //�ƶ��ļ�
  public
    { Public declarations }

  end;

var
  frmUpdate: TfrmUpdate;
  strExePath, ServiceUrl, strUpdate, strUpdateTmp, strServiceTmp,
  strTempPath, strReloadPath,
  strVersionTmp: string;
  UniqueFileList, UpdateList, LocalList, DownloadList, MoveList: TStringList;

  startIndex:Integer;
  IsStop:Boolean;       //�û��Ƿ���ֹ

const
  LOCALINIFILENAME: string = 'Update.XML';

var
  aFileWorkCountMax: Integer;


implementation
{$R *.dfm}

uses
  CYQCommonUnit, IniFiles, Contnrs, StrUtils, UConst, ZLib;

{TfrmUpdate}
procedure TfrmUpdate.FormCreate(Sender: TObject);
begin
  //
end;

procedure TfrmUpdate.FormShow(Sender: TObject);
begin
  SetWindowPos(frmUpdate.Handle,HWND_TOPMOST,0,0,0,0,SWP_NOMOVE or SWP_NOSIZE );
end;

procedure TfrmUpdate.FormDestroy(Sender: TObject);
begin
//
end;

procedure TfrmUpdate.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.ProcessMessages;
  IsStop:=true;//�û��Ƿ���ֹ
  Action := caFree;
  frmUpdate := nil;
end;

procedure TfrmUpdate.btnCloseClick(Sender: TObject);
begin
  Close;
end;

function TfrmUpdate.DeleteDirectory(NowPath: string): Boolean;
var
  search: TSearchRec;
  ret: integer;
  key: string;
begin
  if NowPath[Length(NowPath)] <> '\' then NowPath := NowPath + '\';
  key := NowPath + '*.*';
  ret := findFirst(key, faanyfile, search);
  while ret = 0 do
  begin
    if ((search.Attr and fadirectory) = fadirectory) then
    begin
      if (search.Name <> '.') and (search.name <> '..') then
        DeleteDirectory(NowPath + search.name);
    end
    else
    begin
      if ((search.Attr and fadirectory) <> fadirectory) then
      begin
        deletefile(NowPath + search.name);
      end;
    end;
    ret := FindNext(search);
  end;
  FindClose(search);
  RemoveDir(NowPath); //�����Ҫɾ���ļ��������
  Result := True;
end;

procedure TfrmUpdate.DownLoadURLFileList;
var
  tmpFileName: string;
  arr: array[0..MAX_PATH] of Char;
  i: Integer;
begin
  //�û��Ƿ���ֹ
  IsStop:=false;
  
  //�����ʱĿ¼·��
  GetTempPath(MAX_PATH, arr);
  strTempPath := arr+'whUpdateTemp\';
  strReloadPath := ExtractFilePath(strVersionTmp);
  if DirectoryExists(strTempPath) then DeleteDirectory(strTempPath);

  //��ʼ�����ļ��б�(�������ļ������ص�������ʱĿ¼)
  pbTotalFile.TotalParts := UpdateList.Count - 1;
  DownloadList := TStringList.Create;
  MoveList := TStringList.Create;
  pbTotalFile.PartsComplete := 0;
  for i := 0 to Pred(UpdateList.Count) do
  begin
    tmpFileName := updatelist.Strings[i];
    tmpFileName := SubStrReplace(updatelist.Strings[i],'/','\');
    if FileExists(strTempPath+tmpFileName) then
    DeleteFile(strTempPath+tmpFileName);

    DownloadHttpFile(ServiceUrl+updatelist.Strings[i],strTempPath+tmpFileName);
    //�ļ�ת��
    DownloadList.Add(strTempPath+tmpFileName);
    MoveList.Add(strReloadPath+tmpfilename);
    pbTotalFile.IncPartsByOne;
  end;
end;

procedure TfrmUpdate.MoveDownloadFile;
var
  i: Integer;
  tmpMoveDir: string;
begin
  if not ((DownloadList.Count > 0) and (MoveList.Count > 0)) then Exit;

  for i := 0 to Pred(DownloadList.Count) do
  begin
    tmpMoveDir := MoveList.Strings[i];
    tmpMoveDir := ExtractFilePath(tmpMoveDir);

    if not DirectoryExists(tmpMoveDir) then
    ForceDirectories(tmpMoveDir);
    MoveFile(PChar(DownloadList.Strings[i]), PChar(MoveList.Strings[i]));
  end;
end;

procedure TfrmUpdate.btnUpdateClick(Sender: TObject);
begin
  //�������ļ����ص�������ʱ�ļ���
  DownLoadURLFileList;
  ShowMsbInfo('���سɹ���','info');

  //ת���ļ�
  MoveDownloadFile;

  //����Version�汾�š��������


end;

procedure TfrmUpdate.DownloadHttpFile(FileUrl, FileName: string);
var
  tStream: TFileStream;
  tmpDorectoryName: string;
begin
  if FileExists(FileName) then            //����ļ��Ѿ�����
    tStream := TFileStream.Create(FileName, fmOpenWrite)
  else begin //�����������ж��ļ��У����д����ļ�
    tmpDorectoryName := ExtractFilePath(FileName);
    if not DirectoryExists(tmpDorectoryName) then
    ForceDirectories(tmpDorectoryName);
    tStream := TFileStream.Create(FileName, fmCreate);
  end;

  if FileExists(FileName)=false then      //��һ������
  begin
    idhtpDownLoad.Request.ContentRangeStart:=0; //��ָ���ļ�ƫ�ƴ����������ļ�
    startIndex:=0;
  end else begin                          //����
    startIndex:=tStream.Size-1;
    if startIndex < 0 then startIndex:=0;
    idhtpDownLoad.Request.ContentRangeStart := startIndex;
    tStream.Position := startIndex ;      //�ƶ�������������
    idhtpDownLoad.HandleRedirects := true;
    idhtpDownLoad.Head(FileUrl);                //����HEAD����
  end;

  try
    idhtpDownLoad.Get(FileUrl,tStream);
  except

  end;
  tStream.Free;
end;

function TfrmUpdate.GetURLFileName(aURL: string): string;
var
  i: integer;
  s: string;
begin
  s := aURL;
  i := Pos('/', s);
  while i <> 0 do
  begin
    Delete(s, 1, i);
    i := Pos('/', s);
  end;
  Result := s;
end;

procedure TfrmUpdate.idhtpDownLoadWork(Sender: TObject;
  AWorkMode: TWorkMode; const AWorkCount: Integer);
begin
  if IsStop then //�û��Ƿ���ֹ
  begin
    idhtpDownLoad.Disconnect;
  end;

  lbPrecent.Caption:= IntToStr(aFileWorkCountMax)+'kb/'
    + IntToStr(AWorkCount+startIndex)+'kb';
  pbFilePrecent.PartsComplete := AWorkCount+startIndex;
end;

procedure TfrmUpdate.idhtpDownLoadWorkBegin(Sender: TObject;
  AWorkMode: TWorkMode; const AWorkCountMax: Integer);
begin
  aFileWorkCountMax := AWorkCountMax+startIndex;
  lbPrecent.Caption:=IntToStr(aFileWorkCountMax)+'kb/0kb';
  pbFilePrecent.PartsComplete :=0;
  pbFilePrecent.TotalParts :=AWorkCountMax+startIndex;
end;

end.
