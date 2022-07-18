unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.StdCtrls, System.DateUtils, IdGlobal,
  Vcl.ComCtrls;

type
  TForm1 = class(TForm)
    StringGrid1: TStringGrid;
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    MonthCalendar1: TMonthCalendar;
    Label2: TLabel;
    Button3: TButton;
    DateTimePicker1: TDateTimePicker;
    Label3: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure MonthCalendar1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses ssBasic;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  i,tot: integer;
  oo: TDateTime;
  bb: array[0..13] of string;
  ss: TStringList;
begin
  //ss := TStringList.Create;

//  ss.Free;
  SetChEra(Trunc(MonthCalendar1.Date) + Frac(DateTimePicker1.Time));
  Label1.Caption := strCN();
  Label2.Caption := strJq();

  Label3.Caption := strlunar();
end;

procedure TForm1.MonthCalendar1Click(Sender: TObject);
begin
  SetChEra(Trunc(MonthCalendar1.Date) + Frac(DateTimePicker1.Time));
  Label1.Caption := strCN();
  Label2.Caption := strJq();

  Label3.Caption := strlunar();
end;

end.
