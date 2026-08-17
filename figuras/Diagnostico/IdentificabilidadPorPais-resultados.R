oldpar <- par(no.readonly = TRUE)
oldwd <- getwd()
this.dir <- dirname(parent.frame(2)$ofile)
setwd(this.dir)
nombre.R <-  sys.frame(1)$ofile
require(tools)
nombre <- print(file_path_sans_ext(nombre.R))
pdf(paste0(nombre,".pdf"), width = 8, height = 5 )
setwd(this.dir)
##################################################

s=matrix(nrow=9,ncol=5)
x=matrix(nrow=9,ncol=5)

S <- c(0.8, 0.9, 0.95, 0.7 , 0.8 , 0.93, 0.89, 0.82, 0.999)
X <- c(0.9, 0.99, 0.95, 0.9, 0.65, 0.96, 0.91, 0.79, 0.999)
P <- c(0.1)

s[1,]=c(0.7599100,0.8162335,0.8675302,0.8152246,0.027582667)
s[2,]=c(0.8804264,0.9218361,0.9566341,0.9203727,0.019520935)
s[3,]=c(0.8844139,0.9243011,0.9576653,0.9229258,0.018998355)
s[4,]=c(0.6509611,0.7156488,0.7755191,0.7148355,0.031935372)
s[5,]=c(0.7429675,0.8008551,0.8532745,0.7996660,0.028543399)
s[6,]=c(0.8969111,0.9346342,0.9661208,0.9329647,0.018036668)
s[7,]=c(0.8284304,0.8777128,0.9195907,0.8764130,0.023613482)
s[8,]=c(0.7379424,0.7976657,0.8506503,0.7968067,0.028752433)
s[9,]=c(0.9783400,0.9941588,0.9999980,0.9922726,0.006848265)
x[1,]=c(0.8502145,0.8930571,0.9329874,0.8920172,0.021477155)
x[2,]=c(0.9696457,0.9871943,0.9987314,0.9856754,0.008253530)
x[3,]=c(0.8721826,0.9123554,0.9480096,0.9111639,0.019582553)
x[4,]=c(0.8525413,0.8955371,0.9339799,0.8945337,0.020979078)
x[5,]=c(0.5873808,0.6527177,0.7169733,0.6522598,0.033320246)
x[6,]=c(0.9264006,0.9558566,0.9815409,0.9544895,0.014447659)
x[7,]=c(0.8388676,0.8837722,0.9250426,0.8827432,0.022219527)
x[8,]=c(0.7683245,0.8238768,0.8719025,0.8224091,0.026602915)
x[9,]=c(0.9861220,0.9966711,0.9999991,0.9952701,0.004682200)


plot(0,0,col=rgb(1,1,1,0),  ylim=c(0.65,1), xlim=c(1, 9+0.25), axes=F, xlab="", ylab="")
for (is in seq(length(S))){
    points(is, S[is], pch=19)
    text(is+0.3, S[is]+0.005,paste0("s",toString(is)), cex=1.25, col=rgb(0,0,0,0.6))
    segments(x0=is, x1=is, y0=s[is,1], y1=s[is,3],lwd=1)
    segments(x0=is-0.1, x1=is+0.1, y0=s[is,2], y1=s[is,2])
}

abline(v=3.5)
mtext(text ="Algorithm",side =1,line=0,cex=1.33,at = 2.1)
axis(side=2, at= seq(0.65,1.0,by=0.05) ,labels=NA,cex.axis=0.6,tck=0.015)
#axis(side=1, labels=NA,cex.axis=0.6,tck=0.015)
#axis(lwd=0,side=1, cex.axis=1.5,line=-0.45)
axis(lwd=0,side=2,at= seq(0.65,1.0,by=0.05), cex.axis=1.5,line=-0.45)
abline(h=seq(0.65,1.0,by=0.05), col=rgb(0,0,0,0.1))



plot(0,0,col=rgb(1,1,1,0),  ylim=c(0.65,1), xlim=c(1, 9+0.25), axes=F, xlab="", ylab="")
for (ix in seq(length(X))){
    points(ix, X[ix], pch=19)
    text(ix+0.3,X[ix]+0.005,paste0("x",toString(ix)), cex=1.25, col=rgb(0,0,0,0.6))
    segments(x0=ix, x1=ix, y0=x[ix,1], y1=x[ix,3],lwd=1)
    segments(x0=ix-0.1, x1=ix+0.1, y0=x[ix,2], y1=x[ix,2])
}
abline(v=3.5)
mtext(text ="Algorithm",side =1,line=0,cex=1.33,at = 2.1)
axis(side=2, at= seq(0.65,1.0,by=0.05) ,labels=NA,cex.axis=0.6,tck=0.015)
#axis(side=1, labels=NA,cex.axis=0.6,tck=0.015)
#axis(lwd=0,side=1, cex.axis=1.5,line=-0.45)
axis(lwd=0,side=2,at= seq(0.65,1.0,by=0.05), cex.axis=1.5,line=-0.45)
abline(h=seq(0.65,1.0,by=0.05), col=rgb(0,0,0,0.1))



######
dev.off()
system(paste("pdfcrop -m '0 0 0 0'",paste0(nombre,".pdf") ,paste0(nombre,".pdf")))
setwd(oldwd)
par(oldpar, new=F)

