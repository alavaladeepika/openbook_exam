; Printed in " Radius	Angle	X-cord	Y-cord" order

	 AREA	circle, CODE,READONLY
	 EXPORT __main
	 IMPORT printMsg4p	
	 ENTRY
__main  FUNCTION
		;R0 - Radius
		;R1 - Angle
		;R2 - X co-ordinate
		;R3 - Y co-ordinate
 
		MOV R9, #100;			Radius of circle
		MOV R10, #300;			x co-ordinate of the center (a)
		MOV R11, #200;			y co-ordinate of the center (b)
		
		VLDR.F32 S0,= 0;		starting Angle
	 	VLDR.F32 S10,= 6.29;	Final Angle 360 = 6.28
		VLDR.F32 S11,= 0.0174;	1 deg
		
LOOP	VCMP.F32 S0,S10;		Compare current angle and final angle		
		VMRS    APSR_nzcv, FPSCR;
		BGT stop;				If current angle is > 360, stop
		MOV R4, #200;			No. of terms to compute sinx and cosx
		MOV R5, #1;				Temp variable, count	
		
		VMOV.F32 S1,S0;			Store value of sinx (sinx series begins with x)
		VMOV.F32 S2,S0;			Temp variable for sinx  
	 
		VLDR.F32 S3,= 1;		Store value of cosx
		VLDR.F32 S4,= 1;		Temp variable for cosx
		
		B LOOP1;		
		
LOOP1	CMP R5,R4;				Compare count and no of term
		BGT LOOPX;				IF count > no.of terms print the value
		BL LOOP2;				Compute sinx
		BL LOOP3;				Compute cosx
		ADD R5,R5,#1;			Increment the count
		B LOOP1;				
		
	
LOOP2	
		VMOV.F32 S5,R5;			Move the count to S5 (floating point register)
		VCVT.F32.S32 S5,S5; 	Convert into unsigned 32bit number	
		VLDR.F32 S12,= 1;		Store 1
	 	VLDR.F32 S13,= 2;		Store 2
		VMUL.F32 S14,S5,S13;	S14 = 2*count 
		VADD.F32 S15,S14,S12;	S15 = (2*count)+1
		VSUB.F32 S16,S14,S12;	S15 = (2*count)-1 
		
		VMUL.F32 S2,S2,S0; 		Temp_var = temp_var * x
		VDIV.F32 S2,S2,S14;		Divide temp_var by 2*count 
		VMUL.F32 S2,S2,S0; 		Temp_var = temp_var * x
		VDIV.F32 S2,S2,S15;		Divide temp_var by (2*count)+1
		VNEG.F32 S2,S2;			Negate the tem variable	 
		VADD.F32 S1,S1,S2;		Add temp_var to the sum	- S1 has sinx		
		BX lr;

LOOP3	VMUL.F32 S4,S4,S0; 		Temp_var = temp_var * x
		VDIV.F32 S4,S4,S14;		Divide temp_var by 2*count 
		VMUL.F32 S4,S4,S0; 		Temp_var = temp_var * x
		VDIV.F32 S4,S4,S16;		Divide temp_var by 2*count-1
		VNEG.F32 S4,S4;			Negate the tem variable	 
		VADD.F32 S3,S3,S4;		Add temp_var to the sum	- S3 has cosx		
		BX lr;
LOOPX	
		VMOV.F32 S5,R9;		Move the radius in R9 to S5 (floating point register)
		VCVT.F32.S32 S5,S5; 	Convert into unsigned 32bit number
		VMUL.F32 S9,S3,S5;		S9 = r*cosx
		 
		VMOV.F32 S5,R10;		Move the x-cord in R10 to S5 (floating point register)
		VCVT.F32.S32 S5,S5; 	Convert into unsigned 32bit number
		VADD.F32 S9,S9,S5;		S9 = a + (r*cosx)
		; S9 has x cordinate
		VCVT.S32.F32 S9,S9;		Copy x cord to R2
		VMOV.F32 R2,S9;	 		R2 has x co-ordinate
		
		VMOV.F32 S5,R9;		Move the radius in R9 to S5 (floating point register)
		VCVT.F32.S32 S5,S5; 	Convert into unsigned 32bit number
		VMUL.F32 S8,S1,S5;		S8 = r*sinx
		
		VMOV.F32 S5,R11;		Move the y-cord in R11 to S5 (floating point register)
		VCVT.F32.S32 S5,S5; 	Convert into unsigned 32bit number
		VADD.F32 S8,S8,S5;		S8 = b + (r*sinx)
		; S8 has y co-ordinate
		
		VCVT.S32.F32 S8,S8;		Copy y cord to R3
		VMOV.F32 R3,S8; 	 	R3 has y co-ordinate		
		
		VDIV.F32 S7, S0, S11;	S6 -> x*180/3.14
		VCVT.S32.F32 S7,S7;		Copy angle to R1
		VMOV.F32 R1,S7; 		R1 has angle	

		MOV R0, R9;			Move the radius to R0
	 
		BL printMsg4p;			Print the values
		VADD.F32 S0,S0,S11;	
		B LOOP;
		
stop 	B stop
     ENDFUNC
     END	