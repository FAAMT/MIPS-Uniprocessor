# MIPS-Uniprocessor

This repo contains all the source code and relevant files for my MIPS Uniprocessor project. 
I worked on this for a computer architecture lab at Purdue University in Spring 2022.

The processor was developed using SystemVerilog (HDL). It was simulated and synthesized 
using QuestaSim by Siemens and Design Compiler by Synopsys. All testing was performed 
by feeding assembly programs (testcases) through the processor and then comparing the 
output of memory (RAM) with the expected result.

The diagrams allow us to visualize the overall system and the internal datapath module
so as to establish intention of functionality. 

Overall System Diagram:
<br />
<p align="center">
  <kbd>
    <img src="https://user-images.githubusercontent.com/82693292/189511969-9eac9e14-e69c-4752-9525-9e3c57b6aaef.jpg" width="300" height="400"/>
  </kbd>
</p>


Datapath RTL Diagram:
<br />
<p align="center">
  <kbd>
    <img src="https://user-images.githubusercontent.com/82693292/189511169-f90daddf-94aa-4eef-b58d-23a18067168a.png" width="800" height="600"/>
  </kbd>
</p>

