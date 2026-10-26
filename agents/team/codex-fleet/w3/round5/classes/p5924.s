# n=5 model=out iset=I1 prefix14_class=5924
mov S2, P0
mov S0, P1
cmp P0, P3
cmovge P0, P3
cmovle S2, P3
cmp P2, P1
cmovg P1, P2
cmovg P2, S0
cmp P1, S2
cmovle S1, P1
cmovl P1, S2
cmovl S2, S1
cmp P2, P0
cmovle S1, P2
