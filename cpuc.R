install.packages("igraph") 
install.packages("network") 
install.packages("sna")
install.packages("visNetwork")
install.packages("ndtv", dependencies=T)

library("igraph")

rm(list = ls()) 

#set path to downloaded folder
setwd("C:/Users/Red-8/Downloads/polnet2016") 

nodes <- read.csv("./Data files/Dataset1-Media-Example-NODES.csv", header=T, as.is=T)
links <- read.csv("./Data files/Dataset1-Media-Example-EDGES.csv", header=T, as.is=T)

# Converting the data to an igraph object:
# The graph_from_data_frame() function takes two data frames: 'd' and 'vertices'.
# 'd' describes the edges of the network - it should start with two columns 
# containing the source and target node IDs for each network tie.
# 'vertices' should start with a column of node IDs.
# Any additional columns in either data frame are interpreted as attributes.
net <- graph_from_data_frame(d=links, vertices=nodes, directed=T) 

# We can access the nodes, edges, and their attributes:
E(net)
V(net)
E(net)$type
V(net)$media

# If you need them, you can extract an edge list 
# or a matrix back from the igraph networks.
as_edgelist(net, names=T)
as_adjacency_matrix(net, attr="weight")

# Or data frames describing nodes and edges:
as_data_frame(net, what="edges")
as_data_frame(net, what="vertices")

# First attempt to plot the graph:
plot(net) # not pretty!

# Removing loops from the graph:
net <- simplify(net, remove.multiple = F, remove.loops = T) 

# Let's and reduce the arrow size and remove the labels:
plot(net, edge.arrow.size=.4,vertex.label=NA)

# We can set the node & edge options in two ways - one is to specify
# them in the plot() function, as we are doing below.

# Plot with curved edges (edge.curved=.1) and reduce arrow size:
# Note that using curved edges will allow you to see multiple links
# between two nodes (e.g. links going in either direction, or multiplex links)
plot(net, edge.arrow.size=.4, edge.curved=.1)

# Set node color to orange and the border color to hex #555555
# Replace the vertex label with the node names stored in "media"
plot(net, edge.arrow.size=.4, edge.curved=0,
     vertex.color="orange", vertex.frame.color="#555555",
     vertex.label=V(net)$media, vertex.label.color="black",
     vertex.label.cex=.7) 
# The second way to set attributes is to add them to the igraph object.

# Generate colors based on media type:
colrs <- c("gray50", "tomato", "gold")
V(net)$color <- colrs[V(net)$media.type]

# Compute node degree (#links) and use it to set node size:
deg <- degree(net, mode="all")
V(net)$size <- deg*3
V(net)$size <- V(net)$audience.size*0.6

# The labels are currently node IDs.
# Setting them to NA will render no labels:
V(net)$label.color <- "black"
V(net)$label <- NA

# Set edge width based on weight:
E(net)$width <- E(net)$weight/6


#change arrow size and edge color:
E(net)$arrow.size <- .2  
E(net)$edge.color <- "gray80"

plot(net) 


# We can also add a legend explaining the meaning of the colors we used:
# (below 'x' and 'y' are the legend coordinates, 'pch' is the element symbol, 
# 'pt.bg' is the point's background color, 'col' is the border color, 
# 'pt.cex' is the symbol size, 'bty' is the type of box around the legend,
# and 'ncol' is the number of columns in which the legend is set).

plot(net) 
legend(x=-1.1, y=-1.1, c("Newspaper","Television", "Online News"), pch=21,
       col="#777777", pt.bg=colrs, pt.cex=2.5, bty="n", ncol=1)


# Sometimes, especially with semantic networks, we may be interested in 
# plotting only the labels of the nodes:

plot(net, vertex.shape="none", vertex.label=V(net)$media, 
     vertex.label.font=2, vertex.label.color="gray40",
     vertex.label.cex=1.2, edge.color="gray90")


