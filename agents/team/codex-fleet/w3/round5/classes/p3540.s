# n=5 model=out iset=I1 prefix14_class=3540
mov S2, P2
cmp P3, P1
mov S1, P3
cmovg P3, P1
mov S0, P3
cmovle S1, P1
cmp P2, P0
cmovle P2, P0
cmovl P0, S2
cmp P0, P3
cmovl S0, P0
cmovge P3, P0
mov P0, P3
mov S2, S1
