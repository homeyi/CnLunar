unit ssBasic;

interface

uses
  System.Math, System.Classes, SysUtils, DateUtils;

{
  設定:
   1..10  甲至癸
   1..12  子至亥
 }
  //天干
  function ISZhiSheng(izhi, byzhi: integer): boolean;
  function ISZhiKe(izhi, byzhi: integer): boolean;
  function ISZhiBi(izhi, byzhi: integer): boolean;

  function ISZhi6He(izhi, byzhi: integer): boolean;
  function ISZhi3He(z1, z2, z3: integer): boolean;
  function ISZhiChong(izhi, byzhi: integer): boolean;
  function ISZhiXing(izhi, byzhi: integer): boolean;
  function ISZhiHai(izhi, byzhi: integer): boolean;
  function ISZhiPo(izhi, byzhi: integer): boolean;

  function ISMu(fdayZhi, byzhi: integer): boolean;
//  function ISJue(habcd1,habcd2: integer): boolean;
  function ISJin(izhi, byzhi: integer): boolean;
  function ISTui(izhi, byzhi: integer): boolean;

{  function ISGuiRen(iday,habcd1: integer): boolean;
  function ISYiMa(iday,habcd1: integer): boolean;
  function ISXianChi(iday,habcd1: integer): boolean;
  function ISLu(iday,habcd1: integer): boolean;
 }

  //地支
  function idxChangSheng(byzhi, setZhi: integer; isgan: boolean=False): integer;  //返回十二長生


  //全局记录变量 crJq（干支纪日、节气日、节气名、合朔日、月份
  procedure SetChEra(inDate: TDateTime);

  function strCN(): String; //日期干支
  function strFullKong(): String; //四值空亡
  function strXun(): string;  //六旬
  function strKong(): String;
  function strLunar(): string;

  //測試---增加神煞等
  function zhiYiMa(izhi: integer): integer;

  //delete
  procedure forgrid(ilist: TStringList; ii: integer);
  function bb1: string;
  function bb2: string;
  function strJq(ch: integer): string;

//公用變量
var
  crDate, crJie, crQi: TDateTime;
  strJie, strQi, strnlYue, strnlRi: string;
  Year, Month, Day, Hour, Mins, Sec, MSec: word;
  gYear, gMonth, gDay, gTime, zYear, zMonth, zDay, zTime: integer;
  ooShou, ooXun, ooKong: integer;

  //delete
  ll: integer;
const
  strTianGan: array of string = ['','甲','乙','丙','丁','戊','己','庚','辛','壬','癸'];
  strDiZhi: array of string = ['','子','丑','寅','卯','辰','巳','午','未','申','酉','戌','亥'];

implementation

uses CnLunar;

//判斷
function ISZhiSheng(izhi, byzhi: integer): boolean;
begin
   //地支生
   Result := False;
   case izhi of
      12,1 : result := (byzhi = 3) or (byzhi = 4);
      3,4 : result := (byzhi = 6) or (byzhi = 7);
      2,5,8,11 : result := (byzhi = 9) or (byzhi = 10);
      6,7 : result := (byzhi mod 3) = 2;
      9,10: result := (byzhi = 12) or (byzhi = 1);
   end;
end;

function ISZhiKe(izhi, byzhi: integer): boolean;
begin
    //地支克
    Result := False;
    case izhi of
       12,1 : result := (byzhi = 6) or (byzhi = 7);
       2,5,8,11 : result := (byzhi = 1) or (byzhi = 12);
       3,4 : result := (byzhi mod 3) = 2;
       6,7 : result := (byzhi = 9) or (byzhi = 10);
       9,10: result := (byzhi = 3) or (byzhi = 4);
    end;
end;

function ISZhiBi(izhi, byzhi: integer): boolean;
begin

    //为12时不便计算五行相比，故改为 0
    if izhi = 12 then izhi := 0;
    if byzhi = 12 then byzhi := 0;

    if (izhi mod 3) = 2 then result := (byzhi mod 3) = 2
    else
       result := (izhi = byzhi) or (byzhi = (izhi + 1)) or (byzhi = (izhi - 1));

end;

function ISZhi6He(izhi, byzhi: integer): boolean;
begin
    //地支六合
    if izhi < 3 then izhi := izhi + 12;
    
    result := (15 - izhi) = byzhi;
end;

function ISZhi3He(z1, z2, z3: integer): boolean;
begin

  //地支三合
  result := ([z1,z2,z3] = [2,6,10]) or ([z1,z2,z3] = [1,5,9]) or
            ([z1,z2,z3] = [3,7,11]) or ([z1,z2,z3] = [4,8,12]);

end;


function ISZhiChong(izhi, byzhi: integer): boolean;
begin
   //地支冲
   result := ((izhi + 6) mod 12) = (byzhi mod 12);
end;

function ISZhiXing(izhi, byzhi: integer): boolean;
begin
    //地支刑
    case izhi of
      1: result := byzhi = 4;
      4: result := byzhi = 1;

      2: result := byzhi = 11;
      11: result := byzhi = 8;
      8: result := byzhi = 2;

      3,6: result := byzhi = (izhi + 3);
      9: result := byzhi = 3;
    else
      result := izhi = byzhi;  //辰午酉亥自刑
    end;
end;

function ISZhiHai(izhi, byzhi: integer): boolean;
begin
    //地支害
    //子丑合、午未合，子午衝，未丑衝，故子未相害。。。
    if izhi < 9 then result := (9 - izhi) = byzhi
    else result := (21 - izhi) = byzhi;
end;

function ISZhiPo(izhi, byzhi: integer): boolean;
begin
  //地支破
  //子卯、卯午、午酉相破

  {Result := ((izhi=1) and (byzhi=4)) or ((izhi=4) and (byzhi=1));
  Result := ((izhi=7) and (byzhi=4)) or ((izhi=4) and (byzhi=7));
  Result := ((izhi=10) and (byzhi=7)) or ((izhi=7) and (byzhi=10));}

  //2018-11-29
  //陽支退四、陰支進四：子酉、寅亥、辰丑、午卯、申巳、戌未
  if odd(izhi) then
     result := ((izhi+9) mod 12) = (byzhi mod 12)
  else
     result := ((izhi+3) mod 12) = byzhi;
end;

function ISMu(fdayZhi, byzhi: integer): boolean;
begin

  case fdayZhi of
     2: result := (byzhi = 9) or (byzhi = 10);
     5: result := (byzhi = 1) or (byzhi = 12) or ((byzhi mod 3) = 2);
     8: result := (byzhi = 3) or (byzhi = 4);
    11: result := (byzhi = 6) or (byzhi = 7);
  else
    result := False;
  end;

end;

function ISJin(izhi, byzhi: integer): boolean;
begin
   if izhi  = 12 then izhi  := 0;
   if byzhi = 12 then byzhi := 0;

   result := ISZhiBi(izhi, byzhi) and (izhi < byzhi);
end;

function ISTui(izhi, byzhi: integer): boolean;
begin
   if izhi  = 12 then izhi  := 0;
   if byzhi = 12 then byzhi := 0;

   result := ISZhiBi(izhi, byzhi) and (izhi > byzhi);
end;

//十二長生
function idxChangSheng(byzhi, setZhi: integer; isgan: boolean=False): integer;
begin
   if isgan then  //天干陰陽順逆

      if (setZhi mod 2) = 0 then
      case setzhi of
       4: result := (20 - byzhi) mod 12;
       6: result := (23 - byzhi) mod 12;
       10:result := (26 - byzhi) mod 12;
      else
          result := (29 - byzhi) mod 12;
      end
      else
      case setzhi of
       3: result := (byzhi + 13) mod 12;
       7: result := (byzhi + 10) mod 12;
       9: result := (byzhi + 7)  mod 12;
      else
          result := (byzhi + 4)  mod 12;
      end
   else
      case setZhi of
       3,4:  result := (byzhi + 13) mod 12;
       6,7:  result := (byzhi + 10) mod 12;
       9,10: result := (byzhi + 7)  mod 12;
      else
          result := (byzhi + 4)  mod 12;
      end;

   if result = 0 then result := 12;
   
end;

//空99沖98合97害96刑95(子卯無禮94、巳申寅恃勢93、丑戌未無恩92)
function idxkongchong(byzhi, setzhi: integer): string;
begin

end;
//

//返回地支數

//六爻常用神煞
//驛馬
function zhiYiMa(izhi: integer): integer;
const
  ma: array [0..3] of integer = (6, 3, 12, 9);
begin
  result := ma[izhi mod 4];
end;

//干支年月日时
//年干支
procedure yGz(y: integer);
begin

  //控件只能輸入 1601 年后，故公式簡化爲公元3年起
  if Jq[2] > crDate then DEC(y); //是否立春后

  gYear := (y - 3) mod 10;
  zYear := (y - 3) mod 12;

  if gYear = 0 then gYear := 10;
  if zYear = 0 then zYear := 12;
end;

//月干支
procedure mGz();
begin

  if crDate < crJie then zMonth := Month -2 else zMonth := Month -1;

  if zMonth <=0 then zMonth := zMonth + 12;

  gMonth := (12*gYear + zMonth -10) mod 10;
  zMonth := (12*gYear + zMonth -10) mod 12;

  if gMonth = 0 then gMonth := 10;
  if zMonth = 0 then zMonth := 12;

end;

//日干支
procedure dGz();
var
  total: integer;
begin

  total := Trunc(crDate);
  if Hour < 23 then Dec(total);

  gDay := total mod 10;
  zDay := (total - 2) mod 12;

  if gDay = 0 then gDay := 10;
  if zDay = 0 then zDay := 12;

end;

//時干支
procedure hGz();
begin

  //時支
  if (hour = 0) or (hour = 23) then
     zTime := 1
  else
     zTime := Round((hour + 2.4)/2);

  //時干
  if gDay >5 then gTime := ((gDay -5)*2 -2 + zTime) mod 10
  else gTime := (gDay*2 -2 + zTime) mod 10;

  if gTime = 0 then gTime := 10;
  if zTime = 0 then zTime := 12;

end;

procedure SetLunar();
const
  jqB: array of String = [ // 节气表
    '春分', '清明', '谷雨', '立夏', '小满', '芒种', '夏至', '小暑', '大暑', '立秋', '处暑', '白露',
    '秋分', '寒露', '霜降', '立冬', '小雪', '大雪', '冬至', '小寒', '大寒', '立春', '雨水', '惊蛰'];

  strnl: array of string = ['一','二','三','四','五','六','七','八','九'];

var
  dif: integer;
begin
  crJie := jq[Month];
  crQi  := zq[Month];

  strJie := jqB[(Month*2 + 17) mod 24];
  strQi  := jqB[(Month*2 + 18) mod 24];

  if (trunc(crDate) - trunc(hs[Month])) < 0 then begin
    Dif := Month - 1;
    while (trunc(crDate) - trunc(hs[Dif])) < 0 do Dec(Dif);

    strnlYue := syn[Dif];
    dif := trunc(crDate) - trunc(hs[Dif]);
  end
  else begin
    strnlYue := syn[Month];
    dif := trunc(crDate) - trunc(hs[Month]);
  end;

  case dif of
      0,30: strnlRi := '初一';
      1..8: strnlRi := '初' + strnl[dif];
         9: strnlRi := '初十';
    10..18: strnlRi := '十' + strnl[dif mod 10];
        19: strnlRi := '廿';
    20..28: strnlRi := '廿' + strnl[dif mod 10];
        29: strnlRi := '卅';
  end;

end;

procedure SetChEra(inDate: TDateTime);  //日期转换为干支
begin

  //當前節氣
  crDate := inDate;
  DeCodeTime(inDate,Hour,Mins,Sec,MSec);
  DeCodeDate(inDate,Year,Month,Day);

  syn := TStringList.Create;
  paiYue(Year);

  SetLunar;
  ll := syn.Count -1;

  //年月日時干支
  yGz(Year);
  mGz();
  dGz();
  hGz();

  //起始六兽
  case gDay of
    1,2: ooShou := 1;
    3,4: ooShou := 2;
      5: ooShou := 3;
      6: ooShou := 4;
    7,8: ooShou := 5;
    9,10: ooShou := 6;
  end;

  //旬首空首
  ooXun := (zDay - gDay + 13) mod 12;
  ooKong := (zDay - gDay + 11) mod 12;

end;

//返回各种格式
function strCN(): String;
begin
   result := format('%s%s %s%s %s%s %s%s',[strTianGan[gYear],strDiZhi[zYear],
     strTianGan[gMonth], strDiZhi[zMonth], strTianGan[gDay], strDiZhi[zDay],
     strTianGan[gTime], strDiZhi[zTime]]);

end;

function strKong(): String;
begin
   result := format('%s%s',[strDiZhi[ooKong],strDiZhi[ooKong + 1]]);
end;

function strFullKong(): String;

   function calcKong(ig, iz: byte): byte;
   begin
      result := (iz - ig + 11) mod 12;
   end;

begin
   result := format('%s%s  %s%s  %s%s  %s%s',[StrDiZhi[calcKong(gYear, zYear)],
     StrDiZhi[calcKong(gYear, zYear) +1],
     StrDiZhi[calcKong(gMonth, zMonth)], StrDiZhi[calcKong(gMonth, zMonth) +1],
     StrDiZhi[ooKong], StrDiZhi[ooKong +1],
     StrDiZhi[calcKong(gTime, zTime)], StrDiZhi[calcKong(gTime, zTime) +1]]);
end;

function strXun(): string;
begin
  result := format('甲%s旬',[strDizhi[ooXun]]);
end;

procedure forgrid(ilist: TStringList; ii: integer);
const
  jqB: array of String = [ // 节气表
    '春分', '清明', '谷雨', '立夏', '小满', '芒种', '夏至', '小暑', '大暑', '立秋', '处暑', '白露',
    '秋分', '寒露', '霜降', '立冬', '小雪', '大雪', '冬至', '小寒', '大寒', '立春', '雨水', '惊蛰'];
begin
  ilist.Append(jqB[(ii*2+17) mod 24]);
  ilist.Append(FormatDateTime('YYYY-MM-DD hh:nn',jq[ii]));
  ilist.Append(jqB[(ii*2+18) mod 24]);
  ilist.Append(FormatDateTime('YYYY-MM-DD hh:nn',zq[ii]));
  ilist.Append(syn[ii]);
  ilist.Append(FormatDateTime('YYYY-MM-DD hh:nn',hs[ii]));
end;

function bb1: string;
begin
  result := strJie + '>' + FormatDateTime('MM月DD hh:nn', crJie) + '  ';
  result := result + strQi + '>' + FormatDateTime('MM月DD hh:nn', crQi)
end;
function bb2: string;
begin
  result := strnlYue + ' ' + strnlRi;
end;

function strJq(ch: integer): string;
begin
  case ch of
   1: result := format('%s: %s',[strJie,formatDateTime('MM月DD日 hh:nn',crJie)]);
   2: result := format('%s: %s',[strQi, formatDateTime('MM月DD日 hh:nn',crQi)]);
   3: result := strnlYue + '  ' + strnlRi;
  end;

end;

function strLunar(): string;
begin
  //result := crJq.nYue + crJq.nRi;
end;

end.
