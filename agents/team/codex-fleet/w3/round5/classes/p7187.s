# n=5 model=out iset=I1 prefix14_class=7187
cmp P1, P2
cmovg S1, P2
cmovg P2, P1
cmovg P1, S1
cmp P0, P3
cmovg S2, P0
cmovge P0, P3
cmovle S2, P3
cmovl P3, P0
cmp P0, P1
mov S0, P2
cmovg P3, P1
cmovg P1, P0
cmovl P0, P1
