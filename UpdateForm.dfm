object frmUpdate: TfrmUpdate
  Left = 517
  Top = 288
  BorderStyle = bsNone
  Caption = #21319#32423#31243#24207
  ClientHeight = 163
  ClientWidth = 344
  Color = 15456255
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = #23435#20307
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object pnlShowMessage: TRzPanel
    Left = 0
    Top = 0
    Width = 344
    Height = 163
    Align = alClient
    BorderOuter = fsNone
    GradientColorStart = 16744448
    TabOrder = 0
    DesignSize = (
      344
      163)
    object imgBackgroud: TImage
      Left = 0
      Top = 0
      Width = 344
      Height = 163
      Align = alClient
      Picture.Data = {
        0A54504E474F626A65637489504E470D0A1A0A0000000D494844520000040000
        00004508020000005BA503180000001974455874536F6674776172650041646F
        626520496D616765526561647971C9653C0000037669545874584D4C3A636F6D
        2E61646F62652E786D7000000000003C3F787061636B657420626567696E3D22
        EFBBBF222069643D2257354D304D7043656869487A7265537A4E54637A6B6339
        64223F3E203C783A786D706D65746120786D6C6E733A783D2261646F62653A6E
        733A6D6574612F2220783A786D70746B3D2241646F626520584D5020436F7265
        20352E362D633036372037392E3135373734372C20323031352F30332F33302D
        32333A34303A34322020202020202020223E203C7264663A52444620786D6C6E
        733A7264663D22687474703A2F2F7777772E77332E6F72672F313939392F3032
        2F32322D7264662D73796E7461782D6E7323223E203C7264663A446573637269
        7074696F6E207264663A61626F75743D222220786D6C6E733A786D704D4D3D22
        687474703A2F2F6E732E61646F62652E636F6D2F7861702F312E302F6D6D2F22
        20786D6C6E733A73745265663D22687474703A2F2F6E732E61646F62652E636F
        6D2F7861702F312E302F73547970652F5265736F75726365526566232220786D
        6C6E733A786D703D22687474703A2F2F6E732E61646F62652E636F6D2F786170
        2F312E302F2220786D704D4D3A4F726967696E616C446F63756D656E7449443D
        22786D702E6469643A37623863343839612D376435642D313634622D61333038
        2D3833316134626137323164352220786D704D4D3A446F63756D656E7449443D
        22786D702E6469643A3441423635373538433030413131453541333532443131
        4435413541463633412220786D704D4D3A496E7374616E636549443D22786D70
        2E6969643A344142363537353743303041313145354133353244313144354135
        41463633412220786D703A43726561746F72546F6F6C3D2241646F6265205068
        6F746F73686F702043432032303135202857696E646F777329223E203C786D70
        4D4D3A4465726976656446726F6D2073745265663A696E7374616E636549443D
        22786D702E6969643A66373138633438322D383761632D323334632D39653035
        2D323561303763303061623839222073745265663A646F63756D656E7449443D
        22786D702E6469643A37623863343839612D376435642D313634622D61333038
        2D383331613462613732316435222F3E203C2F7264663A446573637269707469
        6F6E3E203C2F7264663A5244463E203C2F783A786D706D6574613E203C3F7870
        61636B657420656E643D2272223F3E14B32D6A000001754944415478DAEDD701
        0100200CC0205FC3BE0F6A13830C5A3077DF0100001A46000000A04300000020
        4400000020440000002044000000204400000020440000002044000000204400
        0000204400000020440000002044000000204400000020440000002044000000
        2044000000204400000020440000002044000000204400000020440000002044
        0000002044000000204400000020440000002044000000204400000020440000
        0020440000002044000000204400000020440000002044000000204400000020
        4400000020440000002044000000204400000020440000002044000000204400
        0000204400000020440000002044000000204400000020440000002044000000
        2044000000204400000020440000002044000000204400000020440000002044
        0000002044000000204400000020440000002044000000204400000020440000
        0020440000002044000000204400000020440000002044000000204400000020
        44000000204400000020E40396C867C66062CC610000000049454E44AE426082}
      Stretch = True
    end
    object btnClose: TSpeedButton
      Left = 325
      Top = 2
      Width = 16
      Height = 16
      Hint = #20851#38381
      Anchors = [akTop, akRight]
      Flat = True
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = #23435#20307
      Font.Style = []
      Glyph.Data = {
        62000000424D62000000000000003E000000280000000A000000090000000100
        010000000000240000000000000000000000020000000000000000000000FFFF
        FF00FFC000009E400000CCC00000E1C00000F3C00000E1C00000CCC000009E40
        0000FFC00000}
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      OnClick = btnCloseClick
    end
    object pbFilePrecent: TRzProgressBar
      Left = 7
      Top = 113
      Width = 329
      Height = 20
      BorderOuter = fsFlat
      BorderWidth = 0
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = #23435#20307
      Font.Style = []
      InteriorOffset = 0
      ParentFont = False
      PartsComplete = 0
      Percent = 0
      TotalParts = 0
    end
    object pbTotalFile: TRzProgressBar
      Left = 7
      Top = 63
      Width = 329
      Height = 20
      BorderOuter = fsFlat
      BorderWidth = 0
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = #23435#20307
      Font.Style = []
      InteriorOffset = 0
      ParentFont = False
      PartsComplete = 0
      Percent = 0
      TotalParts = 0
    end
    object lb1: TRzLabel
      Left = 8
      Top = 46
      Width = 84
      Height = 14
      Caption = #24635#20307#21319#32423#36827#24230
      Transparent = True
    end
    object lb2: TRzLabel
      Left = 8
      Top = 96
      Width = 84
      Height = 14
      Caption = #25991#20214#21319#32423#36827#24230
      Transparent = True
    end
    object lbPrecent: TRzLabel
      Left = 104
      Top = 96
      Width = 77
      Height = 14
      Caption = '1024kb/20kb'
      Transparent = True
    end
    object btnUpdate: TRzButton
      Left = 261
      Top = 135
      Caption = #21319#32423
      HotTrack = True
      TabOrder = 0
      OnClick = btnUpdateClick
    end
  end
  object idhtpDownLoad: TIdHTTP
    MaxLineAction = maException
    ReadTimeout = 0
    OnWork = idhtpDownLoadWork
    OnWorkBegin = idhtpDownLoadWorkBegin
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = 0
    Request.ContentRangeStart = 0
    Request.ContentType = 'text/html'
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    HTTPOptions = [hoForceEncodeParams]
  end
  object idntfrz1: TIdAntiFreeze
    OnlyWhenIdle = False
    Left = 32
  end
end
