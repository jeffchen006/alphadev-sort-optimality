# n=5 model=out iset=I1 prefix14_class=7934
cmp P2, P1
cmovle S0, P1
cmovle P1, P2
cmovg S0, P2
cmp P3, P0
mov S2, P3
cmovge S2, P0
cmovg P0, P3
mov P2, P0
cmp S2, P1
cmovge P3, P1
cmovge P1, S2
cmovge S2, P3
cmp P2, S0
