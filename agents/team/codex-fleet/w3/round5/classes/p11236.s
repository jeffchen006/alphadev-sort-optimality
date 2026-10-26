# n=5 model=out iset=I1 prefix14_class=11236
cmp P2, P3
cmovg S1, P2
cmovge P2, P3
cmovg P3, S1
cmp P0, P1
cmovle S0, P1
cmovl P1, P0
cmovl P0, S0
mov S2, P3
cmp P0, S2
cmovg S2, P0
cmovg P0, P3
mov S2, P2
cmp P2, P1
