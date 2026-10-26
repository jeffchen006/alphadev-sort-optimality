# n=5 model=out iset=I1 prefix14_class=2740
mov S0, P1
mov S1, P0
cmp S1, P3
cmovg S1, P3
cmovge P3, P0
cmp P2, P1
cmovl P1, P2
cmovle P2, S0
cmp P2, P3
cmovle S2, P2
cmovl P2, P3
mov P0, P1
cmovl P3, S2
mov S0, P3
