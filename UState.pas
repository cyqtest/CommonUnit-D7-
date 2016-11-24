{*********************************************************************}
{                                                                     }
{     UAbout Unit   Create By cyq 2013��10��24��9:54:02               }
{     ���ã����� CYQCommonUnit������ShowAboutForm����                 }
{                                                                     }
{                                                                     }
{*********************************************************************}
unit UState;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ShellAPI;

type
  TfrmState = class(TForm)
    pnlInfo: TPanel;
    imgBack: TImage;
    lblExpires: TLabel;
    imgCompany: TImage;
    Label4: TLabel;
    lbCompany: TLabel;
    Label6: TLabel;
    lbVersion: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Image1: TImage;
    lbLastUpdate: TLabel;
    Label14: TLabel;
    lbUseUnit: TLabel;
    lb1: TLabel;
    lb2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure lblExpiresClick(Sender: TObject);
    procedure Label15Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmState: TfrmState;

const
	NoVersionInfoStr='Not Found Version Information!';

implementation

uses
  CYQCommonUnit;

{$R *.dfm}

procedure TfrmState.FormCreate(Sender: TObject);
var
  wYear, wMonth, wDay: Word;
  Bmp: TBitmap;

  Icon : hIcon;
  IconIndex : word;
begin
  //����ϵͳ��
  //lbOSName.Caption := GetWindowsVertion;
  //�汾��
  lbVersion.Caption := GetFileVersion(PChar(ParamStr(0)));
  //������ʱ��
  lbLastUpdate.Caption := DateToStr(GetFilesTime(ParamStr(0), 1));

  DecodeDate(Date, wYear, wMonth, wDay);
  //lblCopyrightC.Caption := '    �������Ȩ����������������Ƽ����޹�˾��δ��'#13
  //  + '��ɲ������κ���ʽ���ơ�ģ�¡�������룡Υ�߱ؾ���';
  //lblCopyrightE.Caption := '    Copyright(C) GuangZhou WanHong Computer'#13
  //  +'Technology CO.,LTD. 2009-' + IntToStr(wYear) + ',All Rights Reserved.';
  //��ñ�ϵͳ������ͼ��Icon
  Bmp := TBitmap.Create;
  try
    with Bmp, Canvas do begin
      Width := 32;
      Height := 32;
      Brush.Color := pnlInfo.Color;
      FillRect(ClipRect);
      Draw(0, 0, Application.Icon);
    end;
    //imgIcon.Canvas.CopyRect(imgIcon.ClientRect,
   //     Bmp.Canvas, Bmp.Canvas.ClipRect);
  finally
    Bmp.Free;
  end;
end;

procedure TfrmState.lblExpiresClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.gzwanhong.com', '', '', SW_SHOWNORMAL);
end;

procedure TfrmState.Label15Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://mail.126.com/', '', '', SW_SHOWNORMAL);
end;

end.
