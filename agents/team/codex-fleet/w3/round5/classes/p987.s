# n=5 model=out iset=I1 prefix14_class=987
mov S2, P3
cmp P1, P3
mov S0, P0
cmovge S2, P1
cmovle P3, P1
cmp S0, P2
cmovg S0, P2
cmovge P2, P0
mov S1, P2
cmp S2, P2
mov P0, S0
cmovge S1, S2
cmovge S2, P2
cmp P3, P0
