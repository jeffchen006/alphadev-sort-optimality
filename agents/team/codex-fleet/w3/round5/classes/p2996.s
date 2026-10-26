# n=5 model=out iset=I1 prefix14_class=2996
mov S0, P1
mov S2, P3
cmp S0, P2
cmovl S0, P2
mov S1, S0
cmovle P2, P1
cmp P3, P0
cmovg S2, P0
cmovge P0, P3
cmp S0, P0
cmovg S0, P0
cmovge P0, S1
cmp S2, P2
cmovge P1, S2
