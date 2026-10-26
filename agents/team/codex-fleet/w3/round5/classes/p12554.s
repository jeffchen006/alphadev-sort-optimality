# n=5 model=out iset=I1 prefix14_class=12554
cmp P2, P3
cmovle S0, P2
mov S2, P0
cmovle P2, P3
cmovl P3, S0
cmp P0, P1
cmovle P0, P1
cmovl P1, S2
cmovg S2, P1
cmp S2, P3
cmovg P1, P3
cmovge P3, S2
mov P1, P2
mov S1, P3
