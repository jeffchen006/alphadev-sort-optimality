# n=5 model=out iset=I1 prefix14_class=13625
cmp P1, P0
cmovl S2, P1
cmovl P1, P0
cmovl P0, S2
mov S1, P2
cmp P3, P2
cmovg S1, P3
cmovg P3, P2
cmp P0, P3
cmovg S0, P0
cmovge P0, P3
cmovle S0, P3
cmp P1, S1
mov P0, S1
