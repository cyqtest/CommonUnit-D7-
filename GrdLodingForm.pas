{*********************************************************************}
{                                                                     }
{     LodingForm  Create By cyq 2013��7��10��                         }
{                                                                     }
{     ��ʾһ�����ң����£����룬�����ȴ������ݵļ��ش���              }
{     ���ã�����CYQCommonUnit                                         }
{           ShowLodingMessage(��ʾ����,��ɫ����Ϊ�ա�)��ʾ���ش���    }
{           HideLodingMessage���ؼ��ش���                             }
{*********************************************************************}
unit GrdLodingForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, RzPanel, RzBckgnd, RzPrgres;

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

  TfrmGrdLoding = class(TForm)
    bgdShowLoadingMsg: TRzBackground;
    pnlShowMessage: TRzPanel;
    lblTime: TLabel;
    btnClose: TSpeedButton;
    pbShowPercent: TRzProgressBar;
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
  frmGrdLoding: TfrmGrdLoding;


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
    if Assigned(frmGrdLoding) And Assigned(frmGrdLoding.lblTime) And (Not Terminated) then
    begin
      //Synchronize
      frmGrdLoding.lblTime.Caption := FormatDateTime('h:mm:ss', Now - BeginTime);
      frmGrdLoding.lblTime.Repaint;
    end;
  Until
    (Not Assigned(frmGrdLoding)) or (Not Assigned(frmGrdLoding.lblTime)) or Terminated;
end;

{TfrmGrdLoding}

procedure TfrmGrdLoding.FormCreate(Sender: TObject);
begin
  myClock := TShowClockTime.Create;
end;

//�Զ�����������  add by cyq 13.6.15
procedure TfrmGrdLoding.AutoFormSize;
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

procedure TfrmGrdLoding.FormShow(Sender: TObject);
begin
  AutoFormSize;
  //����ʱ������߳�
  //myClock.Resume;
end;

procedure TfrmGrdLoding.FormDestroy(Sender: TObject);
begin
  myClock.Terminate;    //��ֹʱ������߳�
end;

procedure TfrmGrdLoding.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  frmGrdLoding := nil;
end;

procedure TfrmGrdLoding.btnCloseClick(Sender: TObject);
begin
  Close;
end;

end.
