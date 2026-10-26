# n=5 model=out iset=I1 prefix14_class=4875
cmp P1, P3
cmovle S1, P3
cmovle P3, P1
mov S0, P2
cmovl P1, S1
cmp P0, S0
cmovg S0, P0
cmovl P2, P0
cmp P2, P3
cmovge P0, P2
cmovle P0, P3
mov S2, P1
cmovg P2, P3
cmp P1, S0
