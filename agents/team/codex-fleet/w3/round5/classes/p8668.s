# n=5 model=out iset=I1 prefix14_class=8668
mov S2, P2
cmp P1, P2
cmovge S2, P1
cmovge P1, P2
mov S0, S2
cmp P0, P3
cmovle S1, P3
cmovle P3, P0
cmovl P0, S1
cmp P0, S2
cmovg S0, P0
cmovg P0, S2
cmp P3, P1
cmovg S2, P1
