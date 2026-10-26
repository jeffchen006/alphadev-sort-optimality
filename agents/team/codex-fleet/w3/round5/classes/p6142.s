# n=5 model=out iset=I1 prefix14_class=6142
cmp P3, P1
cmovle S1, P3
cmovl P3, P1
cmovl P1, S1
cmp P0, P2
cmovg S0, P2
cmovge P2, P0
mov S2, P2
cmovg P0, S0
cmp P2, P3
cmovl P2, P3
cmovg S2, P3
mov S0, P0
cmp P1, P0
