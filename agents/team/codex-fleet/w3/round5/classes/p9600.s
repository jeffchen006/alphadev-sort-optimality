# n=5 model=out iset=I1 prefix14_class=9600
cmp P2, P3
cmovle S1, P2
cmovge S1, P3
cmovge P3, P2
cmp P1, P0
cmovge S0, P0
mov S2, P3
cmovg P0, P1
cmovg P1, S0
cmp P3, P0
cmovg P3, P0
cmovl S2, P0
cmp P1, S1
mov S2, P1
