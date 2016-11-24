{*********************************************************************}
{                                                                     }
{     LodingForm  Create By cyq 2013��7��10��                         }
{                                                                     }
{     ��ʾһ�����ң����£����룬�����ȴ������ݵļ��ش���              }
{     ���ã�����CYQCommonUnit                                         }
{           ShowLodingMessage(��ʾ����,��ɫ����Ϊ�ա�)��ʾ���ش���    }
{           HideLodingMessage���ؼ��ش���                             }
{*********************************************************************}
unit LodingForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, RzPanel, RzBckgnd;

type
  //��ʾ����ʱ�ӵ��߳�
  TShowClockTime = Class(TThread)
  private
    BeginTime: TDateTime;
  protected
    procedure Execute; override;
  public
    constructor Create;
  end;

  TfrmLoding = class(TForm)
    bgdShowLoadingMsg: TRzBackground;
    pnlShowMessage: TRzPanel;
    lblTime: TLabel;
    btnClose: TSpeedButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }
    myClock: TShowClockTime;
  public
    { Public declarations }
    procedure AutoFormSize;
  end;

var
  frmLoding: TfrmLoding;


implementation

{$R *.dfm}

{TShowClockTime}

//��ʾʱ�ӽ��ȵ��߳�
constructor TShowClockTime.Create;
begin
  BeginTime := Now;
  FreeOnTerminate := True;
  inherited Create(True);
end;

procedure TShowClockTime.Execute;
begin
  Repeat
    Sleep(1000);
    if Assigned(frmLoding) And Assigned(frmLoding.lblTime) And (Not Terminated) then
    begin
      //Synchronize
      frmLoding.lblTime.Caption := FormatDateTime('h:mm:ss', Now - BeginTime);
      frmLoding.lblTime.Repaint;
    end;
  Until
    (Not Assigned(frmLoding)) or (Not Assigned(frmLoding.lblTime)) or Terminated;
end;

{TfrmLoding}

procedure TfrmLoding.FormCreate(Sender: TObject);
begin
  myClock := TShowClockTime.Create;
end;

//�Զ�����������  add by cyq 13.6.15
procedure TfrmLoding.AutoFormSize;
var
  TxtLen: Integer;
begin
  //�Զ�����������
  TxtLen := Self.Canvas.TextWidth(pnlShowMessage.Caption);
  if TxtLen > PnlShowMessage.ClientWidth then
  begin
    if TxtLen > Screen.WorkAreaWidth then
      Self.Width := Screen.WorkAreaWidth
    else
      Self.Width := TxtLen + 10;
    lblTime.Left := (Self.Width - lblTime.Width) div 2;
  end;
end;

procedure TfrmLoding.FormShow(Sender: TObject);
begin
  SetWindowPos(frmLoding.Handle,HWND_TOPMOST,0,0,0,0,SWP_NOMOVE or SWP_NOSIZE );
  AutoFormSize;
  //����ʱ������߳�
  myClock.Resume;
end;

procedure TfrmLoding.FormDestroy(Sender: TObject);
begin
  myClock.Terminate;    //��ֹʱ������߳�
end;

procedure TfrmLoding.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  frmLoding := nil;
end;

procedure TfrmLoding.btnCloseClick(Sender: TObject);
begin
  Close;
end;

end.
