%コンター図作成コード 
close all; clear all; clc; 

ang = linspace(-90, 90, 1000);    %角度（コンター図の横軸）
lam  = linspace(1, 20, 1000);     %波長（コンター図の縦軸）
lam1 = 1;                        
lam2 = 7;                         
lam3 = 12;                        %非相反の始まり
lam4 = 17;                        %非相反の終わり 

e12to17_plus = 0;                 %非相反の波長帯の角度が正の範囲の放射率 
e12to17_minus = 1;                %非相反の波長帯の角度が負の範囲の放射率
e17to = 1;                        %lam4 より上の放射率 
e1to7 = 1;                        %lam1 からlam2までの放射率
e7to12 = 1;                       %lam2 からlam3までの放射率

%-----放射率マッピングの作成-----% 
x = ang; 
y = lam; 
z = zeros(length(lam), length(ang));
for indx = 1:length(ang)                                                 
    for indy = 1:length(lam) 
        if ang(indx)>=0 && ang(indx)<=90 && lam(indy)>=lam3 && lam(indy)<=lam4 
            z(indy, indx) = e12to17_plus; 
        elseif ang(indx)<0 && ang(indx)<=90 && lam(indy)>=lam3 && lam(indy)<=lam4 
            z(indy, indx) = e12to17_minus; 
        elseif lam(indy)>=lam1 && lam(indy)<lam2 
            z(indy, indx) = e1to7; 
        elseif lam(indy)>=lam2 && lam(indy)<lam3 
            z(indy, indx) = e7to12; 
        elseif lam(indy)>lam4 
            z(indy, indx) = e17to; 
        end 
    end 
end

%-----コンター図内に線を引く-----% 
x_line1 = [ -90 , 90 ];               
z_line1 = [ lam3 , lam3 ];            
x_line2 = [ -90 , 90 ]; 
z_line2 = [ 17 , 17 ]; 
x_line3 = [ -90 , -90 ]; 
z_line3 = [ lam3 , 17 ];  
x_line4 = [ 90 , 90 ]; 
z_line4 = [ lam3, 17 ]; 

%-----グラフ出力-----% 
figure; 
pcolor(x,y,z); hold on; 
shading interp; colormap( "gray" ); 
box on; 
set( gca, 'linewidth', 2, 'fontsize', 40, 'fontname', 'arial');         
h = colorbar( 'linewidth', 2, 'fontsize', 36, 'fontname', 'arial' );    
plot( x_line1, z_line1, 'g', 'linewidth', 4 );                 
plot( x_line2, z_line2, 'g', 'linewidth', 4 ); 
plot( x_line3, z_line3, 'g', 'linewidth', 4 ); 
plot( x_line4, z_line4, 'g', 'linewidth', 4 ); 
caxis( [ 0 1 ] )                                 
%xlim( [ min( x ) max( x ) ] ) 
%ylim( [ min( y ) max( y ) ] ) 
xlabel( '¥fontname{Times New Roman}¥fontsize{45}¥theta [deg]' ); 
ylabel( '¥fontname{Times New Roman}¥fontsize{45}{¥lambda} [¥mum]' ); 
left = 20;                             
bottom = 40;   
width = 1024; 
height = 768; 
set( gcf, 'PaperPositionMode', 'auto' ); 
pos = get( gcf, 'Position' ); 
pos(1) = left;                  
pos(2) = bottom;  
pos( 3 ) = width; 
pos( 4 ) = height; 
set( gcf, 'Position', pos ); 
saveas(gcf,'alp01_other1_5to17.png'); 