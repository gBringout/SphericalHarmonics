#SphericalHarmonics#

The repository contains many Matlab scripts used to perform spherical harmonics decomposition and calculation of the magnetic fields value at some points based on spherical harmonic coefficient.

The idea is to reduce the number of measurements/calculation/saved points needed to describe a magnetic field. Compared to a simple Cartesian gridding of the space, the usage of spherical harmonics required just a few points arranged on a sphere.

![Alt text](/examples/Coil.jpg?raw=true "A coil, some points needed for a SHD and the field in a plane")

Then spherical harmonics coefficient can be calculated in order to describe the field up to a given order and degree.
![Alt text](/examples/SHC_driveX.jpg?raw=true "The SH coefficient")
On this graph, each colour represent an order. A darker colour indicate a negative value. This is the coefficients associated with a "homogeneous" coil (or drive coil in [Magnetic Particle Imaging](http://en.wikipedia.org/wiki/Magnetic_particle_imaging)).

For further information, please refer yourself to [this publication](http://www.gael-bringout.com/public/Bringout%202014%20-%20a%20robust%20and%20compact%20representation%20for%20magnetics%20fields%20in%20magnetic%20particle%20imaging.pdf) and the associate references.
