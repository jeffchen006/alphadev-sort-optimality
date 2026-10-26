# n=5 model=out iset=I1 prefix14_class=6964
mov S2, P3
mov S0, P1
cmp P0, P1
cmovge P1, P0
cmovge P0, S0
cmp P2, S2
cmovle P3, P2
cmovg S2, P2
mov S1, P1
cmp S1, S2
cmovge S1, S2
cmovge S2, P1
cmp P3, P0
cmovge P1, P0
