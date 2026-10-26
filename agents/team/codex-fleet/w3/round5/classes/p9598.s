# n=5 model=out iset=I1 prefix14_class=9598
mov S0, P0
cmp P1, S0
cmovge S0, P1
cmovle P0, P1
mov P1, P2
cmp P3, P1
cmovge P1, P3
cmovg P3, P2
cmp S0, P1
cmovge S2, S0
cmovg S0, P1
cmovge P1, S2
cmp P3, P0
cmovg S2, P3
