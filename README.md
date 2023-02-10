# README

In this repository, I will be documenting the steps that I have implemented in order to establish a nanopore DNA sequencing pipeline in the Gonzalez lab at UCSD. This process took a decent amount of troubleshooting for me to set up as much of this I was doing for the first time. Hopefully this documentation will be helpful to someone else and save them a bit of time! 

## Building a Computer to Run the Minion  

First things first, I needed to get a computer capable of running our new minion that we got as part Nanopore's starter pack offering (~$1000 for the minion, a flow cell, and a library preparation kit). After some deliberation, I opted to build a computer that would allow us to call bases with reasonable accuracy in real time.

Alternatively, we could have gotten a computer that had specs capable of running the instrument, but wasn't able to do the base calling in a reasonable amount of time (this is a GPU intensive task- base calling with just a CPU takes forever.) We could then transfer the data to a GPU enabled server (the UCSD supercomputer has GPU node for example) and do the base calling there. I opted not to do this simply because our lab hasn't really used the super-computing center, and I didn't want to have to worry about getting that all set up and paid for. 

I also figured if I built a good computer, I could also use it as a bit of a lab server and use it for completely separate data analysis tasks (I am frequently doing things that my Macbook with 8GB of ram cannot handle easily).

Note that this was the first computer I built completely from scratch, and it really wasn't very hard- if I can do it, you could certainly do it too. Just don't strip a screw on the motherboard, I did that and it was a huge pain getting it out.

The components that I used can be found in the computer_build.xlsx file. This build was a bit less than $3000. 

Be sure to install Ubuntu 20, not the latest Ubuntu 22. There was software on the nanopore side of things that would not work with Ubuntu 22 so I ended up having to downgrade. 

There also were several things that I installed on the computer to make it more useful for general bioinformatics (install RStudio Server, open ssh for remote access, samba server for easy file transfer to and from connected computer). See the ... directory for instructions on how to do that.   

## Bacterial Genome Assembly

Once I got the computer up and running, the next step was to figure out how to do bacterial genome assemblies. This required me to combine a combination of wet lab techniques and bioinformatic software/analysis. 

A protocol describing each of these steps can be found in the Protocol.pdf file in the bacteria_genome_assembly directory. 

It contains instructions on the following: 

1. High MW gDNA extraction
2. DNA Quantification  
    a. Measure DNA purity via nanodrop 
    b. Measure DNA Concentration via Qubit BR 
5. DNA Size Measurement
6. Library Preparation
7. Loading the Flow Cell  
8. Starting the Run in Minknow
9. Bioinformatic Analysis   
    a. De novo assembly  
    b. Variant calling relative to reference  
  
Note that some of the instructions are specific to UCSD, but it should be pretty clear what those are. 
    

## Problems I ran into 

Here specific, annoying problems I ran into are documented. Unfortunately, there are a number of things that have not yet been resolved, but I will update this section as I get the answers. 

1. The initial install of Minknow didn't function right, it wasn't able to call bases and I ended up stuck with a bunch of .raw files. I didn't know what to do with these, as I thought .fast5 files contained the raw data, but apparently there is a file upstream of a fast5. To recover the data from this run, I had to use the recover_reads command line utility as discussed here:   


I'm not sure how the initial install got messed up but a complete re-install fixed the problem. 


2. The length of my reads was much smaller than expected. Average gDNA fragments were >= 60kb by bioanalyzer but N50 via nanopore was ~4kb. I think this is because I didn't bother using wide bore pipette tips during the library preparation steps but I don't actually know for sure. 


3. Epi2meLabs does not install properly, returns several spawn ENONET errors upon trying to launch the software. 

* This would be really great to get working as it seems Oxford Nanopore has a couple of well developed bioinformatic workflows already set up that would work great for my purposes. Unfortunately, the software doesn't install properly. I am currently in communication with them to try to figure out what is the problem but it is out of my hands for the moment. 





