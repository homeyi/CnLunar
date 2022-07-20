unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.StdCtrls, System.DateUtils, IdGlobal,
  Vcl.ComCtrls;

type
  TForm1 = class(TForm)
    StringGrid1: TStringGrid;
    Label1: TLabel;
    MonthCalendar1: TMonthCalendar;
    Label2: TLabel;
    DateTimePicker1: TDateTimePicker;
    Label3: TLabel;
    Label4: TLabel;
    procedure MonthCalendar1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
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

procedure TForm1.FormShow(Sender: TObject);
begin
  MonthCalendar1.Date := Now();
  MonthCalendar1Click(Sender);

end;

procedure TForm1.MonthCalendar1Click(Sender: TObject);
var
  i: integer;
  ss: TStringList;
begin

  ss := TStringList.Create;
  SetChEra(Trunc(MonthCalendar1.Date) + Frac(DateTimePicker1.Time));

  with StringGrid1 do begin
    DefaultColWidth := 180;
    ColWidths[0] := 60;
    ColWidths[2] := 60;
    ColWidths[4] := 100;
    Rows[13].Clear;

    for i := 0 to ll do begin
      ss.Clear;
      forgrid(ss, i);
      Rows[i] := ss;
    end;

  end;
  Label1.Caption := strCN();

  Label2.Caption := strJq(1);
  Label3.Caption := strJq(2);
  Label4.Caption := strJq(3);

  ss.Free;
end;

end.
