unit uSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Buttons, IniFiles;

type
  TSettingPDFViewer = record
    Default: boolean;
    Sumatra: boolean;
    SumatraPath: string;
    Other: boolean;
    OtherPath: string;
  public
    procedure Load;
    procedure Save;
  end;

  TAllSetting = record
    PDFViewer: TSettingPDFViewer;
  public
    procedure Load;
    procedure Save;
  end;

type
  TSettingsForm = class(TForm)
    pcSettings: TPageControl;
    pBottom: TPanel;
    BtnOK: TButton;
    BtnCancel: TButton;
    tvSettings: TTreeView;
    TabPDFViewer: TTabSheet;
    btnPDFViewerOther: TSpeedButton;
    rbPDFViewerDefault: TRadioButton;
    rbPDFViewerOther: TRadioButton;
    rbPDFViewerSumatra: TRadioButton;
    btnPDFViewerSumatra: TSpeedButton;
    ePDFViewerSumatra: TEdit;
    ePDFViewerOther: TEdit;
    TabApplication: TTabSheet;
    procedure FormCreate(Sender: TObject);
    procedure tvSettingsClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure rbPDFViewerDefaultClick(Sender: TObject);
    procedure rbPDFViewerOtherClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure btnPDFViewerOtherClick(Sender: TObject);
    procedure rbPDFViewerSumatraClick(Sender: TObject);
    procedure btnPDFViewerSumatraClick(Sender: TObject);
  private
    { Private declarations }
    FAllSetting: TAllSetting;

    procedure InitialSetting;
    procedure UpdateSetting;
  public
  end;

implementation

{$R *.dfm}

uses uTypes, uLanguage;

{ TSetting }

procedure TAllSetting.Load;
begin
  self.PDFViewer.Load;
end;

procedure TAllSetting.Save;
begin
  self.PDFViewer.Save;
end;

{ TSettingPDFViewer }

procedure TSettingPDFViewer.Load;
var
  ini: tinifile;
begin
  ini := tinifile.Create(ExtractFileDir(Application.ExeName) + '\' + FileSetting);
  try
    self.Default := ini.ReadBool('PDFViewer', 'Default', true);
    self.Sumatra := ini.ReadBool('PDFViewer', 'Sumatra', false);
    self.SumatraPath := ini.ReadString('PDFViewer', 'SumatraPath', '');
    self.Other := ini.ReadBool('PDFViewer', 'Other', false);
    self.OtherPath := ini.ReadString('PDFViewer', 'OtherPath', '');
  finally
    ini.Free;
  end;
end;

procedure TSettingPDFViewer.Save;
var
  ini: tinifile;
begin
  ini := tinifile.Create(ExtractFileDir(Application.ExeName) + '\' + FileSetting);
  try
    ini.WriteBool('PDFViewer', 'Default', self.Default);
    ini.WriteBool('PDFViewer', 'Sumatra', self.Sumatra);
    ini.WriteString('PDFViewer', 'SumatraPath', self.SumatraPath);
    ini.WriteBool('PDFViewer', 'Other', self.Other);
    ini.WriteString('PDFViewer', 'OtherPath', self.OtherPath);
  finally
    ini.Free;
  end;
end;

procedure TSettingsForm.FormCreate(Sender: TObject);
var
  i: integer;
  node: TTreeNode;
begin
  pBottom.Caption := '';
  pcSettings.Align := alClient;

  UpdateLanguage(self, lngRus);

  tvSettings.Items.Clear;
  tvSettings.Items.BeginUpdate;
  node := tvSettings.Items.AddObject(nil, TabApplication.Caption, Pointer(TabApplication));
  node := tvSettings.Items.AddObject(nil, TabPDFViewer.Caption, Pointer(TabPDFViewer));

  tvSettings.Items.EndUpdate;

  for i := 0 to self.ComponentCount - 1 do
    if self.Components[i] is TEdit then
      (self.Components[i] as TEdit).Text := '';

  for i := 0 to pcSettings.PageCount - 1 do
    pcSettings.Pages[i].TabVisible := false;
end;

procedure TSettingsForm.FormShow(Sender: TObject);
begin
  FAllSetting.Load;
  InitialSetting;
end;

procedure TSettingsForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //
end;

procedure TSettingsForm.tvSettingsClick(Sender: TObject);
begin
  pcSettings.ActivePage := TTabSheet(tvSettings.Selected.Data);
end;

procedure TSettingsForm.BtnOKClick(Sender: TObject);
begin
  UpdateSetting;
  FAllSetting.Save;
  close;
end;

procedure TSettingsForm.BtnCancelClick(Sender: TObject);
begin
  close;
end;

procedure TSettingsForm.btnPDFViewerSumatraClick(Sender: TObject);
var
  open: TOpenDialog;
begin
  open := TOpenDialog.Create(self);
  try
    open.Filter := 'Приложения|*.exe';
    open.DefaultExt := 'exe';
    if FileExists(ePDFViewerSumatra.Text) then
      open.InitialDir := ExtractFilePath(ePDFViewerSumatra.Text);
    if open.Execute then
      ePDFViewerSumatra.Text := open.FileName;
  finally
    open.Free;
  end;
end;

procedure TSettingsForm.btnPDFViewerOtherClick(Sender: TObject);
var
  open: TOpenDialog;
begin
  open := TOpenDialog.Create(self);
  try
    open.Filter := 'Приложения|*.exe';
    open.DefaultExt := 'exe';
    if FileExists(ePDFViewerOther.Text) then
      open.InitialDir := ExtractFilePath(ePDFViewerOther.Text);
    if open.Execute then
      ePDFViewerOther.Text := open.FileName;
  finally
    open.Free;
  end;
end;

procedure TSettingsForm.rbPDFViewerDefaultClick(Sender: TObject);
begin
  ePDFViewerOther.Enabled := rbPDFViewerOther.Checked;
  btnPDFViewerOther.Enabled := rbPDFViewerOther.Checked;
  ePDFViewerSumatra.Enabled := rbPDFViewerSumatra.Checked;
  btnPDFViewerSumatra.Enabled := rbPDFViewerSumatra.Checked;
end;

procedure TSettingsForm.rbPDFViewerSumatraClick(Sender: TObject);
begin
  ePDFViewerSumatra.Enabled := rbPDFViewerSumatra.Checked;
  btnPDFViewerSumatra.Enabled := rbPDFViewerSumatra.Checked;
  ePDFViewerOther.Enabled := rbPDFViewerOther.Checked;
  btnPDFViewerOther.Enabled := rbPDFViewerOther.Checked;
end;

procedure TSettingsForm.rbPDFViewerOtherClick(Sender: TObject);
begin
  ePDFViewerOther.Enabled := rbPDFViewerOther.Checked;
  btnPDFViewerOther.Enabled := rbPDFViewerOther.Checked;
  ePDFViewerSumatra.Enabled := rbPDFViewerSumatra.Checked;
  btnPDFViewerSumatra.Enabled := rbPDFViewerSumatra.Checked;
end;

procedure TSettingsForm.InitialSetting;
begin
  rbPDFViewerDefault.Checked := FAllSetting.PDFViewer.Default;
  rbPDFViewerSumatra.Checked := FAllSetting.PDFViewer.Sumatra;
  rbPDFViewerOther.Checked := FAllSetting.PDFViewer.Other;
  ePDFViewerSumatra.Text := FAllSetting.PDFViewer.SumatraPath;
  ePDFViewerOther.Text := FAllSetting.PDFViewer.OtherPath;
end;

procedure TSettingsForm.UpdateSetting;
begin
  FAllSetting.PDFViewer.Default := rbPDFViewerDefault.Checked;
  FAllSetting.PDFViewer.Sumatra := rbPDFViewerSumatra.Checked;
  FAllSetting.PDFViewer.Other := rbPDFViewerOther.Checked;
  FAllSetting.PDFViewer.SumatraPath := ePDFViewerSumatra.Text;
  FAllSetting.PDFViewer.OtherPath := ePDFViewerOther.Text;
end;

end.
