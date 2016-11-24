{*********************************************************************}
{                                                                     }
{     UAbout Unit   Create By cyq 2013年10月24日9:54:02               }
{     调用：引用 CYQCommonUnit，调用ShowAboutForm方法                 }
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
    bvlSplit: TBevel;
    imgIcon: TImage;
    lblExpires: TLabel;
    imgCompany: TImage;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lbCompany: TLabel;
    Label2: TLabel;
    lbOSName: TLabel;
    Label6: TLabel;
    lbVersion: TLabel;
    Label7: TLabel;
    lblCopyrightC: TLabel;
    lblCopyrightE: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Image1: TImage;
    lbLastUpdate: TLabel;
    Label14: TLabel;
    Label13: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    lbUseUnit: TLabel;
    lbSysName: TLabel;
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
  //操作系统名
  lbOSName.Caption := GetWindowsVertion;
  //版本号
  lbVersion.Caption := GetFileVersion(PChar(ParamStr(0)));
  //最后更新时间
  lbLastUpdate.Caption := DateToStr(GetFilesTime(ParamStr(0), 1));

  DecodeDate(Date, wYear, wMonth, wDay);
  lblCopyrightC.Caption := '    本软件版权属广州市万鸿计算机科技有限公司，未经'#13
    + '许可不得以任何形式复制、模仿、反向编译！违者必究！';
  lblCopyrightE.Caption := '    Copyright(C) GuangZhou WanHong Computer'#13
    +'Technology CO.,LTD. 2009-' + IntToStr(wYear) + ',All Rights Reserved.';
  //获得本系统任务栏图标Icon
  Bmp := TBitmap.Create;
  try
    with Bmp, Canvas do begin
      Width := 32;
      Height := 32;
      Brush.Color := pnlInfo.Color;
      FillRect(ClipRect);
      Draw(0, 0, Application.Icon);
    end;
    imgIcon.Canvas.CopyRect(imgIcon.ClientRect,
        Bmp.Canvas, Bmp.Canvas.ClipRect);
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
