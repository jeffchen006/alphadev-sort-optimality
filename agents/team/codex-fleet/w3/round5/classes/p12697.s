# n=5 model=out iset=I1 prefix14_class=12697
cmp P2, P3
cmovg S2, P3
cmovge P3, P2
cmovg P2, S2
mov S0, P2
cmp P0, P1
cmovle S2, P1
cmovl P1, P0
mov S1, P3
cmovl P0, S2
cmp P1, P2
cmovg S0, P1
cmovg P1, P2
cmp P0, S1
