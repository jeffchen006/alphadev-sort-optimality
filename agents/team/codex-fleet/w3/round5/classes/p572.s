# n=5 model=out iset=I1 prefix14_class=572
mov S2, P3
cmp S2, P1
mov S0, P2
cmovge S2, P1
cmovge P1, P3
cmp S0, P0
mov P3, S2
cmovle S0, P0
cmovg P2, P0
cmp P2, P3
cmovle P3, P2
cmovg S2, P2
cmp P1, S0
mov P2, S0
