# n=5 model=out iset=I1 prefix14_class=3478
mov S1, P3
cmp P1, P3
cmovg S1, P1
mov S0, P0
cmovge P1, P3
cmp S0, P2
cmovle P0, P2
cmovl P2, S0
mov S0, P1
cmp P2, S0
cmovg S0, P2
cmovg P2, P1
cmp P0, S1
mov P2, P0
