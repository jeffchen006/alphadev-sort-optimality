# n=5 model=out iset=I1 prefix14_class=1309
mov S2, P0
cmp P3, S2
cmovl S2, P3
cmovle P3, P0
mov S0, P2
cmp S0, P1
cmovge P2, P1
cmovge P1, S0
mov S0, P3
cmp P1, S0
cmovge P3, P1
cmovg P1, S0
mov S0, P1
mov S1, S2
