
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Release
;Chip type              : ATtiny85
;Program type           : Application
;Clock frequency        : 8,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 128 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATtiny85
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 512
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E

	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x11
	.EQU GPIOR1=0x12
	.EQU GPIOR2=0x13

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x025F
	.EQU __DSTACK_SIZE=0x0080
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _migMig=R2
	.DEF _migMig_msb=R3
	.DEF _adcTemp=R4
	.DEF _adcTemp_msb=R5
	.DEF _adcCount=R7
	.DEF _adcVal=R8
	.DEF _adcVal_msb=R9
	.DEF _pwmVal=R10
	.DEF _pwmVal_msb=R11
	.DEF _setZero=R12
	.DEF _setZero_msb=R13
	.DEF _fl=R6

;GPIOR0-GPIOR2 INITIALIZATION VALUES
	.EQU __GPIOR0_INIT=0x00
	.EQU __GPIOR1_INIT=0x00
	.EQU __GPIOR2_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP _timer1_compa_isr
	RJMP _timer1_ovf_isr
	RJMP _timer0_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP _adc_isr
	RJMP _timer1_compb_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0

_0x3:
	.DB  0x81,0x1

__GLOBAL_INI_TBL:
	.DW  0x0C
	.DW  0x02
	.DW  __REG_VARS*2

	.DW  0x02
	.DW  _zero
	.DW  _0x3*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	WDR
	IN   R26,MCUSR
	CBR  R26,8
	OUT  MCUSR,R26
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;GPIOR0-GPIOR2 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30
	;__GPIOR1_INIT = __GPIOR0_INIT
	OUT  GPIOR1,R30
	;__GPIOR2_INIT = __GPIOR0_INIT
	OUT  GPIOR2,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0xE0

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.0 Professional
;Automatic Program Generator
;� Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 28.09.2015
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATtiny85
;AVR Core Clock frequency: 8,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 128
;*****************************************************/
;
;#include <tiny85.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x18
	.EQU __sm_adc_noise_red=0x08
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x18
	.SET power_ctrl_reg=mcucr
	#endif
;
;#include <delay.h>
;#define abs(_a) (((_a)>=0)?_a:-_a)
;
;#define LED PORTB.2
;#define ADCIN 2
;#define DEAD_VALUE 20
;#define PWM1 PORTB.1
;#define PWM2 PORTB.3
;
;int migMig=0;
;signed int adcTemp=0;
;char adcCount=0;
;signed int adcVal=0;
;signed int pwmVal=0;
;unsigned int setZero=0;
;signed int zero = 385;

	.DSEG
;char fl = 0;
;
;
;
;// Timer1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 002F {

	.CSEG
_timer1_ovf_isr:
; .FSTART _timer1_ovf_isr
; 0000 0030     PWM1 = 1;
	SBI  0x18,1
; 0000 0031     PWM2 = 1;
	SBI  0x18,3
; 0000 0032 
; 0000 0033 }
	RETI
; .FEND
;
;// Timer1 output compare A interrupt service routine
;interrupt [TIM1_COMPA] void timer1_compa_isr(void)
; 0000 0037 {
_timer1_compa_isr:
; .FSTART _timer1_compa_isr
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 0038 // Place your code here
; 0000 0039     if(OCR1A<255) PWM1 = 0;
	IN   R30,0x2E
	CPI  R30,LOW(0xFF)
	BRSH _0x8
	CBI  0x18,1
; 0000 003A }
_0x8:
	RJMP _0x3E
; .FEND
;
;// Timer1 output compare B interrupt service routine
;interrupt [TIM1_COMPB] void timer1_compb_isr(void)
; 0000 003E {
_timer1_compb_isr:
; .FSTART _timer1_compb_isr
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 003F // Place your code here
; 0000 0040     if(OCR1B<255) PWM2 = 0;
	IN   R30,0x2B
	CPI  R30,LOW(0xFF)
	BRSH _0xB
	CBI  0x18,3
; 0000 0041 }
_0xB:
_0x3E:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
; .FEND
;
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void) //1ms
; 0000 0046 {
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0047 // Reinitialize Timer 0 value
; 0000 0048 TCNT0=0x83;
	LDI  R30,LOW(131)
	OUT  0x32,R30
; 0000 0049 // Place your code here
; 0000 004A 
; 0000 004B     #asm("wdr")
	wdr
; 0000 004C     LED = 1;
	SBI  0x18,2
; 0000 004D     if(++migMig > (600 - (abs(adcVal)))) migMig = 0;
	MOVW R30,R2
	ADIW R30,1
	MOVW R2,R30
	MOVW R22,R30
	CLR  R0
	CP   R8,R0
	CPC  R9,R0
	BRLT _0x11
	MOVW R30,R8
	RJMP _0x12
_0x11:
	MOVW R30,R8
	RCALL __ANEGW1
_0x12:
	LDI  R26,LOW(600)
	LDI  R27,HIGH(600)
	RCALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	CP   R30,R22
	CPC  R31,R23
	BRGE _0x10
	CLR  R2
	CLR  R3
; 0000 004E 
; 0000 004F     //if(setZero < 5000) setZero++;
; 0000 0050    // else
; 0000 0051     {
_0x10:
; 0000 0052 
; 0000 0053     // -512 < adcVal < 512
; 0000 0054     if(adcVal <= DEAD_VALUE && adcVal >= -DEAD_VALUE)
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CP   R30,R8
	CPC  R31,R9
	BRLT _0x15
	LDI  R30,LOW(65516)
	LDI  R31,HIGH(65516)
	CP   R8,R30
	CPC  R9,R31
	BRGE _0x16
_0x15:
	RJMP _0x14
_0x16:
; 0000 0055     {
; 0000 0056         if(pwmVal>0) pwmVal--;
	CLR  R0
	CP   R0,R10
	CPC  R0,R11
	BRGE _0x17
	RCALL SUBOPT_0x0
; 0000 0057         if(pwmVal<0) pwmVal++;
_0x17:
	CLR  R0
	CP   R10,R0
	CPC  R11,R0
	BRGE _0x18
	RCALL SUBOPT_0x1
; 0000 0058          fl = 0;
_0x18:
	CLR  R6
; 0000 0059     }
; 0000 005A     else
	RJMP _0x19
_0x14:
; 0000 005B     if(adcVal < DEAD_VALUE-zero)
	RCALL SUBOPT_0x2
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	SUB  R30,R26
	SBC  R31,R27
	CP   R8,R30
	CPC  R9,R31
	BRGE _0x1A
; 0000 005C     {
; 0000 005D          LED = 0;
	CBI  0x18,2
; 0000 005E          pwmVal = 0;
	CLR  R10
	CLR  R11
; 0000 005F     }
; 0000 0060     else
	RJMP _0x1D
_0x1A:
; 0000 0061     {
; 0000 0062         if(migMig>100) LED = 0;
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CP   R30,R2
	CPC  R31,R3
	BRGE _0x1E
	CBI  0x18,2
; 0000 0063 
; 0000 0064         if(adcVal > 0)
_0x1E:
	CLR  R0
	CP   R0,R8
	CPC  R0,R9
	BRGE _0x21
; 0000 0065         {
; 0000 0066             if(adcVal - DEAD_VALUE > pwmVal && pwmVal < 255){ pwmVal++;  }
	MOVW R26,R8
	SBIW R26,20
	CP   R10,R26
	CPC  R11,R27
	BRGE _0x23
	RCALL SUBOPT_0x3
	BRLT _0x24
_0x23:
	RJMP _0x22
_0x24:
	RCALL SUBOPT_0x1
; 0000 0067             if(adcVal - DEAD_VALUE < pwmVal && pwmVal > -255){ pwmVal--;  }
_0x22:
	MOVW R26,R8
	SBIW R26,20
	CP   R26,R10
	CPC  R27,R11
	BRGE _0x26
	RCALL SUBOPT_0x4
	BRLT _0x27
_0x26:
	RJMP _0x25
_0x27:
	RCALL SUBOPT_0x0
; 0000 0068         }
_0x25:
; 0000 0069         else
	RJMP _0x28
_0x21:
; 0000 006A         {
; 0000 006B             if(adcVal + DEAD_VALUE > pwmVal && pwmVal < 255){ pwmVal++;  }
	MOVW R26,R8
	ADIW R26,20
	CP   R10,R26
	CPC  R11,R27
	BRGE _0x2A
	RCALL SUBOPT_0x3
	BRLT _0x2B
_0x2A:
	RJMP _0x29
_0x2B:
	RCALL SUBOPT_0x1
; 0000 006C             if(adcVal + DEAD_VALUE < pwmVal && pwmVal > -255){ pwmVal--; }
_0x29:
	MOVW R26,R8
	ADIW R26,20
	CP   R26,R10
	CPC  R27,R11
	BRGE _0x2D
	RCALL SUBOPT_0x4
	BRLT _0x2E
_0x2D:
	RJMP _0x2C
_0x2E:
	RCALL SUBOPT_0x0
; 0000 006D         }
_0x2C:
_0x28:
; 0000 006E     }
_0x1D:
_0x19:
; 0000 006F 
; 0000 0070         if(pwmVal < 0)
	CLR  R0
	CP   R10,R0
	CPC  R11,R0
	BRGE _0x2F
; 0000 0071         {
; 0000 0072             if(pwmVal<-140) fl=1;
	LDI  R30,LOW(65396)
	LDI  R31,HIGH(65396)
	CP   R10,R30
	CPC  R11,R31
	BRGE _0x30
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0000 0073            /* if(!fl)*/ OCR1A = 255 + pwmVal;
_0x30:
	MOV  R30,R10
	SUBI R30,-LOW(255)
	OUT  0x2E,R30
; 0000 0074             //if(fl) OCR1B = -pwmVal;
; 0000 0075         }
; 0000 0076         else if(pwmVal > 0)
	RJMP _0x31
_0x2F:
	CLR  R0
	CP   R0,R10
	CPC  R0,R11
	BRGE _0x32
; 0000 0077         {
; 0000 0078             if(pwmVal>140) fl=1;
	LDI  R30,LOW(140)
	LDI  R31,HIGH(140)
	CP   R30,R10
	CPC  R31,R11
	BRGE _0x33
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0000 0079             // if(fl) OCR1A = pwmVal;
; 0000 007A              /*if(!fl)*/ OCR1B = 255 - pwmVal;
_0x33:
	LDI  R30,LOW(255)
	SUB  R30,R10
	RJMP _0x3D
; 0000 007B         }
; 0000 007C         else
_0x32:
; 0000 007D         {
; 0000 007E             OCR1A = 255;
	LDI  R30,LOW(255)
	OUT  0x2E,R30
; 0000 007F             OCR1B = 255;
_0x3D:
	OUT  0x2B,R30
; 0000 0080         }
_0x31:
; 0000 0081 
; 0000 0082     }
; 0000 0083 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;
;//Aref
;#define ADC_VREF_TYPE 0x40
;
;// ADC interrupt service routine
;// with auto input scanning
;interrupt [ADC_INT] void adc_isr(void)
; 0000 008C {
_adc_isr:
; .FSTART _adc_isr
	ST   -Y,R24
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 008D // Read the AD conversion result
; 0000 008E adcTemp += ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	__ADDWRR 4,5,30,31
; 0000 008F if(++adcCount > 6)
	INC  R7
	LDI  R30,LOW(6)
	CP   R30,R7
	BRSH _0x35
; 0000 0090 {
; 0000 0091     adcTemp >>= 3;
	ASR  R5
	ROR  R4
	ASR  R5
	ROR  R4
	ASR  R5
	ROR  R4
; 0000 0092     if(setZero < 500 && setZero > 495)
; 0000 0093     {
; 0000 0094        // zero = adcTemp;
; 0000 0095     }
; 0000 0096     adcCount=0;
	CLR  R7
; 0000 0097     adcVal = adcTemp-zero;
	RCALL SUBOPT_0x2
	MOVW R30,R4
	SUB  R30,R26
	SBC  R31,R27
	MOVW R8,R30
; 0000 0098     adcTemp = 0;
	CLR  R4
	CLR  R5
; 0000 0099 }
; 0000 009A // Select next ADC input
; 0000 009B ADMUX=(ADCIN | (ADC_VREF_TYPE & 0xff));
_0x35:
	LDI  R30,LOW(66)
	OUT  0x7,R30
; 0000 009C // Delay needed for the stabilization of the ADC input voltage
; 0000 009D delay_us(10);
	__DELAY_USB 27
; 0000 009E // Start the AD conversion
; 0000 009F ADCSRA|=0x40;
	SBI  0x6,6
; 0000 00A0 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R24,Y+
	RETI
; .FEND
;
;
;// Declare your global variables here
;
;void main(void)
; 0000 00A6 {
_main:
; .FSTART _main
; 0000 00A7 // Declare your local variables here
; 0000 00A8 
; 0000 00A9 // Crystal Oscillator division factor: 1
; 0000 00AA #pragma optsize-
; 0000 00AB CLKPR=0x80;
	LDI  R30,LOW(128)
	OUT  0x26,R30
; 0000 00AC CLKPR=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 00AD #ifdef _OPTIMIZE_SIZE_
; 0000 00AE #pragma optsize+
; 0000 00AF #endif
; 0000 00B0 
; 0000 00B1 // Port B initialization
; 0000 00B2 // Func5=In Func4=In Func3=Out Func2=Out Func1=Out Func0=In
; 0000 00B3 // State5=T State4=T State3=1 State2=1 State1=1 State0=T
; 0000 00B4 PORTB=0x0E;
	LDI  R30,LOW(14)
	OUT  0x18,R30
; 0000 00B5 DDRB=0x0E;
	OUT  0x17,R30
; 0000 00B6 
; 0000 00B7 // Timer/Counter 0 initialization
; 0000 00B8 // Clock source: System Clock
; 0000 00B9 // Clock value: 125,000 kHz
; 0000 00BA // Mode: Normal top=0xFF
; 0000 00BB // OC0A output: Disconnected
; 0000 00BC // OC0B output: Disconnected
; 0000 00BD TCCR0A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2A,R30
; 0000 00BE TCCR0B=0x03;
	LDI  R30,LOW(3)
	OUT  0x33,R30
; 0000 00BF TCNT0=0x83;
	LDI  R30,LOW(131)
	OUT  0x32,R30
; 0000 00C0 OCR0A=0x00;
	LDI  R30,LOW(0)
	OUT  0x29,R30
; 0000 00C1 OCR0B=0x00;
	OUT  0x28,R30
; 0000 00C2 
; 0000 00C3 // Timer/Counter 1 initialization
; 0000 00C4 // Clock source: System Clock
; 0000 00C5 // Clock value: 31,250 kHz
; 0000 00C6 // Mode: Normal top=0xFF
; 0000 00C7 // OC1A output: Disconnected
; 0000 00C8 // OC1B output: Disconnected
; 0000 00C9 // Timer1 Overflow Interrupt: On
; 0000 00CA // Compare A Match Interrupt: On
; 0000 00CB // Compare B Match Interrupt: On
; 0000 00CC PLLCSR=0x00;
	OUT  0x27,R30
; 0000 00CD 
; 0000 00CE TCCR1=0x09;
	LDI  R30,LOW(9)
	OUT  0x30,R30
; 0000 00CF GTCCR=0x00;
	LDI  R30,LOW(0)
	OUT  0x2C,R30
; 0000 00D0 TCNT1=0x00;
	OUT  0x2F,R30
; 0000 00D1 OCR1A=0xFF;
	LDI  R30,LOW(255)
	OUT  0x2E,R30
; 0000 00D2 OCR1B=0xFF;
	OUT  0x2B,R30
; 0000 00D3 OCR1C=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 00D4 
; 0000 00D5 
; 0000 00D6 // External Interrupt(s) initialization
; 0000 00D7 // INT0: Off
; 0000 00D8 // Interrupt on any change on pins PCINT0-5: Off
; 0000 00D9 GIMSK=0x00;
	OUT  0x3B,R30
; 0000 00DA MCUCR=0x00;
	OUT  0x35,R30
; 0000 00DB 
; 0000 00DC // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00DD TIMSK=0x66;
	LDI  R30,LOW(102)
	OUT  0x39,R30
; 0000 00DE 
; 0000 00DF // Universal Serial Interface initialization
; 0000 00E0 // Mode: Disabled
; 0000 00E1 // Clock source: Register & Counter=no clk.
; 0000 00E2 // USI Counter Overflow Interrupt: Off
; 0000 00E3 USICR=0x00;
	LDI  R30,LOW(0)
	OUT  0xD,R30
; 0000 00E4 
; 0000 00E5 // Analog Comparator initialization
; 0000 00E6 // Analog Comparator: Off
; 0000 00E7 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00E8 ADCSRB=0x00;
	LDI  R30,LOW(0)
	OUT  0x3,R30
; 0000 00E9 DIDR0=0x00;
	OUT  0x14,R30
; 0000 00EA 
; 0000 00EB // ADC initialization
; 0000 00EC // ADC Clock frequency: 125,000 kHz
; 0000 00ED // ADC Voltage Reference: AREF pin
; 0000 00EE // ADC Bipolar Input Mode: Off
; 0000 00EF // ADC Reverse Input Polarity: Off
; 0000 00F0 // ADC Auto Trigger Source: ADC Stopped
; 0000 00F1 // Digital input buffers on ADC0: On, ADC1: On, ADC2: Off, ADC3: On
; 0000 00F2 DIDR0&=0x03;
	IN   R30,0x14
	ANDI R30,LOW(0x3)
	OUT  0x14,R30
; 0000 00F3 DIDR0|=0x10 | 0x1;
	IN   R30,0x14
	ORI  R30,LOW(0x11)
	OUT  0x14,R30
; 0000 00F4 
; 0000 00F5 ADMUX= ADCIN | (ADC_VREF_TYPE & 0xff);
	LDI  R30,LOW(66)
	OUT  0x7,R30
; 0000 00F6 ADCSRA=0xCE;
	LDI  R30,LOW(206)
	OUT  0x6,R30
; 0000 00F7 ADCSRB&=0x5F;
	IN   R30,0x3
	ANDI R30,LOW(0x5F)
	OUT  0x3,R30
; 0000 00F8 
; 0000 00F9 
; 0000 00FA // Watchdog Timer initialization
; 0000 00FB // Watchdog Timer Prescaler: OSC/1024k
; 0000 00FC // Watchdog Timer interrupt: Off
; 0000 00FD #pragma optsize-
; 0000 00FE #asm("wdr")
	wdr
; 0000 00FF WDTCR=0x39;
	LDI  R30,LOW(57)
	OUT  0x21,R30
; 0000 0100 WDTCR=0x29;
	LDI  R30,LOW(41)
	OUT  0x21,R30
; 0000 0101 #ifdef _OPTIMIZE_SIZE_
; 0000 0102 #pragma optsize+
; 0000 0103 #endif
; 0000 0104 
; 0000 0105 // Global enable interrupts
; 0000 0106 #asm("sei")
	sei
; 0000 0107 
; 0000 0108 while (1)
_0x39:
; 0000 0109       {
; 0000 010A       // Place your code here
; 0000 010B 
; 0000 010C       }
	RJMP _0x39
; 0000 010D }
_0x3C:
	RJMP _0x3C
; .FEND

	.DSEG
_zero:
	.BYTE 0x2

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	MOVW R30,R10
	SBIW R30,1
	MOVW R10,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1:
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDS  R26,_zero
	LDS  R27,_zero+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	CP   R10,R30
	CPC  R11,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	CP   R30,R10
	CPC  R31,R11
	RET


	.CSEG
__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

;END OF CODE MARKER
__END_OF_CODE:
