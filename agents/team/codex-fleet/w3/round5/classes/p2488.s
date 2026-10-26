# n=5 model=out iset=I1 prefix14_class=2488
cmp P3, P1
cmovle S2, P3
cmovl P3, P1
cmovg S2, P1
mov S0, P3
mov S1, S2
cmp P0, P2
cmovg P1, P2
cmovge P2, P0
cmovg P0, P1
cmp S0, P2
cmovle P3, P2
cmovle P2, S0
cmp S1, P0
