S=imread('123.png');
imshow(S);
%set(gca,'looseInset',[0 0 0 0]);

imshow(S,'border','tight','initialmagnification','fit');colormap hot;
h1=gcf ;
saveas(h1, '123.pdf');
