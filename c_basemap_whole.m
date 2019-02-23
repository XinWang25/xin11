function c_basemap_whole(varargin)
%C_BASEMAP_WHOLE Creates Basemap of the Antarctic Peninsula

in = varargin;

while length(in)>0
    switch lower(in{1}(1:3))
        case 'moo'
            MR = in{2};
        case 'bat'
            BT = in{2};
        case 'btm'
            BM = in{2};
        case 'iso'
            VV = in{2};
        case 'pat'
            PT = in{2};
        case 'lab'
            LA = in{2};
        case 'clr'
            CL = in{2};
        case 'ctr'
            CR = in{2};
        case 'rad'
            RD = in{2};
        case 'rot'
            RT = in{2};
    end
    in(1:2)=[];
end

if ~exist('MR')
    MR = 1;
end
if ~exist('LG')
    LG = 1;
end
if ~exist('CR')
    %CR = [-65 -65];
    CR = [-60 -63];
end
if ~exist('RD')
    %RD = [7];
    RD = [4.5];
end
if ~exist('BT')
    BT = 0;
end
if ~exist('BM')
    BM = 0;
end
if ~exist('PT')
    PT = 1;
end
if ~exist('CL')
    CL = 0;
end
if ~exist('RT')
    RT = 0;
end
if ~exist('VV')
    VV = [-1000 -750 -500 -250 0];
end
if BT == 1 & ~exist('LA')
    LA = 0 ;
elseif BT == 0 & ~exist('LA')
    LA = 0;
elseif BT == 0 & exist('LA');
    LA = 0;
end

if BM == 1 & ~exist('LA')
    LA = 0 ;
elseif BM == 0 & ~exist('LA')
    LA = 0;
elseif BM == 0 & exist('LA');
    LA = 0;
end

% Declare stuff
bc = [1/256 1/256 1/256]*180;
% bc = 'r';

% load ~/work/research/globec/data/bathy/scar_ice icelon icelat patch_line
% load ~/work/research/globec/data/bathy/peninsula_coast

load /Users/xwang/Desktop/research/paper1/volume_transport/scar_ice icelon icelat patch_line
load /Users/xwang/Desktop/research/paper1/volume_transport/peninsula_coast
%figure
m_proj('stereographic','lon',CR(1),'lat',CR(2),'rad',RD,'rec',...
    'on','rot',RT);



if BT == 1
    % load ~/work/research/globec/data/bathy/bolmer/bolmer_merged.mat
    load ~/work/data/bathymetry/wapbathy.mat
    % Plot the data, place contours
    if CL == 0
        [c,h] = m_contour(lon,lat,depth,[VV'],'color',bc,'linewidth',1);
        if LA == 1    
            m_grid('tickdir','out','fontsize',10);
            m_ungrid
            clabel(c,h,'manual','fontsize',8,'background','w','color',bc);
        end
    else        
        [c,h] = m_contourf(lon,lat,depth,[VV'],'linecolor','none');
    end    

end


if BM == 1
%     batm = load('~/work/research/wapbank/data/WAP_1k_grid','h','lon_rho','lat_rho');
 batm = load('/Users/xwang/Desktop/research/outputofroms/data/WAP_1k_grid','h','lon_rho','lat_rho');
    % Plot the data, place contours
    if CL == 0
        [c,h] = m_contour(batm.lon_rho,batm.lat_rho,-batm.h,[VV'],'color',bc,'linewidth',1);
        if LA == 1    
            m_grid('tickdir','out','fontsize',10);
            m_ungrid
            clabel(c,h,'manual','fontsize',8,'background','w','color',bc);
        end
    else        
        [c,h] = m_contourf(batm.lon_rho,batm.lat_rho,-batm.h,'linecolor','none');
    end    

end

S = shaperead('/Users/xwang/Desktop/research/outputofroms/data/ne_10m_antarctic_ice_shelves_polys.shp');

for ii = 1:numel(S)
    % if strcmp(S(ii).continent,'North America') | strcmp(S(ii).continent,'South America')
        m_patch(S(ii).X,S(ii).Y,[238 246 255]/256);
        hold on
    % end
end



nlon = [nlon; -80 ; nan];
nlat = [nlat; -75; nan];

if PT == 1
    h = findobj('tag','coastpatch');
    if ~isempty(h);
       % delete(h);
    end
    knan = find(isnan(nlon));
    for ii = 1:length(knan)-1
        ind = knan(ii)+1:knan(ii+1)-1;
        m_patch(nlon(ind),nlat(ind),[.7 .7 .7],'tag','coastpatch');  %mygray
    end
end


hold on
h = findobj('tag','coastline');
if ~isempty(h);
   % delete(h);
end
m_plot(nlon,nlat,'k','tag','coastline');
m_plot(icelon,icelat,'color','g','linewidth',1.5,'tag','iceline'); %mygray
xlabel('Longitude','fontsize',14);
ylabel('Latitude','fontsize',14);
m_grid('linestyle',':','tickdir','out','linewidth',1,'fontsize',12);