# free-energy-simulator.R

library(rgl)

# Determined gas constant by:
#
# dG = dH - TdS
# dG = -RT*log(P2/P1)
# dS = R*log(W2/W1)
#
# -RT*log(P2/P1) = dH - RT*log(W2/W1)
# RT*(log(W2/W1) - log(P2/P1)) = dH
# RT = dH/(log(W2/W1) - log(P2/P1))
#
# For a series of dH (well_depth), I ran simulations with a reduced temperature
# (T_factor) of 1.  W2 and W1 are determined by te areas of states 1 and 2,
# P1 and P2 could be estimated from the simulations.  Did this from dH from -8
# to -1, then took the average and standard error of R.  

GAS_CONSTANT <- 2.9402 # +/- 0.058

# Potential energy function
V <- function(x,y,well_depth=0,beta=7,offset=0.0001){
    r <- sqrt(x**2 + y**2)
    well_depth*exp(-abs(r*beta))/(offset+exp(-abs(r*beta)))
}

# Initialize the drawing surface, which allows the user to resize prior to
# plotting simulations
initialize_drawing <- function(){
    open3d()
}

# Draw the potential energy surface
draw_surface <- function(box_size,state_radius,well_depth,beta=7,offset=0.0001) {

    # Create surface matrix
    x_surface <- seq(-box_size,box_size,by=0.25)
    y_surface <- seq(-box_size,box_size,by=0.25)
    z_surface <- matrix(NA,length(x_surface),length(y_surface))
    for (i in 1:length(x_surface)){
        for (j in 1:length(y_surface)){
            z_surface[i,j] <- V(x_surface[i],y_surface[j],well_depth,beta,offset)
        }
    }

    # Draw mesh surface
    rgl.clear()
    rgl.bg(color="white")
    surface3d(x_surface,y_surface,z_surface,front="lines",back="lines",axes_visible=FALSE,color="white")

    # Draw circle
    n <- 300 
    theta <- seq(0, 2*pi, len=n) 
    x <- cos(theta)*state_radius
    y <- sin(theta)*state_radius
    z <- rep(0, n) 
    lines3d(x,y,z,color=3,lwd=5) 

    # Set viewpoint
    a <- matrix(NA,4,4)
    a[1,] <- c(0.652999163,-0.757358670,-0.000236392,0.000000000)
    a[2,] <- c(0.4236363,0.365003,0.829038799,0)
    a[3,] <- c(-0.6277934,-0.5414616,0.559191108,0)
    a[4,] <- c(0,0,0,1)

    rgl.viewpoint(userMatrix=a,fov=40)

}

run_simulation <- function(box_size=10,state_radius=0.5,well_depth=-2,beta=25,offset=0.0001,
                           start_coord=c(0,0),num_steps=1000,periodic=FALSE,T_factor=1,
                           kinetic_resolution=1000,
                           write_png=FALSE,draw=FALSE,png_suffix="plot"){

    out <- list()
    out$box_size <- box_size
    out$state_radius <- state_radius
    out$well_depth <- well_depth
    out$beta <- beta
    out$offset <- offset
    out$T_factor <- T_factor

    # Create output data frame
    results <- as.data.frame(rep(NA,num_steps))
    names(results) <- c("x")
    results$y <- NA
    results$kinetic_energy <- NA
    results$potential_energy <- NA
    results$state <- NA

    # Draw the potential energy surface
    if (draw == TRUE || write_png == TRUE){
        draw_surface(box_size,state_radius,well_depth,beta,offset)
    }

    # Initialize variables
    x <- start_coord[1]
    y <- start_coord[2]
    radius_squared <- state_radius**2

    # Go for num_steps...
    for (i in 1:num_steps){

        # status
        if (i %% 100 == 0){
            print(i)
        }

        # Choose a random velocity in X and Y from a gaussian distribution
        delta <- rnorm(2,0,T_factor)

        # Move across the potential surface for one time step, changing kinetic energy
        # and position according to the underlying potential surface         
        new_x1 <- x
        new_y1 <- y
        for (j in 1:kinetic_resolution){

            # Calculate current kinetic energy
            Ek <- 1/2*sum(delta**2)

            # Calcualte current position
            new_x2 <- new_x1 + delta[1]/kinetic_resolution
            new_y2 <- new_y1 + delta[2]/kinetic_resolution        

            # Calculate change in potential energy relative to previous position
            dV <- V(new_x2,new_y2,well_depth,beta,offset) - V(new_x1,new_y1,well_depth,beta,offset)

            # scale velocities based on change in potential energy over this step
            delta <- delta*(Ek - dV)/Ek
 
            # Record x and y 
            new_x1 <- new_x2
            new_y1 <- new_y2
 
        }

        # Now record x, y, kinetic, and potential energy after this time step
        new_x <- new_x1
        new_y <- new_y1   

        # Deal with guys that go out of bounds 
        if (periodic == TRUE){ 

            # Periodic boundary conditions
            if (new_x > box_size) {
                new_x <- new_x - 2*box_size
            }
            if (new_x < -box_size){
                new_x <- new_x + 2*box_size
            }
            if (new_y > box_size) {
                new_y <- new_y - 2*box_size
            }
            if (new_y < -box_size){
                new_y <- new_y + 2*box_size
            }

        } else {

            # Elastic collisons -- works fine in a perfectly symmetrical system
            if (new_x > box_size){
                new_x <- 2*box_size - new_x
            } 
  
            if (new_x < -box_size){
                new_x <- -2*box_size - new_x
            }   
            if (new_y > box_size){
                new_y <- 2*box_size - new_y
            } 
  
            if (new_y < -box_size){
                new_y <- -2*box_size - new_y
            }  
 
        }

        # Record x, y, kinetic, and potential energy after this time step
        results$x[i] <- new_x
        results$y[i] <- new_y
        results$kinetic_energy[i] <- 1/2*sum(delta**2)
        results$potential_energy[i] <- V(new_x,new_y,well_depth,beta,offset)

        # Are we inside (state 1) or outside (state 0)the circle?
        if ((new_x**2 + new_y**2) < radius_squared){
            results$state[i] <- 1
        } else { 
            results$state[i] <- 0
        } 
       
        # Draw the move on the potential surface 
        if (draw == TRUE || write_png == TRUE) {
        
            if (results$state[i] == 0){
                color <- 4
            } else { 
                color <- 2
            }

            points3d(new_x,new_y,V(new_x,new_y,well_depth,beta,offset),size=10,col=color)
        
            if (write_png == TRUE){
                rgl.snapshot(paste(png_suffix,"_",formatC(i,width=6,format="d",flag="0"),".png",sep=""))
            }
        }

        x <- new_x
        y <- new_y
 
    }

    out$results <- results

    out 
}   

# Do a plot of all simulation results after the fact
plot_simulation_results <- function(out){

    draw_surface(out$box_size,out$state_radius,out$well_depth,out$beta,out$offset)

    s <- subset(out$results,state==0)
    points3d(s$x,s$y,s$potential_energy,size=10,color=4)

    s <- subset(out$results,state==1)
    points3d(s$x,s$y,s$potential_energy,size=10,color=2)

}
