# n=5 model=out iset=I1 prefix14_class=3782
mov S0, P3
cmp P3, P2
cmovge P3, P2
cmovge P2, S0
mov S0, P1
cmp P0, P1
cmovg S0, P0
cmovg P0, P1
mov S1, P3
cmp S1, P0
cmovl P3, P0
cmovle P0, S1
cmp S0, P2
cmovge P1, P2
