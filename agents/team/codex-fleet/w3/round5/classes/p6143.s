# n=5 model=out iset=I1 prefix14_class=6143
cmp P3, P1
cmovle S1, P3
cmovl P3, P1
cmovl P1, S1
cmp P0, P2
mov S0, P2
cmovg P2, P0
mov S2, P2
cmovg P0, S0
cmp P2, P3
cmovl P2, P3
cmovg S2, P3
cmp P1, P0
mov P3, S2
