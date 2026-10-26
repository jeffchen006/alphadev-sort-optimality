# n=5 model=out iset=I1 prefix14_class=2965
cmp P2, P1
mov S1, P1
cmovle S1, P2
mov S0, P0
cmovge P1, P2
cmp S0, P3
cmovg S0, P3
cmovge P3, P0
cmp P1, P3
cmovl P2, P3
cmovle P3, P1
cmovl P1, P2
cmp S1, S0
mov S2, S0
