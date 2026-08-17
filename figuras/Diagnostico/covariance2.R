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

load("../3-inference/simulated/rjags/results/covariance2-nPop-on.RData")
load("../3-inference/simulated/rjags/results/covariance2-nPop-off.RData")
load("../3-inference/simulated/rjags/results/covariance2-nPop-on-symmetric.RData")


S = c(0.8,0.75)
X = c(0.75,0.85)
Cov = c(0.12, 0.09) # cov_s, cov_x
max_cov = c(min(S[1],S[2]) - S[1]*S[2], min(X[1],X[2]) - X[1]*X[2])
min_cov = c((S[1]-1)*(1-S[2]), (X[1]-1)*(1-X[2]) )

P <- c(0.5)

s=matrix(nrow=2,ncol=3)
x=matrix(nrow=2,ncol=3)
cov = matrix(nrow=2,ncol=3)
s[1,]= brief.on["se[1]",c(1,2,3)]
s[2,]= brief.on["se[2]",c(1,2,3)]
x[1,]= brief.on["sp[1]",c(1,2,3)]
x[2,]= brief.on["sp[2]",c(1,2,3)]
cov[1,]= brief.on["covse12",c(1,2,3)]
cov[2,]= brief.on["covsp12",c(1,2,3)]

s_indep = matrix(nrow=2,ncol=3)
x_indep = matrix(nrow=2,ncol=3)
s_indep[1,]= brief.off["se[1]",c(1,2,3)]
s_indep[2,]= brief.off["se[2]",c(1,2,3)]
x_indep[1,]= brief.off["sp[1]",c(1,2,3)]
x_indep[2,]= brief.off["sp[2]",c(1,2,3)]

s_sym=matrix(nrow=2,ncol=3)
x_sym=matrix(nrow=2,ncol=3)
cov_sym = matrix(nrow=2,ncol=3)
s_sym[1,]= brief.on.sym["se[1]",c(1,2,3)]
s_sym[2,]= brief.on.sym["se[2]",c(1,2,3)]
x_sym[1,]= brief.on.sym["sp[1]",c(1,2,3)]
x_sym[2,]= brief.on.sym["sp[2]",c(1,2,3)]
cov_sym[1,]= brief.on.sym["cov12",c(1,2,3)]
cov_sym[2,]= brief.on.sym["cov12",c(1,2,3)]





plot_estimates <- function(real,estimates,ylim,xlim,name, max=NA, min=NA){

    grilla = seq(ylim[1],ylim[2],by=0.05)

    if (all(is.na(max))){
        max = rep(-10, length(real))
        min = rep(-10, length(real))
    }

    plot(0,0,col=rgb(1,1,1,0),  ylim=ylim, xlim=xlim, axes=F, xlab="", ylab="")
    for (is in seq(length(real))){
        points(is, real[is], pch=19)
        text(is, ylim[2],paste0(name,toString(is)), cex=1.5, col=rgb(0,0,0,0.6))
        segments(x0=is, x1=is, y0=estimates[is,1], y1=estimates[is,3],lwd=1)
        segments(x0=is-0.05, x1=is+0.05, y0=estimates[is,2], y1=estimates[is,2])

        segments(x0=is-0.1, x1=is+0.1, y0=max[is], y1=max[is], lty=2)
        segments(x0=is-0.1, x1=is+0.1, y0=min[is], y1=min[is], lty=2)
    }

    abline(v=3.5)
    axis(side=2, at= grilla ,labels=NA,cex.axis=0.6,tck=0.015)
    #axis(side=1, labels=NA,cex.axis=0.6,tck=0.015)
    #axis(lwd=0,side=1, cex.axis=1.5,line=-0.45)
    axis(lwd=0,side=2,at= grilla, cex.axis=1.5,line=-0.45)
    abline(h=grilla, col=rgb(0,0,0,0.1))
}

plot_estimates(real=S,estimates=s,ylim=c(0.65,1), xlim=c(0.75, length(S)+0.25), name="s")
plot_estimates(real=X,estimates=x,ylim=c(0.65,1), xlim=c(0.75, length(S)+0.25), name="x")
plot_estimates(real=Cov,estimates=cov,ylim=c(-0.1,0.2), xlim=c(0.75, length(S)+0.25), name="cov", min=min_cov, max=max_cov )
plot_estimates(real=S,estimates=s_indep,ylim=c(0.65,1), xlim=c(0.75, length(S)+0.25), name="s")
plot_estimates(real=X,estimates=x_indep,ylim=c(0.65,1), xlim=c(0.75, length(S)+0.25), name="x")
plot_estimates(real=S,estimates=s_sym,ylim=c(0.65,1), xlim=c(0.75, length(S)+0.25), name="s")
plot_estimates(real=X,estimates=x_sym,ylim=c(0.65,1), xlim=c(0.75, length(S)+0.25), name="x")
plot_estimates(real=Cov,estimates=cov_sym,ylim=c(-0.1,0.2), xlim=c(0.75, length(S)+0.25), name="cov_sym", min=min_cov, max=max_cov )


######
dev.off()
system(paste("pdfcrop -m '0 0 0 0'",paste0(nombre,".pdf") ,paste0(nombre,".pdf")))
setwd(oldwd)
par(oldpar, new=F)

