# n=5 model=out iset=I1 prefix14_class=7074
cmp P0, P2
cmovle S1, P2
cmovg S1, P0
mov S2, P1
cmovg P0, P2
cmp P1, P3
cmovg P1, P3
cmovge P3, S2
cmp P0, P1
cmovle S0, P1
cmovg S0, P0
cmovl P1, P0
mov P1, P3
cmp P1, S1
