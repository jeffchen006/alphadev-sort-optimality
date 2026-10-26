# n=5 model=out iset=I1 prefix14_class=235
cmp P2, P0
cmovge S2, P2
mov S0, P3
cmovle S2, P0
cmovle P0, P2
cmp P3, P1
cmovg S0, P1
cmovge P1, P3
cmp S0, P0
mov P2, P0
cmovg P2, S0
cmovle P0, S0
mov S0, P2
cmp S2, P1
