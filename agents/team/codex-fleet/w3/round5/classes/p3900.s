# n=5 model=out iset=I1 prefix14_class=3900
mov S0, P2
cmp S0, P0
cmovg P2, P0
cmovge P0, S0
cmp P1, P3
cmovle S1, P1
mov S2, P2
cmovl P1, P3
cmovl P3, S1
cmp P2, P3
cmovle P2, P3
cmovle P3, S2
mov S1, P0
mov P3, P2
