{*********************************************************************}
{                                                                     }
{     UpdateForm  Create By cyq 2016年2月19日                         }
{                                                                     }
{     显示程序更新时的加载窗口，包括更新文件、进度条等。              }
{     调用：引用CYQCommonUnit                                         }
{           ShowLodingMessage(显示内容,颜色【可为空】)显示加载窗口    }
{           HideLodingMessage隐藏加载窗口                             }
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
    procedure DownloadHttpFile(FileUrl, FileName:string); //下载文件函数
    procedure DownLoadURLFileList; //下载文件
    function GetURLFileName(aURL: string): string; //获得服务端下载的文件名
    function DeleteDirectory(NowPath: string): Boolean; //删除指定目录
    procedure MoveDownloadFile; //移动文件
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
  IsStop:Boolean;       //用户是否终止

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
  IsStop:=true;//用户是否终止
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
  RemoveDir(NowPath); //如果需要删除文件夹则添加
  Result := True;
end;

procedure TfrmUpdate.DownLoadURLFileList;
var
  tmpFileName: string;
  arr: array[0..MAX_PATH] of Char;
  i: Integer;
begin
  //用户是否终止
  IsStop:=false;
  
  //获得临时目录路径
  GetTempPath(MAX_PATH, arr);
  strTempPath := arr+'whUpdateTemp\';
  strReloadPath := ExtractFilePath(strVersionTmp);
  if DirectoryExists(strTempPath) then DeleteDirectory(strTempPath);

  //开始更新文件列表(服务器文件先下载到本地临时目录)
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
    //文件转移
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
  //服务器文件下载到本地临时文件夹
  DownLoadURLFileList;
  ShowMsbInfo('下载成功！','info');

  //转移文件
  MoveDownloadFile;

  //更新Version版本号。更新完成


end;

procedure TfrmUpdate.DownloadHttpFile(FileUrl, FileName: string);
var
  tStream: TFileStream;
  tmpDorectoryName: string;
begin
  if FileExists(FileName) then            //如果文件已经存在
    tStream := TFileStream.Create(FileName, fmOpenWrite)
  else begin //不存在则先判断文件夹，再行创建文件
    tmpDorectoryName := ExtractFilePath(FileName);
    if not DirectoryExists(tmpDorectoryName) then
    ForceDirectories(tmpDorectoryName);
    tStream := TFileStream.Create(FileName, fmCreate);
  end;

  if FileExists(FileName)=false then      //第一次下载
  begin
    idhtpDownLoad.Request.ContentRangeStart:=0; //从指定文件偏移处请求下载文件
    startIndex:=0;
  end else begin                          //续传
    startIndex:=tStream.Size-1;
    if startIndex < 0 then startIndex:=0;
    idhtpDownLoad.Request.ContentRangeStart := startIndex;
    tStream.Position := startIndex ;      //移动到最后继续下载
    idhtpDownLoad.HandleRedirects := true;
    idhtpDownLoad.Head(FileUrl);                //发送HEAD请求
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
  if IsStop then //用户是否终止
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
