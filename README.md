##![ScreenShot](https://www.bu.edu/brand/files/2012/10/master_logo.gif)
# DNA-Mappers
**EC551 Project: FPGA Acceleration of DNA Sequence Mapping**

Team Members:

1. Aditya Narayan
2. Siva Perumal
3. Sarthak Jagetia
4. Aastha Anand
5. Anand Shivalkar


The `DNA_Sequence_Mapping_top.v` is the top level verilog which calls the Smith Waterman and the VGA modules. Since the integration of the indexing block is not working with Place and Route, the indexes values and the corresponding reference sequences are hardcoded. The progress is ongoing and we will update it soon. 

How to run?

1. The reference sequence is input in the `DNA_Sequence_Mapping_top.v` in the reference "wire".
2. The short reads can be input at the short_read "wires".
3. The indexes where the short reads can potentially map can be entered into the sr_index "wires".
4. The corresponding reference sequence has to be input in the ref_seq "wires".
5. The length of the short has to be entered in the n "parameter". 
*Note - Currently, the code can only support equal length short reads.*

Synthesize and build `DNA_Sequence_Mapping_top.v` and generate the programming file.

Set up the ucf file to contain push-buttons for "reset" and "button".

The output matched sequence with the SNP's and indels should display on the screen.

