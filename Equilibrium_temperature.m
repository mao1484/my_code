%ラジエータの平衡温度を求めるコード 
close all; clear variables; clc; 

%-----定数-----% 
pi = 3.141592654; 
sigma = 5.67*10^(-8);         %ステファンボルツマン定数    
h = 6.62607015*10^(-34);      %プランク定数          
k = 1.380649*10^(-23);        %ボルツマン定数           
c = 299792458;                %光速     
c1 = 2*pi*h*c^2*10^24;        %第1ふく射定数  [10^8 W・μm^4/m^2]     
c2 = h*c/k*10^6;              %第2ふく射定数 

%-----各種パラメータ-----% 
heat = 1;                     %定常熱入力[W]  
lam1 = 3;                     %非相反の波長帯の下端  
lam2 = 17;                    %非相反の波長帯の上端   
T_a = 400;                    %小惑星温度   
T_u = 3;                      %宇宙空間温度   
%-----放射率と吸収率の設定-----% 
epsiron1_main = 1;            %小惑星側lam1からlam2の放射率
epsiron1_other = 0;           %小惑星側 lam1からlam2以外の放射率
epsiron2_main = 0;            %宇宙空間側  
epsiron2_other = 0;           %宇宙空間側  
alpha1_main = 0;              %小惑星側12~17μmの吸収率 
alpha1_other = 0;             %小惑星側  
alpha2_main = 1;              %宇宙空間側12~17μmの吸収率  
alpha2_other = 0;             %宇宙空間側12~17以外の吸収率 
lam  = linspace(1, 8000, 8000);  %波長．1~8000 µmを8000刻みで計算．  
temp = linspace(0, 1000, 8000);  %温度．上限は1000以外でもok 

%-----積分の計算-----% 
E_Q1out = zeros(length(lam),length(temp));   
E_Q2out = zeros(length(lam),length(temp)); 
E_Q1in = zeros(1,length(lam)); 
E_Q2in = zeros(1,length(lam));  
for indtem = 1:length(temp)  
    for indlam = 1:length(lam)                                               
        if lam1<lam(indlam) && lam(indlam)<lam2                             
            E_Q1out(indtem,indlam) = epsiron1_main * (1/2) *  c1./(lam(indlam).^5.*(exp(c2./(lam(indlam).*temp(indtem)))-1)); 
        else 
            E_Q1out(indtem,indlam) = epsiron1_other * (1/2) * c1./(lam(indlam).^5.*(exp(c2./(lam(indlam).*temp(indtem)))-1)); 
        end 
    end 
end

for indtem = 1:length(temp)  
    for indlam = 1:length(lam)                                               
        if lam1<lam(indlam) && lam(indlam)<lam2                                                    
            E_Q2out(indtem,indlam) = epsiron2_main * (1/2) *  c1/(lam(indlam).^5.*(exp(c2./(lam(indlam).*temp(indtem)))-1)); 
        else 
            E_Q2out(indtem,indlam) = epsiron2_other * (1/2) * c1./(lam(indlam).^5.*(exp(c2./(lam(indlam).*temp(indtem)))-1)); 
        end 
    end 
end

for indlam = 1:length(lam) 
    if lam1<lam(indlam) && lam(indlam)<lam2                                                    
        E_Q1in(indlam) = alpha1_main * (1/2) *  c1./(lam(indlam).^5.*(exp(c2./(lam(indlam).*T_a))-1)); 
    else 
        E_Q1in(indlam) = alpha1_other * (1/2) * c1./(lam(indlam).^5.*(exp(c2./(lam(indlam).*T_a))-1)); 
    end 
end

for indlam = 1:length(lam)                                               
    if lam1<lam(indlam) && lam(indlam)<lam2                            
        E_Q2in(indlam) = alpha2_main * (1/2) *  c1./(lam(indlam).^5.*(exp(c2./(lam(indlam).*T_u))-1)); 
    else 
        E_Q2in(indlam) = alpha2_other * (1/2) * c1./(lam(indlam).^5.*(exp(c2./(lam(indlam).*T_u))-1)); 
    end 
end 

EP_Q1out = trapz(lam, E_Q1out, 2);  %EP:emissive power  
EP_Q2out = trapz(lam, E_Q2out, 2); 

EP_Q1in = trapz(lam, E_Q1in)  
EP_Q2in = trapz(lam, E_Q2in) 

%-----形態係数-----% 
a = 0.1;            %小惑星表面からの宇宙機の高度
r = 450;            %小惑星半径
H = (a + r)/r; 
F_sa = (1/pi)*(atan(1/(H^2-1)^(1/2))-(H^2-1)^(1/2)/H^2)  %形態係数 

%-----面積-----% 
As = 0.01;          %ラジエータ面積 

%-----熱収支によるラジエータ平衡温度-----% 
Q = As * F_sa .* EP_Q1in + As * (1 - F_sa) .* EP_Q2in - As * F_sa .* EP_Q1out -  As * (1 - F_sa) .* EP_Q2out + heat;      

%-----グラフ出力-----% 
% figure; 
% plot(temp,Q); hold on; 
% xlabel( 'Temperature [K]' ); 
% ylabel('heat balance [W]'); 
% left = 20;                      
% bottom = 40;   
% width = 1024; 
% height = 768; 
%グラフの出力位置を調整する 
% set( gcf, 'PaperPositionMode', 'auto' ); 
% pos = get( gcf, 'Position' ); 
% pos(1) = left;                  
% pos(2) = bottom;  
% pos(3) = width; 
% pos(4) = height; 
% set( gcf, 'Position', pos ); 
% saveas(gcf,'Q_temperature_atepsi09and01.png');

%-----Q がゼロとなるTを探す-----% 
valid_indices = find(Q >= 0);  %Qが0以上のtempの要素のインデックスを取得 
if ~isempty(valid_indices)     %isempty は空かどうかを判別．論理否定演算子がついているので空でない場合にtrueを返す 
    min_tmep = temp(valid_indices(1));   %始めの要素を仮の最小値とする
    min_Q = Q(valid_indices(1));         %最小値に対応するQの値を取得
    for i = 2:length(valid_indices) 
        if Q(valid_indices(i)) < min_Q 
            min_Q = Q(valid_indices(i)); %現時点の最小値よりも小さければ上書き 
            min_temp = temp(valid_indices(i)); 
        end 
    end 
    disp(['Q が 0 以上の範囲での最小値をとるtemp: ', num2str(min_temp)]);   %num2str で数値を文字に． 
    disp(['その時の Q の値: ', num2str(min_Q)]); 
else 
    disp('Q が 0 以上の値を持つtempは存在しません。');
end 

